#ifndef DEVICE_H
#define DEVICE_H

#include <QObject>
#include <QList>
#include <QHash>
#include <QDateTime>
#include <QtQml>
#include <numeric>
#include <iso646.h>
#include <QDebug>

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
#include "database.h"

class device : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int          dId         MEMBER  dId      NOTIFY idSet)
    Q_PROPERTY(QString      name        READ    name     NOTIFY idSet)
    Q_PROPERTY(QString      str         MEMBER  str      NOTIFY gotData)
    Q_PROPERTY(QDateTime    lastseen    MEMBER  lastseen NOTIFY gotData)
    Q_PROPERTY(QString      timerStr    MEMBER  timerStr NOTIFY gotData)

public:
    explicit device(const QHash<QString, deviceVar *> var, const QHash<QString, QString> str_var,
                    const database::DB_TBL devTable, const QStringList prefStr, QObject *parent = nullptr);

    friend device &operator<< (device &dev, const msgFreq &m);
    friend device &operator<< (device &dev, const msgDist &m);
    friend device &operator<< (device &dev, const msgAmp &m);

    inline static QList<device *> deviceList = {};

    inline static const QString trConcat(const QList<std::string> str) {
        return std::accumulate(begin(str), end(str), QString(), [](QString ret, const std::string s)
                -> QString { return ret += tr(s.c_str()); });
    }
    inline static const QString trConcat(const QStringList str) {
        return std::accumulate(str.cbegin(), str.cend(), QString(), [](QString ret, const QString s)
                -> QString { return ret += tr(s.toUtf8()); });
    }

    template <class T> static void updateDevice(const T &m) {
        for (device *d : device::deviceList)
            *d << m;
    }

    static inline device *findDevice(const int id) {
        for (device *d : device::deviceList)
            if (d->dId == id)
                return d;

        return nullptr;
    }

signals:
    void idSet();
    void gotData();

public slots:
    virtual void createCntlMsg() const = 0;
    virtual const QString showIndicatorColor() const = 0;

    inline const QString name() const {
        return device::trConcat(device::idName[dId]);
    }

    inline static const QString name(const int dId) {
        return device::trConcat(device::idName[dId]);
    }

    inline const QString varName(const QString itemName) const {
        if (!STR_VAR.contains(itemName)) {
            qDebug() << "Missing item " << itemName;
            return itemName;
        }
        return STR_VAR[itemName];
    }

    inline bool timedout() const {
        return lastseen == QDateTime()
                or QDateTime::currentDateTime().secsTo(lastseen) <= - alert::timeout;
    }

    inline qint64 getLastseen() const {
        return (lastseen == QDateTime()) ? -1 : - QDateTime::currentDateTime().secsTo(lastseen);
    }

    inline void alertTimeout() const {
        globalDB->setAlert(static_cast<database::DB_TBL>(devTable), dId, alert::P_ALERT_TIMEOUT_NOFIELD, "", this->getLastseen());
    }

    inline const QString showDisplay(const QString itemName) const {
        if (!var.contains(itemName)) {
            qDebug() << "Missing item " << itemName;
            return QString();
        }
        return var[itemName]->display;
    }

    inline const QString showColor(const QString itemName, bool allowHolding = true) const {
        if (!var.contains(itemName)) {
            qDebug() << "Missing item " << itemName;
            return QString();
        }

        if (var[itemName]->getColor(allowHolding) == alert::STR_COLOR[alert::P_COLOR_HOLDING])
            return alert::STR_COLOR[alert::P_COLOR_HOLDING];
        else if (timedout())
            return alert::STR_COLOR[alert::P_COLOR_OTHERS];

        return var[itemName]->getColor(allowHolding);
    }

    inline const QVariant getValue(const QString itemName) const {
        if (!var.contains(itemName)) {
            qDebug() << "Missing item " << itemName;
            return QVariant();
        }
        return var[itemName]->getValue();
    }

    inline void setHold(const QString itemName) {
        if (!var.contains(itemName)) {
            qDebug() << "Missing item " << itemName;
            return;
        }
        var[itemName]->holding = true;
        var[itemName]->v_hold = var[itemName]->value;
    }

    inline void releaseHold(const QString itemName) {
        if (!var.contains(itemName)) {
            qDebug() << "Missing item " << itemName;
            return;
        }
        var[itemName]->holding = false;
        // var[itemName]->setValue(var[itemName]->value);
        // The above line is for displaying
    }

    inline void submitHold(const QString itemName) { /* not in use */
        if (!var.contains(itemName)) {
            qDebug() << "Missing item " << itemName;
            return;
        }
        var[itemName]->setValue(var[itemName]->v_hold);
        var[itemName]->holding = false;
    }

    inline void holdValue(const QString itemName, const QVariant val) {
        if (!var.contains(itemName)) {
            qDebug() << "Missing item " << itemName;
            return;
        }
        var[itemName]->holding = true;
        var[itemName]->v_hold = val;
    }

    inline alert::P_ENUM getVarType(const QString itemName) {
        if (!var.contains(itemName)) {
            qDebug() << "Missing item " << itemName;
            return alert::P_ENUM_OTHERS;
        }
        return var[itemName]->type;
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
        {0x0F, {"C2 ", QT_TR_NOOP("High Amplification"), " B"}},
        {0x10, {QT_TR_NOOP("Serial to Network"), " 1"}},
        {0x11, {QT_TR_NOOP("Serial to Network"), " 2"}},
        {0x12, {QT_TR_NOOP("Switch")}}
    };

    int dId = 0;
    const QHash<QString, deviceVar *> var;
    const QHash<QString, QString> STR_VAR;
    const int devTable = 0;
    serial *lastSerial = nullptr;
    QDateTime lastseen = QDateTime();
    QString timerStr = tr("No data");
    const QStringList prefStr;

    inline bool stateGood(const QString v) const {
        if (!var.contains(v)) {
            qDebug() << "Missing item " << v;
            return false;
        }
        return var[v]->stat == alert::P_NOR_NORMAL;
    }

