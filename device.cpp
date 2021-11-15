#include "device.h"
#include "protocol.h"
#include "serial.h"
#include "database.h"

#include <QDateTime>
#include <QDebug>
#include <iso646.h>

device::device(const QHash<QString, deviceVar*> var, const QHash<QString, QString> str_var,
               const database::DB_TBL devTable, QStringList prefStr, QObject *parent)
    : QObject(parent), var(var), STR_VAR(str_var), devTable(devTable), prefStr(prefStr)
{
    device::push(this);

    connect(this, &device::idSet, [=](){ isSetStandby = getStandby(); });

    for (const QString &key : var.keys())
        connect(var[key], &deviceVar::sendAlert, this, [=]
                (const alert::P_ALERT type, const QVariant value, const QVariant normal_value){
            globalDB->setAlert(devTable, dId, type, key, value, normal_value);
        });
}

device &operator<< (device &d, const msgFreq &m)
{
    if (d.dId == m.deviceId)
    {
        devFreq &dev = dynamic_cast<devFreq &>(d);
        dev.str = m.origin;
        dev.lastSerial = m.serialport;

        if (Q_UNLIKELY(dev.timedout()) and not dev.isSetStandby) {
            dev.lastseen = QDateTime::currentDateTime();
            dev.createCntlMsg();
        } else
            dev.lastseen = QDateTime::currentDateTime();

        dev.timerStr = dev.lastseen.toString(Qt::ISODate) + " #" + QString::number(m.serialId);

        dev << m;
    }
    return d;
}

device &operator<< (device &d, const msgDist &m)
{
    if (d.dId == m.deviceId)
    {
        devDist &dev = dynamic_cast<devDist &>(d);
        dev.str = m.origin;
        dev.lastSerial = m.serialport;

        if (Q_UNLIKELY(dev.timedout())) {
            dev.lastseen = QDateTime::currentDateTime();
            dev.createCntlMsg();
        } else
            dev.lastseen = QDateTime::currentDateTime();

        dev.timerStr = dev.lastseen.toString(Qt::ISODate) + " #" + QString::number(m.serialId);

        dev << m;
    }
    return d;
}

device &operator<< (device &d, const msgAmp &m)
{
    if (d.dId == m.deviceId)
    {
        devAmp &dev = dynamic_cast<devAmp &>(d);
        dev.str = m.origin;
        dev.lastSerial = m.serialport;

        if (Q_UNLIKELY(dev.timedout()) and not dev.isSetStandby) {
            dev.lastseen = QDateTime::currentDateTime();
            dev.createCntlMsg();
        } else
            dev.lastseen = QDateTime::currentDateTime();

        dev.timerStr = dev.lastseen.toString(Qt::ISODate) + " #" + QString::number(m.serialId);

        dev << m;
    }
    return d;
}

devFreq &operator<< (devFreq &dev, const msgFreq &m)
{
    dev.var["atten"]->setValue(m.atten);
    //ch_a = m;
    //ch_b = m;
    dev.var["voltage"]->setValue(m.voltage);
    dev.var["current"]->setValue(m.current);
    dev.var["radio_stat"]->setValue(m.radio_stat);
    dev.var["mid_stat"]->setValue(m.mid_stat);
    dev.var["lock_a1"]->setValue(m.lock_a1);
    dev.var["lock_a2"]->setValue(m.lock_a2);
    dev.var["lock_b1"]->setValue(m.lock_b1);
    dev.var["lock_b2"]->setValue(m.lock_b2);

    if (m.ref_10_1 == alert::P_NOR_NORMAL and m.ref_select_master != 0x00)
        dev.var["ref_10_1"]->setValue(alert::P_NOR_STANDBY);
    else
        dev.var["ref_10_1"]->setValue(m.ref_10_1);
    if (m.ref_10_2 == alert::P_NOR_NORMAL and m.ref_select_master != 0x01)
        dev.var["ref_10_2"]->setValue(alert::P_NOR_STANDBY);
    else
        dev.var["ref_10_2"]->setValue(m.ref_10_2);
    if (m.ref_10_3 == alert::P_NOR_NORMAL and m.ref_select_slave != 0x00)
        dev.var["ref_10_3"]->setValue(alert::P_NOR_STANDBY);
    else
        dev.var["ref_10_3"]->setValue(m.ref_10_3);
    if (m.ref_10_4 == alert::P_NOR_NORMAL and m.ref_select_slave != 0x01)
        dev.var["ref_10_4"]->setValue(alert::P_NOR_STANDBY);
    else
        dev.var["ref_10_4"]->setValue(m.ref_10_4);
    if (m.ref_inner_1 == alert::P_NOR_NORMAL and m.ref_select_master != 0x02)
        dev.var["ref_inner_1"]->setValue(alert::P_NOR_STANDBY);
    else
        dev.var["ref_inner_1"]->setValue(m.ref_inner_1);
    if (m.ref_inner_2 == alert::P_NOR_NORMAL and m.ref_select_slave != 0x02)
        dev.var["ref_inner_2"]->setValue(alert::P_NOR_STANDBY);
    else
        dev.var["ref_inner_2"]->setValue(m.ref_inner_2);

    dev.var["handshake"]->setValue(m.handshake);

    if (m.masterslave == static_cast<int>(dev.isSlave)) {
        dev.var["masterslave"]->setValue(alert::P_NOR_NORMAL);
        dev.isStandby = false;
    } else {
        dev.var["masterslave"]->setValue(alert::P_NOR_STANDBY);
        dev.isStandby = true;
    }

    emit dev.gotData();
    return dev;
}

