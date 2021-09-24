#ifndef CMAINWINDOW_H
#define CMAINWINDOW_H

#include <QCoreApplication>
#include <QObject>
#include <QSettings>
#include <QProcess>
#include <QDir>
#include <QFile>
#include <QException>
#include <QtMultimedia>
#include <QtConcurrent/qtconcurrentrun.h>
#include "CWorkerThread.h"
#include "CAES.h"


class CMainWindow : public QObject
{
    Q_OBJECT

private:    // Private Variables
    QString m_strIniFilePath;
    std::unique_ptr<CWorkerThread>  m_pWorker;
    std::unique_ptr<QThread>        m_pThread;

public:     // Public Variables


private:    // Private Functions


public:     // Public Functions
    explicit CMainWindow(QObject *parent = nullptr);
    virtual ~CMainWindow();

    Q_INVOKABLE int     getMainWindowX();
    Q_INVOKABLE int     getMainWindowY();
    Q_INVOKABLE int     getMainWindowWidth();
    Q_INVOKABLE int     getMainWindowHeight();
    Q_INVOKABLE bool    getMainWindowMaximized();
    Q_INVOKABLE int     setMainWindowState(int X, int Y, int Width, int Height, bool Maximized);

    Q_INVOKABLE int     savePassword(QString strPassword);
    Q_INVOKABLE QString getPassword();
    Q_INVOKABLE bool    isExistSoundFile();

    Q_INVOKABLE int onShutdown(QString strPassword);
    Q_INVOKABLE int onReboot(QString strPassword);

signals:
    void start(QString strPassword, int iShutdownID);
    void result();
};

#endif // CMAINWINDOW_H
