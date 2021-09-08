#ifndef PROTOCOL_H
#define PROTOCOL_H

#include <QObject>
#include <QList>
#include <QDateTime>
#include <QDataStream>

#include "device.h"

class serial;

class msg : public QObject
{
public:
    explicit msg(QObject *parent = nullptr);

    msg &operator= (const QByteArray &input);
    msg &operator()() const;
    friend const msg &operator>> (const msg &m, QByteArray &data);
    friend msg &operator<< (msg &m, const QByteArray &data);

    enum validateResult { VAL_PASS, VAL_TOOSHORT, VAL_TOOLONG, VAL_INVALIDID, VAL_REMAINS, VAL_USEINPUT, VAL_FAILED };
    static validateResult validateProtocol(QByteArray &buffer, const QByteArray &input);

    enum proto {
        PROTO_DEFAULT, PROTO_UPLINK, PROTO_DOWNLINK, PROTO_AMP, PROTO_FREQ, PROTO_DIST,
        PROTO_QUERY, PROTO_CNTL_AMP, PROTO_CNTL_FREQ, PROTO_CNTL_DIST
    };

    inline const static int header = 0xff;
    inline const static int tailer = 0xaa;

    inline static QList<msg *> unknownmsglist = {};
    /* static inline int protoMaxLength()
    {
        return *std::max_element(protoLength.values().begin(), protoLength.values().end());
    } */

protected:
    const quint8 head = msg::header;
    const quint8 tail = msg::tailer;
    quint8 serialId = quint8();
    quint8 deviceId = quint8();
    quint8 holder8 = 0x00;
    QDateTime time = QDateTime();
    QString origin = QString();

    static const inline QHash<int, proto> idProto = {
        {0x00, PROTO_FREQ}, {0x01, PROTO_FREQ}, {0x02, PROTO_FREQ}, {0x03, PROTO_FREQ},
        {0x04, PROTO_FREQ}, {0x05, PROTO_FREQ}, {0x06, PROTO_FREQ}, {0x07, PROTO_FREQ},
        {0x0A, PROTO_DIST}, {0x0B, PROTO_DIST},
        {0x0C, PROTO_AMP}, {0x0D, PROTO_AMP}, {0x0E, PROTO_AMP}, {0x0F, PROTO_AMP}
    };
    /* static const inline QHash<proto, int> protoLength = {
        {PROTO_DEFAULT, 2},
    }; */

signals:

public slots:
};

class msgUplink : public msg
{
public:
    explicit msgUplink(QObject *parent = nullptr);
    friend const msgUplink &operator>> (const msgUplink &m, QByteArray &data);
    friend msgUplink &operator<< (msgUplink &m, const QByteArray &data);

    inline const static int mlen = 20;
    inline const static int posDevice = 15;
};

class msgDownlink : public msg
{
public:
    explicit msgDownlink(QObject *parent = nullptr);
    friend const msgDownlink &operator>> (const msgDownlink &m, QByteArray &data);
    friend msgDownlink &operator<< (msgDownlink &m, const QByteArray &data);
};

class msgFreq : public msgUplink
{
public:
    explicit msgFreq(QObject *parent = nullptr);
    friend const msgFreq &operator>> (const msgFreq &m, QByteArray &data);
    friend msgFreq &operator<< (msgFreq &m, const QByteArray &data);
    friend device &operator<< (device &dev, const msgFreq &m);
    friend devFreq &operator<< (devFreq &dev, const msgFreq &m);

    inline const static int posSerial = 17;

protected:
    quint8 atten = quint8();
    quint8 voltage = quint8();
    quint16 current = quint16();
    quint8 output_stat = quint8();
    quint8 input_stat = quint8();
    quint8 lock_a1 = quint8();
    quint8 lock_a2 = quint8();
    quint8 lock_b1 = quint8();
    quint8 lock_b2 = quint8();
    quint8 ref_10_1 = quint8();
    quint8 ref_10_2 = quint8();
    quint8 ref_3 = quint8();
    quint8 ref_4 = quint8();
    quint8 handshake = quint8();
};

class msgDist : public msgUplink
{
public:
    explicit msgDist(QObject *parent = nullptr);
    friend const msgDist &operator>> (const msgDist &m, QByteArray &data);
    friend msgDist &operator<< (msgDist &m, const QByteArray &data);
    friend device &operator<< (device &dev, const msgDist &m);
    friend devDist &operator<< (devDist &dev, const msgDist &m);

    inline const static int posSerial = 8;

protected:
    quint8 ref_10 = quint8();
    quint8 ref_16 = quint8();
    quint8 voltage = quint8();
    quint16 current = quint16();
    quint8 power = quint8();

};

class msgAmp : public msgUplink
{
public:
    explicit msgAmp(QObject *parent = nullptr);
    friend const msgAmp &operator>> (const msgAmp &m, QByteArray &data);
    friend msgAmp &operator<< (msgAmp &m, const QByteArray &data);
    friend device &operator<< (device &dev, const msgAmp &m);
    friend devAmp &operator<< (devAmp &dev, const msgAmp &m);

    inline const static int posSerial = 17;

protected:
    quint16 power = quint16();
    quint16 gain = quint16();
    quint16 atten = quint16();
    quint16 loss = quint16();
    quint16 temp = quint16();
    quint16 stat = quint16();
    quint16 load_temp = quint16();
    quint8 handshake = quint8();
};

class msgQuery : public msgDownlink
{
public:
    explicit msgQuery(QObject *parent = nullptr);
    friend const msgQuery &operator>> (const msgQuery &m, QByteArray &data);
    friend msgQuery &operator<< (msgQuery &m, const QByteArray &data);

    void createQuery();

    inline const static int posSerial = 4;

protected:
    quint8 identify = 0x00;
    quint8 instruction = 0x01;
};

class msgCntlAmp : public msgDownlink
{
public:
    explicit msgCntlAmp(QObject *parent = nullptr);
    friend const msgCntlAmp &operator>> (const msgCntlAmp &m, QByteArray &data);
    friend msgCntlAmp &operator<< (msgCntlAmp &m, const QByteArray &data);

    inline const static int posSerial = 8;

protected:
    quint8 atten_mode = quint8();
    quint8 atten = quint8();
    quint16 power = quint16();
    quint16 gain = quint16();
};

class msgCntlFreq : public msgDownlink
{
public:
    explicit msgCntlFreq(QObject *parent = nullptr);
    friend const msgCntlFreq &operator>> (const msgCntlFreq &m, QByteArray &data);
    friend msgCntlFreq &operator<< (msgCntlFreq &m, const QByteArray &data);

    inline const static int posSerial = 6;

protected:
    quint8 atten = quint8();
    quint8 ref_10_a = quint8();
    quint8 ref_10_b = quint8();
};

class msgCntlDist : public msgDownlink
{
public:
    explicit msgCntlDist(QObject *parent = nullptr);
    friend const msgCntlDist &operator>> (const msgCntlDist &m, QByteArray &data);
    friend msgCntlDist &operator<< (msgCntlDist &m, const QByteArray &data);

    inline const static int posSerial = 4;

protected:
    quint8 ref_10 = quint8();
    quint8 ref_16 = quint8();
};


class protocol : public QObject
{
    Q_OBJECT
public:
    explicit protocol(QObject *parent = nullptr);
    friend const protocol &operator>> (const protocol &p, serial &s);
    friend protocol &operator<< (protocol &p, const serial &s);

    inline static QList<protocol *> protocollist = {};

private:
    msgUplink *uplink;
    msgDownlink *downlink;

signals:

public slots:
    static void createQueryMsg(serial &s);
};

#endif // PROTOCOL_H
