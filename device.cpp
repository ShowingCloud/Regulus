#include "device.h"
#include "protocol.h"
#include "serial.h"

#include <QDateTime>
#include <QDebug>

device::device(QObject *parent) : QObject(parent)
{
    //connect(this, &device::idChanged, this, &device::nameChanged);
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
    dev.atten = m.atten;
    //this->ch_a = m;
    //this->ch_b = m;
    dev.voltage = m.voltage;
    dev.current = m.current;
    dev.output_stat = m.output_stat;
    dev.input_stat = m.input_stat;
    dev.lock_a1 = m.lock_a1;
    dev.lock_a2 = m.lock_a2;
    dev.lock_b1 = m.lock_b1;
    dev.lock_b2 = m.lock_b2;
    dev.ref_10_1 = m.ref_10_1;
    dev.ref_10_2 = m.ref_10_2;
    dev.ref_3 = m.ref_3;
    dev.ref_4 = m.ref_4;
    dev.handshake = m.handshake;

    emit dev.gotData();
    return dev;
}

devDist &operator<< (devDist &dev, const msgDist &m)
{
    dev.ref_10 = m.ref_10;
    dev.ref_16 = m.ref_16;
    dev.voltage = m.voltage;
    dev.current = m.current;
    dev.power = m.power;

    emit dev.gotData();
    return dev;
}

devAmp &operator<< (devAmp &dev, const msgAmp &m)
{
    dev.power = m.power;
    dev.gain = m.gain;
    dev.atten = m.atten;
    dev.loss = m.loss;
    dev.amp_temp = m.temp;
    dev.stat = m.stat;
    dev.load_temp = m.load_temp;
    dev.handshake = m.handshake;

    emit dev.gotData();
    return dev;
}

const devFreq &operator>> (const devFreq &dev, msgCntlFreq &m)
{
    m.atten = static_cast<quint8>(dev.atten);
    m.ref_10_a = static_cast<quint8>(dev.ref_10_1);
    m.ref_10_b = static_cast<quint8>(dev.ref_10_2);

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
    m.atten = static_cast<quint8>(dev.atten);
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

    if (this->lastSerial and QDateTime::currentDateTime().secsTo(this->lastseen) < 3) {
        qDebug() << "create msg: sending one";
        *this->lastSerial << *q;
    } else {
        qDebug() << "create msg: sending all";
        for (serial *s : serial::serialList)
        {
            *s << *q;
        }
    }
}

void devDist::createCntlMsg()
{
    protocol *p = new protocol();
    protocol::protocolList << p;

    msgCntlDist *q = new msgCntlDist();
    *this >> *q;

    if (this->lastSerial and QDateTime::currentDateTime().secsTo(this->lastseen) < 3) {
        qDebug() << "create msg: sending one";
        *this->lastSerial << *q;
    } else {
        qDebug() << "create msg: sending all";
        for (serial *s : serial::serialList)
        {
            *s << *q;
        }
    }
}

void devAmp::createCntlMsg()
{
    protocol *p = new protocol();
    protocol::protocolList << p;

    msgCntlAmp *q = new msgCntlAmp();
    *this >> *q;

    if (this->lastSerial and QDateTime::currentDateTime().secsTo(this->lastseen) < 3) {
        qDebug() << "create msg: sending one";
        *this->lastSerial << *q;
    } else {
        qDebug() << "create msg: sending all";
        for (serial *s : serial::serialList)
        {
            *s << *q;
        }
    }
}
