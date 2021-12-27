#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QTranslator>
#include <QSerialPortInfo>
#include <QTimer>
#include <QDebug>

#include "database.h"
#include "serial.h"
#include "protocol.h"
#include "device.h"

database *globalDB;

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QTranslator translator;
    translator.load(":/i18n/zh_CN");
    app.installTranslator(&translator);

    globalDB = new database();

    qmlRegisterType<devFreq>("rdss.device", 1, 0, "DevFreq");
    qmlRegisterType<devDist>("rdss.device", 1, 0, "DevDist");
    qmlRegisterType<devAmp>("rdss.device", 1, 0, "DevAmp");
    qmlRegisterType<devNet>("rdss.device", 1, 0, "DevNet");

    qmlRegisterSingletonType<alert>("rdss.alert", 1, 0, "Alert", [](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject * {
        Q_UNUSED(engine)
        Q_UNUSED(scriptEngine)
        return new alert();
    });
    qmlRegisterSingletonType<alertRecordModel>("rdss.alert", 1, 0, "AlertRecordModel", [](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject * {
        Q_UNUSED(engine)
        Q_UNUSED(scriptEngine)
        return new alertRecordModel();
    });

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    QTimer *searchSerialTimer = new QTimer(&app);
    QObject::connect(searchSerialTimer, &QTimer::timeout, &app, [&]() {
        searchSerialTimer->start(30000);
        qInfo() << "Traversing serial ports";

        for (const auto &serialportinfo : QSerialPortInfo::availablePorts())
            [&]() {
                for (serial *inlist : qAsConst(serial::serialList))
                    if (inlist->has(serialportinfo))
                        return;

                serial *s = new serial(serialportinfo);
                serial::serialList << s;
                qInfo() << "Serial List: " << serial::serialList;
            }();
    });
    searchSerialTimer->start(0);

    QTimer *timer = new QTimer(&app);
    QObject::connect(timer, &QTimer::timeout, [=]() {
        timer->start(1000);

        for (serial *s : qAsConst(serial::serialList))
            protocol::createQueryMsg(*s);
#ifdef QT_DEBUG
        serial::readFakeData();
#endif
    });
    timer->start(0);

    int ret = app.exec();
    for (serial *s : qAsConst(serial::serialList))
        delete s;
    timer->deleteLater();
    searchSerialTimer->deleteLater();
    delete globalDB;
    return ret;
}
