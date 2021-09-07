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

void device::updateDevice(const int dev, const QString str)
{
    for (device *d : device::deviceList)
    {
        d->find_and_set(dev, str);
    }
}

void device::find_and_set(const int dev, const QString str)
{
    if (this->dId == dev)
    {
        this->str = str;
        emit this->gotData();
    }
}
