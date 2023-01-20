#include "CWorkerThread.h"

CWorkerThread::CWorkerThread(QObject *parent) : QObject(parent)
{

}

void CWorkerThread::Shutdown([[maybe_unused]] QString strPassword, int iShutdownID)
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

//    QStringList args = {};
//    if(iShutdownID == 0)
//    {
//        args = QStringList() << tr("-c") << tr("echo ") + strPassword + tr(" | sudo -S shutdown -h now");
//    }
//    else
//    {
//        args = QStringList() << tr("-c") << tr("echo ") + strPassword + tr(" | sudo -S shutdown -r now");
//    }
//    QProcess::startDetached(tr("/bin/sh"), args);

    QDBusConnection bus = QDBusConnection::systemBus();
    if (!bus.isConnected())
    {
        qFatal("Cannot connect to the D-Bus session bus.");
        return;
    }

    QDBusMessage message;
    switch(iShutdownID)
    {
    case 0: // Shutdown
        message = QDBusMessage::createMethodCall("org.freedesktop.login1",
                                                 "/org/freedesktop/login1",
                                                 "org.freedesktop.login1.Manager", QLatin1String("CanPowerOff"));
        break;
    case 1:
        message = QDBusMessage::createMethodCall("org.freedesktop.login1",
                                                 "/org/freedesktop/login1",
                                                 "org.freedesktop.login1.Manager", QLatin1String("CanReboot"));
        break;
    default:
        return;
    }

    // Send a message to DBus.
    QDBusMessage replyStatus = QDBusConnection::systemBus().call(message);

    // Receive the return value (including arguments) from the D-Bus reply.
    // The methods have 1 argument, so check them.
    if (replyStatus.type() == QDBusMessage::ReplyMessage && replyStatus.arguments().size() == 1)
    {
        // the reply can be anything, receive a string ("yes" or "no").
        QString strReply = replyStatus.arguments().at(0).toString();
        if (strReply == "yes" && iShutdownID == 0)
        {
            message = QDBusMessage::createMethodCall("org.freedesktop.login1",
                                                     "/org/freedesktop/login1",
                                                     "org.freedesktop.login1.Manager", QLatin1String("PowerOff"));
        }
        else if (strReply == "yes" && iShutdownID == 1)
        {
            message = QDBusMessage::createMethodCall("org.freedesktop.login1",
                                                     "/org/freedesktop/login1",
                                                     "org.freedesktop.login1.Manager", QLatin1String("Reboot"));

//            message = QDBusMessage::createSignal("/org/freedesktop/login1","org.freedesktop.login1.Manager","PrepareForShutdown");

//            QList<QVariant> ArgsToDBusService;
//            ArgsToDBusService << QVariant::fromValue(true);
//            message.setArguments(ArgsToDBusService);

//            if(QDBusConnection::systemBus().send(message))
//            {
//                qDebug() << "yes i can send the pong signal and see with dbus --monitor";
//            }
        }

        // Method in a helper file has 1 argument, enter the argument.
        QList<QVariant> ArgsToDBusService;
        ArgsToDBusService << QVariant::fromValue(true);
        message.setArguments(ArgsToDBusService);

        // Send a message to DBus.
        QDBusMessage reply = QDBusConnection::systemBus().call(message);
    }
    else
    {
        return;
    }


    emit result();

    return;
}
