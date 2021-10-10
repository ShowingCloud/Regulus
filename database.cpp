#include "database.h"
#include "alert.h"
#include "protocol.h"

#include <QtDebug>

database::database(QObject *parent) : QObject(parent)
{
    if (QSqlDatabase::contains("qt_sql_default_connection")) {
        db = QSqlDatabase::database("qt_sql_default_connection");
    } else {
        db = QSqlDatabase::addDatabase("QSQLITE");
        db.setDatabaseName(database::filename);
        db.setUserName(database::username);
        db.setPassword(database::password);
    }

    if (!db.open()) {
        qDebug() << "Error: Failed to connect db." << db.lastError();
    }

    dbModel = new QSqlTableModel(this, db);
    dbQuery = new QSqlQuery(db);

    createTable();
}

database::~database()
{
    db.close();
    qDebug() << "Database closed.";
}

bool database::createTable()
{
    for (const DB_TBL table : DB_TBL_ALL) {
        QString q = "CREATE TABLE IF NOT EXISTS ";
        q += DB_TABLES[table] + " (";

        for (const QStringList column : DB_COLUMNS[table]) {
            q += column.join(" ") + ", ";
        }
        q.replace(q.length() - 2, 1, ")");
        dbQuery->prepare(q);
        if(!dbQuery->exec())
            qDebug() << dbQuery->lastError();


        for (const QString column : DB_INDEXES[table]) {
            dbQuery->prepare("CREATE INDEX IF NOT EXISTS " + DB_TABLES[table] + "_" + column
                    + " ON " + DB_TABLES[table] + "(" + column + ")");
            if(!dbQuery->exec())
                qDebug() << dbQuery->lastError();
        }
    }
    return true;
}


database &operator<< (database &db, const msgFreq &msg)
{
    db.dbModel->setTable(db.DB_TABLES[db.DB_TBL_FREQ_DATA]);
    QSqlRecord r = db.dbModel->record();
    r.setValue("Device", msg.deviceId);
    r.setValue("Time", msg.time);
    r.setValue("Attenuation", msg.atten);
    r.setValue("Voltage", msg.voltage);
    r.setValue("Current", msg.current);
    r.setValue("Radio_Stat", msg.radio_stat);
    r.setValue("Mid_Stat", msg.mid_stat);
    r.setValue("Lock_A1", msg.lock_a1);
    r.setValue("Lock_A2", msg.lock_a2);
    r.setValue("Lock_B1", msg.lock_b1);
    r.setValue("Lock_B2", msg.lock_b2);
    r.setValue("Ref10_1", msg.ref_10_1);
    r.setValue("Ref10_2", msg.ref_10_2);
    r.setValue("Ref10_Inner_1", msg.ref_inner_1);
    r.setValue("Ref10_3", msg.ref_10_3);
    r.setValue("Ref10_4", msg.ref_10_4);
    r.setValue("Ref10_Inner_2", msg.ref_inner_2);
    r.setValue("Handshake", msg.handshake);
    r.setValue("Serial_Id", msg.serialId);
    r.setValue("Master_Slave", msg.handshake);
    if (!db.dbModel->insertRecord(-1, r))
        qDebug() << db.dbModel->lastError();

    return db;
}

database &operator<< (database &db, const msgDist &msg)
{
    db.dbModel->setTable(db.DB_TABLES[db.DB_TBL_DIST_DATA]);
    QSqlRecord r = db.dbModel->record();
    r.setValue("Device", msg.deviceId);
    r.setValue("Time", msg.time);
    r.setValue("Ref10", msg.ref_10);
    r.setValue("Ref16", msg.ref_16);
    r.setValue("Voltage", msg.voltage);
    r.setValue("Current", msg.current);
    r.setValue("Lock10_1", msg.lock_10_1);
    r.setValue("Lock10_2", msg.lock_10_2);
    r.setValue("Lock16_1", msg.lock_16_1);
    r.setValue("Lock16_2", msg.lock_16_2);
    r.setValue("Serial_Id", msg.serialId);
    if (!db.dbModel->insertRecord(-1, r))
        qDebug() << db.dbModel->lastError();

    return db;
}

database &operator<< (database &db, const msgAmp &msg)
{
    db.dbModel->setTable(db.DB_TABLES[db.DB_TBL_AMP_DATA]);
    QSqlRecord r = db.dbModel->record();
    r.setValue("Device", msg.deviceId);
    r.setValue("Time", msg.time);
    r.setValue("Power", msg.power);
    r.setValue("Gain", msg.gain);
    r.setValue("Attenuation", msg.atten);
    r.setValue("Loss", msg.loss);
    r.setValue("Temperature", msg.temp);
    r.setValue("Stat_Stand_Wave", msg.stat_stand_wave);
    r.setValue("Stat_Temperature", msg.stat_temp);
    r.setValue("Stat_Current", msg.stat_current);
    r.setValue("Stat_Voltage", msg.stat_voltage);
    r.setValue("Stat_Power", msg.stat_power);
    r.setValue("Load_Temperature", msg.load_temp);
    r.setValue("Serial_Id", msg.serialId);
    r.setValue("Handshake", msg.handshake);
    if (!db.dbModel->insertRecord(-1, r))
        qDebug() << db.dbModel->lastError();

    return db;
}

