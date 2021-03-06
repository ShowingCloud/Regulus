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
    template <class T> friend database &operator<< (database &db, const T &dev);
    template <class T> friend const database &operator>> (const database &db, T &dev);
    friend const database &operator>> (const database &db, QList<QStringList> &str);
    friend void setDBStandby (database &db, const device &dev);
    friend bool getDBStandby (const database &db, device &dev);

    enum DB_TBL { DB_TBL_AMP_DATA, DB_TBL_AMP_ALERT, DB_TBL_AMP_OPER,
                  DB_TBL_FREQ_DATA, DB_TBL_FREQ_ALERT, DB_TBL_FREQ_OPER,
                  DB_TBL_DIST_DATA, DB_TBL_DIST_ALERT, DB_TBL_DIST_OPER,
                  DB_TBL_MSG_ALERT, DB_TBL_NET_ALERT, DB_TBL_PREFERENCES,
                  DB_TBL_OTHERS };
    static const inline DB_TBL DB_TBL_ALL[] = { /* all tables in history db */
        DB_TBL_AMP_DATA, DB_TBL_AMP_ALERT, DB_TBL_AMP_OPER,
        DB_TBL_FREQ_DATA, DB_TBL_FREQ_ALERT, DB_TBL_FREQ_OPER,
        DB_TBL_DIST_DATA, DB_TBL_DIST_ALERT, DB_TBL_DIST_OPER,
        DB_TBL_MSG_ALERT, DB_TBL_NET_ALERT };
    enum DB_RET { DB_RET_SUCCESS };

    bool setAlert(const database::DB_TBL dbTable, const int deviceId, const int type,
                      const QString field, const QVariant value, const QVariant normal_value = 0);
    bool setAlert(const int type, const QString text, const int deviceId = 0);

