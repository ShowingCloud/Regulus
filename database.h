#ifndef DATABASE_H
#define DATABASE_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlQuery>

#define DB_FILENAME "history.db"
#define DB_USERNAME "logusr"
#define DB_PASSWORD "password"

class database : public QObject
{
    Q_OBJECT

    enum {DB_TBL_DATA, DB_TBL_ALERT, DB_TBL_OPER};

public:
    explicit database(QObject *parent = nullptr);
    ~database();

private:
    QSqlDatabase db;
    QList<QString> db_tables = {"data", "alert", "oper"};

signals:

public slots:
};

#endif // DATABASE_H
