#include "alert.h"

#include <QMetaEnum>
#include <QDebug>
#include <iso646.h>

const QVariant alert::setValue(const QVariant val, const P_ENUM e)
{
    QVariant ret;

    switch (e) {
    case P_ENUM_NOR:
    case P_ENUM_LOCK:
    case P_ENUM_MS:
    case P_ENUM_HSK:
    case P_ENUM_ATTEN:
    case P_ENUM_STAT:
    case P_ENUM_CH:
        ret = (val.value<int>() >= 0 and val.value<int>() < P_ENUM_VALUE["others"][e].value<int>())
                ? val.value<int>()
                : P_ENUM_VALUE["others"][e].value<int>();
        break;
    case P_ENUM_INT:
    case P_ENUM_CURRENT:
    case P_ENUM_VOLTAGE:
        ret = val.value<int>();
        break;
    case P_ENUM_FLOAT:
        ret = 0.5 * val.value<int>();
        break;
    case P_ENUM_DECUPLE:
    case P_ENUM_DECUPLE_DOUBLE:
        ret = val.value<int>() / 10.0;
        break;
    case P_ENUM_OTHERS:
        ret = val;
        break;
    }

    return ret;
}

alert::P_NOR alert::setState(const QVariant val, const P_ENUM e, deviceVar *parent)
{
    switch (e) {
    case P_ENUM_NOR:
        switch (val.value<P_NOR>()) {
        case P_NOR_NORMAL:
            alert::prepareAlert(P_ALERT_GOOD, val, parent);
            return P_NOR_NORMAL;
        case P_NOR_ABNORMAL:
            alert::prepareAlert(P_ALERT_BAD, val, P_NOR_NORMAL, parent);
            return P_NOR_ABNORMAL;
        case P_NOR_STANDBY:
            alert::prepareAlert(P_ALERT_GOOD, val, parent);
            return P_NOR_STANDBY;
        case P_NOR_OTHERS:
            alert::prepareAlert(P_ALERT_BAD, val, P_NOR_NORMAL, parent);
            return P_NOR_OTHERS;
        }
        alert::prepareAlert(P_ALERT_BAD, val, P_NOR_NORMAL, parent);
        return P_NOR_ABNORMAL;
    case P_ENUM_LOCK:
        switch (val.value<P_LOCK>()) {
        case P_LOCK_LOCKED:
            alert::prepareAlert(P_ALERT_GOOD, val, parent);
            return P_NOR_NORMAL;
        case P_LOCK_UNLOCK:
            alert::prepareAlert(P_ALERT_BAD, val, P_LOCK_LOCKED, parent);
            return P_NOR_ABNORMAL;
        case P_LOCK_STANDBY:
            alert::prepareAlert(P_ALERT_GOOD, val, parent);
            return P_NOR_STANDBY;
        case P_LOCK_OTHERS:
            alert::prepareAlert(P_ALERT_BAD, val, P_LOCK_LOCKED, parent);
            return P_NOR_OTHERS;
        }
        alert::prepareAlert(P_ALERT_BAD, val, P_LOCK_LOCKED, parent);
        return P_NOR_ABNORMAL;
    case P_ENUM_HSK:
        switch (val.value<P_HSK>()) {
        case P_HSK_SUCCESS:
            alert::prepareAlert(P_ALERT_GOOD, val, parent);
            return P_NOR_NORMAL;
        case P_HSK_FAILED:
            alert::prepareAlert(P_ALERT_BAD, val, P_HSK_SUCCESS, parent);
            return P_NOR_ABNORMAL;
        case P_HSK_OTHERS:
            alert::prepareAlert(P_ALERT_BAD, val, P_HSK_SUCCESS, parent);
            return P_NOR_OTHERS;
        }
        alert::prepareAlert(P_ALERT_BAD, val, P_HSK_SUCCESS, parent);
        return P_NOR_ABNORMAL;
    case P_ENUM_MS:
    case P_ENUM_ATTEN:
    case P_ENUM_CH:
    case P_ENUM_INT:
    case P_ENUM_FLOAT:
    case P_ENUM_DECUPLE:
    case P_ENUM_DECUPLE_DOUBLE:
        alert::prepareAlert(P_ALERT_GOOD, val, parent);
        return P_NOR_NORMAL;
    case P_ENUM_STAT:
        switch (val.value<P_STAT>()) {
        case P_STAT_NORMAL:
            alert::prepareAlert(P_ALERT_GOOD, val, parent);
            return P_NOR_NORMAL;
        case P_STAT_ABNORMAL:
            alert::prepareAlert(P_ALERT_BAD, val, P_STAT_NORMAL, parent);
            return P_NOR_ABNORMAL;
        case P_STAT_OTHERS:
            alert::prepareAlert(P_ALERT_BAD, val, P_STAT_NORMAL, parent);
            return P_NOR_OTHERS;
        }
        alert::prepareAlert(P_ALERT_BAD, val, P_STAT_NORMAL, parent);
        return P_NOR_ABNORMAL;
    case P_ENUM_VOLTAGE:
        if (val.value<int>() > 15) {
            alert::prepareAlert(P_ALERT_UPPER, val, 15, parent);
            return P_NOR_ABNORMAL;
        } else if (val.value<int>() < 10) {
            alert::prepareAlert(P_ALERT_LOWER, val, 10, parent);
            return P_NOR_ABNORMAL;
        } else {
            alert::prepareAlert(P_ALERT_GOOD, val, parent);
            return P_NOR_NORMAL;
        }
    case P_ENUM_CURRENT:
        if (val.value<int>() > 3000) {
            alert::prepareAlert(P_ALERT_UPPER, val, 3000, parent);
            return P_NOR_ABNORMAL;
        } else if (val.value<int>() < 100) {
            alert::prepareAlert(P_ALERT_LOWER, val, 100, parent);
            return P_NOR_ABNORMAL;
        } else {
            alert::prepareAlert(P_ALERT_GOOD, val, parent);
            return P_NOR_NORMAL;
        }
    case P_ENUM_OTHERS:
        return P_NOR_ABNORMAL;
    }

    qDebug() << "!!! Shouldn't get here";
    return P_NOR_ABNORMAL;
}

