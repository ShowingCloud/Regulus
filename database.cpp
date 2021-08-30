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
        this->db.setDatabaseName(database::filename);
        this->db.setUserName(database::username);
        this->db.setPassword(database::password);
    }

    if (!this->db.open())
    {
        qDebug() << "Error: Failed to connect db." << this->db.lastError();
    }

    this->dbModel = new QSqlTableModel(this, this->db);
}

database::~database()
{
    this->db.close();
    qDebug() << "Database closed.";
}
