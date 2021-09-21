#ifndef CWORKERTHREAD_H
#define CWORKERTHREAD_H

#include <QCoreApplication>
#include <QObject>
#include <QDir>
#include <QFile>
#include <QtMultimedia>
#include <QtConcurrent/qtconcurrentrun.h>


class CWorkerThread : public QObject
{
    Q_OBJECT

private:
    int m_iError;

public:


private:


public:
    explicit CWorkerThread(QObject *parent = nullptr);
    int GetError() const;

signals:
    void result();

public slots:
    void Shutdown(QString strPassword, int iShutdownID);
};

#endif // CWORKERTHREAD_H
