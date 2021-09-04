#ifndef DEVICE_H
#define DEVICE_H

#include <QObject>

class device : public QObject
{
    Q_OBJECT
public:
    explicit device(const QString name, QObject *parent = nullptr);

signals:

public slots:
};

class devFreq : public device
{
    Q_OBJECT
public:
    explicit devFreq(const QString name, QObject *parent = nullptr);

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
    explicit devDist(const QString name, QObject *parent = nullptr);

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
    explicit devAmp(const QString name, QObject *parent = nullptr);
};

#endif // DEVICE_H
