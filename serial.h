#ifndef SERIAL_H
#define SERIAL_H

#include <QObject>
#include <QSerialPort>
#include <QDateTime>

#define SERIAL_BAUDRATE     QSerialPort::Baud115200
#define SERIAL_DATABITS     QSerialPort::Data8
#define SERIAL_PARITY       QSerialPort::NoParity
#define SERIAL_STOPBITS     QSerialPort::OneStop
#define SERIAL_FLOWCONTROL  QSerialPort::NoFlowControl
#define SERIAL_TIMEOUT      10

class msg;

class serial : public QObject
{
    Q_OBJECT
public:
    explicit serial(const QSerialPortInfo &serialportinfo, QObject *parent = nullptr);
    ~serial();
    serial &operator<< (const msg &m);
    const serial &operator>> (msg &m) const;

    inline bool timedout()
    {
        return QDateTime::currentDateTime().secsTo(lastseen) < SERIAL_TIMEOUT;
    }

private:
    QSerialPort *serialport = new QSerialPort(this);
    QDateTime lastseen;

signals:

public slots:
    void readData();
    void writeData(const QByteArray &data) const;
};

#endif // SERIAL_H
