#ifndef DEVICE_H
#define DEVICE_H

#include <QObject>
#include <QList>
#include <QHash>
#include <QDateTime>
#include <numeric>

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
public:
    explicit device(QObject *parent = nullptr);

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

protected:
    serial *lastSerial;
    QDateTime lastseen;

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
    /*
    Q_PROPERTY(float            atten           MEMBER var["atten"].display         NOTIFY gotData)
    Q_PROPERTY(alert::P_CH      ch_a            MEMBER var["ch_a"].display          NOTIFY gotData)
    Q_PROPERTY(alert::P_CH      ch_b            MEMBER var["ch_b"].display          NOTIFY gotData)
    Q_PROPERTY(int              voltage         MEMBER var["voltage"].display       NOTIFY gotData)
    Q_PROPERTY(int              current         MEMBER var["current"].display       NOTIFY gotData)
    Q_PROPERTY(alert::P_NOR     output_stat     MEMBER var["output_stat"].display   NOTIFY gotData)
    Q_PROPERTY(alert::P_NOR     input_stat      MEMBER var["input_stat"].display    NOTIFY gotData)
    Q_PROPERTY(alert::P_LOCK    lock_a1         MEMBER var["lock_a1"].display       NOTIFY gotData)
    Q_PROPERTY(alert::P_LOCK    lock_a2         MEMBER var["lock_a2"].display       NOTIFY gotData)
    Q_PROPERTY(alert::P_LOCK    lock_b1         MEMBER var["lock_b1"].display       NOTIFY gotData)
    Q_PROPERTY(alert::P_LOCK    lock_b2         MEMBER var["lock_b2"].display       NOTIFY gotData)
    Q_PROPERTY(alert::P_NOR     ref_10_1        MEMBER var["ref_10_1"].display      NOTIFY gotData)
    Q_PROPERTY(alert::P_NOR     ref_10_2        MEMBER var["ref_10_2"].display      NOTIFY gotData)
    Q_PROPERTY(alert::P_NOR     ref_10_inner    MEMBER var["ref_10_2"].display      NOTIFY gotData)
    Q_PROPERTY(alert::P_NOR     ref_3           MEMBER var["ref_3"].display         NOTIFY gotData)
    Q_PROPERTY(alert::P_NOR     ref_4           MEMBER var["ref_4"].display         NOTIFY gotData)
    Q_PROPERTY(alert::P_HSK     handshake       MEMBER var["handshake"].display     NOTIFY gotData)
    Q_PROPERTY(alert::P_MS      masterslave     MEMBER var["masterslave"].display   NOTIFY gotData)
    */
public:
    explicit devFreq(device *parent = nullptr) : device(parent) {}
    friend devFreq &operator<< (devFreq &dev, const msgFreq &m);
    friend const devFreq &operator>> (const devFreq &dev, msgCntlFreq &m);

public slots:
    void createCntlMsg();

    inline const QString showDisplay(const QString itemName) const
    {
        if (var[itemName.toUtf8()] == nullptr) {
            qDebug() << "Missing item " << itemName;
            return QString();
        }
        return var[itemName.toUtf8()]->display;
    }

    inline const QString showColor(const QString itemName) const
    {
        if (var[itemName.toUtf8()] == nullptr) {
            qDebug() << "Missing item " << itemName;
            return QString();
        }
        return var[itemName.toUtf8()]->getColor();
    }

    inline const QString showIndicatorColor() const
    {
        return "green";
    }

    inline void setValue(const QString itemName, const QVariant val)
    {
        if (var[itemName.toUtf8()] == nullptr) {
            qDebug() << "Missing item " << itemName;
            return;
        }
        var[itemName.toUtf8()]->setValue(val);
        this->createCntlMsg();
    }

private:
    const QHash<QString, deviceVar *> var = {
        {"atten",       new deviceVar(alert::P_ENUM_FLOAT)},
        {"ch_a",        new deviceVar(alert::P_ENUM_CH)},
        {"ch_b",        new deviceVar(alert::P_ENUM_CH)},
        {"voltage",     new deviceVar(alert::P_ENUM_VOLTAGE)},
        {"current",     new deviceVar(alert::P_ENUM_CURRENT)},
        {"output_stat", new deviceVar(alert::P_ENUM_NOR)},
        {"input_stat",  new deviceVar(alert::P_ENUM_NOR)},
        {"lock_a1",     new deviceVar(alert::P_ENUM_LOCK)},
        {"lock_a2",     new deviceVar(alert::P_ENUM_LOCK)},
        {"lock_b1",     new deviceVar(alert::P_ENUM_LOCK)},
        {"lock_b2",     new deviceVar(alert::P_ENUM_LOCK)},
        {"ref_10_1",    new deviceVar(alert::P_ENUM_NOR)},
        {"ref_10_2",    new deviceVar(alert::P_ENUM_NOR)},
        {"ref_10_inner",new deviceVar(alert::P_ENUM_NOR)},
        {"ref_3",       new deviceVar(alert::P_ENUM_NOR)},
        {"ref_4",       new deviceVar(alert::P_ENUM_NOR)},
        {"handshake",   new deviceVar(alert::P_ENUM_HSK)},
        {"masterslave", new deviceVar(alert::P_ENUM_MS)}
    };
};

