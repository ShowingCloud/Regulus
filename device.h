#ifndef DEVICE_H
#define DEVICE_H

#include <QObject>
#include <QList>
#include <QHash>
#include <QDateTime>
#include <numeric>
#include <iso646.h>

class msg;
class msgFreq;
class msgDist;
class msgAmp;
class msgCntlFreq;
class msgCntlDist;
class msgCntlAmp;
class protocol;
class serial;

#include "alert.h"

class device : public QObject
{
    Q_OBJECT
    Q_ENUM(alert::P_NOR)
    Q_ENUM(alert::P_LOCK)
    Q_ENUM(alert::P_MS)
    Q_ENUM(alert::P_HSK)
    Q_ENUM(alert::P_ATTEN)
    Q_ENUM(alert::P_STAT)
    Q_ENUM(alert::P_CH)
    Q_PROPERTY(int          dId         MEMBER  dId      NOTIFY idSet)
    Q_PROPERTY(QString      name        READ    name     NOTIFY idSet)
    Q_PROPERTY(QString      str         MEMBER  str      NOTIFY gotData)
    Q_PROPERTY(QDateTime    lastseen    MEMBER  lastseen NOTIFY gotData)
    Q_PROPERTY(QString      timerStr    MEMBER  timerStr NOTIFY gotData)
public:
    explicit device(const QHash<QString, deviceVar *> var, QObject *parent = nullptr);
    friend device &operator<< (device &dev, const msgFreq &m);
    friend device &operator<< (device &dev, const msgDist &m);
    friend device &operator<< (device &dev, const msgAmp &m);

    inline static QList<device *> deviceList = {};

    inline QString trConcat(const QList<std::string> str) const
    {
        return std::accumulate(begin(str), end(str), QString(), [](QString ret, const std::string s)
                -> QString { return ret += tr(s.c_str()); });
    }

    template <class T> static void updateDevice(const T &m)
    {
        for (device *d : device::deviceList)
        {
            *d << m;
        }
    }

signals:
    void idSet();
    void gotData();

public slots:
    virtual void createCntlMsg() = 0;
    virtual const QString showIndicatorColor() const = 0;

    inline QString name() const
    {
        return this->trConcat(device::idName[this->dId]);
    }

    inline bool timedout() const
    {
        return lastseen == QDateTime()
                or QDateTime::currentDateTime().secsTo(lastseen) <= - alert::timeout;
    }

    inline const QString showDisplay(const QString itemName) const
    {
        if (!var.contains(itemName.toUtf8())) {
            qDebug() << "Missing item " << itemName;
            return QString();
        }
        return var[itemName.toUtf8()]->display;
    }

    inline const QString showColor(const QString itemName) const
    {
        if (!var.contains(itemName.toUtf8())) {
            qDebug() << "Missing item " << itemName;
            return QString();
        } else if (this->timedout()) {
            return alert::STR_COLOR[alert::P_COLOR_OTHERS];
        }
        return var[itemName.toUtf8()]->getColor();
    }

    inline QVariant getValue(const QString itemName)
    {
        if (!var.contains(itemName.toUtf8())) {
            qDebug() << "Missing item " << itemName;
            return QVariant();
        }
        return var[itemName.toUtf8()]->getValue();
    }

    inline void setHold(const QString itemName)
    {
        if (!var.contains(itemName.toUtf8())) {
            qDebug() << "Missing item " << itemName;
            return;
        }
        var[itemName.toUtf8()]->holding = true;
        var[itemName.toUtf8()]->v_hold = var[itemName.toUtf8()]->value;
    }

    inline void releaseHold(const QString itemName)
    {
        if (!var.contains(itemName.toUtf8())) {
            qDebug() << "Missing item " << itemName;
            return;
        }
        var[itemName.toUtf8()]->holding = false;
        var[itemName.toUtf8()]->setValue(var[itemName.toUtf8()]->value);
        // The above line is for displaying
    }

    inline void submitHold(const QString itemName) /* not in use */
    {
        if (!var.contains(itemName.toUtf8())) {
            qDebug() << "Missing item " << itemName;
            return;
        }
        var[itemName.toUtf8()]->setValue(var[itemName.toUtf8()]->v_hold);
        var[itemName.toUtf8()]->holding = false;
    }

    inline void holdValue(const QString itemName, const QVariant val)
    {
        if (!var.contains(itemName.toUtf8())) {
            qDebug() << "Missing item " << itemName;
            return;
        }
        var[itemName.toUtf8()]->holding = true;
        var[itemName.toUtf8()]->v_hold = val;
    }

protected:
    static const inline QHash<int, QList<std::string>> idName = {
        {0x04, {"C1 ", QT_TR_NOOP("Down Frequency Conversion")}},
        {0x05, {"C1 ", QT_TR_NOOP("Down Frequency Conversion")}},
        {0x06, {"C2 ", QT_TR_NOOP("Down Frequency Conversion")}},
        {0x07, {"C2 ", QT_TR_NOOP("Down Frequency Conversion")}},
        {0x00, {"C1 ", QT_TR_NOOP("Up Frequency Conversion")}},
        {0x01, {"C1 ", QT_TR_NOOP("Up Frequency Conversion")}},
        {0x02, {"C2 ", QT_TR_NOOP("Up Frequency Conversion")}},
        {0x03, {"C2 ", QT_TR_NOOP("Up Frequency Conversion")}},
        {0x0A, {QT_TR_NOOP("Middle Frequency Distribution"), " A"}},
        {0x0B, {QT_TR_NOOP("Middle Frequency Distribution"), " B"}},
        {0x0C, {"C1 ", QT_TR_NOOP("High Amplification"), " A"}},
        {0x0D, {"C1 ", QT_TR_NOOP("High Amplification"), " B"}},
        {0x0E, {"C2 ", QT_TR_NOOP("High Amplification"), " A"}},
        {0x0F, {"C2 ", QT_TR_NOOP("High Amplification"), " B"}}
    };
    int dId = 0;
    serial *lastSerial = nullptr;
    QDateTime lastseen = QDateTime();
    const QHash<QString, deviceVar *> var;
    QString timerStr = tr("No data");

private:
    QString str = QString();

