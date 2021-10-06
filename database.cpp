#include "database.h"

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

database &operator<< (database &db, const alert &alert)
{
    return db;
}

database &operator<< (database &db, const msgCntlAmp &msg)
{
    return db;
}

database &operator<< (database &db, const msgCntlFreq &msg)
{
    return db;
}

database &operator<< (database &db, const msgCntlDist &msg)
{
    return db;
}

//msgDist &operator<< (msgDist &m, const QByteArray &data)
//{
//    if (data.length() != msgUplink::mlen)
//    {
//        qDebug() << "Mulformed message";
//        return m;
//    }
//    qDebug() << "Got Msg Dist" << m.deviceId << m.origin;
//
//    QDataStream(data) >> m.holder8 /* header */ >> m.ref_10 >> m.ref_16 >> m.voltage
//                      >> m.current >> m.lock_10_1 >> m.lock_10_2 >> m.serialId
//                      >> m.lock_16_1 >> m.lock_16_2 >> m.holder8 >> m.holder8
//                      >> m.holder8 >> m.holder8 >> m.holder8 /* device */ >> m.holder8 >> m.holder8
//                      >> m.holder8 >> m.holder8 /* tailer */;
//
//    device::updateDevice(m);
//    return m;
//}
//
//msgAmp &operator<< (msgAmp &m, const QByteArray &data)
//{
//    if (data.length() != msgUplink::mlen)
//    {
//        qDebug() << "Mulformed message";
//        return m;
//    }
//    qDebug() << "Got Msg Amp" << m.deviceId << m.origin;
//
//    QDataStream(data) >> m.holder8 /* header */ >> m.power >> m.gain >> m.atten
//                      >> m.loss >> m.temp >> m.stat >> m.load_temp
//                      >> m.holder8 /* device */ >> m.holder8 >> m.serialId
//                      >> m.handshake >> m.holder8 /* tailer */;
//    m.stat_stand_wave = (m.stat & 0x10) >> 4;
//    m.stat_temp = (m.stat & 0x08) >> 3;
//    m.stat_current = (m.stat & 0x04) >> 2;
//    m.stat_voltage = (m.stat & 0x02) >> 1;
//    m.stat_power = m.stat & 0x01;
//
//    device::updateDevice(m);
//    return m;
//}
//
//const msgQuery &operator>> (const msgQuery &m, QByteArray &data)
//{
//    QDataStream(&data, QIODevice::WriteOnly) << m.head << m.identify << m.instruction
//                                             << m.deviceId << m.serialId << m.tail;
//    return m;
//}
//
//const msgCntlFreq &operator>> (const msgCntlFreq &m, QByteArray &data)
//{
//    QDataStream(&data, QIODevice::WriteOnly) << m.head << m.atten << m.ref_10_a << m.ref_10_b
//                                             << m.holder8 << m.deviceId << m.serialId << m.holder8
//                                             << m.holder8 << m.tail;
//    return m;
//}
//
//const msgCntlDist &operator>> (const msgCntlDist &m, QByteArray &data)
//{
//    QDataStream(&data, QIODevice::WriteOnly) << m.head << m.ref_10 << m.ref_16 << m.deviceId
//                                             << m.serialId << m.holder8 << m.holder8 << m.holder8
//                                             << m.holder8 << m.tail;
//    return m;
//}
//
//const msgCntlAmp &operator>> (const msgCntlAmp &m, QByteArray &data)
//{
//    QDataStream(&data, QIODevice::WriteOnly) << m.head << m.atten_mode << m.atten << m.power
//                                             << m.gain << m.deviceId << m.serialId << m.tail;
//    return m;
//}
