#ifndef DEVICE_H
#define DEVICE_H

#include <QObject>
#include <QList>
#include <numeric>

class device : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int dId MEMBER dId NOTIFY idChanged)
    Q_PROPERTY(QString name READ name NOTIFY nameChanged)
public:
    explicit device(QObject *parent = nullptr);

signals:
    void idChanged();
    void nameChanged();

public slots:
    inline QString name() const
    {
        QList<std::string> str = device::idName[this->dId];
        return std::accumulate(begin(str), end(str), QString(), [](QString ret, const std::string s)
                -> QString { return ret += tr(s.c_str()); });
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
    int dId;
};

class devFreq : public device
{
    Q_OBJECT
public:
    explicit devFreq(QObject *parent = nullptr);

protected:
    int atten;
    int ch_a;
    int ch_b;
    int voltage;
    int current;
    int radio_stat;
    int mid_stat;
    int lock_a1;
    int lock_a2;
    int lock_b1;
    int lock_b2;
    int ref_10_1;
    int ref_10_2;
    int ref_3;
    int ref_4;
    int handshake;
};

class devDist : public device
{
    Q_OBJECT
public:
    explicit devDist(QObject *parent = nullptr);

protected:
    int ref_10;
    int ref_16;
    int voltage;
    int current;
    int power;
};

class devAmp : public device
{
    Q_OBJECT
public:
    explicit devAmp(QObject *parent = nullptr);

protected:
    int power;
    int gain;
    int atten;
    int loss;
    int temp;
    int stat;
    int load_temp;
    int handshake;
};

#endif // DEVICE_H
