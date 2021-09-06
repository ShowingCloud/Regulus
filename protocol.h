#ifndef PROTOCOL_H
#define PROTOCOL_H

#include <QObject>
#include <QList>
#include <QDateTime>
#include <QDataStream>

class serial;

class msg : public QObject
{
public:
    explicit msg(QObject *parent = nullptr);

    msg &operator= (const QByteArray input);
    msg &operator()() const;
    const msg &operator>> (QByteArray &data) const;
    msg &operator<< (const QByteArray &data);

    enum validateResult { VAL_PASS, VAL_TOOSHORT, VAL_TOOLONG, VAL_INVALIDID, VAL_REMAINS, VAL_USEINPUT, VAL_FAILED };
    static validateResult validateProtocol(QByteArray &buffer, const QByteArray input);

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
    quint8 device;
    quint8 serial;
    quint8 holder8 = 0x00;
    QDateTime time;

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
    const msgUplink &operator>> (QByteArray &data) const;
    msgUplink &operator<< (const QByteArray &data);

    inline const static int mlen = 20;
    inline const static int posDevice = 15;
};

class msgDownlink : public msg
{
public:
    explicit msgDownlink(QObject *parent = nullptr);
    const msgDownlink &operator>> (QByteArray &data) const;
    msgDownlink &operator<< (const QByteArray &data);
};

class msgAmp : public msgUplink
{
public:
    explicit msgAmp(QObject *parent = nullptr);
    const msgAmp &operator>> (QByteArray &data) const;
    msgAmp &operator<< (const QByteArray &data);

    inline const static int posSerial = 17;

protected:
    quint16 power;
    quint16 gain;
    quint16 atten;
    quint16 loss;
    quint16 temp;
    quint16 stat;
    quint16 load_temp;
    quint8 handshake;
};

class msgFreq : public msgUplink
{
public:
    explicit msgFreq(QObject *parent = nullptr);
    const msgFreq &operator>> (QByteArray &data) const;
    msgFreq &operator<< (const QByteArray &data);

    inline const static int posSerial = 17;

protected:
    quint8 atten;
    quint8 voltage;
    quint16 current;
    quint8 output_stat;
    quint8 input_stat;
    quint8 lock_a1;
    quint8 lock_a2;
    quint8 lock_b1;
    quint8 lock_b2;
    quint8 ref_10_1;
    quint8 ref_10_2;
    quint8 ref_3;
    quint8 ref_4;
    quint8 handshake;
};

class msgDist : public msgUplink
{
public:
    explicit msgDist(QObject *parent = nullptr);
    const msgDist &operator>> (QByteArray &data) const;
    msgDist &operator<< (const QByteArray &data);

    inline const static int posSerial = 8;

protected:
    quint8 ref_10;
    quint8 ref_16;
    quint8 voltage;
    quint16 current;
    quint8 power;

};

class msgQuery : public msgDownlink
{
public:
    explicit msgQuery(QObject *parent = nullptr);
    const msgQuery &operator>> (QByteArray &data) const;
    msgQuery &operator<< (const QByteArray &data);

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
    const msgCntlAmp &operator>> (QByteArray &data) const;
    msgCntlAmp &operator<< (const QByteArray &data);

    inline const static int posSerial = 8;

protected:
    quint8 atten_mode;
    quint8 atten;
    quint16 power;
    quint16 gain;
};

class msgCntlFreq : public msgDownlink
{
public:
    explicit msgCntlFreq(QObject *parent = nullptr);
    const msgCntlFreq &operator>> (QByteArray &data) const;
    msgCntlFreq &operator<< (const QByteArray &data);

    inline const static int posSerial = 6;

protected:
    quint8 atten;
    quint8 ref_10_a;
    quint8 ref_10_b;
};

class msgCntlDist : public msgDownlink
{
public:
    explicit msgCntlDist(QObject *parent = nullptr);
    const msgCntlDist &operator>> (QByteArray &data) const;
    msgCntlDist &operator<< (const QByteArray &data);

    inline const static int posSerial = 4;

protected:
    quint8 ref_10;
    quint8 ref_16;
};


class protocol : public QObject
{
    Q_OBJECT
public:
    explicit protocol(QObject *parent = nullptr);
    const protocol &operator>> (serial &s) const;
    protocol &operator<< (const serial &s);

    inline static QList<protocol *> protocollist = {};

private:
    msgUplink uplink;
    msgDownlink downlink;

signals:

public slots:
    static void createQueryMsg(serial &s);
};

#endif // PROTOCOL_H
