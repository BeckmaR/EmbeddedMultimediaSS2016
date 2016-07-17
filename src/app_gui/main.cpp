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
#include "web_socket_client.h"


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

    web_socket_client websocketclient;

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


    /*
     * signals from web_socket_client
     * void OpenPDF(QString)
     * void signal_setPage(int)
     * void connection_success()
    */

    QObject::connect(&websocketclient, SIGNAL(OpenPDF(QString)),
                     &myPdfRenderer, SLOT(OpenPDF(QString)));
    QObject::connect(&websocketclient, SIGNAL(signal_setPage(QVariant)),
                                            root, SLOT(qml_setPage(QVariant)));
    QObject::connect(&websocketclient, SIGNAL(connection_success()),
                     root, SLOT(connection_success()));

    /*
     * slots of web_socket_client
     * void connect(QString)
     * void onConnected()
     * void onBinaryMessage(QByteArray)
     * void onTextMessage(QString)
     * void sendFile(QString filename)
     * void registerMaster(QString)
     * void download_pdf(QString filename)
     * void getPage()
     * void setPage(QString)
     */

    QObject::connect(root, SIGNAL(connect(QString)),
                     &websocketclient, SLOT(connect(QString)));
    QObject::connect(root, SIGNAL(registerMaster(QString)),
                     &websocketclient, SLOT(registerMaster(QString)));
    QObject::connect(root, SIGNAL(sendFile(QString)),
                     &websocketclient, SLOT(sendFile(QString)));
    QObject::connect(root, SIGNAL(download_pdf(QString)),
                     &websocketclient, SLOT(download_pdf(QString)));
    QObject::connect(root, SIGNAL(setPage(QString)),
                     &websocketclient, SLOT(setPage(QString)));
    QObject::connect(root, SIGNAL(getPage()),
                     &websocketclient, SLOT(getPage()));
    return app.exec();
}




