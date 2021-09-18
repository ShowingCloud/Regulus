#include "device.h"
#include "protocol.h"
#include "serial.h"

#include <QDateTime>
#include <QDebug>
#include <iso646.h>

device::device(QHash<QString, deviceVar*> var, QObject *parent) : QObject(parent), var(var)
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
    dev.var["radio_stat"]->setValue(m.radio_stat);
    dev.var["mid_stat"]->setValue(m.mid_stat);
    dev.var["lock_a1"]->setValue(m.lock_a1);
    dev.var["lock_a2"]->setValue(m.lock_a2);
    dev.var["lock_b1"]->setValue(m.lock_b1);
    dev.var["lock_b2"]->setValue(m.lock_b2);
    dev.var["ref_10_1"]->setValue(m.ref_10_1);
    dev.var["ref_10_2"]->setValue(m.ref_10_2);
    dev.var["ref_3"]->setValue(m.ref_3);
    dev.var["ref_4"]->setValue(m.ref_4);
    dev.var["handshake"]->setValue(m.handshake);
    dev.var["masterslave"]->setValue(m.masterslave);

    emit dev.gotData();
    return dev;
}

devDist &operator<< (devDist &dev, const msgDist &m)
{
    dev.var["ref_10"]->setValue(m.ref_10);
    dev.var["ref_16"]->setValue(m.ref_16);
    dev.var["voltage"]->setValue(m.voltage);
    dev.var["current"]->setValue(m.current);
    dev.var["lock_10_1"]->setValue(m.lock_10_1);
    dev.var["lock_10_2"]->setValue(m.lock_10_2);
    dev.var["lock_16_1"]->setValue(m.lock_16_1);
    dev.var["lock_16_2"]->setValue(m.lock_16_2);

    emit dev.gotData();
    return dev;
}

devAmp &operator<< (devAmp &dev, const msgAmp &m)
{
    dev.var["power"]->setValue(m.power);
    dev.var["gain"]->setValue(m.gain);
    dev.var["atten"]->setValue(m.atten);
    dev.var["loss"]->setValue(m.loss);
    dev.var["amp_temp"]->setValue(m.temp);
    dev.var["load_temp"]->setValue(m.load_temp);
    dev.var["handshake"]->setValue(m.handshake);

    emit dev.gotData();
    return dev;
}

const devFreq &operator>> (const devFreq &dev, msgCntlFreq &m)
{
    m.atten = static_cast<quint8>(dev.var["atten"]->getValue());
    m.ref_10_a = static_cast<quint8>(dev.var["ch_a"]->getValue());
    m.ref_10_b = static_cast<quint8>(dev.var["ch_b"]->getValue());

    return dev;
}

const devDist &operator>> (const devDist &dev, msgCntlDist &m)
{
    m.ref_10 = static_cast<quint8>(dev.var["ref_10"]->getValue());
    m.ref_16 = static_cast<quint8>(dev.var["ref_16"]->getValue());

    return dev;
}

const devAmp &operator>> (const devAmp &dev, msgCntlAmp &m)
{
    m.atten_mode = static_cast<quint8>(dev.var["atten_mode"]->getValue());
    m.atten = static_cast<quint8>(dev.var["atten"]->getValue());
    m.power = static_cast<quint16>(dev.var["power"]->getValue());
    m.gain = static_cast<quint16>(dev.var["gain"]->getValue());

    return dev;
}

void devFreq::createCntlMsg()
{
    protocol *p = new protocol();
    protocol::protocolList << p;

    msgCntlFreq *q = new msgCntlFreq();
    *this >> *q;
    q->setDeviceId(this->dId);

    if (this->lastSerial and QDateTime::currentDateTime().secsTo(this->lastseen) < 3) {
        qDebug() << "create msg: sending one";
        *this->lastSerial << *q;
    } else {
        qDebug() << "create msg: sending all";
        for (serial *s : qAsConst(serial::serialList))
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
    q->setDeviceId(this->dId);

    if (this->lastSerial and QDateTime::currentDateTime().secsTo(this->lastseen) < 3) {
        qDebug() << "create msg: sending one";
        *this->lastSerial << *q;
    } else {
        qDebug() << "create msg: sending all";
        for (serial *s : qAsConst(serial::serialList))
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
    q->setDeviceId(this->dId);

    if (this->lastSerial and QDateTime::currentDateTime().secsTo(this->lastseen) < 3) {
        qDebug() << "create msg: sending one";
        *this->lastSerial << *q;
    } else {
        qDebug() << "create msg: sending all";
        for (serial *s : qAsConst(serial::serialList))
        {
            *s << *q;
        }
    }

    delete q;
}
