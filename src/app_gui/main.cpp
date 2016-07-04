#include <QGuiApplication>
#include <QQmlApplicationEngine>
//Ein
#include <QImage>
//#include <QDebug>
#include "pdfrenderer.h"
//Aus
int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);//Alt und nicht im neuen
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    PdfRenderer myPdfRenderer;

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    engine.addImageProvider(QLatin1String("pdfrenderer"), &myPdfRenderer);//Neu , aber warum=????

    QObject *root = engine.rootObjects()[0];

    QObject::connect(root, SIGNAL(nextpage()),&myPdfRenderer, SLOT(nextPage()));
    QObject::connect(root, SIGNAL(prevpage()),&myPdfRenderer, SLOT(prevPage()));
    QObject::connect(root, SIGNAL(openfile(QUrl)),&myPdfRenderer, SLOT(OpenPDF(QUrl)));
    QObject::connect(&myPdfRenderer, SIGNAL(setPage(QVariant)),root, SLOT(qml_setPage(QVariant)));

    return app.exec();
}





