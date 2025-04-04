#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <Manager/SDR/SDRManager.h>
#include <Receiver/ADSB/ADSBReceiver.h>
#include <Manager/RTLManagerTest.h>
#include <QIcon>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    app.setWindowIcon(QIcon("qrc:/Resources/Image/ic_logo_launcher.png"));

    qmlRegisterSingletonType(QUrl("qrc:/UI/Navigation/Route.qml"), "Route", 1, 0, "Route");
    qmlRegisterSingletonType(QUrl("qrc:/Resources/Style/Style.qml"), "Style", 1, 0, "Style");
    qmlRegisterSingletonType(QUrl("qrc:/Resources/Font/Font.qml"), "Font", 1, 0, "Font");
    qmlRegisterSingletonType(QUrl("qrc:/UI/Component/Toolbar.qml"), "Toolbar", 1, 0, "Toolbar");

    SDRManager sdrManager;
    engine.rootContext()->setContextProperty("sdrManager", &sdrManager);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule("sdrlink", "App");

    return app.exec();
}
