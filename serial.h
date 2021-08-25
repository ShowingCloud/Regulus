#ifndef SERIAL_H
#define SERIAL_H

#include <QObject>
#include <QSerialPort>

#define SERIAL_BAUDRATE QSerialPort::Baud115200
#define SERIAL_DATABITS QSerialPort::Data8
#define SERIAL_PARITY QSerialPort::NoParity
#define SERIAL_STOPBITS QSerialPort::OneStop
#define SERIAL_FLOWCONTROL QSerialPort::NoFlowControl

class serial : public QObject
{
    Q_OBJECT
public:
    explicit serial(QObject *parent = nullptr);
    ~serial();

private:
    QSerialPort *serialport = new QSerialPort(this);

signals:

public slots:
    void readData();
    void writeData(const QByteArray &data);
};

#endif // SERIAL_H
