#ifndef PROTOCOL_H
#define PROTOCOL_H

#include <QObject>
#include <QList>
#include <QDateTime>
#include <QDataStream>

#include "device.h"

class serial;
class database;

class msg
{
public:
    explicit msg() {}

    friend const msg &operator>> (const msg &m, QByteArray &data);
    friend msg &operator<< (msg &m, const QByteArray &data);

    enum validateResult { VAL_PASS, VAL_TOOSHORT, VAL_TOOLONG, VAL_INVALIDID, VAL_REMAINS, VAL_USEINPUT, VAL_FAILED };
    static validateResult validateProtocol(QByteArray &buffer, const QByteArray &input, serial *s);

    enum proto {
        PROTO_DEFAULT, PROTO_UPLINK, PROTO_DOWNLINK, PROTO_AMP, PROTO_FREQ, PROTO_DIST,
        PROTO_QUERY, PROTO_CNTL_AMP, PROTO_CNTL_FREQ, PROTO_CNTL_DIST
    };

    inline const static int header = 0xff;
    inline const static int tailer = 0xaa;

    inline static QList<msg *> unknownmsgList = {};

protected:
    const quint8 head = msg::header;
    const quint8 tail = msg::tailer;
    quint8 serialId = quint8();
    quint8 deviceId = quint8();
    quint8 holder8 = 0x00;
    QDateTime time = QDateTime();
    QByteArray origin = QByteArray();
    serial *serialport;

    static const inline QHash<int, proto> idProto = {
        {0x00, PROTO_FREQ}, {0x01, PROTO_FREQ}, {0x02, PROTO_FREQ}, {0x03, PROTO_FREQ},
        {0x04, PROTO_FREQ}, {0x05, PROTO_FREQ}, {0x06, PROTO_FREQ}, {0x07, PROTO_FREQ},
        {0x0A, PROTO_DIST}, {0x0B, PROTO_DIST},
        {0x0C, PROTO_AMP}, {0x0D, PROTO_AMP}, {0x0E, PROTO_AMP}, {0x0F, PROTO_AMP}
    };
};

class msgUplink : public msg
{
public:
    explicit msgUplink(msg parent) : msg(parent) {}
    explicit msgUplink() {}

    friend const msgUplink &operator>> (const msgUplink &m, QByteArray &data);
    friend msgUplink &operator<< (msgUplink &m, const QByteArray &data);

    inline const static int mlen = 20;
    inline const static int posDevice = 15;
};

class msgDownlink : public msg
{
public:
    explicit msgDownlink(msg parent) : msg(parent) {}
    explicit msgDownlink() {}

    friend const msgDownlink &operator>> (const msgDownlink &m, QByteArray &data);
    friend msgDownlink &operator<< (msgDownlink &m, const QByteArray &data);

    inline void setDeviceId(quint8 dId) {
        deviceId = dId;
    }

    inline const static int posSerial = 0;
};

class msgFreq : public msgUplink
{
public:
    explicit msgFreq(msgUplink parent) : msgUplink(parent) {}
    explicit msgFreq() {}

    friend const msgFreq &operator>> (const msgFreq &m, QByteArray &data);
    friend msgFreq &operator<< (msgFreq &m, const QByteArray &data);
    friend device &operator<< (device &dev, const msgFreq &m);
    friend devFreq &operator<< (devFreq &dev, const msgFreq &m);
    friend database &operator<< (database &db, const msgFreq &msg);

    inline const static int posSerial = 17;

private:
    quint8 atten = quint8();
    quint8 voltage = quint8();
    quint16 current = quint16();
    quint8 radio_stat = quint8();
    quint8 mid_stat = quint8();
    quint8 lock_a1 = quint8();
    quint8 lock_a2 = quint8();
    quint8 lock_b1 = quint8();
    quint8 lock_b2 = quint8();
    quint8 ref_2 = quint8();
    quint8 ref_4 = quint8();
    quint8 ref_10_1 = quint8();
    quint8 ref_10_2 = quint8();
    quint8 ref_10_3 = quint8();
    quint8 ref_10_4 = quint8();
    quint8 ref_inner_1 = quint8();
    quint8 ref_inner_2 = quint8();
    quint8 handshake = quint8();
    quint8 masterslave = quint8();
};

class msgDist : public msgUplink
{
public:
    explicit msgDist(msgUplink parent) : msgUplink(parent) {}
    explicit msgDist() {}

    friend const msgDist &operator>> (const msgDist &m, QByteArray &data);
    friend msgDist &operator<< (msgDist &m, const QByteArray &data);
    friend device &operator<< (device &dev, const msgDist &m);
    friend devDist &operator<< (devDist &dev, const msgDist &m);
    friend database &operator<< (database &db, const msgDist &msg);

