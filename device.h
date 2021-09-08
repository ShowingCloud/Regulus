#ifndef DEVICE_H
#define DEVICE_H

#include <QObject>
#include <QList>
#include <QHash>
#include <numeric>

class msg;
class msgFreq;
class msgDist;
class msgAmp;
class protocol;

class device : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int dId MEMBER dId NOTIFY idSet)
    Q_PROPERTY(QString name READ name NOTIFY idSet)
    Q_PROPERTY(QString str MEMBER str NOTIFY gotData)
public:
    explicit device(QObject *parent = nullptr);

    inline static QList<device *> deviceList = {};

    inline QString trConcat(const QList<std::string> str) const
    {
        return std::accumulate(begin(str), end(str), QString(), [](QString ret, const std::string s)
                -> QString { return ret += tr(s.c_str()); });
    }

    template <class T> static void updateDevice(const T &m);
    friend device &operator<< (device &dev, const msgFreq &m);
    friend device &operator<< (device &dev, const msgDist &m);
    friend device &operator<< (device &dev, const msgAmp &m);

signals:
    void idSet();
    void gotData();

public slots:
    inline QString name() const
    {
        return this->trConcat(device::idName[this->dId]);
    }

protected:
    static const inline QHash<int, QList<std::string>> idName = {
        {0x04, {"C1", QT_TR_NOOP("Down Frequency Conversion")}},
        {0x05, {"C1", QT_TR_NOOP("Down Frequency Conversion")}},
        {0x06, {"C2", QT_TR_NOOP("Down Frequency Conversion")}},
        {0x07, {"C2", QT_TR_NOOP("Down Frequency Conversion")}},
        {0x00, {"C1", QT_TR_NOOP("Up Frequency Conversion")}},
        {0x01, {"C1", QT_TR_NOOP("Up Frequency Conversion")}},
        {0x02, {"C2", QT_TR_NOOP("Up Frequency Conversion")}},
        {0x03, {"C2", QT_TR_NOOP("Up Frequency Conversion")}},
        {0x0A, {QT_TR_NOOP("Middle Frequency Distribution"), "A"}},
        {0x0B, {QT_TR_NOOP("Middle Frequency Distribution"), "B"}},
        {0x0C, {"C1", QT_TR_NOOP("High Amplification"), "A"}},
        {0x0D, {"C1", QT_TR_NOOP("High Amplification"), "B"}},
        {0x0E, {"C2", QT_TR_NOOP("High Amplification"), "A"}},
        {0x0F, {"C2", QT_TR_NOOP("High Amplification"), "B"}}
    };

private:
    int dId = 0;
    QString str = QString();

    protocol *query;
    protocol *rntl;

    inline static void push(device *dev)
    {
        device::deviceList << dev;
    }
};

template <class T> void device::updateDevice(const T &m)
{
    for (device *d : device::deviceList)
    {
        *d << m;
    }
}

class devFreq : public device
{
    Q_OBJECT
    Q_PROPERTY(int atten MEMBER atten NOTIFY gotData)
    Q_PROPERTY(int voltage MEMBER voltage NOTIFY gotData)
    Q_PROPERTY(int current MEMBER current NOTIFY gotData)
    Q_PROPERTY(bool output_stat MEMBER output_stat NOTIFY gotData)
    Q_PROPERTY(bool input_stat MEMBER input_stat NOTIFY gotData)
    Q_PROPERTY(int lock_a1 MEMBER lock_a1 NOTIFY gotData)
    Q_PROPERTY(int lock_a2 MEMBER lock_a2 NOTIFY gotData)
    Q_PROPERTY(int lock_b1 MEMBER lock_b1 NOTIFY gotData)
    Q_PROPERTY(int lock_b2 MEMBER lock_b2 NOTIFY gotData)
    Q_PROPERTY(bool ref_10_1 MEMBER ref_10_1 NOTIFY gotData)
    Q_PROPERTY(bool ref_10_2 MEMBER ref_10_2 NOTIFY gotData)
    Q_PROPERTY(bool ref_3 MEMBER ref_3 NOTIFY gotData)
    Q_PROPERTY(bool ref_4 MEMBER ref_4 NOTIFY gotData)
public:
    explicit devFreq(device *parent = nullptr) : device(parent) {}
    friend devFreq &operator<< (devFreq &dev, const msgFreq &m);

private:
    int atten = int();
    int ch_a = int();
    int ch_b = int();
    int voltage = int();
    int current = int();
    bool output_stat = true;
    bool input_stat = true;
    int lock_a1 = int();
    int lock_a2 = int();
    int lock_b1 = int();
    int lock_b2 = int();
    bool ref_10_1 = true;
    bool ref_10_2 = true;
    bool ref_3 = true;
    bool ref_4 = true;
    int handshake = int();
};

class devDist : public device
{
    Q_OBJECT
    Q_PROPERTY(int voltage MEMBER voltage NOTIFY gotData)
    Q_PROPERTY(int current MEMBER voltage NOTIFY gotData)
    Q_PROPERTY(int power MEMBER voltage NOTIFY gotData)
public:
    explicit devDist(device *parent = nullptr) : device(parent) {}
    friend devDist &operator<< (devDist &dev, const msgDist &m);

protected:
    int ref_10 = int();
    int ref_16 = int();
    int voltage = int();
    int current = int();
    int power = int();
};

class devAmp : public device
{
    Q_OBJECT
    Q_PROPERTY(int power MEMBER power NOTIFY gotData)
    Q_PROPERTY(int gain MEMBER gain NOTIFY gotData)
    Q_PROPERTY(int atten MEMBER atten NOTIFY gotData)
    Q_PROPERTY(int loss MEMBER loss NOTIFY gotData)
    Q_PROPERTY(int amp_temp MEMBER amp_temp NOTIFY gotData)
    Q_PROPERTY(int load_temp MEMBER load_temp NOTIFY gotData)
public:
    explicit devAmp(device *parent = nullptr) : device(parent) {}
    friend devAmp &operator<< (devAmp &dev, const msgAmp &m);

protected:
    int power = int();
    int gain = int();
    int atten = int();
    int loss = int();
    int amp_temp = int();
    int stat = int();
    int load_temp = int();
    int handshake = int();
};

#endif // DEVICE_H
