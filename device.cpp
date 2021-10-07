#include "device.h"
#include "protocol.h"
#include "serial.h"
#include "database.h"

#include <QDateTime>
#include <QDebug>
#include <iso646.h>

device::device(const QHash<QString, deviceVar*> var, const database::DB_TBL devTable, QObject *parent)
    : QObject(parent), var(var), devTable(devTable)
{
    device::push(this);

    QHash<QString, deviceVar *>::const_iterator v = var.constBegin();
    while (v != var.constEnd()) {
        connect(v.value(), &deviceVar::sendAlert, this, [=]
                (const alert::P_ALERT type, const QVariant value, const QVariant normal_value){
            staticDB.setAlert(devTable, dId, type, v.key(), value, normal_value);
        });
        v++;
    }
}

device &operator<< (device &d, const msgFreq &m)
{
    if (d.dId == m.deviceId)
    {
        devFreq &dev = dynamic_cast<devFreq &>(d);
        dev.str = m.origin;
        dev.lastseen = QDateTime::currentDateTime();
        dev.timerStr = dev.lastseen.toString(Qt::ISODate) + "#" + QString::number(m.serialId);
        dev.lastSerial = m.serialport;
        dev << m;
    }
    return d;
}

device &operator<< (device &d, const msgDist &m)
{
    if (d.dId == m.deviceId)
    {
        devDist &dev = dynamic_cast<devDist &>(d);
        dev.str = m.origin;
        dev.lastseen = QDateTime::currentDateTime();
        dev.timerStr = dev.lastseen.toString(Qt::ISODate) + "#" + QString::number(m.serialId);
        dev.lastSerial = m.serialport;
        dev << m;
    }
    return d;
}

device &operator<< (device &d, const msgAmp &m)
{
    if (d.dId == m.deviceId)
    {
        devAmp &dev = dynamic_cast<devAmp &>(d);
        dev.str = m.origin;
        dev.lastseen = QDateTime::currentDateTime();
        dev.timerStr = dev.lastseen.toString(Qt::ISODate) + "#" + QString::number(m.serialId);
        dev.lastSerial = m.serialport;
        dev << m;
    }
    return d;
}

devFreq &operator<< (devFreq &dev, const msgFreq &m)
{
    dev.var["atten"]->setValue(m.atten);
    //ch_a = m;
    //ch_b = m;
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
    dev.var["ref_10_3"]->setValue(m.ref_10_3);
    dev.var["ref_10_4"]->setValue(m.ref_10_4);
    dev.var["ref_inner_1"]->setValue(m.ref_inner_1);
    dev.var["ref_inner_2"]->setValue(m.ref_inner_2);
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
    dev.var["s_stand_wave"]->setValue(m.stat_stand_wave);
    dev.var["s_temp"]->setValue(m.stat_temp);
    dev.var["s_current"]->setValue(m.stat_current);
    dev.var["s_voltage"]->setValue(m.stat_voltage);
    dev.var["s_power"]->setValue(m.stat_power);
    dev.var["handshake"]->setValue(m.handshake);

    emit dev.gotData();
    return dev;
}

const devFreq &operator>> (const devFreq &dev, msgCntlFreq &m)
{
    m.atten = static_cast<quint8>(dev.var["atten"]->getValue());
    m.ref_10_a = static_cast<quint8>(dev.var["ch_a"]->getValue());
    m.ref_10_b = static_cast<quint8>(dev.var["ch_b"]->getValue());

    m.setDeviceId(static_cast<quint8>(dev.dId));
    return dev;
}

const devDist &operator>> (const devDist &dev, msgCntlDist &m)
{
    m.ref_10 = static_cast<quint8>(dev.var["ref_10"]->getValue());
    m.ref_16 = static_cast<quint8>(dev.var["ref_16"]->getValue());

    m.setDeviceId(static_cast<quint8>(dev.dId));
    return dev;
}

