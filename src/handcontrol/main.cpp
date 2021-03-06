#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QObject>
#include <QCamera>
#include "handcontrol.h"
#include "test_handcontrol.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    //test_handcontrol mytest_handcontrol;
    handcontrol myhandcontrol;
    //char video_name[] = "test.mp4";
    //mytest_handcontrol.openFile(video_name);
    //qmlRegisterType<handcontrol>("handcontrol", 1, 0, "Handcontrol");
    engine.load(QUrl(QStringLiteral("qrc:/main_handcontrol.qml")));

    QObject *root = engine.rootObjects()[0];
    QObject *cameraComponent = root->findChild<QObject*>("camera");
    QCamera *camera = qvariant_cast<QCamera*>(cameraComponent->property("mediaObject"));
    myhandcontrol.setCamera(camera);

    //myhandcontrol.setQMLCamera(qmlCamera);
    //root->setProperty("frame_count", mytest_handcontrol.getNrOfFrames());
    QObject::connect(root, SIGNAL(handcontrol_enable(int)),&myhandcontrol, SLOT(enable(int)));
    QObject::connect(&myhandcontrol, SIGNAL(debugMessage(QVariant)),root, SLOT(print_debugMessage(QVariant)));
    QObject::connect(&myhandcontrol, SIGNAL(errorMessage(QVariant)),root, SLOT(print_errorMessage(QVariant)));
    QObject::connect(&myhandcontrol, SIGNAL(change_page(QVariant)),root, SLOT(count_page(QVariant)));

    //engine.addImageProvider(QLatin1String("test_handcontrol"), &mytest_handcontrol);
    qDebug()<<"From main thread: "<<QThread::currentThreadId();
    return app.exec();
}
