#ifndef SERIAL_H
#define SERIAL_H

#include <QObject>
#include <QSerialPort>
#include <QSerialPortInfo>
#include <QDateTime>
#include <QThreadPool>
#include <QRunnable>
#include <iso646.h>

class msg;
class msgQuery;
class msgCntlFreq;
class msgCntlDist;
class msgCntlAmp;
class serialThread;

class serial : public QObject
{
    Q_OBJECT

public:
    explicit serial(const QSerialPortInfo &serialportinfo, QObject *parent = nullptr);
    ~serial() override;

    friend serial &operator<< (serial &s, const msg &m);
    friend serial &operator<< (serial &s, const msgQuery &m);
    friend serial &operator<< (serial &s, const msgCntlFreq &m);
    friend serial &operator<< (serial &s, const msgCntlDist &m);
    friend serial &operator<< (serial &s, const msgCntlAmp &m);
    friend const serial &operator>> (const serial &s, msg &m);

#ifdef QT_DEBUG
    static void readFakeData();
#endif

    inline bool timedout() const {
        return QDateTime::currentDateTime().secsTo(lastseen) <= - serial::timeout;
    }

    inline bool has(const QSerialPortInfo &info) const {
        return serialport->portName() == info.portName();
    }

    inline const static enum QSerialPort::BaudRate baudrate = QSerialPort::Baud115200;
    inline const static enum QSerialPort::DataBits databits = QSerialPort::Data8;
    inline const static enum QSerialPort::Parity parity = QSerialPort::NoParity;
    inline const static enum QSerialPort::StopBits stopbits = QSerialPort::OneStop;
    inline const static enum QSerialPort::FlowControl flowcontrol = QSerialPort::NoFlowControl;

    inline static QList<serial *> serialList = QList<serial *>();

private:
    void writeData(const QByteArray &data);

    QDateTime lastseen;
    QByteArray buffer = "";
    inline const static int timeout = 10;
    int serialno = 0;
    serialThread *thread;
    QSerialPort *serialport = new QSerialPort();

signals:
    void openSerial();
    void writeSerial(const QByteArray &data);

public slots:
    void readData();
};

class serialThread : public QThread
{
    Q_OBJECT

    void run() override;

    friend class serial;

private:
    QSerialPort *serialport;
    serial *serialInstance;
};

#endif // SERIAL_H
