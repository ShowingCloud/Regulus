#ifndef DEVICE_H
#define DEVICE_H

#include <QObject>

class device : public QObject
{
    Q_OBJECT
public:
    explicit device(QObject *parent = nullptr);

signals:

public slots:
};

class devFreq : public device
{
    Q_OBJECT
public:
    explicit devFreq(QObject *parent = nullptr);
};

class devDist : public device
{
    Q_OBJECT
public:
    explicit devDist(QObject *parent = nullptr);
};

class devAmp : public device
{
    Q_OBJECT
public:
    explicit devAmp(QObject *parent = nullptr);
};

#endif // DEVICE_H
