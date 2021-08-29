#include "protocol.h"
#include "serial.h"

msg::msg(QObject *parent) : QObject(parent)
{
    return;
}

msg::msg(QObject *parent, QString input) : QObject(parent)
{
    return;
}

msg &msg::operator= (QString input)
{
}

msg::validateResult msg::validateProtocol(const QString input)
{
    if (idProto.contains(input.at(1).unicode()))
    {
        proto p = idProto[input.at(1).unicode()];

        /* int length = protoLength[p];

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
        } */
    }
    else {
        return VAL_INVALIDID;
    }
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
    return *this;
}
