#ifndef CWORKERTHREAD_H
#define CWORKERTHREAD_H

#include <QCoreApplication>
#include <QObject>
#include <QDir>
#include <QFile>
#include <QtMultimedia>
#include <QtConcurrent/qtconcurrentrun.h>
#include <QtDBus>


class CWorkerThread : public QObject
{
    Q_OBJECT
    Q_CLASSINFO("D-Bus Interface", "org.freedesktop.login1")

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
    void Shutdown(int iShutdownID);
};

#endif // CWORKERTHREAD_H
