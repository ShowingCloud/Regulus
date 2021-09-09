#ifndef ALERT_H
#define ALERT_H

#include <QObject>
#include <QHash>

class alert : public QObject
{
    Q_OBJECT
public:
    explicit alert(QObject *parent = nullptr);

    enum P_NOR { P_NOR_ABNORMAL = 0, P_NOR_NORMAL = 1, P_NOR_STANDBY = 2, P_NOR_OTHERS };
    enum P_LOCK { P_LOCK_UNLOCK = 0, P_LOCK_LOCKED = 1, P_LOCK_STANDBY = 2, P_LOCK_OTHERS };
    enum P_MS { P_MS_MASTER = 0, P_MS_SLAVE = 1, P_MS_OTHERS };
    enum P_HSK { P_HSK_SUCCESS = 0, P_HSK_FAILED = 1, P_HSK_OTHERS };
    enum P_ATTEN { P_ATTEN_NORMAL = 0, P_ATTEN_CONSTPOWER = 1, P_ATTEN_CONSTGAIN = 2, P_ATTEN_OTHERS };
    enum P_STAT { P_STAT_NORMAL = 0, P_STAT_ABNORMAL = 1, P_STAT_OTHERS };
    enum P_CH { P_CH_CH1 = 0, P_CH_CH2 = 1, P_CH_OTHERS };

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

signals:

public slots:
};

#endif // ALERT_H
