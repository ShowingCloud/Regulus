#ifndef DATABASE_H
#define DATABASE_H

#include <QCoreApplication>
#include <QSqlTableModel>
#include <QSqlQuery>
#include <QSqlDatabase>
#include <QSqlRecord>
#include <QSqlError>
#include <QTextStream>
#include <QDateTime>
#include <QDir>

class msgFreq;
class msgDist;
class msgAmp;
class msgCntlFreq;
class msgCntlDist;
class msgCntlAmp;
class device;
class devFreq;
class devDist;
class devAmp;
class databaseSetter;

class database : public QObject
{
    Q_OBJECT

public:
    explicit database(QObject *parent = nullptr);
    ~database() override;

    friend database &operator<< (database &db, const msgFreq &msg);
    friend database &operator<< (database &db, const msgDist &msg);
    friend database &operator<< (database &db, const msgAmp &msg);
    friend database &operator<< (database &db, const msgCntlFreq &msg);
    friend database &operator<< (database &db, const msgCntlDist &msg);
    friend database &operator<< (database &db, const msgCntlAmp &msg);
    friend database &operator<< (database &db, const databaseSetter &setter);
    friend const database &operator>> (const database &db, QList<QStringList> &str);

    enum DB_TBL { DB_TBL_AMP_DATA, DB_TBL_AMP_ALERT, DB_TBL_AMP_OPER,
         DB_TBL_FREQ_DATA, DB_TBL_FREQ_ALERT, DB_TBL_FREQ_OPER,
         DB_TBL_DIST_DATA, DB_TBL_DIST_ALERT, DB_TBL_DIST_OPER,
         DB_TBL_MSG_ALERT, DB_TBL_OTHERS };
    static const inline DB_TBL DB_TBL_ALL[] = {
        DB_TBL_AMP_DATA, DB_TBL_AMP_ALERT, DB_TBL_AMP_OPER,
        DB_TBL_FREQ_DATA, DB_TBL_FREQ_ALERT, DB_TBL_FREQ_OPER,
        DB_TBL_DIST_DATA, DB_TBL_DIST_ALERT, DB_TBL_DIST_OPER,
        DB_TBL_MSG_ALERT };
    enum DB_RET { DB_RET_SUCCESS };

    bool setAlert(const database::DB_TBL dbTable, const int deviceId, const int type,
                      const QString field, const QVariant value, const QVariant normal_value = 0);
    bool setAlert(const int type, const QString text, const int deviceId = 0);

private:
    bool prepare();
    bool createTable();
    bool cleanUp();

    QSqlDatabase    db          = QSqlDatabase();
    QSqlTableModel  *dbModel    = nullptr;
    QSqlQuery       dbQuery     = QSqlQuery();
    QString         setDBTable  = QString();
    int             setDeviceId = -1;
    QFile           logfile     = QFile(this);
    QTextStream     logstream   = QTextStream();

    inline static QDate date = QDate::currentDate();

    inline const static QString historyPath = "history";
    inline const static QString filename = "history/history.db";
    inline const static QString logfilename = "history/history.txt";
    inline const static int historyKeepDays = 30;

    inline static const QHash<DB_TBL, QString> DB_TABLES = {
        {DB_TBL_AMP_DATA, "amp_data"}, {DB_TBL_AMP_ALERT, "amp_alert"}, {DB_TBL_AMP_OPER, "amp_oper"},
        {DB_TBL_FREQ_DATA, "freq_data"}, {DB_TBL_FREQ_ALERT, "freq_alert"}, {DB_TBL_FREQ_OPER, "freq_oper"},
        {DB_TBL_DIST_DATA, "dist_data"}, {DB_TBL_DIST_ALERT, "dist_alert"}, {DB_TBL_DIST_OPER, "dist_oper"},
        {DB_TBL_MSG_ALERT, "msg_alert"}, {DB_TBL_OTHERS, "others"}};

