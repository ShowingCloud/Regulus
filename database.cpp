#include "database.h"
#include "alert.h"
#include "protocol.h"
#include "device.h"

#include <QtDebug>

database::database(QObject *parent) : QObject(parent)
{
    prepareHistory();

    QTimer *timer = new QTimer(this);
    connect(timer, &QTimer::timeout, [=]() {
        if (QDate::currentDate() != date) {
            prepareHistory();
        }
    });
    timer->start(60000);

    preparePref();
}

database::~database()
{
    historyDb.close();
    qDebug() << "Database closed.";
    logstream.flush();
    logfile.close();
}

bool database::prepareHistory()
{
    QDir::current().mkdir(historyPath);

    if (not QSqlDatabase::contains("qt_sql_default_connection"))
        historyDb = QSqlDatabase::addDatabase("QSQLITE", "history.db");

    if (historyDb.isOpen()) historyDb.close();
    historyDb.setDatabaseName(database::dbFilenames());
    if (not historyDb.open()) {
        qDebug() << "Error: Failed to connect history db." << historyDb.lastError();
        return false;
    }

    if (historyModel) historyModel->deleteLater();
    historyModel = new QSqlTableModel(this, historyDb);
    historyQuery = QSqlQuery(historyDb);

    createHistoryTable();

    if (logfile.isOpen()) {
        logstream.flush();
        logfile.close();
    }
    logfile.setFileName(database::logFilenames());
    if (!logfile.open(QIODevice::WriteOnly | QIODevice::Text | QIODevice::Append)) {
        qDebug() << "Error: Failed to create log file." << logfile.errorString();
        return false;
    }
    logstream.setDevice(&logfile);

    cleanUpHistory();

    return true;
}

bool database::createHistoryTable()
{
    for (const DB_TBL table : DB_TBL_ALL) {
        QString q = "CREATE TABLE IF NOT EXISTS ";
        q += DB_TABLES[table] + " (";

        for (const QStringList &column : DB_COLUMNS[table])
            q += column.join(" ") + ", ";
        q.replace(q.length() - 2, 1, ")");

        historyQuery.prepare(q);
        if(!historyQuery.exec())
            qDebug() << historyQuery.lastError();

        for (const QString &column : DB_INDEXES[table]) {
            historyQuery.prepare("CREATE INDEX IF NOT EXISTS " + DB_TABLES[table] + "_" + column
                                 + " ON " + DB_TABLES[table] + "(" + column + ")");
            if(!historyQuery.exec())
                qDebug() << historyQuery.lastError();
        }
    }
    return true;
}

bool database::cleanUpHistory()
{
    QDir dir = historyPath;

    for (const QFileInfo &file : dir.entryInfoList({ "*.db", "*.txt" }))
        if (not database::dbFilenames(historyKeepDays).contains(file.filePath())
                and not database::logFilenames(historyKeepDays).contains(file.filePath()))
            QFile(file.filePath()).remove();

    return true;
}

bool database::preparePref()
{
    QDir::current().mkdir(historyPath);

    prefDb = QSqlDatabase::addDatabase("QSQLITE", "preferences.db");

    if (prefDb.isOpen()) prefDb.close();
    prefDb.setDatabaseName(database::prefFilename);
    if (not prefDb.open()) {
        qDebug() << "Error: Failed to connect preferences db." << prefDb.lastError();
        return false;
    }

    prefModel = new QSqlTableModel(this, prefDb);
    prefQuery = QSqlQuery(prefDb);

    createPrefTable();

    return true;
}

bool database::createPrefTable()
{
    DB_TBL table = DB_TBL_PREFERENCES;

    QString q = "CREATE TABLE IF NOT EXISTS ";
    q += DB_TABLES[table] + " (";

    for (const QStringList &column : DB_COLUMNS[table])
        q += column.join(" ") + ", ";
    q.replace(q.length() - 2, 1, ")");

    prefQuery.prepare(q);
    if(!prefQuery.exec())
        qDebug() << prefQuery.lastError();

    for (const QString &column : DB_INDEXES[table]) {
        prefQuery.prepare("CREATE INDEX IF NOT EXISTS " + DB_TABLES[table] + "_" + column
                          + " ON " + DB_TABLES[table] + "(" + column + ")");
        if(!prefQuery.exec())
            qDebug() << prefQuery.lastError();
    }
    return true;
}

