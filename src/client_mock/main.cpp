#include <QCoreApplication>
#include <QtWebSockets/QWebSocket>
#include <QFile>
#include <QByteArray>
#include <QTime>

void onConnected();
void OnMessageReceived(QString);
void registerAsMaster();
void sendFile(QString);

static QWebSocket websock;

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    websock.open(QUrl(QStringLiteral("ws://localhost:1234")));

    QObject::connect(&websock, &QWebSocket::connected, onConnected);
    QObject::connect(&websock, &QWebSocket::textMessageReceived, OnMessageReceived);

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
        websock.sendTextMessage("This is a test message and not a command.");
        registerAsMaster();
        sendFile("../../theoryoffun.pdf");
    }
}

void registerAsMaster()
{
    websock.sendTextMessage("RM:mpw12345");
}

void sendFile(QString filename)
{
    QFile file(filename);
    QByteArray buffer;
    if(!file.open(QIODevice::ReadOnly))
    {
        qDebug() << "Could not open file";
        qDebug() << file.errorString();
        return;
    }
    buffer = file.readAll();
    file.close();
    websock.sendBinaryMessage(buffer);
}

void OnMessageReceived(QString message)
{
    qDebug() << message;
}
