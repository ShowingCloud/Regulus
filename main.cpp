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

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QTranslator translator;
    translator.load(":/i18n/zh_CN");
    app.installTranslator(&translator);

    qmlRegisterType<devFreq>("rdss.device", 1, 0, "DevFreq");
    qmlRegisterType<devDist>("rdss.device", 1, 0, "DevDist");
    qmlRegisterType<devAmp>("rdss.device", 1, 0, "DevAmp");

    qmlRegisterSingletonType<alert>("rdss.alert", 1, 0, "Alert", [](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject * {
        Q_UNUSED(engine)
        Q_UNUSED(scriptEngine)

        alert *ret = new alert();
        return ret;
    });

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    database db(&app);

    QTimer *searchSerialTimer = new QTimer(&app);
    QObject::connect(searchSerialTimer, &QTimer::timeout, [&]() {
        for (const QSerialPortInfo &serialportinfo : QSerialPortInfo::availablePorts())
        {
            for (serial *inlist : qAsConst(serial::serialList))
                if (inlist->has(serialportinfo))
                    return;

            serial *s = new serial(serialportinfo);
            serial::serialList << s;

            QTimer *timer = new QTimer(&app);
            QObject::connect(timer, &QTimer::timeout, [=]() {
                protocol::createQueryMsg(*s);
#ifdef QT_DEBUG
                s->readFakeData();
#endif
                timer->start(1000);
            });
            timer->start(0);
        }
        searchSerialTimer->start(10000);
        qDebug() << "Serial List: " << serial::serialList;
    });
    searchSerialTimer->start(0);

    return app.exec();
}