    inline const static int posSerial = 8;

private:
    quint8 ref_10 = quint8();
    quint8 ref_16 = quint8();
    quint8 voltage = quint8();
    quint16 current = quint16();
    quint8 lock_10_1 = quint8();
    quint8 lock_10_2 = quint8();
    quint8 lock_16_1 = quint8();
    quint8 lock_16_2 = quint8();
};

class msgAmp : public msgUplink
{
public:
    explicit msgAmp(msgUplink parent) : msgUplink(parent) {}
    explicit msgAmp() {}

    friend const msgAmp &operator>> (const msgAmp &m, QByteArray &data);
    friend msgAmp &operator<< (msgAmp &m, const QByteArray &data);
    friend device &operator<< (device &dev, const msgAmp &m);
    friend devAmp &operator<< (devAmp &dev, const msgAmp &m);
    friend database &operator<< (database &db, const msgAmp &msg);

    inline const static int posSerial = 17;

private:
    quint16 power = quint16();
    quint16 gain = quint16();
    quint16 atten = quint16();
    quint16 loss = quint16();
    quint16 temp = quint16();
    quint16 stat = quint16();
    quint8 stat_stand_wave = quint8();
    quint8 stat_temp = quint8();
    quint8 stat_current = quint8();
    quint8 stat_voltage = quint8();
    quint8 stat_power = quint8();
    quint16 load_temp = quint16();
    quint8 handshake = quint8();
};

class msgQuery : public msgDownlink
{
public:
    explicit msgQuery(msgDownlink parent) : msgDownlink(parent) {}
    explicit msgQuery() {}

    friend const msgQuery &operator>> (const msgQuery &m, QByteArray &data);
    friend msgQuery &operator<< (msgQuery &m, const QByteArray &data);

    void createQuery();

    inline const static int posSerial = 4;

private:
    quint8 identify = 0x00;
    quint8 instruction = 0x01;
};

class msgCntlAmp : public msgDownlink
{
public:
    explicit msgCntlAmp(msgDownlink parent) : msgDownlink(parent) {}
    explicit msgCntlAmp() {}

    friend const msgCntlAmp &operator>> (const msgCntlAmp &m, QByteArray &data);
    friend msgCntlAmp &operator<< (msgCntlAmp &m, const QByteArray &data);
    friend const devAmp &operator>> (const devAmp &dev, msgCntlAmp &m);
    friend database &operator<< (database &db, const msgCntlAmp &msg);

    inline const static int posSerial = 8;

private:
    quint8 atten_mode = quint8();
    quint8 atten = quint8();
    quint16 power = quint16();
    quint16 gain = quint16();
};

class msgCntlFreq : public msgDownlink
{
public:
    explicit msgCntlFreq(msgDownlink parent) : msgDownlink(parent) {}
    explicit msgCntlFreq() {}

    friend const msgCntlFreq &operator>> (const msgCntlFreq &m, QByteArray &data);
    friend msgCntlFreq &operator<< (msgCntlFreq &m, const QByteArray &data);
    friend const devFreq &operator>> (const devFreq &dev, msgCntlFreq &m);
    friend database &operator<< (database &db, const msgCntlFreq &msg);

    inline const static int posSerial = 6;

private:
    quint8 atten = quint8();
    quint8 ref_10_a = quint8();
    quint8 ref_10_b = quint8();
};

class msgCntlDist : public msgDownlink
{
public:
    explicit msgCntlDist(msgDownlink parent) : msgDownlink(parent) {}
    explicit msgCntlDist() {}

    friend const msgCntlDist &operator>> (const msgCntlDist &m, QByteArray &data);
    friend msgCntlDist &operator<< (msgCntlDist &m, const QByteArray &data);
    friend const devDist &operator>> (const devDist &dev, msgCntlDist &m);
    friend database &operator<< (database &db, const msgCntlDist &msg);

    inline const static int posSerial = 4;

private:
    quint8 ref_10 = quint8();
    quint8 ref_16 = quint8();
};


class protocol : public QObject
{
    Q_OBJECT
public:
    explicit protocol(QObject *parent = nullptr) : QObject(parent) {}

    friend const protocol &operator>> (const protocol &p, serial &s);
    friend protocol &operator<< (protocol &p, const serial &s);

    inline static QList<protocol *> protocolList = {};

private:
    msgUplink *uplink;
    msgDownlink *downlink;

signals:

public slots:
    static void createQueryMsg(serial &s);
};

#endif // PROTOCOL_H
