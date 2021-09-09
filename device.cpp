#include "device.h"
#include "protocol.h"
#include "serial.h"

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

void device::createCntlMsg(const QString &msg)
{
    protocol *p = new protocol();
    protocol::protocolList << p;

    msgCntlFreq *q = new msgCntlFreq();
    q->createFakeCntl(this->dId, msg);

    for (serial *s : serial::serialList)
    {
        *s << *q;
    }
}