void alert::prepareAlert(const P_ALERT type, const QVariant value, const QVariant normal_value, deviceVar *parent)
{
    if (parent->stat_alert != type) {
        emit parent->sendAlert(type, value, normal_value);
        parent->stat_alert = type;
    }
}

void alert::prepareAlert(const P_ALERT type, const QVariant value, deviceVar *parent)
{
    if (type == P_ALERT_GOOD) {
        if (parent->stat_alert != type) {
            emit parent->sendAlert(type, value);
            parent->stat_alert = type;
        }
    } else
        qDebug() << "!!! Shouldn't get here";
}

const QString alert::setDisplay(const QVariant val, const P_ENUM e)
{
    QString v;

    switch (e) {
    case P_ENUM_NOR:
        v = STR_NOR[val.value<P_NOR>()];
        break;
    case P_ENUM_LOCK:
        v = STR_LOCK[val.value<P_LOCK>()];
        break;
    case P_ENUM_MS:
        v = STR_MS[val.value<P_MS>()];
        break;
    case P_ENUM_HSK:
        v = STR_HSK[val.value<P_HSK>()];
        break;
    case P_ENUM_ATTEN:
        v = STR_ATTEN[val.value<P_ATTEN>()];
        break;
    case P_ENUM_STAT:
        v = STR_STAT[val.value<P_STAT>()];
        break;
    case P_ENUM_CH:
        v = STR_CH[val.value<P_CH>()];
        break;
    case P_ENUM_INT:
    case P_ENUM_CURRENT:
    case P_ENUM_VOLTAGE:
    case P_ENUM_OTHERS:
        v = val.toString();
        break;
    case P_ENUM_FLOAT:
    case P_ENUM_DECUPLE:
    case P_ENUM_DECUPLE_DOUBLE:
        v = QString::number(val.value<double>());
        break;
    }

    return tr(v.toUtf8());
}

const QStringList alert::addEnum(const QString e, const QString add)
{
    alert alrt;
    const QMetaObject *metaObj = alrt.metaObject();
    QMetaEnum enumType = metaObj->enumerator(metaObj->indexOfEnumerator(e.toUtf8()));

    QStringList list;

    auto strFunc = +[](const int x) { Q_UNUSED(x) return QString("No such enum").toUtf8(); };
    if (e == "P_NOR")
        strFunc = [](const int x) { return STR_NOR[static_cast<P_NOR>(x)].toUtf8(); };
    else if (e == "P_LOCK")
        strFunc = [](const int x) { return STR_LOCK[static_cast<P_LOCK>(x)].toUtf8(); };
    else if (e == "P_MS")
        strFunc = [](const int x) { return STR_MS[static_cast<P_MS>(x)].toUtf8(); };
    else if (e == "P_HSK")
        strFunc = [](const int x) { return STR_HSK[static_cast<P_HSK>(x)].toUtf8(); };
    else if (e == "P_ATTEN")
        strFunc = [](const int x) { return STR_ATTEN[static_cast<P_ATTEN>(x)].toUtf8(); };
    else if (e == "P_STAT")
        strFunc = [](const int x) { return STR_STAT[static_cast<P_STAT>(x)].toUtf8(); };
    else if (e == "P_CH")
        strFunc = [](const int x) { return STR_CH[static_cast<P_CH>(x)].toUtf8(); };

    for (int i = 0; i < enumType.keyCount() - 1; ++i) /* omitting the last _OTHERS item */
    {
        list << (add + tr(strFunc(i)));
    }
    return list;
}