const devAmp &operator>> (const devAmp &dev, msgCntlAmp &m)
{
    m.atten_mode = static_cast<quint8>(dev.var["atten_mode"]->getValue());
    m.atten = static_cast<quint8>(dev.var["atten"]->getValue());
    m.power = static_cast<quint16>(dev.var["power"]->getValue());
    m.gain = static_cast<quint16>(dev.var["gain"]->getValue());

    m.setDeviceId(static_cast<quint8>(dev.dId));
    return dev;
}

const QString devFreq::showIndicatorColor() const
{
    if (timedout())
        return alert::STR_COLOR[alert::P_COLOR_ABNORMAL];
    else
        if (stateGood("atten") and stateGood("voltage") and stateGood("current")
                and stateGood("radio_stat") and stateGood("mid_stat")
                and (stateGood("lock_a1") or stateGood("lock_b1"))
                and (stateGood("ref_10_1") or stateGood("ref_10_2") or stateGood("ref_10_3")
                     or stateGood("ref_10_4") or stateGood("ref_inner_1") or stateGood("ref_inner_2"))
                and stateGood("handshake"))
            return alert::STR_COLOR[alert::P_COLOR_NORMAL];
        else
            return alert::STR_COLOR[alert::P_COLOR_ABNORMAL];
}

const QString devDist::showIndicatorColor() const
{
    if (timedout())
        return alert::STR_COLOR[alert::P_COLOR_ABNORMAL];
    else
        if (stateGood("ref_10") and stateGood("ref_16") and stateGood("voltage")
                and stateGood("current")
                and (stateGood("lock_10_1") or stateGood("lock_10_2")
                     or stateGood("lock_10_3") or stateGood("lock_10_4")))
            return alert::STR_COLOR[alert::P_COLOR_NORMAL];
        else
            return alert::STR_COLOR[alert::P_COLOR_ABNORMAL];
}

const QString devAmp::showIndicatorColor() const
{
    if (timedout())
        return alert::STR_COLOR[alert::P_COLOR_ABNORMAL];
    else
        if (stateGood("power") and stateGood("gain") and stateGood("atten")
                and stateGood("loss") and stateGood("amp_temp") and stateGood("load_temp")
                and stateGood("s_stand_wave") and stateGood("s_temp") and stateGood("s_current")
                and stateGood("s_voltage") and stateGood("s_power") and stateGood("handshake"))
            return alert::STR_COLOR[alert::P_COLOR_NORMAL];
        else
            return alert::STR_COLOR[alert::P_COLOR_ABNORMAL];
}

void devFreq::createCntlMsg() const
{
    protocol *p = new protocol();
    protocol::protocolList << p;

    msgCntlFreq *q = new msgCntlFreq();
    *this >> *q;

    if (lastSerial and QDateTime::currentDateTime().secsTo(lastseen) < 3) {
        qDebug() << "create msg: sending one";
        *lastSerial << *q;
    } else {
        qDebug() << "create msg: sending all";
        for (serial *s : qAsConst(serial::serialList))
            *s << *q;
    }

    delete q;
}

void devDist::createCntlMsg() const
{
    protocol *p = new protocol();
    protocol::protocolList << p;

    msgCntlDist *q = new msgCntlDist();
    *this >> *q;

    if (lastSerial and QDateTime::currentDateTime().secsTo(lastseen) < 3) {
        qDebug() << "create msg: sending one";
        *lastSerial << *q;
    } else {
        qDebug() << "create msg: sending all";
        for (serial *s : qAsConst(serial::serialList))
            *s << *q;
    }

    delete q;
}

void devAmp::createCntlMsg() const
{
    protocol *p = new protocol();
    protocol::protocolList << p;

    msgCntlAmp *q = new msgCntlAmp();
    *this >> *q;

    if (lastSerial and QDateTime::currentDateTime().secsTo(lastseen) < 3) {
        qDebug() << "create msg: sending one";
        *lastSerial << *q;
    } else {
        qDebug() << "create msg: sending all";
        for (serial *s : qAsConst(serial::serialList))
            *s << *q;
    }

    delete q;
}
