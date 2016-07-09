#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QObject>
#include "handcontrol.h"
//#include "test_handcontrol.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    //test_handcontrol mytest_handcontrol;
    handcontrol myhandcontrol;
    //char video_name[] = "test.mp4";
    //mytest_handcontrol.openFile(video_name);

    engine.load(QUrl(QStringLiteral("qrc:/main_handcontrol.qml")));

    QObject *root = engine.rootObjects()[0];
    //root->setProperty("frame_count", mytest_handcontrol.getNrOfFrames());
    QObject::connect(root, SIGNAL(handcontrol_enable(int)),&myhandcontrol, SLOT(enable(int)));
    QObject::connect(&myhandcontrol, SIGNAL(debugMessage(QVariant)),root, SLOT(print_debugMessage(QVariant)));
    QObject::connect(&myhandcontrol, SIGNAL(errorMessage(QVariant)),root, SLOT(print_errorMessage(QVariant)));
    QObject::connect(&myhandcontrol, SIGNAL(change_page(QVariant)),root, SLOT(count_page(QVariant)));

    //engine.addImageProvider(QLatin1String("test_handcontrol"), &mytest_handcontrol);

    return app.exec();
}
