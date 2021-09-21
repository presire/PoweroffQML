#include "CMainWindow.h"

CMainWindow::CMainWindow(QObject *parent) : QObject(parent)
{
    m_pWorker = std::make_unique<CWorkerThread>();
    m_pThread = std::make_unique<QThread>();

    m_pWorker->moveToThread(m_pThread.get());

    connect(this, SIGNAL(start(QString,int)), m_pWorker.get(), SLOT(Shutdown(QString,int)));
    connect(m_pWorker.get(), SIGNAL(result()), this, SIGNAL(result()));

    m_pThread->start();
}

CMainWindow::~CMainWindow()
{
    m_pThread.release();
    m_pWorker.release();
}

int CMainWindow::getMainWindowX()
{
    QSettings settings("settings.ini", QSettings::IniFormat, this);

    settings.beginGroup("MainWindow");

    int iMainWindowX = 0;
    if(settings.contains("X"))
    {
        iMainWindowX = settings.value("X").toInt();
    }

    settings.endGroup();

    return iMainWindowX;
}

int CMainWindow::getMainWindowY()
{
    QSettings settings("settings.ini", QSettings::IniFormat, this);

    settings.beginGroup("MainWindow");

    int iMainWindowY = 0;
    if(settings.contains("Y"))
    {
        iMainWindowY = settings.value("Y").toInt();
    }

    settings.endGroup();

    return iMainWindowY;
}

int CMainWindow::getMainWindowWidth()
{
    QSettings settings("settings.ini", QSettings::IniFormat, this);

    settings.beginGroup("MainWindow");

    int iMainWindowWidth = 640;
    if(settings.contains("Width"))
    {
        iMainWindowWidth = settings.value("Width").toInt();
    }

    settings.endGroup();

    return iMainWindowWidth;
}

int CMainWindow::getMainWindowHeight()
{
    QSettings settings("settings.ini", QSettings::IniFormat, this);

    settings.beginGroup("MainWindow");

    int iMainWindowHeight = 480;
    if(settings.contains("Height"))
    {
        iMainWindowHeight = settings.value("Height").toInt();
    }

    settings.endGroup();

    return iMainWindowHeight;
}

bool CMainWindow::getMainWindowMaximized()
{
    QSettings settings("settings.ini", QSettings::IniFormat, this);

    settings.beginGroup("MainWindow");

    int bMainWindowMaximized = false;
    if(settings.contains("Maximized"))
    {
        bMainWindowMaximized = settings.value("Maximized").toBool();
    }

    settings.endGroup();

    return bMainWindowMaximized;
}

int CMainWindow::setMainWindowState(int X, int Y, int Width, int Height, bool Maximized)
{
    int iRet = 0;

    try
    {
        QSettings settings("settings.ini", QSettings::IniFormat, this);

        settings.beginGroup("MainWindow");
        settings.setValue("X", X);
        settings.setValue("Y", Y);
        settings.setValue("Width", Width);
        settings.setValue("Height", Height);
        if(Maximized)
        {
            settings.setValue("Maximized", "true");
        }
        else
        {
            settings.setValue("Maximized", "false");
        }

        settings.endGroup();
    }
    catch (QException *ex)
    {
        iRet = -1;
    }

    return iRet;
}

int CMainWindow::onShutdown(QString strPassword)
{
    if(strPassword.isEmpty())
    {
        return -1;
    }

    // Play Shutdown's Sound. Wait until playback is finished.
    QString strFilePath = QCoreApplication::applicationDirPath() + QDir::separator() + tr("Shutdown.wav");

    // If Password File exist, then error.
    QFile File(strFilePath);
    if(!File.exists())
    {
        return -1;
    }

    QFuture<void> Task = QtConcurrent::run([=]()
    {
        QSoundEffect effect;
        QEventLoop loop;
        effect.setSource(QUrl::fromLocalFile(strFilePath));
        effect.setVolume(50);
        effect.play();
        QObject::connect(&effect, &QSoundEffect::playingChanged, [&loop](){loop.exit();});
        loop.exec();
    });
    Task.waitForFinished();

    auto args = QStringList() << tr("-c") << tr("echo ") + strPassword + tr(" | sudo -S shutdown -h now");
    QProcess::startDetached(tr("/bin/sh"), args);

    return 0;
}


int CMainWindow::onReboot(QString strPassword)
{
    if(strPassword.isEmpty())
    {
        return -1;
    }

    QString strFilePath = QCoreApplication::applicationDirPath() + QDir::separator() + tr("Shutdown.wav");

    // If Password File exist, then error.
    QFile File(strFilePath);
    if(!File.exists())
    {
        return -1;
    }

    // Play Shutdown's Sound. Wait until playback is finished.
    QFuture<void> Task = QtConcurrent::run([=]()
    {
        QSoundEffect effect;
        QEventLoop loop;
        effect.setSource(QUrl::fromLocalFile(strFilePath));
        effect.setVolume(50);
        effect.play();
        QObject::connect(&effect, &QSoundEffect::playingChanged, [&loop](){loop.exit();});
        loop.exec();
    });
    Task.waitForFinished();

    auto args = QStringList() << tr("-c") << tr("echo ") + strPassword + tr(" | sudo -S shutdown -r now");
    QProcess::startDetached(tr("/bin/sh"), args);

    return 0;
}

int CMainWindow::savePassword(QString strPassword)
{
    if(strPassword.isEmpty())
    {
        return 0;
    }

    QString strFilePath = QCoreApplication::applicationDirPath() + QDir::separator() + tr("Password.txt");

    try
    {
        // Encrypt Password
        CAES AES("");
        QByteArray ByAryEncriptData = AES.Crypt(strPassword.toUtf8());

        QFile File(strFilePath);
        File.open(QIODevice::WriteOnly);

        // If Password File exist, File Data truncate.
        if(File.exists())
        {
            File.resize(strFilePath, 0);
        }

        // Write Data to File
        File.write(ByAryEncriptData);

        // File Close
        File.close();
    }
    catch(QException *e)
    {
        return -1;
    }

    return 0;
}


QString CMainWindow::getPassword()
{
    QString strFilePath = QCoreApplication::applicationDirPath() + QDir::separator() /*strExecutePath*/ + tr("Password.txt");
    QString strPassword = tr("");

    QFile File(strFilePath);
    if(!File.exists())
    {
        // Create Empty Password File
        try
        {
            File.open(QIODevice::WriteOnly);

            File.write(nullptr);

            File.close();
        }
        catch(QException *e)
        {
            return QString(e->what());
        }

        return tr("");
    }
    else
    {
        try
        {
            File.open(QIODevice::ReadOnly);

            QByteArray ByAryEncryptPassword = File.readLine();

            // Decrypt Password
            CAES AES("");
            QByteArray ByAryDecryptData = AES.DeCrypt(ByAryEncryptPassword);

            strPassword = ByAryDecryptData.toStdString().c_str();
            strPassword = strPassword.replace(" ", "", Qt::CaseSensitive);

            File.close();
        }
        catch(QException *e)
        {

        }
    }

    return strPassword;
}

bool CMainWindow::isExistSoundFile()
{
    // If Password File exist, then error.
    QString strFilePath = QCoreApplication::applicationDirPath() + QDir::separator() + tr("Shutdown.wav");

    QFile File(strFilePath);
    if(!File.exists())
    {
        return false;
    }

    return true;
}
