#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QObject>
#include "handcontrol.h"
#include "test_handcontrol.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    test_handcontrol mytest_handcontrol;

    char video_name[] = "test.mp4";
    mytest_handcontrol.openFile(video_name);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    QObject *root = engine.rootObjects()[0];
    root->setProperty("frame_count", mytest_handcontrol.getNrOfFrames());

    engine.addImageProvider(QLatin1String("test_handcontrol"), &mytest_handcontrol);

    return app.exec();
}