private:
    QString str = QString();
    protocol *query;
    protocol *cntl;

    inline static void push(device *dev) {
        device::deviceList << dev;
    }
};

class devFreq : public device
{
    Q_OBJECT
#if QT_VERSION > QT_VERSION_CHECK(5, 15, 0)
    QML_ELEMENT
#endif

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
    }, {
        {"atten",       tr("Attenuation")},
        {"ch_a",        "10 MHz " + tr("Ref")},
        {"ch_b",        "10 MHz " + tr("Ref")},
        {"voltage",     tr("Voltage")},
        {"current",     tr("Current")},
        {"radio_stat",  tr("Radio") + tr("Output") + "/" + tr("Input")},
        {"mid_stat",    tr("Mid freq") + tr("Input") + "/" + tr("Output")},
        {"lock_a1",     tr("Local Oscillator") + " A1"},
        {"lock_a2",     tr("Local Oscillator") + " A2"},
        {"lock_b1",     tr("Local Oscillator") + " B1"},
        {"lock_b2",     tr("Local Oscillator") + " B2"},
        {"ref_10_1",    "10 MHz " + tr("Outer Ref") + " 1"},
        {"ref_10_2",    "10 MHz " + tr("Outer Ref") + " 2"},
        {"ref_10_3",    "10 MHz " + tr("Outer Ref") + " 1"},
        {"ref_10_4",    "10 MHz " + tr("Outer Ref") + " 2"},
        {"ref_inner_1", "10 MHz " + tr("Inner Ref")},
        {"ref_inner_2", "10 MHz " + tr("Inner Ref")},
        {"handshake",   tr("Handshake Signal")},
        {"masterslave", tr("Current State")}
    }, database::DB_TBL_FREQ_ALERT,
    {"atten", "ch_a", "ch_b"}, parent) { connect(this, &device::idSet, [=](){ *globalDB >> *this; }); }

    friend devFreq &operator<< (devFreq &dev, const msgFreq &m);
    template <class T> friend database &operator<< (database &db, const T &dev);
    friend const devFreq &operator>> (const devFreq &dev, msgCntlFreq &m);
    template <class T> friend const database &operator>> (const database &db, T &dev);

