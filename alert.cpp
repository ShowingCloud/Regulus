#include "alert.h"

#include <QMetaEnum>
#include <QDebug>
#include <iso646.h>

QVariant alert::setValue(const QVariant val, const P_ENUM e)
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
                ? val.value<int>() : P_ENUM_VALUE["others"][e].value<int>();
        break;
    case P_ENUM_INT:
    case P_ENUM_CURRENT:
    case P_ENUM_VOLTAGE:
        ret = val.value<int>();
        break;
    case P_ENUM_FLOAT:
        ret = 0.5f * val.value<int>();
        break;
    case P_ENUM_DECUPLE:
    case P_ENUM_DECUPLE_DOUBLE:
        ret = val.value<int>() / 10.0f;
        break;
    }

    return ret;
}

alert::P_NOR alert::setState(const QVariant val, const P_ENUM e)
{
    switch (e) {
    case P_ENUM_NOR:
        switch (val.value<P_NOR>()) {
        case P_NOR_NORMAL:
            return P_NOR_NORMAL;
        case P_NOR_ABNORMAL:
            return P_NOR_ABNORMAL;
        case P_NOR_STANDBY:
            return P_NOR_STANDBY;
        case P_NOR_OTHERS:
            return P_NOR_OTHERS;
        }
    case P_ENUM_LOCK:
        switch (val.value<P_LOCK>()) {
        case P_LOCK_LOCKED:
            return P_NOR_NORMAL;
        case P_LOCK_UNLOCK:
            return P_NOR_ABNORMAL;
        case P_LOCK_STANDBY:
            return P_NOR_STANDBY;
        case P_LOCK_OTHERS:
            return P_NOR_OTHERS;
        }
    case P_ENUM_HSK:
        switch (val.value<P_HSK>()) {
        case P_HSK_SUCCESS:
            return P_NOR_NORMAL;
        case P_HSK_FAILED:
            return P_NOR_ABNORMAL;
        case P_HSK_OTHERS:
            return P_NOR_OTHERS;
        }
    case P_ENUM_MS:
    case P_ENUM_ATTEN:
    case P_ENUM_CH:
    case P_ENUM_INT:
    case P_ENUM_FLOAT:
    case P_ENUM_DECUPLE:
    case P_ENUM_DECUPLE_DOUBLE:
        return P_NOR_NORMAL;
    case P_ENUM_STAT:
        switch (val.value<P_STAT>()) {
        case P_STAT_NORMAL:
            return P_NOR_NORMAL;
        case P_STAT_ABNORMAL:
            return P_NOR_ABNORMAL;
        case P_STAT_OTHERS:
            return P_NOR_OTHERS;
        }
    case P_ENUM_VOLTAGE:
        if (val.value<int>() > 15 or val.value<int>() < 10)
            return P_NOR_ABNORMAL;
        else
            return P_NOR_NORMAL;
    case P_ENUM_CURRENT:
        if (val.value<int>() > 3000 or val.value<int>() < 100)
            return P_NOR_ABNORMAL;
        else
            return P_NOR_NORMAL;
    }

    qDebug() << "Shouldn't get here";
    return P_NOR_NORMAL;
}

QString alert::setDisplay(const QVariant val, const P_ENUM e)
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
        this->setValue(alert::P_ENUM_VALUE["default"][type]);
        return;
    case alert::P_ENUM_INT:
    case alert::P_ENUM_CURRENT:
    case alert::P_ENUM_VOLTAGE:
    case alert::P_ENUM_DECUPLE:
    case alert::P_ENUM_DECUPLE_DOUBLE:
        this->setValue(0);
        return;
    case alert::P_ENUM_FLOAT:
        this->setValue(0.0f);
        return;
    }
}

void deviceVar::setValue(const QVariant value)
{
    if (not this->holding) {
        this->value = alert::setValue(value, this->type);
        this->stat = alert::setState(this->value, this->type);
        this->display = alert::setDisplay(this->value, this->type);
    }
}

int deviceVar::getValue()
{
    QVariant *ret;
    if (this->holding)
        ret = &this->v_hold;
    else
        ret = &this->value;

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
        return ret->value<int>() * 10;
    }

    qDebug() << "Shouldn't get here";
    return -1;
}

QString deviceVar::getColor()
{
    if (holding)
        return alert::STR_COLOR[alert::P_COLOR_HOLDING];

    switch (stat) {
    case alert::P_NOR_NORMAL:
        return alert::STR_COLOR[alert::P_COLOR_NORMAL];
    case alert::P_NOR_ABNORMAL:
        return "red";
    case alert::P_NOR_STANDBY:
        return "yellow";
    case alert::P_NOR_OTHERS:
        return "black";
    }

    qDebug() << "Shouldn't get here";
    return QString();
}