    static const inline QHash<DB_TBL, QList<QStringList>> DB_COLUMNS = {
        {DB_TBL_FREQ_DATA, {{"Id", "INTEGER", "UNIQUE", "PRIMARY KEY", "AUTOINCREMENT"},
                           {"Device", "INTEGER"}, {"Time", "DATETIME"}, {"Attenuation", "INTEGER"},
                           {"Voltage", "INTEGER"}, {"Current", "INTEGER"}, {"Radio_Stat", "INTEGER"},
                           {"Mid_Stat", "INTEGER"}, {"Lock_A1", "INTEGER"}, {"Lock_A2", "INTEGER"},
                           {"Lock_B1", "INTEGER"}, {"Lock_B2", "INTEGER"}, {"Ref10_1", "INTEGER"},
                           {"Ref10_2", "INTEGER"}, {"Ref10_Inner_1", "INTEGER"}, {"Ref10_3" "INTEGER"},
                           {"Ref10_4", "INTEGER"}, {"Ref10_Inner_2", "INTEGER"}, {"Handshake", "INTEGER"},
                           {"Serial_Id", "INTEGER"}, {"Master_Slave", "INTEGER"}}},
        {DB_TBL_FREQ_ALERT, {{"Id", "INTEGER", "UNIQUE", "PRIMARY KEY", "AUTOINCREMENT"},
                             {"Device", "INTEGER"}, {"Time", "DATETIME"}, {"Type", "INTEGER"},
                             {"Field", "TEXT"}, {"Value", "INTEGER"}, {"Normal_Value", "INTEGER"},
                             {"Emergence", "INTEGER"}}},
        {DB_TBL_FREQ_OPER, {{"Id", "INTEGER", "UNIQUE", "PRIMARY KEY", "AUTOINCREMENT"},
                            {"Device", "INTEGER"}, {"Time", "DATETIME"}, {"Attenuation", "INTEGER"},
                            {"Ref10_A", "INTEGER"}, {"Ref10_B", "INTEGER"}, {"Serial_Id", "INTEGER"}}},
        {DB_TBL_DIST_DATA, {{"Id", "INTEGER", "UNIQUE", "PRIMARY KEY", "AUTOINCREMENT"},
                            {"Device", "INTEGER"}, {"Time", "DATETIME"}, {"Ref10", "INTEGER"},
                            {"Ref16", "INTEGER"}, {"Voltage", "INTEGER"}, {"Current", "INTEGER"},
                            {"Lock10_1", "INTEGER"}, {"Lock10_2", "INTEGER"}, {"Lock16_1", "INTEGER"},
                            {"Lock16_2", "INTEGER"}, {"Serial_Id", "INTEGER"}}},
        {DB_TBL_DIST_ALERT, {{"Id", "INTEGER", "UNIQUE", "PRIMARY KEY", "AUTOINCREMENT"},
                             {"Device", "INTEGER"}, {"Time", "DATETIME"}, {"Type", "INTEGER"},
                             {"Field", "TEXT"}, {"Value", "INTEGER"}, {"Normal_Value", "INTEGER"},
                             {"Emergence", "INTEGER"}}},
        {DB_TBL_DIST_OPER, {{"Id", "INTEGER", "UNIQUE", "PRIMARY KEY", "AUTOINCREMENT"},
                            {"Device", "INTEGER"}, {"Time", "DATETIME"}, {"Ref10", "INTEGER"},
                            {"Ref16", "INTEGER"}, {"Serial_Id", "INTEGER"}}},
        {DB_TBL_AMP_DATA, {{"Id", "INTEGER", "UNIQUE", "PRIMARY KEY", "AUTOINCREMENT"},
                           {"Device", "INTEGER"}, {"Time", "DATETIME"}, {"Power", "INTEGER"},
                           {"Gain", "INTEGER"}, {"Attenuation", "INTEGER"}, {"Loss", "INTEGER"},
                           {"Temperature", "INTEGER"}, {"Stat_Stand_Wave", "INTEGER"}, {"Stat_Temperature", "INTEGER"},
                           {"Stat_Current", "INTEGER"}, {"Stat_Voltage", "INTEGER"}, {"Stat_Power", "INTEGER"},
                           {"Load_Temperature", "INTEGER"}, {"Serial_Id", "INTEGER"}, {"Handshake", "INTEGER"}}},
        {DB_TBL_AMP_ALERT, {{"Id", "INTEGER", "UNIQUE", "PRIMARY KEY", "AUTOINCREMENT"},
                            {"Device", "INTEGER"}, {"Time", "DATETIME"}, {"Type", "INTEGER"},
                            {"Field", "TEXT"}, {"Value", "INTEGER"}, {"Normal_Value", "INTEGER"},
                            {"Emergence", "INTEGER"}}},
        {DB_TBL_AMP_OPER, {{"Id", "INTEGER", "UNIQUE", "PRIMARY KEY", "AUTOINCREMENT"},
                           {"Device", "INTEGER"}, {"Time", "DATETIME"}, {"Attenuation_Mode", "INTEGER"},
                           {"Power", "INTEGER"}, {"Gain", "INTEGER"}, {"Serial_Id", "INTEGER"}}},
        {DB_TBL_MSG_ALERT, {{"Id", "INTEGER", "UNIQUE", "PRIMARY KEY", "AUTOINCREMENT"},
                            {"Time", "DATETIME"}, {"Alert", "TEXT"}, {"Type", "INTEGER"},
                            {"Emergence", "INTEGER"}, {"Device", "INTEGER"}}}};

