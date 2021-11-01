#include <QDebug>

#ifdef QT_DEBUG
#include <stdlib.h>
#include <time.h>
#endif

#include "serial.h"
#include "protocol.h"

serial::serial(const QSerialPortInfo &serialportinfo, QObject *parent) : QObject(parent)
{
    serialport->setPort(serialportinfo);
    serialport->setBaudRate(serial::baudrate);
    serialport->setDataBits(serial::databits);
    serialport->setParity(serial::parity);
    serialport->setStopBits(serial::stopbits);
    serialport->setFlowControl(serial::flowcontrol);

    openPort();
    connect(serialport, &QSerialPort::readyRead, this, &serial::readData);

#ifdef QT_DEBUG
    QByteArray data = QByteArray::fromHex("ff010a03040101010101010101010105001701aa");
    buffer += data;
    lastseen = QDateTime::currentDateTime();
    msg::validateProtocol(buffer, data, this);
#endif
}

void serial::openPort()
{
#if QT_VERSION < QT_VERSION_CHECK(5, 15, 0)
    QThreadPool::globalInstance()->start(new FunctionRunnable([&](){
#else
    QThreadPool::globalInstance()->start(([&](){
#endif
        if (serialport->open(QIODevice::ReadWrite))
            qDebug() << "Serial port opened.";
        else
            qDebug() << "Serial port open failed" << serialport->error();
    }));
}

serial::~serial()
{
    if (serialport->isOpen())
        serialport->close();
    qDebug() << "Serial port closed.";
    delete serialport;
}

void serial::readData()
{
    if (not serialport->isOpen())
        return;

    QByteArray data = serialport->readAll();
    buffer += data;
    lastseen = QDateTime::currentDateTime();
    msg::validateProtocol(buffer, data, this);
}

#ifdef QT_DEBUG
void serial::readFakeData()
{
    srand(static_cast<uint>(time(nullptr)));

    QByteArray data = QByteArray::fromHex("ff010a03040101010101010101010103011701aa");
    buffer += data;
    lastseen = QDateTime::currentDateTime();
    msg::validateProtocol(buffer, data, this);

    data = QByteArray::fromHex("ff" + QString::number(rand() % 10000 * 10000 + rand() % 10000).rightJustified(8, '0').toUtf8() + "0101010101010101010102001700aa");
    //qDebug() << data.toHex();
    buffer += data;
    lastseen = QDateTime::currentDateTime();
    msg::validateProtocol(buffer, data, this);

    data = QByteArray::fromHex("ff01000a04050001010001010101010A001701aa");
    buffer += data;
    lastseen = QDateTime::currentDateTime();
    msg::validateProtocol(buffer, data, this);

    data = QByteArray::fromHex("ff00010202030301040105060601070E001701aa");
    buffer += data;
    lastseen = QDateTime::currentDateTime();
    msg::validateProtocol(buffer, data, this);
}
#endif

void serial::writeData(const QByteArray &data) const
{
    if (not serialport->isOpen())
        return;

    serialport->write(data);
}

serial &operator<< (serial &s, const msgQuery &m)
{
    if (not s.serialport->isOpen())
        return s;

    QByteArray data;
    m >> data;

    const char sn = static_cast<char>(s.serialno++);
    data.replace(msgQuery::posSerial, 1, &sn, 1);
    qInfo() << "Serial writing data <msgQuery>: " << data.length() << data.toHex();
    s.writeData(data);
    return s;
}

serial &operator<< (serial &s, const msgCntlFreq &m)
{
    if (not s.serialport->isOpen())
        return s;

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
    if (not s.serialport->isOpen())
        return s;

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
    if (not s.serialport->isOpen())
        return s;

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
    if (not s.serialport->isOpen())
        return s;

    QByteArray data;
    m >> data;
    s.writeData(data);
    return s;
}

const serial &operator>> (const serial &s, msg &m)
{
    Q_UNUSED(m)

    if (not s.serialport->isOpen())
        return s;

    qDebug() << "!!! not processing";
    return s;
}
