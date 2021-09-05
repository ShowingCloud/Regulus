#include "protocol.h"
#include "serial.h"

msg::msg(QObject *parent) : QObject(parent)
{
    return;
}

msg &msg::operator= (const QByteArray input)
{
    *this << input;
    *static_cast<msgUplink *>(this) << input;

    switch (idProto[this->device]) {
    case PROTO_FREQ:
        *static_cast<msgFreq *>(this) << input;
        break;
    case PROTO_DIST:
        *static_cast<msgDist *>(this) << input;
        break;
    case PROTO_AMP:
        *static_cast<msgAmp *>(this) << input;
        break;
    default:
        break;
    }

    return *this;
}

msg::validateResult msg::validateProtocol(QByteArray buffer, const QByteArray input)
{
    int head = 0, tail = 0;
    const char msg_header = static_cast<char>(msg::header), msg_tailer = static_cast<char>(msg::tailer);
    do {
        head = buffer.indexOf(msg_header, head);
        if (buffer.at(head + msgUplink::mlen) == msg_tailer) {
            msg *m = new msg();
            if (buffer.length() == msgUplink::mlen) {
                *m << buffer;
                buffer = "";
                return VAL_PASS;
            } else {
                *m << buffer.mid(head, msgUplink::mlen);
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
    QDataStream(data.mid(msgUplink::posDevice, 1)) >> this->device;
    return *this;
}

msgFreq &msgFreq::operator<< (const QByteArray &data)
{
    if (data.length() != msgUplink::mlen)
        return *this;

    QDataStream(data) >> this->holder8 /* header */ >> this->atten >> this->voltage
                      >> this->current >> this->output_stat >> this->input_stat >> this->lock_a1
                      >> this->lock_a2 >> this->lock_b1 >> this->lock_b2 >> this->ref_10_1
                      >> this->ref_10_2 >> this->ref_3 >> this->ref_4 >> this->holder8 /* device */
                      >> this->handshake >> this->serial >> this->holder8 >> this->holder8 /* tailer */;
    return *this;
}

msgDist &msgDist::operator<< (const QByteArray &data)
{
    if (data.length() != msgUplink::mlen)
        return *this;

    QDataStream(data) >> this->holder8 /* header */ >> this->ref_10 >> this->ref_16 >> this->voltage
                      >> this->current >> this->power >> this->holder8 >> this->holder8 /* device */
                      >> this->holder8 >> this->holder8 >> this->holder8 >> this->holder8
                      >> this->holder8 >> this->holder8 >> this->serial >> this->holder8 >> this->holder8
                      >> this->holder8 >> this->holder8 /* tailer */;
    return *this;
}

msgAmp &msgAmp::operator<< (const QByteArray &data)
{
    if (data.length() != msgUplink::mlen)
        return *this;

    QDataStream(data) >> this->holder8 /* header */ >> this->power >> this->gain >> this->atten
                      >> this->loss >> this->temp >> this->stat >> this->load_temp
                      >> this->holder8 /* device */ >> this->holder8 >> this->serial
                      >> this->handshake >> this->holder8 /* tailer */;
    return *this;
}
