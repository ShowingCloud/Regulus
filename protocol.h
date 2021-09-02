#ifndef PROTOCOL_H
#define PROTOCOL_H

#include <QObject>
#include <QList>
#include <QDateTime>

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
    static validateResult validateProtocol(QByteArray buffer, const QByteArray input);

    enum proto {
        PROTO_DEFAULT, PROTO_UPLINK, PROTO_DOWNLINK, PROTO_AMP, PROTO_FREQ, PROTO_DIST,
        PROTO_QUERY, PROTO_CNTL_AMP, PROTO_CNTL_FREQ, PROTO_CNTL_DIST
    };

    inline const static int header = 0xff;
    inline const static int tailer = 0xaa;

    /* static inline int protoMaxLength()
    {
        return *std::max_element(protoLength.values().begin(), protoLength.values().end());
    } */

protected:
    const uint8_t head = msg::header;
    const uint8_t tail = msg::tailer;
    uint8_t device;
    uint8_t serial;
    uint8_t holder8;
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

    inline const static int mlen = 19;
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

protected:
    uint16_t power;
    uint16_t gain;
    uint16_t atten;
    uint16_t loss;
    uint16_t temp;
    uint16_t stat;
    uint16_t load_temp;
    uint8_t handshake;
};

class msgFreq : public msgUplink
{
public:
    explicit msgFreq(QObject *parent = nullptr);
    const msgFreq &operator>> (QByteArray &data) const;
    msgFreq &operator<< (const QByteArray &data);

protected:
    uint8_t atten;
    uint8_t voltage;
    uint16_t current;
    uint8_t radio_stat;
    uint8_t mid_stat;
    uint8_t lock_a1;
    uint8_t lock_a2;
    uint8_t lock_b1;
    uint8_t lock_b2;
    uint8_t ref_10_1;
    uint8_t ref_10_2;
    uint8_t ref_3;
    uint8_t ref_4;
    uint8_t handshake;
};

class msgDist : public msgUplink
{
public:
    explicit msgDist(QObject *parent = nullptr);
    const msgDist &operator>> (QByteArray &data) const;
    msgDist &operator<< (const QByteArray &data);

protected:
    uint8_t ref_10;
    uint8_t ref_16;
    uint8_t voltage;
    uint16_t current;
    uint8_t power;
};

class msgQuery : public msgDownlink
{
public:
    explicit msgQuery(QObject *parent = nullptr);
    const msgQuery &operator>> (QByteArray &data) const;
    msgQuery &operator<< (const QByteArray &data);

protected:
    uint8_t identify;
    uint8_t instruction;
};

class msgCntlAmp : public msgDownlink
{
public:
    explicit msgCntlAmp(QObject *parent = nullptr);
    const msgCntlAmp &operator>> (QByteArray &data) const;
    msgCntlAmp &operator<< (const QByteArray &data);

protected:
    uint8_t atten_mode;
    uint8_t atten;
    uint16_t power;
    uint16_t gain;
};

class msgCntlFreq : public msgDownlink
{
public:
    explicit msgCntlFreq(QObject *parent = nullptr);
    const msgCntlFreq &operator>> (QByteArray &data) const;
    msgCntlFreq &operator<< (const QByteArray &data);

protected:
    uint8_t atten;
    uint8_t ref_10_a;
    uint8_t ref_10_b;
};

class msgCntlDist : public msgDownlink
{
public:
    explicit msgCntlDist(QObject *parent = nullptr);
    const msgCntlDist &operator>> (QByteArray &data) const;
    msgCntlDist &operator<< (const QByteArray &data);

protected:
    uint8_t ref_10;
    uint8_t ref_16;
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
    static void createDownMsg(serial &s);
};

#endif // PROTOCOL_H
