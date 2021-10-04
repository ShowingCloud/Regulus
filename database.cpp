#include "database.h"

#include <QtDebug>

database::database(QObject *parent) : QObject(parent)
{
    if (QSqlDatabase::contains("qt_sql_default_connection"))
    {
        db = QSqlDatabase::database("qt_sql_default_connection");
    }
    else
    {
        db = QSqlDatabase::addDatabase("QSQLITE");
        db.setDatabaseName(database::filename);
        db.setUserName(database::username);
        db.setPassword(database::password);
    }

    if (!db.open())
    {
        qDebug() << "Error: Failed to connect db." << db.lastError();
    }

    dbModel = new QSqlTableModel(this, db);
}

database::~database()
{
    db.close();
    qDebug() << "Database closed.";
    delete dbModel;
}
