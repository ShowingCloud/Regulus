#ifndef ALERT_H
#define ALERT_H

#include <QObject>
#include <QHash>
#include <QDebug>

class alert : public QObject
{
    Q_OBJECT
    Q_ENUMS(P_NOR)
    Q_ENUMS(P_LOCK)
    Q_ENUMS(P_MS)
    Q_ENUMS(P_HSK)
    Q_ENUMS(P_ATTEN)
    Q_ENUMS(P_STAT)
    Q_ENUMS(P_CH)
    Q_ENUMS(P_ENUM)
public:
    explicit alert(QObject *parent = nullptr);

    enum P_NOR { P_NOR_ABNORMAL = 0, P_NOR_NORMAL = 1, P_NOR_STANDBY = 2, P_NOR_OTHERS };
    enum P_LOCK { P_LOCK_UNLOCK = 0, P_LOCK_LOCKED = 1, P_LOCK_STANDBY = 2, P_LOCK_OTHERS };
    enum P_MS { P_MS_MASTER = 0, P_MS_SLAVE = 1, P_MS_OTHERS };
    enum P_HSK { P_HSK_SUCCESS = 0, P_HSK_FAILED = 1, P_HSK_OTHERS };
    enum P_ATTEN { P_ATTEN_NORMAL = 0, P_ATTEN_CONSTPOWER = 1, P_ATTEN_CONSTGAIN = 2, P_ATTEN_OTHERS };
    enum P_STAT { P_STAT_NORMAL = 0, P_STAT_ABNORMAL = 1, P_STAT_OTHERS };
    enum P_CH { P_CH_CH1 = 0, P_CH_CH2 = 1, P_CH_OTHERS };

    enum P_ENUM { P_ENUM_NOR, P_ENUM_LOCK, P_ENUM_MS, P_ENUM_HSK, P_ENUM_ATTEN, P_ENUM_STAT, P_ENUM_CH,
                  P_ENUM_FLOAT, P_ENUM_INT, P_ENUM_VOLTAGE, P_ENUM_CURRENT };

    static const inline QHash<P_NOR, QString> STR_NOR = {
        {P_NOR_ABNORMAL, QT_TR_NOOP("Abnormal")},
        {P_NOR_NORMAL, QT_TR_NOOP("Normal")},
        {P_NOR_STANDBY, QT_TR_NOOP("Standby")},
        {P_NOR_OTHERS, QT_TR_NOOP("Others")}
    };
    static const inline QHash<P_LOCK, QString> STR_LOCK = {
        {P_LOCK_UNLOCK, QT_TR_NOOP("Unlocked")},
        {P_LOCK_LOCKED, QT_TR_NOOP("Locked")},
        {P_LOCK_STANDBY, QT_TR_NOOP("Standby")},
        {P_LOCK_OTHERS, QT_TR_NOOP("Others")}
    };
    static const inline QHash<P_MS, QString> STR_MS = {
        {P_MS_MASTER, QT_TR_NOOP("Master")},
        {P_MS_SLAVE, QT_TR_NOOP("Slave")},
        {P_MS_OTHERS, QT_TR_NOOP("Others")}
    };
    static const inline QHash<P_HSK, QString> STR_HSK = {
        {P_HSK_SUCCESS, QT_TR_NOOP("Successful")},
        {P_HSK_FAILED, QT_TR_NOOP("Failed")},
        {P_HSK_OTHERS, QT_TR_NOOP("Others")}
    };
    static const inline QHash<P_ATTEN, QString> STR_ATTEN = {
        {P_ATTEN_NORMAL, QT_TR_NOOP("Normal Attenuation")},
        {P_ATTEN_CONSTPOWER, QT_TR_NOOP("Constant Power")},
        {P_ATTEN_CONSTGAIN, QT_TR_NOOP("Constant Gain")},
        {P_ATTEN_OTHERS, QT_TR_NOOP("Others")}
    };
    static const inline QHash<P_STAT, QString> STR_STAT = {
        {P_STAT_NORMAL, QT_TR_NOOP("Normal")},
        {P_STAT_ABNORMAL, QT_TR_NOOP("Abnormal")},
        {P_STAT_OTHERS, QT_TR_NOOP("Others")}
    };
    static const inline QHash<P_CH, QString> STR_CH = {
        {P_CH_CH1, QString("1")},
        {P_CH_CH2, QString("2")},
        {P_CH_OTHERS, QT_TR_NOOP("Others")}
    };

    static QVariant setValue(const QVariant val, const P_ENUM e);
    static P_NOR setState(const QVariant val, const P_ENUM e);
    static QString setDisplay(const QVariant val, const P_ENUM e);
signals:

public slots:
    static const QStringList addEnum(const QString e, const QString add = nullptr);
};

Q_DECLARE_METATYPE(alert::P_NOR)
Q_DECLARE_METATYPE(alert::P_LOCK)
Q_DECLARE_METATYPE(alert::P_MS)
Q_DECLARE_METATYPE(alert::P_HSK)
Q_DECLARE_METATYPE(alert::P_ATTEN)
Q_DECLARE_METATYPE(alert::P_STAT)
Q_DECLARE_METATYPE(alert::P_CH)
Q_DECLARE_METATYPE(alert::P_ENUM)

class deviceVar : public QObject
{
    Q_OBJECT
public:
    explicit deviceVar(const alert::P_ENUM type, QObject *parent = nullptr);

    void setValue(const QVariant value);
    int getValue();
    QString getColor();

    alert::P_ENUM type;
    QVariant value;
    alert::P_NOR stat = alert::P_NOR_NORMAL;
    QString display = QString();
    bool holding = false;
    QVariant v_hold;
};

#endif // ALERT_H
