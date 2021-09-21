#include "CWorkerThread.h"

CWorkerThread::CWorkerThread(QObject *parent) : QObject(parent)
{

}

void CWorkerThread::Shutdown(QString strPassword, int iShutdownID)
{
    // Play Shutdown's Sound. Wait until playback is finished.
    QString strFilePath = QCoreApplication::applicationDirPath() + QDir::separator() + tr("Shutdown.wav");
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

    QStringList args = {};
    if(iShutdownID == 0)
    {
        args = QStringList() << tr("-c") << tr("echo ") + strPassword + tr(" | sudo -S shutdown -h now");
    }
    else
    {
        args = QStringList() << tr("-c") << tr("echo ") + strPassword + tr(" | sudo -S shutdown -r now");
    }
    QProcess::startDetached(tr("/bin/sh"), args);

    emit result();

    return;
}
