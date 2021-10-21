#include <QDebug>
#include <iso646.h>

#include "protocol.h"
#include "serial.h"
#include "device.h"
#include "database.h"

msg::validateResult msg::validateProtocol(QByteArray &buffer, const QByteArray &input, serial *s)
{
    int head = 0, tail = 0;
    const char msg_header = static_cast<char>(msg::header), msg_tailer = static_cast<char>(msg::tailer);
    do {
        head = buffer.indexOf(msg_header, head);
        if (buffer.length() >= head + msgUplink::mlen and buffer.at(head + msgUplink::mlen - 1) == msg_tailer) {
            msg *m = new msg();
            m->serialport = s;
            if (buffer.length() == msgUplink::mlen) {
                *m << buffer;
                msg::unknownmsgList << m;
                buffer = QByteArray();
                return VAL_PASS;
            } else {
                *m << buffer.mid(head, msgUplink::mlen);
                msg::unknownmsgList << m;
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
            } while (tail != -1 and tail - head < msgUplink::mlen);
        }
    } while (head != -1);

    if (head == -1) {
        // TODO: log buffer and input
        head = input.indexOf(msg_header, head);
        if (input.at(head + msgUplink::mlen) == msg_tailer) {
            msg *m = new msg();
            m->serialport = s;
            *m << input.mid(head, msgUplink::mlen);
            msg::unknownmsgList << m;
            return VAL_USEINPUT;
        }
    }

    return VAL_FAILED;
}

void protocol::createQueryMsg(serial &s)
{
    protocol *p = new protocol();
    protocol::protocolList << p;

    msgQuery *q = new msgQuery();
    p->downlink = q;
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
    Q_UNUSED(data)
    qDebug() << "!!! nothing processed";
    return m;
}

msg &operator<< (msg &m, const QByteArray &data)
{
    m.time = QDateTime::currentDateTime();
    m.origin = data;

    msgUplink u = msgUplink(m);
    u << data;

    switch (msg::idProto[u.deviceId]) {
    case msg::PROTO_FREQ: {
        msgFreq *s = new msgFreq(u);
        *s << data;
        return *s;
    } case msg::PROTO_DIST: {
        msgDist *s = new msgDist(u);
        *s << data;
        return *s;
    } case msg::PROTO_AMP: {
        msgAmp *s = new msgAmp(u);
        *s << data;
        return *s;
    } default:
        qDebug() << "unknown device id";
        return *new msgUplink(m);
    }
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
    qInfo() << "Got Msg Freq" << m.deviceId << m.origin;

    QDataStream(data) >> m.holder8 /* header */ >> m.atten >> m.voltage
                      >> m.current >> m.radio_stat >> m.mid_stat >> m.lock_a1
                      >> m.lock_a2 >> m.lock_b1 >> m.lock_b2 >> m.ref_10_1
                      >> m.ref_2 >> m.ref_10_3 >> m.ref_4 >> m.holder8 /* device */
                      >> m.handshake >> m.serialId >> m.masterslave >> m.holder8 /* tailer */;
    m.ref_10_2 = m.ref_2 & 0x0F;
    m.ref_inner_1 = (m.ref_2 & 0xF0) >> 4;
    m.ref_10_4 = m.ref_4 & 0x0F;
    m.ref_inner_2 = (m.ref_4 & 0xF0) >> 4;

    device::updateDevice(m);
    *globalDB << m;
    return m;
}

msgDist &operator<< (msgDist &m, const QByteArray &data)
{
    if (data.length() != msgUplink::mlen)
    {
        qDebug() << "Mulformed message";
        return m;
    }
    qInfo() << "Got Msg Dist" << m.deviceId << m.origin;

    QDataStream(data) >> m.holder8 /* header */ >> m.ref_10 >> m.ref_16 >> m.voltage
                      >> m.current >> m.lock_10_1 >> m.lock_10_2 >> m.serialId
                      >> m.lock_16_1 >> m.lock_16_2 >> m.holder8 >> m.holder8
                      >> m.holder8 >> m.holder8 >> m.holder8 /* device */ >> m.holder8 >> m.holder8
                      >> m.holder8 >> m.holder8 /* tailer */;

    device::updateDevice(m);
    *globalDB << m;
    return m;
}

msgAmp &operator<< (msgAmp &m, const QByteArray &data)
{
    if (data.length() != msgUplink::mlen)
    {
        qDebug() << "Mulformed message";
        return m;
    }
    qInfo() << "Got Msg Amp" << m.deviceId << m.origin;

    QDataStream(data) >> m.holder8 /* header */ >> m.power >> m.gain >> m.atten
                      >> m.loss >> m.temp >> m.stat >> m.load_temp
                      >> m.holder8 /* device */ >> m.holder8 >> m.serialId
                      >> m.handshake >> m.holder8 /* tailer */;
    m.stat_stand_wave = (m.stat & 0x10) >> 4;
    m.stat_temp = (m.stat & 0x08) >> 3;
    m.stat_current = (m.stat & 0x04) >> 2;
    m.stat_voltage = (m.stat & 0x02) >> 1;
    m.stat_power = m.stat & 0x01;

    device::updateDevice(m);
    *globalDB << m;
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
    msgCntlFreq msg = m;
    msg.time = QDateTime::currentDateTime();
    *globalDB << msg;
    return m;
}

const msgCntlDist &operator>> (const msgCntlDist &m, QByteArray &data)
{
    QDataStream(&data, QIODevice::WriteOnly) << m.head << m.ref_10 << m.ref_16 << m.deviceId
                                             << m.serialId << m.holder8 << m.holder8 << m.holder8
                                             << m.holder8 << m.tail;
    msgCntlDist msg = m;
    msg.time = QDateTime::currentDateTime();
    *globalDB << m;
    return m;
}

const msgCntlAmp &operator>> (const msgCntlAmp &m, QByteArray &data)
{
    QDataStream(&data, QIODevice::WriteOnly) << m.head << m.atten_mode << m.atten << m.power
                                             << m.gain << m.deviceId << m.serialId << m.tail;
    msgCntlAmp msg = m;
    msg.time = QDateTime::currentDateTime();
    *globalDB << m;
    return m;
}