deviceVar::deviceVar(const alert::P_ENUM type, QObject *parent) : QObject(parent), type(type)
{
    switch (type) {
    case alert::P_ENUM_NOR:
    case alert::P_ENUM_LOCK:
    case alert::P_ENUM_MS:
    case alert::P_ENUM_HSK:
    case alert::P_ENUM_ATTEN:
    case alert::P_ENUM_STAT:
    case alert::P_ENUM_CH:
        value = alert::setValue(alert::P_ENUM_VALUE["default"][type], type);
        display = alert::setDisplay(value, type);
        return;
    case alert::P_ENUM_INT:
    case alert::P_ENUM_CURRENT:
    case alert::P_ENUM_VOLTAGE:
    case alert::P_ENUM_DECUPLE:
    case alert::P_ENUM_DECUPLE_DOUBLE:
        value = alert::setValue(0, type);
        display = alert::setDisplay(value, type);
        return;
    case alert::P_ENUM_FLOAT:
        value = alert::setValue(0.0f, type);
        display = alert::setDisplay(value, type);
        return;
    case alert::P_ENUM_OTHERS:
        value = "";
        display = "";
        return;
    }
}

void deviceVar::setValue(const QVariant v)
{
    if (not holding) {
        value = alert::setValue(v, type);
        stat = alert::setState(value, type, this);
        display = alert::setDisplay(value, type);
    } else
        value = alert::setValue(v, type);
}

int deviceVar::getValue() const
{
    const QVariant *ret;
    if (holding)
        ret = &v_hold;
    else
        ret = &value;

    switch (type) {
    case alert::P_ENUM_NOR:
    case alert::P_ENUM_LOCK:
    case alert::P_ENUM_MS:
    case alert::P_ENUM_HSK:
    case alert::P_ENUM_ATTEN:
    case alert::P_ENUM_STAT:
    case alert::P_ENUM_CH:
    case alert::P_ENUM_INT:
    case alert::P_ENUM_CURRENT:
    case alert::P_ENUM_VOLTAGE:
        return ret->value<int>();
    case alert::P_ENUM_FLOAT:
    case alert::P_ENUM_DECUPLE_DOUBLE:
        return static_cast<int>(ret->value<float>() * 2);
    case alert::P_ENUM_DECUPLE:
        return static_cast<int>(ret->value<float>() * 10);
    case alert::P_ENUM_OTHERS:
        return -1;
    }

    qDebug() << "Shouldn't get here";
    return -1;
}

const QString deviceVar::getColor(bool allowHolding) const
{
    if (holding && allowHolding)
        return alert::STR_COLOR[alert::P_COLOR_HOLDING];

    switch (stat) {
    case alert::P_NOR_NORMAL:
        return alert::STR_COLOR[alert::P_COLOR_NORMAL];
    case alert::P_NOR_ABNORMAL:
        return alert::STR_COLOR[alert::P_COLOR_ABNORMAL];
    case alert::P_NOR_STANDBY:
        return alert::STR_COLOR[alert::P_COLOR_STANDBY];
    case alert::P_NOR_OTHERS:
        return alert::STR_COLOR[alert::P_COLOR_OTHERS];
    }

    qDebug() << "Shouldn't get here";
    return QString();
}

void alertRecordModel::initialize(const QString dbTable, const int masterId, const int slaveId)
{
    beginResetModel();

    record = QList<QStringList>();
    globalDB << databaseSetter(dbTable, masterId);
    globalDB >> record;
    if (slaveId != -1) {
        globalDB << databaseSetter(dbTable, slaveId);
        globalDB >> record;
    }

    std::sort(record.begin(), record.end(), [](const QStringList &v1, const QStringList &v2){
        return v1[1] > v2[1]; // Comparing timestamp field
    });

    endResetModel();

    this->masterId = masterId;
    this->slaveId = slaveId;
    alertRecordModelList << this;
}

void alertRecordModel::addAlert(const int deviceId, const QStringList alert)
{
    if (deviceId != this->masterId and deviceId != this->slaveId)
        return;

    beginInsertRows(QModelIndex(), 0, 0);
    record.insert(0, alert);
    endInsertRows();
}