class devDist : public device
{
    Q_OBJECT
    Q_PROPERTY(alert::P_CH  ref_10      MEMBER ref_10   NOTIFY gotData)
    Q_PROPERTY(alert::P_CH  ref_16      MEMBER ref_16   NOTIFY gotData)
    Q_PROPERTY(int          voltage     MEMBER voltage  NOTIFY gotData)
    Q_PROPERTY(int          current     MEMBER voltage  NOTIFY gotData)
    Q_PROPERTY(alert::P_NOR lock_10_1   MEMBER lock_10_1 NOTIFY gotData)
    Q_PROPERTY(alert::P_NOR lock_10_2   MEMBER lock_10_2 NOTIFY gotData)
    Q_PROPERTY(alert::P_NOR lock_16_1   MEMBER lock_16_1 NOTIFY gotData)
    Q_PROPERTY(alert::P_NOR lock_16_2   MEMBER lock_16_2 NOTIFY gotData)
public:
    explicit devDist(device *parent = nullptr) : device(parent) {}
    friend devDist &operator<< (devDist &dev, const msgDist &m);
    friend const devDist &operator>> (const devDist &dev, msgCntlDist &m);

public slots:
    void createCntlMsg();
    void createFakeCntlMsg(const QString &msg);

protected:
    alert::P_CH     ref_10      = alert::P_CH();
    alert::P_CH     ref_16      = alert::P_CH();
    int             voltage     = int();
    int             current     = int();
    alert::P_NOR    lock_10_1   = alert::P_NOR();
    alert::P_NOR    lock_10_2   = alert::P_NOR();
    alert::P_NOR    lock_16_1   = alert::P_NOR();
    alert::P_NOR    lock_16_2   = alert::P_NOR();
};

class devAmp : public device
{
    Q_OBJECT
    Q_PROPERTY(int              power           MEMBER power        NOTIFY gotData)
    Q_PROPERTY(int              gain            MEMBER gain         NOTIFY gotData)
    Q_PROPERTY(float            atten_in        MEMBER atten_in     NOTIFY gotData)
    Q_PROPERTY(int              atten_out       MEMBER atten_out    NOTIFY gotData)
    Q_PROPERTY(int              loss            MEMBER loss         NOTIFY gotData)
    Q_PROPERTY(int              amp_temp        MEMBER amp_temp     NOTIFY gotData)
    Q_PROPERTY(alert::P_STAT    s_stand_wave    MEMBER s_stand_wave NOTIFY gotData)
    Q_PROPERTY(alert::P_STAT    s_temp          MEMBER s_temp       NOTIFY gotData)
    Q_PROPERTY(alert::P_STAT    s_current       MEMBER s_current    NOTIFY gotData)
    Q_PROPERTY(alert::P_STAT    s_voltage       MEMBER s_voltage    NOTIFY gotData)
    Q_PROPERTY(alert::P_STAT    s_power         MEMBER s_power      NOTIFY gotData)
    Q_PROPERTY(int              load_temp       MEMBER load_temp    NOTIFY gotData)
    Q_PROPERTY(alert::P_HSK     handshake       MEMBER handshake    NOTIFY gotData)
    Q_PROPERTY(alert::P_ATTEN   atten_mode      MEMBER atten_mode   NOTIFY gotData)
public:
    explicit devAmp(device *parent = nullptr) : device(parent) {}
    friend devAmp &operator<< (devAmp &dev, const msgAmp &m);
    friend const devAmp &operator>> (const devAmp &dev, msgCntlAmp &m);

public slots:
    void createCntlMsg();

protected:
    int             power           = int();
    int             gain            = int();
    float           atten_in        = float();
    int             atten_out       = int();
    int             loss            = int();
    int             amp_temp        = int();
    alert::P_STAT   s_stand_wave    = alert::P_STAT();
    alert::P_STAT   s_temp          = alert::P_STAT();
    alert::P_STAT   s_current       = alert::P_STAT();
    alert::P_STAT   s_voltage       = alert::P_STAT();
    alert::P_STAT   s_power         = alert::P_STAT();
    int             load_temp       = int();
    alert::P_HSK    handshake       = alert::P_HSK();
    alert::P_ATTEN  atten_mode      = alert::P_ATTEN();
};

#endif // DEVICE_H
