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
    msg::validateProtocol(this->buffer, data, this);
}

void serial::readFakeData()
{
    QByteArray data = QByteArray::fromHex("ff010203040101010101010101010103011701aa");
    this->buffer += data;
    lastseen = QDateTime::currentDateTime();
    msg::validateProtocol(this->buffer, data, this);

    data = QByteArray::fromHex("ff010203040101010101010101010102001701aa");
    this->buffer += data;
    lastseen = QDateTime::currentDateTime();
    msg::validateProtocol(this->buffer, data, this);

    data = QByteArray::fromHex("ff01000304050001010001010101010A001701aa");
    this->buffer += data;
    lastseen = QDateTime::currentDateTime();
    msg::validateProtocol(this->buffer, data, this);
}

void serial::writeData(const QByteArray &data) const
{
    serialport->write(data);
}

serial &operator<< (serial &s, const msgQuery &m)
{
    QByteArray data;
    m >> data;

    const char sn = static_cast<char>(s.serialno++);
    data.replace(msgQuery::posSerial, 1, &sn, 1);
    qDebug() << "Serial writing data <msgQuery>: " << data.length() << data.toHex();
    s.writeData(data);
    return s;
}

serial &operator<< (serial &s, const msgCntlFreq &m)
{
    QByteArray data;
    m >> data;

    const char sn = static_cast<char>(s.serialno++);
    data.replace(msgCntlFreq::posSerial, 1, &sn, 1);
    qDebug() << "Serial writing data <msgCntlFreq>: " << data.length() << data.toHex();
    s.writeData(data);
    return s;
}

serial &operator<< (serial &s, const msgCntlDist &m)
{
    QByteArray data;
    m >> data;

    const char sn = static_cast<char>(s.serialno++);
    data.replace(msgCntlDist::posSerial, 1, &sn, 1);
    qDebug() << "Serial writing data <msgCntlDist>: " << data.length() << data.toHex();
    s.writeData(data);
    return s;
}

serial &operator<< (serial &s, const msgCntlAmp &m)
{
    QByteArray data;
    m >> data;

    const char sn = static_cast<char>(s.serialno++);
    data.replace(msgCntlAmp::posSerial, 1, &sn, 1);
    qDebug() << "Serial writing data <msgCntlAmp>: " << data.length() << data.toHex();
    s.writeData(data);
    return s;
}

serial &operator<< (serial &s, const msg &m)
{
    QByteArray data;
    m >> data;
    s.writeData(data);
    return s;
}

const serial &operator>> (const serial &s, msg &m)
{
    Q_UNUSED(m);
    qDebug() << "!!! not processing";
    return s;
}
