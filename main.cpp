﻿#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include "CMainWindow.h"


int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    // Trying to close the Lock File, if the attempt is unsuccessful for 100 milliseconds,
    // then there is a Lock File already created by another process.
    // Therefore, we throw a warning and close the program
    QLockFile lockFile(QDir::temp().absoluteFilePath("PoweroffQML.lock"));

    if(!lockFile.tryLock(100))
    {
        return 1;
    }

    // Set PoweroffQML's Icon
    app.setWindowIcon(QIcon(":/PoweroffQML.svg"));

    // メイン画面のコア処理
    qmlRegisterType<CMainWindow>("MainWindow", 1, 0, "CMainWindow");

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));   
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
