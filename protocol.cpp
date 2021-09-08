#include <QDebug>

#include "protocol.h"
#include "serial.h"
#include "device.h"

msg::msg(QObject *parent) : QObject(parent)
{
    return;
}

msg::validateResult msg::validateProtocol(QByteArray &buffer, const QByteArray &input)
{
    int head = 0, tail = 0;
    const char msg_header = static_cast<char>(msg::header), msg_tailer = static_cast<char>(msg::tailer);
    do {
        head = buffer.indexOf(msg_header, head);
        if (buffer.length() >= head + msgUplink::mlen && buffer.at(head + msgUplink::mlen - 1) == msg_tailer) {
            msg *m = new msg();
            if (buffer.length() == msgUplink::mlen) {
                *m << buffer;
                msg::unknownmsglist << m;
                buffer = QByteArray();
                return VAL_PASS;
            } else {
                *m << buffer.mid(head, msgUplink::mlen);
                msg::unknownmsglist << m;
                buffer.remove(head, msgUplink::mlen);
                // TODO: log
                return VAL_REMAINS;
            }
        } else {
            tail = head + 1;
            do {
                tail = buffer.indexOf(msg_tailer, tail);
                if (tail - head < msgUplink::mlen) {
                    // TODO: fill and process
                    // TODO: log
                    return VAL_TOOSHORT;
                } else if (tail - head > msgUplink::mlen) {
                    // TODO: truncate and process
                    // TODO: log
                    return VAL_TOOLONG;
                }
            } while (tail != -1 && tail - head < msgUplink::mlen);
        }
    } while (head != -1);

    if (head == -1) {
        // TODO: log buffer and input
        head = input.indexOf(msg_header, head);
        if (input.at(head + msgUplink::mlen) == msg_tailer) {
            msg *m = new msg();
            *m << input.mid(head, msgUplink::mlen);
            msg::unknownmsglist << m;
            return VAL_USEINPUT;
        }
    }

    return VAL_FAILED;

    /*
    if (idProto.contains(input.at(1).unicode()))
    {
        proto p = idProto[input.at(1).unicode()];

        int length = protoLength[p];

        if (input.length() == length)
        {
            return VAL_PASS;
        }
        else if (input.length() < length)
        {
            return VAL_TOOSHORT;
        }
        else // input.length() > length
        {
            return VAL_TOOLONG;
        }
    }
    else {
        return VAL_INVALIDID;
    }
    */
}

msgUplink::msgUplink(QObject *parent) : msg(parent)
{
    return;
}

msgDownlink::msgDownlink(QObject *parent) : msg(parent)
{
    return;
}

msgFreq::msgFreq(QObject *parent) : msgUplink(parent)
{
    return;
}

msgDist::msgDist(QObject *parent) : msgUplink(parent)
{
    return;
}

msgAmp::msgAmp(QObject *parent) : msgUplink(parent)
{
    return;
}

msgQuery::msgQuery(QObject *parent) : msgDownlink(parent)
{
    return;
}

void msgQuery::createQuery()
{
    this->identify = 0x00;
    this->instruction = 0x01;
    this->deviceId = 0;
    this->serialId = 0;
    return;
}

protocol::protocol(QObject *parent) : QObject(parent)
{
    return;
}

void protocol::createQueryMsg(serial &s)
{
    protocol *p = new protocol();
    protocol::protocollist << p;

    msgQuery *q = new msgQuery(new msgDownlink());
    p->downlink = q;
    q->createQuery();
    s << *q;
}

const protocol &operator>> (const protocol &p, serial &s)
{
    s << *p.downlink;
    return p;
}

protocol &operator<< (protocol &p, const serial &s)
{
    s >> *p.uplink;
    return p;
}

const msg &operator>> (const msg &m, QByteArray &data)
{
    return m;
}

