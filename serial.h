#ifndef SERIAL_H
#define SERIAL_H

#include <QObject>
#include <QSerialPort>

class serial : public QObject
{
    Q_OBJECT
public:
    explicit serial(QObject *parent = nullptr);

signals:

public slots:
};

#endif // SERIAL_H
