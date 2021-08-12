#include "database.h"

#include <QtDebug>

database::database(QObject *parent) : QObject(parent)
{
    if (QSqlDatabase::contains("qt_sql_default_connection"))
    {
        this->db = QSqlDatabase::database("qt_sql_default_connection");
    }
    else
    {
        this->db = QSqlDatabase::addDatabase("QSQLITE");
        this->db.setDatabaseName(DB_FILENAME);
        this->db.setUserName(DB_USERNAME);
        this->db.setPassword(DB_PASSWORD);
    }

    if (!this->db.open())
    {
        qDebug() << "Error: Failed to connect db." << this->db.lastError();
    }
}

database::~database()
{
    this->db.close();
}
