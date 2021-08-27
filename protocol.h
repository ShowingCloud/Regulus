#ifndef PROTOCOL_H
#define PROTOCOL_H

#include <QObject>
#include <QList>

class serial;

class msg : public QObject
{
    Q_OBJECT
public:
    explicit msg(QObject *parent = nullptr);
    explicit msg(QObject *parent, const QString input);
    ~msg();

    msg &operator= (const QString input);
    msg &operator()() const;
    QDataStream &operator>> (const QDataStream input);
    QDataStream &operator<< (QDataStream output);

    enum validateResult { VAL_PASS, VAL_TOOSHORT, VAL_TOOLONG, VAL_INVALIDID };
    static validateResult validateProtocol(const QString input);

    enum proto {
        PROTO_DEFAULT, PROTO_UPLINK, PROTO_DOWNLINK, PROTO_AMP, PROTO_FREQ, PROTO_DIST,
        PROTO_QUERY, PROTO_CNTL_AMP, PROTO_CNTL_FREQ, PROTO_CNTL_DIST
    };


    /* static inline int protoMaxLength()
    {
        return *std::max_element(protoLength.values().begin(), protoLength.values().end());
    } */

protected:
    const uint8_t head = 0xff;
    const uint8_t tail = 0xaa;
    uint8_t device;
    uint8_t serial;

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

};

class msgDownlink : public msg
{

};

class msgAmp : public msgUplink
{
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
protected:
    uint8_t ref_10;
    uint8_t ref_16;
    uint8_t voltage;
    uint16_t current;
    uint8_t power;
};

class msgQuery : public msgDownlink
{
protected:
    uint8_t identify;
    uint8_t instruction;
};

class msgCntlAmp : public msgDownlink
{
protected:
    uint8_t atten_mode;
    uint8_t atten;
    uint16_t power;
    uint16_t gain;
};

class msgCntlFreq : public msgDownlink
{
protected:
    uint8_t atten;
    uint8_t ref_10_a;
    uint8_t ref_10_b;
};

class msgCntlDist : public msgDownlink
{
protected:
    uint8_t ref_10;
    uint8_t ref_16;
};


class protocol : public QObject
{
    Q_OBJECT
public:
    explicit protocol(QObject *parent = nullptr);
    protocol &operator>> (QByteArray &data) const;
    protocol &operator<< (const QByteArray &data);

    static QList<protocol *> protocollist;

private:
    msgUplink uplink;
    msgDownlink downlink;

signals:

public slots:
    static void createDownMsg(serial &s);
};

#endif // PROTOCOL_H
