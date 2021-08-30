#include "protocol.h"
#include "serial.h"

msg::msg(QObject *parent) : QObject(parent)
{
    return;
}

msg &msg::operator= (const QByteArray input)
{
    *this << input;
    msgUplink *u = static_cast<msgUplink *>(this);
    *u << input;
    switch (idProto[this->device]) {
    case PROTO_FREQ: {
        msgFreq *m = static_cast<msgFreq *>(this);
        *m << input;
        break;
    } case PROTO_DIST: {
        msgDist *m = static_cast<msgDist *>(this);
        *m << input;
        break;
    } case PROTO_AMP: {
        msgAmp *m = static_cast<msgAmp *>(this);
        *m << input;
        break;
    } default:
        break;
    }

    return *u;
}

msg::validateResult msg::validateProtocol(QByteArray buffer, const QByteArray input)
{
    int head = 0, tail = 0;
    do {
        head = buffer.indexOf(static_cast<char>(msg::header), head);
        if (buffer.at(head + msgUplink::mlen) == static_cast<char>(msg::tailer)) {
            if (buffer.length() == msgUplink::mlen) {
                msg *m = new msg();
                *m << buffer;
                buffer = "";
                return VAL_PASS;
            } else {
                msg *m = new msg();
                *m << buffer.mid(head, msgUplink::mlen);
                buffer.remove(head, msgUplink::mlen);
                return VAL_REMAINS;
            }
        } else {
            tail = head + 1;
            do {
                tail = buffer.indexOf(static_cast<char>(msg::tailer), tail);
            } while (tail != -1 and tail - head < msgUplink::mlen);
        }
    } while (head != -1);

    if (head == -1) {
        return VAL_USEINPUT;
    }
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

protocol::protocol(QObject *parent) : QObject(parent)
{
    return;
}

void protocol::createDownMsg(serial &s)
{
    protocol *p = new protocol();
    protocol::protocollist << p;
    *p >> s;
}

const protocol &protocol::operator>> (serial &s) const
{
    s << this->downlink;
    return *this;
}

protocol &protocol::operator<< (const serial &s)
{
    s >> this->uplink;
    return *this;
}

const msg &msg::operator>> (QByteArray &data) const
{
    return *this;
}

msg &msg::operator<< (const QByteArray &data)
{
    this->time = QDateTime::currentDateTime();
    return *this;
}

msgUplink &msgUplink::operator<< (const QByteArray &data)
{
    this->device = static_cast<uint8_t>(data.at(msgUplink::posDevice));
    this->serial = static_cast<uint8_t>(data.at(msgUplink::posSerial));
    return *this;
}

msgFreq &msgFreq::operator<< (const QByteArray &data)
{
    return *this;
}

msgDist &msgDist::operator<< (const QByteArray &data)
{
    return *this;
}

msgAmp &msgAmp::operator<< (const QByteArray &data)
{
    return *this;
}