    inline static const QHash<DB_TBL, QStringList> DB_INDEXES = {
        {DB_TBL_FREQ_DATA, {"Device", "Time"}},
        {DB_TBL_FREQ_ALERT, {"Device", "Time", "Type", "Emergence"}},
        {DB_TBL_FREQ_OPER, {"Device", "Time"}},
        {DB_TBL_DIST_DATA, {"Device", "Time"}},
        {DB_TBL_DIST_ALERT, {"Device", "Time", "Type", "Emergence"}},
        {DB_TBL_DIST_OPER, {"Device", "Time"}},
        {DB_TBL_AMP_DATA, {"Device", "Time"}},
        {DB_TBL_AMP_ALERT, {"Device", "Time", "Type", "Emergence"}},
        {DB_TBL_AMP_OPER, {"Device", "Time"}},
        {DB_TBL_MSG_ALERT, {"Time"}}};

    inline static const QString dbFilename() {
        date = QDate::currentDate();
        QFileInfo file(filename);
        return file.path() + '/' + file.baseName() + '-' + date.toString(Qt::ISODate) + '.' + file.completeSuffix();
    }
    inline static const QStringList dbFilename(const int days) {
        QFileInfo file(filename);
        QStringList ret = QStringList();
        for (int i = 0; i < days; ++i)
            ret << QString(file.path() + '/' + file.baseName() + '-'
                           + QDate::currentDate().addDays(-i).toString(Qt::ISODate)
                           + '.' + file.completeSuffix());
        return ret;
    }

    inline static const QString logFilename() {
        date = QDate::currentDate();
        QFileInfo file(logfilename);
        return file.path() + '/' + file.baseName() + '-' + date.toString(Qt::ISODate) + '.' + file.completeSuffix();
    }
    inline static const QStringList logFilename(const int days) {
        QFileInfo file(logfilename);
        QStringList ret = QStringList();
        for (int i = 0; i < days; ++i)
            ret << QString(file.path() + '/' + file.baseName() + '-'
                           + QDate::currentDate().addDays(-i).toString(Qt::ISODate)
                           + '.' + file.completeSuffix());
        return ret;
    }

signals:

public slots:
};

extern database *globalDB;

class databaseSetter
{
public:
    explicit databaseSetter(const QString dbTable, const int deviceId)
        : dbTable(dbTable), deviceId(deviceId) {}

    inline friend database &operator<< (database &db, const databaseSetter &setter) {
        db.setDBTable = setter.dbTable;
        db.setDeviceId = setter.deviceId;
        return db;
    }

private:
    const QString dbTable = QString();
    const int deviceId = -1;
};

#endif // DATABASE_H
