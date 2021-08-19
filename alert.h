#ifndef ALERT_H
#define ALERT_H

#include <QObject>

class alert : public QObject
{
    Q_OBJECT
public:
    explicit alert(QObject *parent = nullptr);

signals:

public slots:
};

#endif // ALERT_H