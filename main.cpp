#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QTranslator>
#include <QSerialPortInfo>
#include <QTimer>
//#include <iostream>

#include "database.h"
#include "serial.h"
#include "protocol.h"
#include "device.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QTranslator translator;
    translator.load(":/zh_CN");
    app.installTranslator(&translator);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    database db(&app);

    QList<serial *> seriallist;
    for (const QSerialPortInfo &serialportinfo : QSerialPortInfo::availablePorts())
    {
        serial *s = new serial(serialportinfo);
        seriallist << s;

        QTimer *timer = new QTimer(&app);
        QObject::connect(timer, &QTimer::timeout, [=]() {
            protocol::createDownMsg(*s);
        });
        timer->start(1000);
    }

    return app.exec();
}