private:
    bool prepareHistory();
    bool createHistoryTable();
    bool cleanUpHistory();
    bool preparePref();
    bool createPrefTable();
    const QHash<QString, QVariant> getPreferences(const int deviceId) const;
    bool setPreferences(const int deviceId, const QString field, const QVariant value);

    QSqlDatabase    historyDb       = QSqlDatabase();
    QSqlTableModel  *historyModel   = nullptr;
    QSqlQuery       historyQuery    = QSqlQuery();
    QSqlDatabase    prefDb          = QSqlDatabase();
    QSqlTableModel  *prefModel      = nullptr;
    QSqlQuery       prefQuery       = QSqlQuery();
    QString         setDBTable      = QString();
    int             setDeviceId     = -1;
    QFile           logfile         = QFile(this);
    QTextStream     logstream       = QTextStream();

    inline static QDate date = QDate::currentDate();

    inline const static QString historyPath = "history";
    inline const static QString historyFilename = "history/history.db";
    inline const static QString logFilename = "history/history.txt";
    inline const static QString prefFilename = "preferences.db";
    inline const static int historyKeepDays = 30;

    inline static const QHash<DB_TBL, QString> DB_TABLES = {
        {DB_TBL_AMP_DATA, "amp_data"}, {DB_TBL_AMP_ALERT, "amp_alert"}, {DB_TBL_AMP_OPER, "amp_oper"},
        {DB_TBL_FREQ_DATA, "freq_data"}, {DB_TBL_FREQ_ALERT, "freq_alert"}, {DB_TBL_FREQ_OPER, "freq_oper"},
        {DB_TBL_DIST_DATA, "dist_data"}, {DB_TBL_DIST_ALERT, "dist_alert"}, {DB_TBL_DIST_OPER, "dist_oper"},
        {DB_TBL_MSG_ALERT, "msg_alert"}, {DB_TBL_NET_ALERT, "net_alert"}, {DB_TBL_PREFERENCES, "preferences"},
        {DB_TBL_OTHERS, "others"}};

    static const inline QHash<DB_TBL, QList<QStringList>> DB_COLUMNS = {
        {DB_TBL_FREQ_DATA, {{"Id", "INTEGER", "UNIQUE", "PRIMARY KEY", "AUTOINCREMENT"},
                            {"Device", "INTEGER"}, {"Time", "DATETIME"}, {"Attenuation", "INTEGER"},
                            {"Voltage", "INTEGER"}, {"Current", "INTEGER"}, {"Radio_Stat", "INTEGER"},
                            {"Mid_Stat", "INTEGER"}, {"Lock_A1", "INTEGER"}, {"Lock_A2", "INTEGER"},
                            {"Lock_B1", "INTEGER"}, {"Lock_B2", "INTEGER"}, {"Ref10_1", "INTEGER"},
                            {"Ref10_2", "INTEGER"}, {"Ref10_Inner_1", "INTEGER"}, {"Ref_Select_Master", "INTEGER"},
                            {"Ref10_3" "INTEGER"}, {"Ref10_4", "INTEGER"}, {"Ref10_Inner_2", "INTEGER"},
                            {"Ref_Select_Slave", "INTEGER"}, {"Handshake", "INTEGER"},
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
                           {"Device", "INTEGER"}, {"Time", "DATETIME"}, {"Output_Power", "INTEGER"},
                           {"Gain", "INTEGER"}, {"Attenuation", "INTEGER"}, {"Input_Power", "INTEGER"},
                           {"Amplifier_Temperature", "INTEGER"}, {"Stat_Stand_Wave", "INTEGER"}, {"Stat_Temperature", "INTEGER"},
                           {"Stat_Current", "INTEGER"}, {"Stat_Voltage", "INTEGER"}, {"Stat_Power", "INTEGER"},
                           {"Load_Temperature", "INTEGER"}, {"Is_Remote", "INTEGER"}, {"Is_Radio_On", "INTEGER"},
                           {"Atten_Mode", "INTEGER"}, {"Serial_Id", "INTEGER"}, {"Handshake", "INTEGER"},
                           {"MasterSlave_Active", "INTEGER"}}},
        {DB_TBL_AMP_ALERT, {{"Id", "INTEGER", "UNIQUE", "PRIMARY KEY", "AUTOINCREMENT"},
                            {"Device", "INTEGER"}, {"Time", "DATETIME"}, {"Type", "INTEGER"},
                            {"Field", "TEXT"}, {"Value", "INTEGER"}, {"Normal_Value", "INTEGER"},
                            {"Emergence", "INTEGER"}}},
        {DB_TBL_AMP_OPER, {{"Id", "INTEGER", "UNIQUE", "PRIMARY KEY", "AUTOINCREMENT"},
                           {"Device", "INTEGER"}, {"Time", "DATETIME"}, {"Attenuation_Mode", "INTEGER"},
                           {"Output_Power", "INTEGER"}, {"Gain", "INTEGER"}, {"Is_Remote", "INTEGER"},
                           {"Is_Radio_On", "INTEGER"}, {"Serial_Id", "INTEGER"}}},
        {DB_TBL_MSG_ALERT, {{"Id", "INTEGER", "UNIQUE", "PRIMARY KEY", "AUTOINCREMENT"},
                            {"Time", "DATETIME"}, {"Alert", "TEXT"}, {"Type", "INTEGER"},
                            {"Emergence", "INTEGER"}, {"Device", "INTEGER"}}},
        {DB_TBL_NET_ALERT, {{"Id", "INTEGER", "UNIQUE", "PRIMARY KEY", "AUTOINCREMENT"},
                            {"Device", "INTEGER"}, {"Time", "DATETIME"}, {"Type", "INTEGER"},
                            {"Field", "TEXT"}, {"Value", "INTEGER"}, {"Normal_Value", "INTEGER"},
                            {"Emergence", "INTEGER"}}},
        {DB_TBL_PREFERENCES, {{"Id", "INTEGER", "UNIQUE", "PRIMARY KEY", "AUTOINCREMENT"},
                              {"Device", "INTEGER"}, {"Time", "DATETIME"}, {"Field", "TEXT"},
                              {"Value", "INTEGER"}}}};

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
        {DB_TBL_MSG_ALERT, {"Time"}},
        {DB_TBL_NET_ALERT, {"Device", "Time", "Type", "Emergence"}},
        {DB_TBL_NET_ALERT, {"Device", "Time", "Type"}}};

    inline static const QString dbFilenames() {
        date = QDate::currentDate();
        QFileInfo file(historyFilename);
        return file.path() + '/' + file.baseName() + '-' + date.toString(Qt::ISODate) + '.' + file.completeSuffix();
    }
    inline static const QStringList dbFilenames(const int days) {
        QFileInfo file(historyFilename);
        QStringList ret = QStringList();
        for (int i = 0; i < days; ++i)
            ret << QString(file.path() + '/' + file.baseName() + '-'
                           + QDate::currentDate().addDays(-i).toString(Qt::ISODate)
                           + '.' + file.completeSuffix());
        return ret;
    }

    inline static const QString logFilenames() {
        date = QDate::currentDate();
        QFileInfo file(logFilename);
        return file.path() + '/' + file.baseName() + '-' + date.toString(Qt::ISODate) + '.' + file.completeSuffix();
    }
    inline static const QStringList logFilenames(const int days) {
        QFileInfo file(logFilename);
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
