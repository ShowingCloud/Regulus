#ifndef DATABASE_H
#define DATABASE_H

#include <QCoreApplication>
#include <QSqlTableModel>
#include <QSqlDatabase>
#include <QSqlError>

#include "protocol.h"
#include "alert.h"

#define DB_FILENAME "history.db"
#define DB_USERNAME "logusr"
#define DB_PASSWORD "password"

class database : public QObject
{
    Q_OBJECT

    enum { DB_TBL_AMP_DATA, DB_TBL_AMP_ALERT, DB_TBL_AMP_OPER,
         DB_TBL_FREQ_DATA, DB_TBL_FREQ_ALERT, DB_TBL_FREQ_OPER,
         DB_TBL_DIST_DATA, DB_TBL_DIST_ALERT, DB_TBL_DIST_OPER };

public:
    explicit database(QObject *parent = nullptr);
    ~database();

    database &operator<< (const msgAmp &msg);
    database &operator<< (const msgFreq &msg);
    database &operator<< (const msgDist &msg);
    database &operator<< (const alert &alert);
    database &operator<< (const msgCntlAmp &msg);
    database &operator<< (const msgCntlFreq &msg);
    database &operator<< (const msgCntlDist &msg);

private:
    QSqlDatabase db;
    QSqlTableModel *dbModel;

    QList<QString> dbTables = { "amp_data", "amp_alert", "amp_oper",
                               "freq_data", "freq_alert", "freq_oper",
                               "dist_data", "dist_alert", "dist_oper" };

signals:

public slots:
};

#endif // DATABASE_H