database &operator<< (database &db, const msgFreq &msg)
{
    db.historyModel->setTable(db.DB_TABLES[db.DB_TBL_FREQ_DATA]);
    QSqlRecord r = db.historyModel->record();
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
    r.setValue("Ref_Select_Master", msg.ref_select_master);
    r.setValue("Ref10_Inner_1", msg.ref_inner_1);
    r.setValue("Ref10_3", msg.ref_10_3);
    r.setValue("Ref10_4", msg.ref_10_4);
    r.setValue("Ref10_Inner_2", msg.ref_inner_2);
    r.setValue("Ref_Select_Slave", msg.ref_select_slave);
    r.setValue("Handshake", msg.handshake);
    r.setValue("Serial_Id", msg.serialId);
    r.setValue("Master_Slave", msg.masterslave);
    if (!db.historyModel->insertRecord(-1, r))
        qDebug() << db.historyModel->lastError();

    return db;
}

database &operator<< (database &db, const msgDist &msg)
{
    db.historyModel->setTable(db.DB_TABLES[db.DB_TBL_DIST_DATA]);
    QSqlRecord r = db.historyModel->record();
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
    if (!db.historyModel->insertRecord(-1, r))
        qDebug() << db.historyModel->lastError();

    return db;
}

database &operator<< (database &db, const msgAmp &msg)
{
    db.historyModel->setTable(db.DB_TABLES[db.DB_TBL_AMP_DATA]);
    QSqlRecord r = db.historyModel->record();
    r.setValue("Device", msg.deviceId);
    r.setValue("Time", msg.time);
    r.setValue("Output_Power", msg.output_power);
    r.setValue("Gain", msg.gain);
    r.setValue("Attenuation", msg.atten);
    r.setValue("Input_Power", msg.input_power);
    r.setValue("Amplifier_Temperature", msg.temp);
    r.setValue("Stat_Stand_Wave", msg.stat_stand_wave);
    r.setValue("Stat_Temperature", msg.stat_temp);
    r.setValue("Stat_Current", msg.stat_current);
    r.setValue("Stat_Voltage", msg.stat_voltage);
    r.setValue("Stat_Power", msg.stat_power);
    r.setValue("Load_Temperature", msg.load_temp);
    r.setValue("Is_Remote", msg.remote);
    r.setValue("Is_Radio_On", msg.radio);
    r.setValue("Atten_Mode", msg.atten_mode);
    r.setValue("Serial_Id", msg.serialId);
    r.setValue("Handshake", msg.handshake);
    r.setValue("MasterSlave_Active", msg.isactive);
    if (!db.historyModel->insertRecord(-1, r))
        qDebug() << db.historyModel->lastError();

    return db;
}

database &operator<< (database &db, const msgCntlFreq &msg)
{
    db.historyModel->setTable(db.DB_TABLES[db.DB_TBL_FREQ_OPER]);
    QSqlRecord r = db.historyModel->record();
    r.setValue("Device", msg.deviceId);
    r.setValue("Time", msg.time);
    r.setValue("Attenuation", msg.atten);
    r.setValue("Ref10_A", msg.ref_10_a);
    r.setValue("Ref10_B", msg.ref_10_b);
    r.setValue("Serial_Id", msg.serialId);
    if (!db.historyModel->insertRecord(-1, r))
        qDebug() << db.historyModel->lastError();

    return db;
}

database &operator<< (database &db, const msgCntlDist &msg)
{
    db.historyModel->setTable(db.DB_TABLES[db.DB_TBL_DIST_OPER]);
    QSqlRecord r = db.historyModel->record();
    r.setValue("Device", msg.deviceId);
    r.setValue("Time", msg.time);
    r.setValue("Ref10", msg.ref_10);
    r.setValue("Ref16", msg.ref_16);
    r.setValue("Serial_Id", msg.serialId);
    if (!db.historyModel->insertRecord(-1, r))
        qDebug() << db.historyModel->lastError();

    return db;
}

database &operator<< (database &db, const msgCntlAmp &msg)
{
    db.historyModel->setTable(db.DB_TABLES[db.DB_TBL_AMP_OPER]);
    QSqlRecord r = db.historyModel->record();
    r.setValue("Device", msg.deviceId);
    r.setValue("Time", msg.time);
    r.setValue("Attenuation_Mode", msg.atten);
    r.setValue("Output_Power", msg.output_power);
    r.setValue("Gain", msg.gain);
    r.setValue("Is_Remote", msg.remote);
    r.setValue("Is_Radio_On", msg.radio);
    r.setValue("Serial_Id", msg.serialId);
    if (!db.historyModel->insertRecord(-1, r))
        qDebug() << db.historyModel->lastError();

    return db;
}

