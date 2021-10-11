#ifndef ALERT_H
#define ALERT_H

#include <QHash>
#include <QColor>
#include <QtQml>
#include <QAbstractTableModel>

class deviceVar;

#include "database.h"

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
    Q_ENUMS(P_COLOR)
    Q_PROPERTY(QVariantMap  MAP_COLOR   MEMBER MAP_COLOR    CONSTANT)
    Q_PROPERTY(int          timeout     MEMBER timeout      CONSTANT)

public:
    explicit alert(const QObject *parent = nullptr) {Q_UNUSED(parent)}

    friend database &operator<< (database &db, const alert &alert);

    inline const static int timeout = 10;

    enum P_NOR { P_NOR_ABNORMAL = 0, P_NOR_NORMAL = 1, P_NOR_STANDBY = 2, P_NOR_OTHERS };
    enum P_LOCK { P_LOCK_UNLOCK = 0, P_LOCK_LOCKED = 1, P_LOCK_STANDBY = 2, P_LOCK_OTHERS };
    enum P_MS { P_MS_MASTER = 0, P_MS_SLAVE = 1, P_MS_OTHERS };
    enum P_HSK { P_HSK_SUCCESS = 0, P_HSK_FAILED = 1, P_HSK_OTHERS };
    enum P_ATTEN { P_ATTEN_NORMAL = 0, P_ATTEN_CONSTPOWER = 1, P_ATTEN_CONSTGAIN = 2, P_ATTEN_OTHERS };
    enum P_STAT { P_STAT_NORMAL = 0, P_STAT_ABNORMAL = 1, P_STAT_OTHERS };
    enum P_CH { P_CH_CH1 = 0, P_CH_CH2 = 1, P_CH_OTHERS };
    enum P_ENUM { P_ENUM_NOR, P_ENUM_LOCK, P_ENUM_MS, P_ENUM_HSK, P_ENUM_ATTEN, P_ENUM_STAT, P_ENUM_CH,
                  P_ENUM_FLOAT, P_ENUM_INT, P_ENUM_VOLTAGE, P_ENUM_CURRENT, P_ENUM_DECUPLE, P_ENUM_DECUPLE_DOUBLE,
                  P_ENUM_OTHERS };

    enum P_COLOR { P_COLOR_NORMAL, P_COLOR_ABNORMAL, P_COLOR_STANDBY, P_COLOR_HOLDING, P_COLOR_OTHERS };
    static const inline QHash<P_COLOR, QString> STR_COLOR = {
        {P_COLOR_NORMAL, "green"},
        {P_COLOR_ABNORMAL, "red"},
        {P_COLOR_STANDBY, "yellow"},
        {P_COLOR_HOLDING, "blue"},
        {P_COLOR_OTHERS, "black"}
    };

    enum P_ALERT { P_ALERT_GOOD = 0, P_ALERT_NODATA, P_ALERT_LOWER, P_ALERT_UPPER, P_ALERT_BAD,
                   P_ALERT_TIMEOUT, P_ALERT_TIMEOUT_NOFIELD, P_ALERT_OTHERS, P_ALERT_OTHERS_NOFIELD };
    static const inline QHash<P_ALERT, QStringList> STR_ALERT = {
        {P_ALERT_NODATA, {QT_TR_NOOP("No data")}},
        {P_ALERT_GOOD, {QT_TR_NOOP("Good value")}},
        {P_ALERT_LOWER, {QT_TR_NOOP("Lower than lower limit"),
                         QT_TR_NOOP("Got value"),
                         QT_TR_NOOP("Lower limit")}},
        {P_ALERT_UPPER, {QT_TR_NOOP("Higher than upper limit"),
                         QT_TR_NOOP("Got value"),
                         QT_TR_NOOP("Upper limit")}},
        {P_ALERT_BAD, {QT_TR_NOOP("Bad value"),
                       QT_TR_NOOP("Got value"),
                       QT_TR_NOOP("Good value")}},
        {P_ALERT_TIMEOUT, {QT_TR_NOOP("Timeout"),
                           QT_TR_NOOP("Last seen"),
                           QT_TR_NOOP("Never"),
                           QT_TR_NOOP("seconds before")}},
        {P_ALERT_TIMEOUT_NOFIELD, {QT_TR_NOOP("Timeout"),
                           QT_TR_NOOP("Last seen"),
                           QT_TR_NOOP("Never"),
                           QT_TR_NOOP("seconds before")}},
        {P_ALERT_OTHERS, {QT_TR_NOOP("Other alert")}},
        {P_ALERT_OTHERS_NOFIELD, {QT_TR_NOOP("Other alert")}}
    };

    static inline const QVariantHash EnumMap2VariantHash (const QHash<QVariant, QString> enumMap) {
        QVariantHash ret;
        QHashIterator<QVariant, QString> i(enumMap);
        while (i.hasNext()) {
            ret[i.key().toString()] = i.value();
        }
        return ret;
    }

    static const inline QVariantMap MAP_COLOR = { /* Using QVariantMap until something supported by Qt */
        {"NORMAL", STR_COLOR[P_COLOR_NORMAL]},
        {"ABNORMAL", STR_COLOR[P_COLOR_ABNORMAL]},
        {"STANDBY", STR_COLOR[P_COLOR_STANDBY]},
        {"HOLDING", STR_COLOR[P_COLOR_HOLDING]},
        {"OTHERS", STR_COLOR[P_COLOR_OTHERS]},
    };
    //static const inline QVariantMap MAP_COLOR = EnumMap2VariantHash(STR_COLOR);

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

    static const inline QHash<QString, QHash<P_ENUM, QVariant>> P_ENUM_VALUE = {
        {"str", {
            {P_ENUM_NOR,    QVariant::fromValue(STR_NOR)},
            {P_ENUM_LOCK,   QVariant::fromValue(STR_LOCK)},
            {P_ENUM_MS,     QVariant::fromValue(STR_MS)},
            {P_ENUM_HSK,    QVariant::fromValue(STR_HSK)},
            {P_ENUM_ATTEN,  QVariant::fromValue(STR_ATTEN)},
            {P_ENUM_STAT,   QVariant::fromValue(STR_STAT)},
            {P_ENUM_CH,     QVariant::fromValue(STR_CH)}
        }}, {"others", {
            {P_ENUM_NOR,    P_NOR_OTHERS},
            {P_ENUM_LOCK,   P_LOCK_OTHERS},
            {P_ENUM_MS,     P_MS_OTHERS},
            {P_ENUM_HSK,    P_HSK_OTHERS},
            {P_ENUM_ATTEN,  P_ATTEN_OTHERS},
            {P_ENUM_STAT,   P_STAT_OTHERS},
            {P_ENUM_CH,     P_CH_OTHERS}
         }}, {"default", {
            {P_ENUM_NOR,    P_NOR_NORMAL},
            {P_ENUM_LOCK,   P_LOCK_LOCKED},
            {P_ENUM_MS,     P_MS_MASTER},
            {P_ENUM_HSK,    P_HSK_SUCCESS},
            {P_ENUM_ATTEN,  P_ATTEN_NORMAL},
            {P_ENUM_STAT,   P_STAT_NORMAL},
            {P_ENUM_CH,     P_CH_OTHERS}
         }}
    };

    static const QVariant setValue(const QVariant val, const P_ENUM e);
    static P_NOR setState(const QVariant val, const P_ENUM e, deviceVar *parent);
    static const QString setDisplay(const QVariant val, const P_ENUM e);

    static void prepareAlert(const P_ALERT type, const QVariant value, const QVariant normal_value, deviceVar *parent);
    static void prepareAlert(const P_ALERT type, const QVariant value, deviceVar *parent);

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
Q_DECLARE_METATYPE(alert::P_COLOR)
Q_DECLARE_METATYPE(alert::P_ALERT)

