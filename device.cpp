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
        dev.findAndUpdate(m);
    }
}

void devFreq::findAndUpdate(const msgFreq *m)
{
    this->str = m->origin;
    this->atten = m->atten;
    this->ch_a = m;
    this->ch_b = m;
    this->voltage = m->voltage;
    this->current = m->current;
    this->output_stat = m->output_stat;
    this->input_stat = m->input_stat;
    this->lock_a1 = m->lock_a1;
    this->lock_a2 = m->lock_a2;
    this->lock_b1 = m->lock_b1;
    this->lock_b2 = m->lock_b2;
    this->ref_10_1 = m->ref_10_1;
    this->ref_10_2 = m->ref_10_2;
    this->ref_3 = m->ref_3;
    this->ref_4 = m->ref_4;
    this->handshake = m->handshake;

    emit this->gotData();
}

void device::findAndUpdate(const msgDist *m)
{
    if (this->dId == m->device)
    {
        devDist dev = static_cast<devDist>(this);
        dev.findAndUpdate(m);
    }
}

void devDist::findAndUpdate(const msgDist *m)
    this->str = m->origin;
    this->ref_10 = m->ref_10;
    this->ref_16 = m->ref_16;
    this->voltage = m->voltage;
    this->current = m->current;
    this->power = m->power;

    emit this->gotData();
}

void device::findAndUpdate(const msgAmp *m)
{
    if (this->dId == m->device)
    {
        devAmp dev = static_cast<devAmp>(this);
        dev.findAndUpdate(m);
    }
}

void devAmp::findAndUpdate(const msgAmp *m)
{
    this->str = m->origin;
    this->power = m->power;
    this->gain = m->gain;
    this->atten = m->atten;
    this->loss = m->loss;
    this->amp_temp = m->temp;
    this->stat = m->stat;
    this->load_temp = m->load_temp;
    this->handshake = m->handshake;

    emit this->gotData();
}
