#ifndef SERIAL_H
#define SERIAL_H

#include <QObject>
#include <QSerialPort>
#include <QDateTime>

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
        return QDateTime::currentDateTime().secsTo(lastseen) < serial::timeout;
    }

    inline const static enum QSerialPort::BaudRate baudrate = QSerialPort::Baud115200;
    inline const static enum QSerialPort::DataBits databits = QSerialPort::Data8;
    inline const static enum QSerialPort::Parity parity = QSerialPort::NoParity;
    inline const static enum QSerialPort::StopBits stopbits = QSerialPort::OneStop;
    inline const static enum QSerialPort::FlowControl flowcontrol = QSerialPort::NoFlowControl;

private:
    QSerialPort *serialport = new QSerialPort(this);
    QDateTime lastseen;
    QByteArray buffer = "";
    inline const static int timeout = 10;

signals:

public slots:
    void readData();
    void writeData(const QByteArray &data) const;
};

#endif // SERIAL_H