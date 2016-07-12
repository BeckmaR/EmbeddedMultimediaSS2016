#include <QCoreApplication>
#include <QtWebSockets/QWebSocket>
#include <QFile>
#include <QByteArray>
#include <QTime>

void onConnected();
void registerAsMaster();

static QWebSocket websock;

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    websock.open(QUrl(QStringLiteral("ws://localhost:1234")));

    QObject::connect(&websock, &QWebSocket::connected, onConnected);

    /*
    qDebug() << "Opened WebSocket";

    if(!websock.isValid())
    {
        qDebug() << websock.errorString();
    }

    QTime t0 = QTime::currentTime().addSecs(1);

    while(QTime::currentTime() < t0)
    {}


    websock.sendTextMessage("RM:mpw12345"); //register as master

    qDebug() << "Sent Message";
    */



    return a.exec();
}

void onConnected()
{
    qDebug() << "Finally";

    if(!websock.isValid())
    {
        qDebug() << "Something went wrong";
    }
    else
    {
        qDebug() << "Everything's fine.";
        websock.sendTextMessage("FUBAR: Fucked Up Beyond All Recognition.");
        registerAsMaster();
    }
}

void registerAsMaster()
{
    websock.sendTextMessage("RM:mpw12345");
}
