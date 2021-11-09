#include <QApplication>
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

    thread = new serialThread();
    thread->serialInstance = this;
    serialport->moveToThread(thread);
    thread->serialport = serialport;
    connect(thread, &serialThread::finished, thread, &QThread::deleteLater);
    connect(thread, &serialThread::finished, serialport, &QSerialPort::close);
    connect(thread, &serialThread::finished, serialport, &QSerialPort::deleteLater);
    thread->start();

#ifdef QT_DEBUG
    QByteArray data = QByteArray::fromHex("ff010a03040101010101010101010105001701aa");
    buffer += data;
    lastseen = QDateTime::currentDateTime();
    msg::validateProtocol(buffer, data, this);
#endif
}

void serialThread::run()
{
    QTimer *timer = new QTimer(serialport);
    timer->setSingleShot(true);
    connect(timer, &QTimer::timeout, [=]() {
        if (serialport->open(QIODevice::ReadWrite)) {
            qDebug() << "Serial port opened.";
            connect(serialport, &QSerialPort::readyRead, serialInstance, &serial::readData);
            connect(serialInstance, &serial::writeSerial, serialport, [=](const QByteArray &data){
                serialport->write(data);
            });
        } else {
            qDebug() << "Serial port open failed" << serialport->error();
            timer->start(10000);
        }
    });
    timer->start(0);

    exec();
    timer->deleteLater();
}

serial::~serial()
{
    thread->quit();
    thread->wait();
    qDebug() << "Serial port closed.";
}

void serial::readData()
{
    QByteArray data = serialport->readAll();
    buffer += data;
    lastseen = QDateTime::currentDateTime();
    msg::validateProtocol(buffer, data, this);
}

#ifdef QT_DEBUG
void serial::readFakeData()
{
    srand(static_cast<uint>(time(nullptr)));
    QByteArray buffer;

    QByteArray data = QByteArray::fromHex("ff010a03040101010101010101010103011700aa");
    buffer = data;
    msg::validateProtocol(buffer, data, nullptr);

    data = QByteArray::fromHex("ff" + QString::number(rand() % 10000 * 10000 + rand() % 10000).rightJustified(8, '0').toUtf8() + "0101010101010101010102001700aa");
    //qDebug() << data.toHex();
    buffer = data;
    msg::validateProtocol(buffer, data, nullptr);

    data = QByteArray::fromHex("ff01000a04050001010001010101010A001701aa");
    buffer = data;
    msg::validateProtocol(buffer, data, nullptr);

    data = QByteArray::fromHex("ff00010202030301040105060601070E001701aa");
    buffer = data;
    msg::validateProtocol(buffer, data, nullptr);
}
#endif

void serial::writeData(const QByteArray &data)
{
    emit writeSerial(data);
}

serial &operator<< (serial &s, const msgQuery &m)
{
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
    Q_UNUSED(m)

    qDebug() << "!!! not processing";
    return s;
}