msg &operator<< (msg &m, const QByteArray &data)
{
    m.time = QDateTime::currentDateTime();
    m.origin = data;

    msgUplink *u = new msgUplink(&m);
    *u << data;

    switch (msg::idProto[m.deviceId]) {
    case msg::PROTO_FREQ: {
        msgFreq *m = new msgFreq(u);
        *m << data;
    } break;

    case msg::PROTO_DIST: {
        msgDist *m = new msgDist(u);
        *m << data;
    } break;

    case msg::PROTO_AMP: {
        msgAmp *m = new msgAmp(u);
        *m << data;
    } break;

    default:
        qDebug() << "unknown device id";
        break;
    }

    return m;
}

msgUplink &operator<< (msgUplink &m, const QByteArray &data)
{
    QDataStream(data.mid(msgUplink::posDevice, 1)) >> m.deviceId;
    return m;
}

msgFreq &operator<< (msgFreq &m, const QByteArray &data)
{
    if (data.length() != msgUplink::mlen)
    {
        qDebug() << "Mulformed message";
        return m;
    }
    qDebug() << "Got Msg Freq" << m.deviceId << m.origin;

    QDataStream(data) >> m.holder8 /* header */ >> m.atten >> m.voltage
                      >> m.current >> m.output_stat >> m.input_stat >> m.lock_a1
                      >> m.lock_a2 >> m.lock_b1 >> m.lock_b2 >> m.ref_10_1
                      >> m.ref_10_2 >> m.ref_3 >> m.ref_4 >> m.holder8 /* device */
                      >> m.handshake >> m.serialId >> m.holder8 >> m.holder8 /* tailer */;
    m.origin = data;
    device::updateDevice(m);
    return m;
}

msgDist &operator<< (msgDist &m, const QByteArray &data)
{
    if (data.length() != msgUplink::mlen)
    {
        qDebug() << "Mulformed message";
        return m;
    }
    qDebug() << "Got Msg Dist" << m.deviceId << m.origin;

    QDataStream(data) >> m.holder8 /* header */ >> m.ref_10 >> m.ref_16 >> m.voltage
                      >> m.current >> m.power >> m.holder8 >> m.holder8 /* device */
                      >> m.holder8 >> m.holder8 >> m.holder8 >> m.holder8
                      >> m.holder8 >> m.holder8 >> m.serialId >> m.holder8 >> m.holder8
                      >> m.holder8 >> m.holder8 /* tailer */;
    m.origin = data;
    device::updateDevice(m);
    return m;
}

msgAmp &operator<< (msgAmp &m, const QByteArray &data)
{
    if (data.length() != msgUplink::mlen)
    {
        qDebug() << "Mulformed message";
        return m;
    }
    qDebug() << "Got Msg Amp" << m.deviceId << m.origin;

    QDataStream(data) >> m.holder8 /* header */ >> m.power >> m.gain >> m.atten
                      >> m.loss >> m.temp >> m.stat >> m.load_temp
                      >> m.holder8 /* device */ >> m.holder8 >> m.serialId
                      >> m.handshake >> m.holder8 /* tailer */;
    m.origin = data;
    device::updateDevice(m);
    return m;
}

const msgQuery &operator>> (const msgQuery &m, QByteArray &data)
{
    QDataStream(&data, QIODevice::WriteOnly) << m.head << m.identify << m.instruction
                                             << m.deviceId << m.serialId << m.tail;
    return m;
}

const msgCntlFreq &operator>> (const msgCntlFreq &m, QByteArray &data)
{
    QDataStream(&data, QIODevice::WriteOnly) << m.head << m.atten << m.ref_10_a << m.ref_10_b
                                             << m.holder8 << m.deviceId << m.serialId << m.holder8
                                             << m.holder8 << m.tail;
    return m;
}

const msgCntlDist &operator>> (const msgCntlDist &m, QByteArray &data)
{
    QDataStream(&data, QIODevice::WriteOnly) << m.head << m.ref_10 << m.ref_16 << m.deviceId
                                             << m.serialId << m.holder8 << m.holder8 << m.holder8
                                             << m.holder8 << m.tail;
    return m;
}

const msgCntlAmp &operator>> (const msgCntlAmp &m, QByteArray &data)
{
    QDataStream(&data, QIODevice::WriteOnly) << m.head << m.atten_mode << m.atten << m.power
                                             << m.gain << m.deviceId << m.serialId << m.tail;
    return m;
}