    protocol *query;
    protocol *cntl;

    inline static void push(device *dev)
    {
        device::deviceList << dev;
    }
};

class devFreq : public device
{
    Q_OBJECT
public:
    explicit devFreq(device *parent = nullptr) : device({
        {"atten",       new deviceVar(alert::P_ENUM_FLOAT)},
        {"ch_a",        new deviceVar(alert::P_ENUM_CH)},
        {"ch_b",        new deviceVar(alert::P_ENUM_CH)},
        {"voltage",     new deviceVar(alert::P_ENUM_VOLTAGE)},
        {"current",     new deviceVar(alert::P_ENUM_CURRENT)},
        {"radio_stat",  new deviceVar(alert::P_ENUM_NOR)},
        {"mid_stat",    new deviceVar(alert::P_ENUM_NOR)},
        {"lock_a1",     new deviceVar(alert::P_ENUM_LOCK)},
        {"lock_a2",     new deviceVar(alert::P_ENUM_LOCK)},
        {"lock_b1",     new deviceVar(alert::P_ENUM_LOCK)},
        {"lock_b2",     new deviceVar(alert::P_ENUM_LOCK)},
        {"ref_10_1",    new deviceVar(alert::P_ENUM_NOR)},
        {"ref_10_2",    new deviceVar(alert::P_ENUM_NOR)},
        {"ref_10_3",    new deviceVar(alert::P_ENUM_NOR)},
        {"ref_10_4",    new deviceVar(alert::P_ENUM_NOR)},
        {"ref_inner_1", new deviceVar(alert::P_ENUM_NOR)},
        {"ref_inner_2", new deviceVar(alert::P_ENUM_NOR)},
        {"handshake",   new deviceVar(alert::P_ENUM_HSK)},
        {"masterslave", new deviceVar(alert::P_ENUM_MS)}
    }, parent) {}
    friend devFreq &operator<< (devFreq &dev, const msgFreq &m);
    friend const devFreq &operator>> (const devFreq &dev, msgCntlFreq &m);

public slots:
    void createCntlMsg() override;
    const QString showIndicatorColor() const override;
};

class devDist : public device
{
    Q_OBJECT
public:
    explicit devDist(device *parent = nullptr) : device({
        {"ref_10",      new deviceVar(alert::P_ENUM_CH)},
        {"ref_16",      new deviceVar(alert::P_ENUM_CH)},
        {"voltage",     new deviceVar(alert::P_ENUM_VOLTAGE)},
        {"current",     new deviceVar(alert::P_ENUM_CURRENT)},
        {"lock_10_1",   new deviceVar(alert::P_ENUM_LOCK)},
        {"lock_10_2",   new deviceVar(alert::P_ENUM_LOCK)},
        {"lock_16_1",   new deviceVar(alert::P_ENUM_LOCK)},
        {"lock_16_2",   new deviceVar(alert::P_ENUM_LOCK)}
    }, parent) {}
    friend devDist &operator<< (devDist &dev, const msgDist &m);
    friend const devDist &operator>> (const devDist &dev, msgCntlDist &m);

public slots:
    void createCntlMsg() override;
    const QString showIndicatorColor() const override;
};

class devAmp : public device
{
    Q_OBJECT
public:
    explicit devAmp(device *parent = nullptr) : device({
        {"power",           new deviceVar(alert::P_ENUM_DECUPLE)},
        {"gain",            new deviceVar(alert::P_ENUM_DECUPLE)},
        {"atten",           new deviceVar(alert::P_ENUM_DECUPLE)},
        {"loss",            new deviceVar(alert::P_ENUM_DECUPLE)},
        {"amp_temp",        new deviceVar(alert::P_ENUM_INT)},
        {"s_stand_wave",    new deviceVar(alert::P_ENUM_STAT)},
        {"s_temp",          new deviceVar(alert::P_ENUM_STAT)},
        {"s_current",       new deviceVar(alert::P_ENUM_STAT)},
        {"s_voltage",       new deviceVar(alert::P_ENUM_STAT)},
        {"s_power",         new deviceVar(alert::P_ENUM_STAT)},
        {"load_temp",       new deviceVar(alert::P_ENUM_INT)},
        {"handshake",       new deviceVar(alert::P_ENUM_HSK)},
        {"atten_mode",      new deviceVar(alert::P_ENUM_ATTEN)}
    }, parent) {}
    friend devAmp &operator<< (devAmp &dev, const msgAmp &m);
    friend const devAmp &operator>> (const devAmp &dev, msgCntlAmp &m);

public slots:
    void createCntlMsg() override;
    const QString showIndicatorColor() const override;
};

#endif // DEVICE_H
