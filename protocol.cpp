#include "protocol.h"

msg::msg(QObject *parent) : QObject(parent)
{

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
