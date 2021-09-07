#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QTranslator>
#include <QSerialPortInfo>
#include <QTimer>
//#include <iostream>
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
    translator.load(":/zh_CN");
    app.installTranslator(&translator);

    qmlRegisterType<devFreq>("rdss.device", 1, 0, "DevFreq");
    qmlRegisterType<devDist>("rdss.device", 1, 0, "DevDist");
    qmlRegisterType<devAmp>("rdss.device", 1, 0, "DevAmp");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    //QQmlComponent componentMain(&engine, QUrl(QStringLiteral("qrc:/main.qml")));
    //QQuickWindow *winMain = qobject_cast<QQuickWindow *>(componentMain.create());

    //QQmlComponent componentFreq(&engine, QUrl(QStringLiteral("qrc:/freq.qml")));
    //QQuickWindow *winFreq = qobject_cast<QQuickWindow *>(componentFreq.create());
    //winFreq->hide();

    //QList<devFreq *> devFreqList = QList<devFreq *>();
    //QList<devDist *> devDistList = QList<devDist *>();
    //QList<devAmp *> devAmpList = QList<devAmp *>();

    database db(&app);

    QList<serial *> serialList;
    for (const QSerialPortInfo &serialportinfo : QSerialPortInfo::availablePorts())
    {
        serial *s = new serial(serialportinfo);
        serialList << s;

        QTimer *timer = new QTimer(&app);
        QObject::connect(timer, &QTimer::timeout, [=]() {
            protocol::createQueryMsg(*s);
            //s->readFakeData();
        });
        timer->start(1000);
    }
    qDebug() << "Serial List: " << serialList;

    return app.exec();
}