devDist &operator<< (devDist &dev, const msgDist &m)
{
    dev.var["ref_10"]->setValue(m.ref_10);
    dev.var["ref_16"]->setValue(m.ref_16);
    dev.var["voltage"]->setValue(m.voltage);
    dev.var["current"]->setValue(m.current);
    dev.var["lock_10_1"]->setValue(m.lock_10_1);
    dev.var["lock_10_2"]->setValue(m.lock_10_2);
    dev.var["lock_16_1"]->setValue(m.lock_16_1);
    dev.var["lock_16_2"]->setValue(m.lock_16_2);

    emit dev.gotData();
    return dev;
}

devAmp &operator<< (devAmp &dev, const msgAmp &m)
{
    dev.var["output_power"]->setValue(m.output_power);
    dev.var["gain"]->setValue(m.gain);
    dev.var["atten"]->setValue(m.atten);
    dev.var["input_power"]->setValue(m.input_power);
    dev.var["amp_temp"]->setValue(m.temp);
    dev.var["load_temp"]->setValue(m.load_temp);
    dev.var["s_stand_wave"]->setValue(m.stat_stand_wave);
    dev.var["s_temp"]->setValue(m.stat_temp);
    dev.var["s_current"]->setValue(m.stat_current);
    dev.var["s_voltage"]->setValue(m.stat_voltage);
    dev.var["s_power"]->setValue(m.stat_power);
    dev.var["handshake"]->setValue(m.handshake);

    dev.var["masterslave"]->setValue(m.isactive == 0 ? alert::P_NOR_STANDBY : alert::P_NOR_NORMAL);
    dev.isStandby = (m.isactive == 0);

    emit dev.gotData();
    return dev;
}

const devFreq &operator>> (const devFreq &dev, msgCntlFreq &m)
{
    m.atten = static_cast<quint8>(dev.var["atten"]->getValue());
    m.ref_10_a = static_cast<quint8>(dev.var["ch_a"]->getValue());
    m.ref_10_b = static_cast<quint8>(dev.var["ch_b"]->getValue());

    m.setDeviceId(static_cast<quint8>(dev.dId));
    return dev;
}

const devDist &operator>> (const devDist &dev, msgCntlDist &m)
{
    m.ref_10 = static_cast<quint8>(dev.var["ref_10"]->getValue());
    m.ref_16 = static_cast<quint8>(dev.var["ref_16"]->getValue());

    m.setDeviceId(static_cast<quint8>(dev.dId));
    return dev;
}

const devAmp &operator>> (const devAmp &dev, msgCntlAmp &m)
{
    m.atten_mode = static_cast<quint8>(dev.var["atten_mode"]->getValue());
    m.atten = static_cast<quint8>(dev.var["atten"]->getValue());
    m.output_power = static_cast<quint16>(dev.var["output_power"]->getValue());
    m.gain = static_cast<quint16>(dev.var["gain"]->getValue());

    m.setDeviceId(static_cast<quint8>(dev.dId));
    return dev;
}

const QString devFreq::showIndicatorColor() const
{
    if (timedout())
        return alert::STR_COLOR[alert::P_COLOR_ABNORMAL];
    else if (isStandby)
        return alert::STR_COLOR[alert::P_COLOR_STANDBY];
    else
        if (stateGood("atten") and stateGood("voltage") and stateGood("current")
                and stateGood("radio_stat") and stateGood("mid_stat")
                and (stateGood("lock_a1") or stateGood("lock_b1"))
                and (stateGood("ref_10_1") or stateGood("ref_10_2") or stateGood("ref_10_3")
                     or stateGood("ref_10_4") or stateGood("ref_inner_1") or stateGood("ref_inner_2"))
                and stateGood("handshake"))
            return alert::STR_COLOR[alert::P_COLOR_NORMAL];
        else
            return alert::STR_COLOR[alert::P_COLOR_ABNORMAL];
}

