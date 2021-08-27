#include <QDebug>

#include "serial.h"
#include "protocol.h"

serial::serial(const QSerialPortInfo &serialportinfo, QObject *parent) : QObject(parent)
{
    this->serialport->setPort(serialportinfo);
    this->serialport->setBaudRate(SERIAL_BAUDRATE);
    this->serialport->setDataBits(SERIAL_DATABITS);
    this->serialport->setParity(SERIAL_PARITY);
    this->serialport->setStopBits(SERIAL_STOPBITS);
    this->serialport->setFlowControl(SERIAL_FLOWCONTROL);

    if(serialport->open(QIODevice::ReadWrite)) {
        qDebug() << "Serial port opened.";
    } else {
        qDebug() << "Serial port open failed" << serialport->error();
    }

    connect(this->serialport, &QSerialPort::readyRead, this, &serial::readData);
}

serial::~serial()
{
    if(this->serialport->isOpen())
        this->serialport->close();
    qDebug() << "Serial port closed.";
}

void serial::readData()
{
    QByteArray data = serialport->readAll();
    lastseen = QDateTime::currentDateTime();
}

void serial::writeData(const QByteArray &data) const
{
    serialport->write(data);
}

serial &serial::operator<< (const protocol &p)
{
    this->postProtocol(p);
    return *this;
}

void serial::postProtocol(const protocol &p) const
{
    QByteArray data;
    p >> data;
    this->writeData(data);
}
