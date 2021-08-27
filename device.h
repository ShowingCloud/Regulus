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

#endif // DEVICE_H