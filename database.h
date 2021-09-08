#ifndef DATABASE_H
#define DATABASE_H

#include <QCoreApplication>
#include <QSqlTableModel>
#include <QSqlDatabase>
#include <QSqlError>

#include "protocol.h"
#include "alert.h"

class database : public QObject
{
    Q_OBJECT

    enum { DB_TBL_AMP_DATA, DB_TBL_AMP_ALERT, DB_TBL_AMP_OPER,
         DB_TBL_FREQ_DATA, DB_TBL_FREQ_ALERT, DB_TBL_FREQ_OPER,
         DB_TBL_DIST_DATA, DB_TBL_DIST_ALERT, DB_TBL_DIST_OPER,
         DB_TBL_MSG_ALERT };
    enum DB_RET { DB_RET_SUCCESS };

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

    DB_RET insert_msg_alert(const QString err, const QByteArray data);

private:
    QSqlDatabase db = QSqlDatabase();
    QSqlTableModel *dbModel;

    inline const static QString filename = "history.db";
    inline const static QString username = "logusr";
    inline const static QString password = "password";
    QList<QString> dbTables = { "amp_data", "amp_alert", "amp_oper",
                                "freq_data", "freq_alert", "freq_oper",
                                "dist_data", "dist_alert", "dist_oper",
                                "msg_alert" };

signals:

public slots:
};

#endif // DATABASE_H
