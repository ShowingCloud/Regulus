#include "device.h"

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
        d->findAndUpdate(m);
    }
}

void device::updateDevice(const msgDist &m)
{
    for (device *d : device::deviceList)
    {
        d->findAndUpdate(m);
    }
}

void device::updateDevice(const msgAmp &m)
{
    for (device *d : device::deviceList)
    {
        d->findAndUpdate(m);
    }
}

void device::findAndUpdate(const msgFreq &m)
{
    if (this->dId == m.device)
    {
        devFreq dev = static_cast<devFreq>(this);
        dev.str = m.origin;
        emit dev.gotData();
    }
}

void device::findAndUpdate(const msgDist &m)
{
    if (this->dId == m.device)
    {
        devDist dev = static_cast<devDist>(this);
        dev.str = m.origin;
        emit dev.gotData();
    }
}

void device::findAndUpdate(const msgAmp &m)
{
    if (this->dId == m.device)
    {
        devAmp dev = static_cast<devAmp>(this);
        dev.str = m.origin;
        emit dev.gotData();
    }
}