public slots:
    void createCntlMsg() const override;
    const QString showIndicatorColor() const override;

private:
};

class devDist : public device
{
    Q_OBJECT
#if QT_VERSION > QT_VERSION_CHECK(5, 15, 0)
    QML_ELEMENT
#endif

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
    }, {
        {"ref_10",      tr("Outer Ref") + " 10 MHz"},
        {"ref_16",      tr("Outer Ref") + " 16 MHz"},
        {"voltage",     tr("Voltage")},
        {"current",     tr("Current")},
        {"lock_10_1",   "10 MHz " + tr("Lock") + " 1"},
        {"lock_10_2",   "10 MHz " + tr("Lock") + " 2"},
        {"lock_16_1",   "16 MHz " + tr("Lock") + " 1"},
        {"lock_16_2",   "16 MHz " + tr("Lock") + " 2"}
    }, database::DB_TBL_DIST_ALERT,
    {"ref_10", "ref_16"}, parent) { connect(this, &device::idSet, [=](){ *globalDB >> *this; }); }

    friend devDist &operator<< (devDist &dev, const msgDist &m);
    template <class T> friend database &operator<< (database &db, const T &dev);
    friend const devDist &operator>> (const devDist &dev, msgCntlDist &m);
    template <class T> friend const database &operator>> (const database &db, T &dev);

public slots:
    void createCntlMsg() const override;
    const QString showIndicatorColor() const override;

private:
};

class devAmp : public device
{
    Q_OBJECT
#if QT_VERSION > QT_VERSION_CHECK(5, 15, 0)
    QML_ELEMENT
#endif

public:
    explicit devAmp(device *parent = nullptr) : device({
        {"power",           new deviceVar(alert::P_ENUM_DECUPLE)},
        {"gain",            new deviceVar(alert::P_ENUM_DECUPLE)},
        {"atten",           new deviceVar(alert::P_ENUM_DECUPLE_DOUBLE)},
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
    }, {
        {"power",           tr("Power")},
        {"gain",            tr("Gain")},
        {"atten",           tr("Attenuation")},
        {"loss",            tr("Return Loss")},
        {"amp_temp",        tr("Amplifier Temperature")},
        {"s_stand_wave",    tr("Stand Wave")},
        {"s_temp",          tr("Temperature")},
        {"s_current",       tr("Current")},
        {"s_voltage",       tr("Voltage")},
        {"s_power",         tr("Output Power")},
        {"load_temp",       tr("Load Temperature")},
        {"handshake",       tr("Handshake Signal")},
        {"atten_mode",      tr("Attenuation Mode")},
        {"masterslave",     tr("Current State")}
    }, database::DB_TBL_AMP_ALERT,
    {"atten_mode", "atten", "power", "gain"}, parent) { connect(this, &device::idSet, [=](){ *globalDB >> *this; }); }

    friend devAmp &operator<< (devAmp &dev, const msgAmp &m);
    template <class T> friend database &operator<< (database &db, const T &dev);
    friend const devAmp &operator>> (const devAmp &dev, msgCntlAmp &m);
    template <class T> friend const database &operator>> (const database &db, T &dev);

public slots:
    void createCntlMsg() const override;
    const QString showIndicatorColor() const override;

private:
};

class devNet : public device
{
    Q_OBJECT
#if QT_VERSION > QT_VERSION_CHECK(5, 15, 0)
    QML_ELEMENT
#endif

public:
    explicit devNet(QObject *parent = nullptr);

public slots:
    void createCntlMsg() const override {}
    const QString showIndicatorColor() const override;

private:
    static const inline QHash<int, QString> ipAddr = {
        {0x10, "192.168.1.1"},
        {0x11, "8.8.8.8"},
        {0x12, "8.8.8.7"}};
};

#endif // DEVICE_H
