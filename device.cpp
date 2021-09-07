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

void device::updateDevice(const msgFreq *m)
{
    for (device *d : device::deviceList)
    {
        d->findAndUpdate(m);
    }
}

void device::updateDevice(const msgDist *m)
{
    for (device *d : device::deviceList)
    {
        d->findAndUpdate(m);
    }
}

void device::updateDevice(const msgAmp *m)
{
    for (device *d : device::deviceList)
    {
        d->findAndUpdate(m);
    }
}

void device::findAndUpdate(const msgFreq *m)
{
    if (this->dId == m->device)
    {
        devFreq dev = static_cast<devFreq>(this);
        dev.str = m->origin;
        dev.atten = m->atten;
        dev.ch_a = m;
        dev.ch_b = m;
        dev.voltage = m->voltage;
        dev.current = m->current;
        dev.output_stat = m->output_stat;
        dev.input_stat = m->input_stat;
        dev.lock_a1 = m->lock_a1;
        dev.lock_a2 = m->lock_a2
        dev.lock_b1 = m->lock_b1;
        dev.lock_b2 = m->lock_b2;
        dev.ref_10_1 = m->ref_10_1;
        dev.ref_10_2 = m->ref_10_2;
        dev.ref_3 = m->ref_3;
        dev.ref_4 = m->ref_4;
        dev.handshake = m->handshake;

        emit dev.gotData();
    }
}

void device::findAndUpdate(const msgDist *m)
{
    if (this->dId == m->device)
    {
        devDist dev = static_cast<devDist>(this);
        dev.str = m->origin;
        dev.ref_10 = m->ref_10;
        dev.ref_16 = m->ref_16;
        dev.voltage = m->voltage;
        dev.current = m->current;
        dev.power = m->power;

        emit dev.gotData();
    }
}

void device::findAndUpdate(const msgAmp *m)
{
    if (this->dId == m->device)
    {
        devAmp dev = static_cast<devAmp>(this);
        dev.str = m->origin;
        dev.power = m->power;
        dev.gain = m->gain;
        dev.atten = m->atten;
        dev.loss = m->loss;
        dev.amp_temp = m->temp;
        dev.stat = m->stat;
        dev.load_temp = m->load_temp;
        dev.handshake = m->handshake;

        emit dev.gotData();
    }
}
