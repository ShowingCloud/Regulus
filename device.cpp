#include "device.h"
#include "protocol.h"
#include "serial.h"

#include <QDateTime>
#include <QDebug>

device::device(QObject *parent) : QObject(parent)
{
    device::push(this);
}

device &operator<< (device &d, const msgFreq &m)
{
    if (d.dId == m.deviceId)
    {
        devFreq &dev = dynamic_cast<devFreq &>(d);
        dev.str = m.origin;
        dev << m;

        dev.lastseen = QDateTime::currentDateTime();
        dev.lastSerial = m.serialport;
    }
    return d;
}

device &operator<< (device &d, const msgDist &m)
{
    if (d.dId == m.deviceId)
    {
        devDist &dev = dynamic_cast<devDist &>(d);
        dev.str = m.origin;
        dev << m;

        dev.lastseen = QDateTime::currentDateTime();
        dev.lastSerial = m.serialport;
    }
    return d;
}

device &operator<< (device &d, const msgAmp &m)
{
    if (d.dId == m.deviceId)
    {
        devAmp &dev = dynamic_cast<devAmp &>(d);
        dev.str = m.origin;
        dev << m;

        dev.lastseen = QDateTime::currentDateTime();
        dev.lastSerial = m.serialport;
    }
    return d;
}

devFreq &operator<< (devFreq &dev, const msgFreq &m)
{
    dev.var["atten"]->setValue(m.atten);
    //this->ch_a = m;
    //this->ch_b = m;
    dev.var["voltage"]->setValue(m.voltage);
    dev.var["current"]->setValue(m.current);
    dev.var["output_stat"]->setValue(m.output_stat);
    dev.var["input_stat"]->setValue(m.input_stat);
    dev.var["lock_a1"]->setValue(m.lock_a1);
    dev.var["lock_a2"]->setValue(m.lock_a2);
    dev.var["lock_b1"]->setValue(m.lock_b1);
    dev.var["lock_b2"]->setValue(m.lock_b2);
    dev.var["ref_10_1"]->setValue(m.ref_10_1);
    dev.var["ref_10_2"]->setValue(m.ref_10_2);
    dev.var["ref_3"]->setValue(m.ref_3);
    dev.var["ref_4"]->setValue(m.ref_4);
    dev.var["handshake"]->setValue(m.handshake);

    emit dev.gotData();
    return dev;
}

devDist &operator<< (devDist &dev, const msgDist &m)
{
    dev.ref_10 = static_cast<alert::P_CH>(m.ref_10);
    dev.ref_16 = static_cast<alert::P_CH>(m.ref_16);
    dev.voltage = m.voltage;
    dev.current = m.current;

    emit dev.gotData();
    return dev;
}

devAmp &operator<< (devAmp &dev, const msgAmp &m)
{
    dev.power = m.power;
    dev.gain = m.gain;
    dev.atten_out = m.atten;
    dev.loss = m.loss;
    dev.amp_temp = m.temp;
    dev.load_temp = m.load_temp;
    dev.handshake = static_cast<alert::P_HSK>(m.handshake);

    emit dev.gotData();
    return dev;
}

const devFreq &operator>> (const devFreq &dev, msgCntlFreq &m)
{
    m.atten = static_cast<quint8>(dev.var["atten"]->getValue());
    m.ref_10_a = static_cast<quint8>(dev.var["ref_10_1"]->getValue());
    m.ref_10_b = static_cast<quint8>(dev.var["ref_10_2"]->getValue());

    return dev;
}

const devDist &operator>> (const devDist &dev, msgCntlDist &m)
{
    m.ref_10 = static_cast<quint8>(dev.ref_10);
    m.ref_16 = static_cast<quint8>(dev.ref_16);

    return dev;
}

const devAmp &operator>> (const devAmp &dev, msgCntlAmp &m)
{
    m.atten_mode = static_cast<quint8>(dev.atten_mode);
    m.atten = static_cast<quint8>(dev.atten_in);
    m.power = static_cast<quint16>(dev.power);
    m.gain = static_cast<quint16>(dev.gain);

    return dev;
}

void devFreq::createCntlMsg()
{
    protocol *p = new protocol();
    protocol::protocolList << p;

    msgCntlFreq *q = new msgCntlFreq();
    *this >> *q;

    if (this->lastSerial && QDateTime::currentDateTime().secsTo(this->lastseen) < 3) {
        qDebug() << "create msg: sending one";
        *this->lastSerial << *q;
    } else {
        qDebug() << "create msg: sending all";
        for (serial *s : serial::serialList)
        {
            *s << *q;
        }
    }

    delete q;
}

void devDist::createCntlMsg()
{
    protocol *p = new protocol();
    protocol::protocolList << p;

    msgCntlDist *q = new msgCntlDist();
    *this >> *q;

    if (this->lastSerial && QDateTime::currentDateTime().secsTo(this->lastseen) < 3) {
        qDebug() << "create msg: sending one";
        *this->lastSerial << *q;
    } else {
        qDebug() << "create msg: sending all";
        for (serial *s : serial::serialList)
        {
            *s << *q;
        }
    }

    delete q;
}

void devAmp::createCntlMsg()
{
    protocol *p = new protocol();
    protocol::protocolList << p;

    msgCntlAmp *q = new msgCntlAmp();
    *this >> *q;

    if (this->lastSerial && QDateTime::currentDateTime().secsTo(this->lastseen) < 3) {
        qDebug() << "create msg: sending one";
        *this->lastSerial << *q;
    } else {
        qDebug() << "create msg: sending all";
        for (serial *s : serial::serialList)
        {
            *s << *q;
        }
    }

    delete q;
}

void devDist::createFakeCntlMsg(const QString &msg)
{
    protocol *p = new protocol();
    protocol::protocolList << p;

    msgCntlDist *q = new msgCntlDist();
    q->createFakeCntlMsg(this->dId, msg);

    for (serial *s : serial::serialList)
    {
        *s << *q;
    }

    delete q;
}

void msgCntlDist::createFakeCntlMsg(const int deviceId, const QString &msg)
{
    QByteArray b = QByteArray::fromHex(msg.toUtf8());
    *this << b;
    this->deviceId = static_cast<quint8>(deviceId);
}

msgCntlDist &operator<< (msgCntlDist &m, const QByteArray &data)
{
    QDataStream(data) >> m.ref_10 >> m.ref_16;
    return m;
}

const QStringList devFreq::addEnum(const QString e) const
{
    alert alrt;
    const QMetaObject *metaObj = alrt.metaObject();
    QMetaEnum enumType = metaObj->enumerator(metaObj->indexOfEnumerator(e.toUtf8()));

    QStringList list;
    for (int i = 0; i < enumType.keyCount(); ++i)
    {
        QString item = QString(enumType.key(i)) + " is "
                + tr(alert::STR_NOR[static_cast<alert::P_NOR>(i)].toUtf8());
        qDebug() << tr("Normal");
        list << item;
    }
    return list;
}
