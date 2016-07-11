#include <QObject>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QImage>
#include <QDebug>
#include "pdfrenderer.h"
#include "server.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    PdfRenderer myPdfRenderer;

    server pdfServer(1234);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    engine.addImageProvider(QLatin1String("pdfrenderer"), &myPdfRenderer);

    QObject *root = engine.rootObjects()[0];
    //QObject *main_qml = root->findChild<QObject*>("main");

    QObject::connect(&pdfServer, SIGNAL(pdfReceived(QByteArray)), &myPdfRenderer, SLOT(savePDF(QByteArray)));
    QObject::connect(&pdfServer, SIGNAL(pdfPageChanged(int)), &myPdfRenderer, SLOT(slot_setPage(int)));
    QObject::connect(&myPdfRenderer, SIGNAL(setPage(QVariant)),root, SLOT(qml_setPage(QVariant)));

    qDebug() << "App gestartet";
    return app.exec();
}