database &operator<< (database &db, const msgCntlFreq &msg)
{
    db.dbModel->setTable(db.DB_TABLES[db.DB_TBL_FREQ_OPER]);
    QSqlRecord r = db.dbModel->record();
    r.setValue("Device", msg.deviceId);
    r.setValue("Time", msg.time);
    r.setValue("Attenuation", msg.atten);
    r.setValue("Ref10_A", msg.ref_10_a);
    r.setValue("Ref10_B", msg.ref_10_b);
    r.setValue("Serial_Id", msg.serialId);
    if (!db.dbModel->insertRecord(-1, r))
        qDebug() << db.dbModel->lastError();

    return db;
}

database &operator<< (database &db, const msgCntlDist &msg)
{
    db.dbModel->setTable(db.DB_TABLES[db.DB_TBL_DIST_OPER]);
    QSqlRecord r = db.dbModel->record();
    r.setValue("Device", msg.deviceId);
    r.setValue("Time", msg.time);
    r.setValue("Ref10", msg.ref_10);
    r.setValue("Ref16", msg.ref_16);
    r.setValue("Serial_Id", msg.serialId);
    if (!db.dbModel->insertRecord(-1, r))
        qDebug() << db.dbModel->lastError();

    return db;
}

database &operator<< (database &db, const msgCntlAmp &msg)
{
    db.dbModel->setTable(db.DB_TABLES[db.DB_TBL_AMP_OPER]);
    QSqlRecord r = db.dbModel->record();
    r.setValue("Device", msg.deviceId);
    r.setValue("Time", msg.time);
    r.setValue("Attenuation_Mode", msg.atten);
    r.setValue("Power", msg.power);
    r.setValue("Gain", msg.gain);
    r.setValue("Serial_Id", msg.serialId);
    if (!db.dbModel->insertRecord(-1, r))
        qDebug() << db.dbModel->lastError();

    return db;
}

bool database::setAlert(const database::DB_TBL dbTable, const int device, const int type,
                  const QString field, const QVariant value, const QVariant normal_value)
{
    dbModel->setTable(DB_TABLES[dbTable]);
    QSqlRecord r = dbModel->record();
    r.setValue("Device", device);
    r.setValue("Time", QDateTime::currentDateTime());
    r.setValue("Type", type);
    r.setValue("Field", field);
    r.setValue("Value", value);
    r.setValue("Normal_Value", normal_value);
    r.setValue("Emergence", (type != alert::P_ALERT_GOOD));
    if (!dbModel->insertRecord(-1, r))
        qDebug() << dbModel->lastError();

    return true;
}

bool database::setAlert(const int type, const QString text, const int device)
{
    dbModel->setTable(DB_TABLES[DB_TBL_MSG_ALERT]);
    QSqlRecord r = dbModel->record();
    r.setValue("Device", device);
    r.setValue("Time", QDateTime::currentDateTime());
    r.setValue("Type", type);
    r.setValue("Alert", text);
    r.setValue("Emergence", (type != alert::P_ALERT_GOOD));
    if (!dbModel->insertRecord(-1, r))
        qDebug() << dbModel->lastError();

    return true;
}

const database &operator>> (const database &db, QList<QStringList> &str)
{
    db.dbModel->setTable(db.setDBTable);
    db.dbModel->setFilter("Device=" + QString::number(db.setDeviceId));
    db.dbModel->setSort(1, Qt::AscendingOrder);
    db.dbModel->select();

    for (int i = 0; i < 10; ++i) {
        QSqlRecord r = db.dbModel->record(i);
        QStringList s = {
            device::name(r.value("device").toInt()) + "#" + QString::number(r.value("device").toInt()),

            r.value("Time").toDateTime().toString(Qt::ISODate),

            (static_cast<alert::P_ALERT>(r.value("Type").toInt() == alert::P_ALERT_TIMEOUT_NOFIELD
                or static_cast<alert::P_ALERT>(r.value("Type").toInt() == alert::P_ALERT_OTHERS_NOFIELD))
                ? ""
                : r.value("Field").toString()),

            [=](){
                const auto getAlertStr = [](const alert::P_ALERT type, const int n) {
                    return QObject::tr(alert::STR_ALERT[type][n].toUtf8()); };

                alert::P_ALERT type = static_cast<alert::P_ALERT>(r.value("Type").toInt());
                switch (type)
                {
                case alert::P_ALERT_GOOD:
                    return (QObject::tr("Restored normal") + (", ") + getAlertStr(type, 0)
                        + QObject::tr(": ") + r.value("Value").toString());
                case alert::P_ALERT_LOWER:
                case alert::P_ALERT_UPPER:
                case alert::P_ALERT_BAD:
                    return getAlertStr(type, 0) + ", " + getAlertStr(type, 1) + ": " + r.value("Value").toString();
                case alert::P_ALERT_TIMEOUT:
                case alert::P_ALERT_TIMEOUT_NOFIELD:
                    return getAlertStr(type, 0) + ", " + getAlertStr(type, 1) + ": "
                        + (r.value("Value").toInt() == -1 ? getAlertStr(type, 2) : getAlertStr(type, 3));
                case alert::P_ALERT_OTHERS:
                case alert::P_ALERT_OTHERS_NOFIELD:
                case alert::P_ALERT_NODATA:
                    return getAlertStr(type, 0);
                }

                return QObject::tr("No content");
            }()};

        str << s;
    }

    return db;
}