bool database::setAlert(const database::DB_TBL dbTable, const int deviceId, const int type,
                  const QString field, const QVariant value, const QVariant normal_value)
{
    historyModel->setTable(DB_TABLES[dbTable]);
    QSqlRecord r = historyModel->record();
    r.setValue("Device", deviceId);
    r.setValue("Time", QDateTime::currentDateTime());
    r.setValue("Type", type);
    r.setValue("Field", field);
    r.setValue("Value", value);
    r.setValue("Normal_Value", normal_value);
    r.setValue("Emergence", (type != alert::P_ALERT_GOOD));
    if (!historyModel->insertRecord(-1, r))
        qDebug() << historyModel->lastError();

    alert::P_ALERT alertType = static_cast<alert::P_ALERT>(type);
    alert::P_ENUM varType = alert::P_ENUM_OTHERS;
    device *dev = device::findDevice(deviceId);
    if (dev and alertType != alert::P_ALERT_TIMEOUT_NOFIELD and alertType != alert::P_ALERT_OTHERS_NOFIELD)
        varType = dev->getVarType(field);

    QStringList alrt = {
        device::name(deviceId) + " #" + QString::number(deviceId),
        QDateTime::currentDateTime().toString(Qt::ISODate),

        (alertType == alert::P_ALERT_TIMEOUT_NOFIELD or alertType == alert::P_ALERT_OTHERS_NOFIELD)
        ? ""
        : (dev ? dev->varName(field) : field),

        [=](){
            const auto getAlertStr = [](const alert::P_ALERT type, const int n) {
                return alert::tr(alert::STR_ALERT[type][n].toUtf8()); };

            switch (alertType) {
            case alert::P_ALERT_GOOD:
                return (tr("Restored normal") + (", ") + getAlertStr(alertType, 0) + ": "
                    + alert::setDisplay(value, varType));
            case alert::P_ALERT_LOWER:
            case alert::P_ALERT_UPPER:
            case alert::P_ALERT_BAD:
                return getAlertStr(alertType, 0) + ", " + getAlertStr(alertType, 2) + ": "
                    + alert::setDisplay(normal_value, varType)
                    + ", " + getAlertStr(alertType, 1) + ": "
                    + alert::setDisplay(value, varType);
            case alert::P_ALERT_TIMEOUT:
            case alert::P_ALERT_TIMEOUT_NOFIELD:
                return getAlertStr(alertType, 0) + ", " + getAlertStr(alertType, 1) + ": "
                    + (value.value<int>() == -1 ? getAlertStr(alertType, 2)
                        : QString::number(value.value<int>())
                    + getAlertStr(alertType, 3));
            case alert::P_ALERT_OTHERS:
            case alert::P_ALERT_OTHERS_NOFIELD:
            case alert::P_ALERT_NODATA:
                return getAlertStr(alertType, 0);
            }

            return tr("No content");
        }(),

        alertType == alert::P_ALERT_GOOD ? alert::STR_COLOR[alert::P_COLOR_NORMAL] : alert::STR_COLOR[alert::P_COLOR_ABNORMAL]
    };

    for (alertRecordModel *model : qAsConst(alertRecordModel::alertRecordModelList))
        model->addAlert(deviceId, alrt);

    for (const QString &str : alrt.mid(0, 4))
        logstream << str << ",\t";
#if QT_VERSION > QT_VERSION_CHECK(5, 14, 0)
    logstream << Qt::endl;
#else
    logstream << endl;
#endif
    return true;
}

bool database::setAlert(const int type, const QString text, const int deviceId)
{
    historyModel->setTable(DB_TABLES[DB_TBL_MSG_ALERT]);
    QSqlRecord r = historyModel->record();
    r.setValue("Device", deviceId);
    r.setValue("Time", QDateTime::currentDateTime());
    r.setValue("Type", type);
    r.setValue("Alert", text);
    r.setValue("Emergence", (type != alert::P_ALERT_GOOD));
    if (!historyModel->insertRecord(-1, r))
        qDebug() << historyModel->lastError();

    return true;
}