const QString devDist::showIndicatorColor() const
{
    if (timedout())
        return alert::STR_COLOR[alert::P_COLOR_ABNORMAL];
    else
        if (stateGood("ref_10") and stateGood("ref_16") and stateGood("voltage")
                and stateGood("current")
                and (stateGood("lock_10_1") or stateGood("lock_10_2")
                     or stateGood("lock_16_1") or stateGood("lock_16_2")))
            return alert::STR_COLOR[alert::P_COLOR_NORMAL];
        else
            return alert::STR_COLOR[alert::P_COLOR_ABNORMAL];
}

const QString devAmp::showIndicatorColor() const
{
    if (timedout())
        return alert::STR_COLOR[alert::P_COLOR_ABNORMAL];
    else
        if (stateGood("output_power") and stateGood("gain") and stateGood("atten")
                and stateGood("input_power") and stateGood("amp_temp") and stateGood("load_temp")
                and stateGood("s_stand_wave") and stateGood("s_temp") and stateGood("s_current")
                and stateGood("s_voltage") and stateGood("s_power") and stateGood("handshake"))
            return alert::STR_COLOR[alert::P_COLOR_NORMAL];
        else
            return alert::STR_COLOR[alert::P_COLOR_ABNORMAL];
}

const QString devNet::showIndicatorColor() const
{
    if (timedout())
        return alert::STR_COLOR[alert::P_COLOR_ABNORMAL];
    else
        return alert::STR_COLOR[alert::P_COLOR_NORMAL];
}

void devFreq::createCntlMsg() const
{
    protocol *p = new protocol();
    protocol::protocolList << p;

    *globalDB << *this;
    msgCntlFreq *q = new msgCntlFreq();
    *this >> *q;

    if (lastSerial and lastseen.secsTo(QDateTime::currentDateTime()) <= 3) {
        qDebug() << "create msg: sending one" << dId;
        *lastSerial << *q;
    } else {
        qDebug() << "create msg: sending all" << dId;
        for (serial *s : qAsConst(serial::serialList))
            *s << *q;
    }

    delete q;
}

void devDist::createCntlMsg() const
{
    protocol *p = new protocol();
    protocol::protocolList << p;

    *globalDB << *this;
    msgCntlDist *q = new msgCntlDist();
    *this >> *q;

    if (lastSerial and lastseen.secsTo(QDateTime::currentDateTime()) <= 3) {
        qDebug() << "create msg: sending one" << dId;
        *lastSerial << *q;
    } else {
        qDebug() << "create msg: sending all" << dId;
        for (serial *s : qAsConst(serial::serialList))
            *s << *q;
    }

    delete q;
}

void devAmp::createCntlMsg() const
{
    protocol *p = new protocol();
    protocol::protocolList << p;

    *globalDB << *this;
    msgCntlAmp *q = new msgCntlAmp();
    *this >> *q;

    if (lastSerial and lastseen.secsTo(QDateTime::currentDateTime()) <= 3) {
        qDebug() << "create msg: sending one" << dId;
        *lastSerial << *q;
    } else {
        qDebug() << "create msg: sending all" << dId;
        for (serial *s : qAsConst(serial::serialList))
            *s << *q;
    }

    delete q;
}

devNet::devNet(QObject *parent)
        : device({}, {}, database::DB_TBL_NET_ALERT, {}, parent)
{
    connect(this, &device::idSet, [=]() {
        QStringList params;
#ifdef Q_OS_WIN
        params << "-n" << "1" << "-w" << "900";
#else
        params << "-c" << "1" << "-W" << "0.9";
#endif
        params << ipAddr[dId];

        QTimer *timer = new QTimer(this);
        connect(timer, &QTimer::timeout, this, [=]() {
            timer->start(1000);

            if (ping) {
                ping->kill();
                ping->waitForFinished();
                ping->deleteLater();
            }
            ping = new QProcess(this);
            ping->start("ping", params);

            connect(ping, QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished),
                    [=](int exitCode, QProcess::ExitStatus exitStatus){
                Q_UNUSED(exitStatus)
#ifdef Q_OS_WIN
                if (exitCode == 0 and ping->readAllStandardOutput().contains("TTL=")) {
#else
                if (exitCode == 0) {
#endif
                    lastseen = QDateTime::currentDateTime();
                    emit gotData();
                }
            });
        });
        timer->start(0);
    });
}

devNet::~devNet()
{
    if (ping) {
        ping->kill();
        ping->waitForFinished();
        ping->deleteLater();
    }
}