class alertRecordModel : public QAbstractTableModel
{
    Q_OBJECT
#if QT_VERSION > QT_VERSION_CHECK(5, 15, 0)
    QML_ELEMENT
#endif

public:
    explicit alertRecordModel(QAbstractTableModel *parent = nullptr) : QAbstractTableModel(parent) {
        alertRecordModelList << this;
    }

    inline int rowCount(const QModelIndex & = QModelIndex()) const override {
        return record.length();
    }

    inline int columnCount(const QModelIndex & = QModelIndex()) const override {
        return 4;
    }

    inline QVariant data(const QModelIndex &index, const int role) const override {
        switch (role) {
        case Qt::DisplayRole:
            return record[index.row()][index.column()];
        case Qt::ForegroundRole:
            return QColor(record[index.row()][4]);
        case Qt::TextAlignmentRole: {
            static int alignments[] = { Qt::AlignHCenter, Qt::AlignHCenter, Qt::AlignHCenter, Qt::AlignLeft };
            return alignments[index.column()];
        } case Qt::SizeHintRole: {
            static int columnWidths[] = { 150, 200, 150, 800 };
            return columnWidths[index.column()];
        } default:
            break;
        }
        return QVariant();
    }

    inline QVariant headerData(const int section, const Qt::Orientation orientation, const int role) const override {
        if (role == Qt::DisplayRole && orientation == Qt::Horizontal) {
            static QStringList header = { tr("Device"), tr("Timestamp"), tr("Field"), tr("Error info") };
            return header[section];
        }
        return QVariant();
    }

    inline QHash<int, QByteArray> roleNames() const override {
        return QHash<int, QByteArray> {
            { Qt::DisplayRole, "display" },
            { Qt::ForegroundRole, "foreground" },
            { Qt::TextAlignmentRole, "textalignment" },
            { Qt::SizeHintRole, "sizehint" }
        };
    }

    void addAlert(const int deviceId, const QStringList alert);

    inline static QList<alertRecordModel *> alertRecordModelList = {};

public slots:
    void initialize(const QString dbTable, const int masterId, const int slaveId = -1);

private:
    QList<QStringList> record;
    int masterId = -1, slaveId = -1;
};

class deviceVar : public QObject
{
    Q_OBJECT

public:
    explicit deviceVar(const alert::P_ENUM type, QObject *parent = nullptr);

    void setValue(const QVariant value);
    int getValue() const;
    const QString getColor(bool allowHolding = true) const;

    alert::P_ENUM   type;
    QVariant        value;
    alert::P_NOR    stat        = alert::P_NOR_NORMAL;
    QString         display     = QString();
    bool            holding     = false;
    QVariant        v_hold;
    alert::P_ALERT  stat_alert  = alert::P_ALERT_GOOD;

signals:
    void sendAlert(alert::P_ALERT type, QVariant value, QVariant normal_value = 0) const;
};

#endif // ALERT_H
