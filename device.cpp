#include "device.h"
#include "protocol.h"

#include <QDebug>

device::device(QObject *parent) : QObject(parent)
{
    //connect(this, &device::idChanged, this, &device::nameChanged);
    device::push(this);
}

devFreq::devFreq(QObject *parent) : device(parent)
{

}

devDist::devDist(QObject *parent) : device(parent)
{

}

devAmp::devAmp(QObject *parent) : device(parent)
{

}

void device::updateDevice(const msgFreq &m)
{
    for (device *d : device::deviceList)
    {
        *d << m;
    }
}

void device::updateDevice(const msgDist &m)
{
    for (device *d : device::deviceList)
    {
        *d << m;
    }
}

void device::updateDevice(const msgAmp &m)
{
    for (device *d : device::deviceList)
    {
        *d << m;
    }
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
