#include <QObject>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QImage>
#include <QDebug>
#include "pdfrenderer.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    PdfRenderer myPdfRenderer;

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    engine.addImageProvider(QLatin1String("pdfrenderer"), &myPdfRenderer);

    QObject *root = engine.rootObjects()[0];
    //QObject *main_qml = root->findChild<QObject*>("main");

    QObject::connect(root, SIGNAL(nextpage()),&myPdfRenderer, SLOT(nextPage()));
    QObject::connect(root, SIGNAL(prevpage()),&myPdfRenderer, SLOT(prevPage()));
    QObject::connect(root, SIGNAL(openfile(QUrl)),&myPdfRenderer, SLOT(OpenPDF(QUrl)));
    QObject::connect(&myPdfRenderer, SIGNAL(setPage(QVariant)),root, SLOT(qml_setPage(QVariant)));

    qDebug() << "App gestartet";
    return app.exec();
}
