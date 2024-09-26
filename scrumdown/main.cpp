#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "configs_manager.h"
#include "ensemble.h"

int main(int argc, char * argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    qmlRegisterType<ConfigsManager>("scrumdown.utils", 1, 0, "ConfigsManager");
    qmlRegisterType<Ensemble>("scrumdown.utils", 1, 0, "Ensemble");

    auto exitOnCreationFailure{[url]
        (QObject *obj, const QUrl &objUrl)
        {
            if (!obj and url == objUrl) QCoreApplication::exit(-1);
        }
    };

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreated,
        &app, exitOnCreationFailure,
        Qt::QueuedConnection
    );
    engine.load(url);

    return app.exec();
}

