#include <QDebug>

#include "serial.h"
#include "protocol.h"

serial::serial(const QSerialPortInfo &serialportinfo, QObject *parent) : QObject(parent)
{
    this->serialport->setPort(serialportinfo);
    this->serialport->setBaudRate(serial::baudrate);
    this->serialport->setDataBits(serial::databits);
    this->serialport->setParity(serial::parity);
    this->serialport->setStopBits(serial::stopbits);
    this->serialport->setFlowControl(serial::flowcontrol);

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
    this->buffer += data;
    lastseen = QDateTime::currentDateTime();
    msg::validateProtocol(this->buffer, data);
}

void serial::readFakeData()
{
    QByteArray data = QByteArray::fromHex("ff010203040506070809101112131403161718aa");
    this->buffer += data;
    lastseen = QDateTime::currentDateTime();
    msg::validateProtocol(this->buffer, data);
}

void serial::writeData(const QByteArray &data) const
{
    serialport->write(data);
}

serial &serial::operator<< (const msgQuery &m)
{
    QByteArray data;
    m >> data;

    const char s = static_cast<char>(serialno++);
    data.replace(msgQuery::posSerial, 1, &s, 1);
    qDebug() << "Serial writing data: " << data.length() << data.toHex();
    this->writeData(data);
    return *this;
}

serial &serial::operator<< (const msgCntlFreq &m)
{
    QByteArray data;
    m >> data;

    const char s = static_cast<char>(serialno++);
    data.replace(msgCntlFreq::posSerial, 1, &s, 1);
    qDebug() << "Serial writing data: " << data.length() << data.toHex();
    this->writeData(data);
    return *this;
}

serial &serial::operator<< (const msgCntlDist &m)
{
    QByteArray data;
    m >> data;

    const char s = static_cast<char>(serialno++);
    data.replace(msgCntlDist::posSerial, 1, &s, 1);
    qDebug() << "Serial writing data: " << data.length() << data.toHex();
    this->writeData(data);
    return *this;
}

serial &serial::operator<< (const msgCntlAmp &m)
{
    QByteArray data;
    m >> data;

    const char s = static_cast<char>(serialno++);
    data.replace(msgCntlAmp::posSerial, 1, &s, 1);
    qDebug() << "Serial writing data: " << data.length() << data.toHex();
    this->writeData(data);
    return *this;
}

serial &serial::operator<< (const msg &m)
{
    QByteArray data;
    m >> data;
    this->writeData(data);
    return *this;
}

const serial &serial::operator>> (msg &m) const
{
    return *this;
}
