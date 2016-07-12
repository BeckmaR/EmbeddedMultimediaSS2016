//#include <QDebug>

#include <QGuiApplication>
#include <QQmlApplicationEngine>

/* VON GALLERY
*/
#include <QQmlContext>
#include <QSettings>
#include <QQuickStyle>
/* VON GUI
*/
#include <QImage>
#include "pdfrenderer.h"





int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    QGuiApplication::setApplicationName("Presentao");
    QGuiApplication::setOrganizationName("Embedded_Multimedia");

    QSettings settings;
    QString style = QQuickStyle::name();
    if (!style.isEmpty())
        settings.setValue("style", style);
    else
        QQuickStyle::setStyle(settings.value("style").toString());



    QQmlApplicationEngine engine;
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));
    //engine.load(QUrl("qrc:/gallery.qml"));
    if (engine.rootObjects().isEmpty())
        return -1;

    PdfRenderer myPdfRenderer;
    engine.addImageProvider(QLatin1String("pdfrenderer"), &myPdfRenderer);//Neu , aber warum=????

    QObject *root = engine.rootObjects()[0];

    QObject::connect(root, SIGNAL(nextpage()),&myPdfRenderer, SLOT(nextPage()));
    QObject::connect(root, SIGNAL(prevpage()),&myPdfRenderer, SLOT(prevPage()));
    QObject::connect(root, SIGNAL(openfile(QString)),&myPdfRenderer, SLOT(OpenPDF(QString)));
    QObject::connect(&myPdfRenderer, SIGNAL(setPage(QVariant)),root, SLOT(qml_setPage(QVariant)));

    return app.exec();
}