const database &operator>> (const database &db, QList<QStringList> &str)
{
    db.historyModel->setTable(db.setDBTable);
    db.historyModel->setFilter("Device=" + QString::number(db.setDeviceId));
    db.historyModel->setSort(2, Qt::DescendingOrder);
    db.historyModel->select();

    for (int i = 0; i < qMin(db.historyModel->rowCount(), 10); ++i) {
        QSqlRecord r = db.historyModel->record(i);
        if (r.value("Id").toString() == "") {
            return db;
        }

        QString field = r.value("Field").value<QString>();
        alert::P_ALERT type = r.value("Type").value<alert::P_ALERT>();

        alert::P_ENUM varType = alert::P_ENUM_OTHERS;
        device *dev = device::findDevice(db.setDeviceId);
        if (dev and type != alert::P_ALERT_TIMEOUT_NOFIELD and type != alert::P_ALERT_OTHERS_NOFIELD)
            varType = dev->getVarType(field);

        QStringList s = {
            device::name(r.value("device").value<int>()) + " #" + QString::number(r.value("device").value<int>()),

            r.value("Time").toDateTime().toString(Qt::ISODate),

            (type == alert::P_ALERT_TIMEOUT_NOFIELD or type == alert::P_ALERT_OTHERS_NOFIELD)
                ? ""
                : (dev ? dev->varName(field) : field),

            [&](){
                const auto getAlertStr = [](const alert::P_ALERT type, const int n) {
                    return alert::tr(alert::STR_ALERT[type][n].toUtf8()); };

                switch (type) {
                case alert::P_ALERT_GOOD:
                    return (QObject::tr("Restored normal") + (", ") + getAlertStr(type, 0) + ": "
                        + alert::setDisplay(r.value("Value"), varType));
                case alert::P_ALERT_LOWER:
                case alert::P_ALERT_UPPER:
                case alert::P_ALERT_BAD:
                    return getAlertStr(type, 0) + ", " + getAlertStr(type, 2) + ": "
                        + alert::setDisplay(r.value("Normal_Value"), varType)
                        + ", " + getAlertStr(type, 1) + ": "
                        + alert::setDisplay(r.value("Value"), varType);
                case alert::P_ALERT_TIMEOUT:
                case alert::P_ALERT_TIMEOUT_NOFIELD:
                    return getAlertStr(type, 0) + ", " + getAlertStr(type, 1) + ": "
                        + (r.value("Value").value<int>() == -1 ? getAlertStr(type, 2)
                            : QString::number(r.value("Value").value<int>())
                        + getAlertStr(type, 3));
                case alert::P_ALERT_OTHERS:
                case alert::P_ALERT_OTHERS_NOFIELD:
                case alert::P_ALERT_NODATA:
                    return getAlertStr(type, 0);
                }

                return QObject::tr("No content");
            }(),

            r.value("Emergence").value<bool>() ? alert::STR_COLOR[alert::P_COLOR_ABNORMAL] : alert::STR_COLOR[alert::P_COLOR_NORMAL]
        };

        str << s;
    }

    return db;
}

const QHash<QString, QVariant> database::getPreferences(const int deviceId) const
{
    prefModel->setTable(DB_TABLES[DB_TBL_PREFERENCES]);
    prefModel->setFilter("Device=" + QString::number(deviceId));
    prefModel->setSort(2, Qt::DescendingOrder);
    prefModel->select();

    QHash<QString, QVariant> data;
    for (int i = 0; i < prefModel->rowCount(); ++i) {
        QSqlRecord r = prefModel->record(i);
        data[r.value("Field").toString()] = r.value("Value");
    }

    return data;
}

bool database::setPreferences(const int deviceId, const QString field, const QVariant value)
{
    prefModel->setTable(DB_TABLES[DB_TBL_PREFERENCES]);
    prefModel->setFilter("Device=" + QString::number(deviceId)
                         + " AND Field=\"" + field + "\"");
    prefModel->setSort(2, Qt::DescendingOrder);
    prefModel->select();

    QSqlRecord r;
    if (prefModel->rowCount() != 0)
        r = prefModel->record(0);
    else
        r = prefModel->record();

    r.setValue("Device", deviceId);
    r.setValue("Time", QDateTime::currentDateTime());
    r.setValue("Field", field);
    r.setValue("Value", value);

    bool ret;
    if (prefModel->rowCount() != 0)
        ret = prefModel->setRecord(0, r);
    else
        ret = prefModel->insertRecord(-1, r);

    if (!ret) {
        qDebug() << prefModel->lastError();
        return false;
    }

    return true;
}
