#include "alert.h"

alert::alert(QObject *parent) : QObject(parent)
{

}

QVariant alert::setValue(const QVariant val, const P_ENUM e)
{
    QVariant ret;

    switch (e) {
    case P_ENUM_NOR:
        ret = (val.value<int>() >= 0 && val.value<int>() < P_NOR_OTHERS) ? val.value<int>() : P_NOR_OTHERS;
        break;
    case P_ENUM_LOCK:
        ret = (val.value<int>() >= 0 && val.value<int>() < P_LOCK_OTHERS) ? val.value<int>() : P_LOCK_OTHERS;
        break;
    case P_ENUM_MS:
        ret = (val.value<int>() >= 0 && val.value<int>() < P_MS_OTHERS) ? val.value<int>() : P_MS_OTHERS;
        break;
    case P_ENUM_HSK:
        ret = (val.value<int>() >= 0 && val.value<int>() < P_HSK_OTHERS) ? val.value<int>() : P_HSK_OTHERS;
        break;
    case P_ENUM_ATTEN:
        ret = (val.value<int>() >= 0 && val.value<int>() < P_ATTEN_OTHERS) ? val.value<int>() : P_ATTEN_OTHERS;
        break;
    case P_ENUM_STAT:
        ret = (val.value<int>() >= 0 && val.value<int>() < P_STAT_OTHERS) ? val.value<int>() : P_STAT_OTHERS;
        break;
    case P_ENUM_CH:
        ret = (val.value<int>() >= 0 && val.value<int>() < P_CH_OTHERS) ? val.value<int>() : P_CH_OTHERS;
        break;
    case P_ENUM_INT:
    case P_ENUM_CURRENT:
    case P_ENUM_VOLTAGE:
        ret = val.value<int>();
        break;
    case P_ENUM_FLOAT:
        ret = 0.5f * val.value<float>();
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
        if (val.value<int>() > 15 || val.value<int>() < 10)
            return P_NOR_ABNORMAL;
        else
            return P_NOR_NORMAL;
    case P_ENUM_CURRENT:
        if (val.value<int>() > 3000 || val.value<int>() < 100)
            return P_NOR_ABNORMAL;
        else
            return P_NOR_NORMAL;
    }
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
    case P_ENUM_FLOAT:
    case P_ENUM_CURRENT:
    case P_ENUM_VOLTAGE:
        v = val.toString();
        break;
    }

    return tr(v.toUtf8());
}

deviceVar::deviceVar(const alert::P_ENUM type, QObject *parent) : QObject(parent), type(type)
{
    switch (type) {
    case alert::P_ENUM_NOR:
        this->setValue(alert::P_NOR_NORMAL);
        return;
    case alert::P_ENUM_LOCK:
        this->setValue(alert::P_LOCK_LOCKED);
        return;
    case alert::P_ENUM_MS:
        this->setValue(alert::P_MS_MASTER);
        return;
    case alert::P_ENUM_HSK:
        this->setValue(alert::P_HSK_SUCCESS);
        return;
    case alert::P_ENUM_ATTEN:
        this->setValue(alert::P_ATTEN_NORMAL);
        return;
    case alert::P_ENUM_STAT:
        this->setValue(alert::P_STAT_NORMAL);
        return;
    case alert::P_ENUM_CH:
        this->setValue(alert::P_CH_OTHERS);
        return;
    case alert::P_ENUM_INT:
    case alert::P_ENUM_CURRENT:
    case alert::P_ENUM_VOLTAGE:
        this->setValue(0);
        return;
    case alert::P_ENUM_FLOAT:
        this->setValue(0.0f);
        return;
    }
}

void deviceVar::setValue(const QVariant value)
{
    this->value = alert::setValue(value, this->type);
    this->stat = alert::setState(value, this->type);
    this->display = alert::setDisplay(value, this->type);
}

int deviceVar::getValue()
{
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
        return value.value<int>();
    case alert::P_ENUM_FLOAT:
        return static_cast<int>(value.value<float>());
    }
}

QString deviceVar::getColor()
{
    switch (stat) {
    case alert::P_NOR_NORMAL:
        return "green";
    case alert::P_NOR_ABNORMAL:
        return "red";
    case alert::P_NOR_STANDBY:
        return "yellow";
    case alert::P_NOR_OTHERS:
        return "black";
    }
}
