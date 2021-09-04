#ifndef DEVICE_H
#define DEVICE_H

#include <QObject>
#include <QList>
#include <QDebug>

class device : public QObject
{
    Q_OBJECT
public:
    explicit device(QObject *parent = nullptr);
    int id;

signals:

public slots:
    inline void setId(const int id)
    {
        this->id = id;
    }

    inline QString name() const
    {
        return device::idName[this->id];
    }

protected:
    static const inline QHash<int, QString> idName = {
        {0x04, "C1" + QObject::tr("Down Frequency Conversion")},
        {0x05, "C1" + QObject::tr("Down Frequency Conversion")},
        {0x06, "C2" + QObject::tr("Down Frequency Conversion")},
        {0x07, "C2" + QObject::tr("Down Frequency Conversion")},
        {0x00, "C1" + QObject::tr("Up Frequency Conversion")},
        {0x01, "C1" + QObject::tr("Up Frequency Conversion")},
        {0x02, "C2" + QObject::tr("Up Frequency Conversion")},
        {0x03, "C2" + QObject::tr("Up Frequency Conversion")},
        {0x0A, QObject::tr("Middle Frequency Distribution") + "A"},
        {0x0B, QObject::tr("Middle Frequency Distribution") + "B"},
        {0x0C, "C1" + QObject::tr("High Amplification") + "A"},
        {0x0D, "C1" + QObject::tr("High Amplification") + "B"},
        {0x0E, "C2" + QObject::tr("High Amplification") + "A"},
        {0x0F, "C2" + QObject::tr("High Amplification") + "B"}
    };
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
