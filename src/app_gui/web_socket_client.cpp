#include "web_socket_client.h"
#include <QWebSocket>

web_socket_client::web_socket_client(QObject *parent) : QObject(parent)
{
    isConnected = false;
    filePath = "Presentation.pdf";
}

void web_socket_client::connect(QString url)
{
    WebSock.open(url);
    QObject::connect(&WebSock, &QWebSocket::connected,this, onConnected);
}
void web_socket_client::onConnected()
{
    qDebug() << "Connection is";
    isConnected = true;
    QObject::connect(&WebSock, &QWebSocket::binaryMessageReceived,this, onBinaryMessage);
    QObject::connect(&WebSock, &QWebSocket::textMessageReceived,this, onTextMessage);
    emit connection_success();
}
void web_socket_client::sendFile(QString filename)
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
    WebSock.sendBinaryMessage(buffer);
}
void web_socket_client::registerMaster(QString password)
{
    if (isConnected){
        WebSock.sendTextMessage("RM:" + password);
    }
}
void web_socket_client::download_pdf(QString filename)
{
    if (isConnected){
        WebSock.sendTextMessage("DL:");
        filePath = filename;
    }
}
void web_socket_client::onTextMessage(QString message)
{
    QString command = message.left(2);
    QString payload = message.mid(3);
    if (command=="PN"){
        bool conversion;
       int pagenum = payload.toInt(&conversion);
       if(!conversion)
       {
           qDebug()<< message ;
           return;
       }else{
           emit signal_setPage(pagenum);
       }
    }
}
void web_socket_client::onBinaryMessage(QByteArray data)
{
    QFile file(filePath);
        if(file.open(QIODevice::WriteOnly))
        {
            file.write(data);
            file.close();
            emit OpenPDF(filePath); //nur zur Optik
        }
        else
        {
            qDebug() << "Could not open file 'presentation.pdf' for writing'";
    }
}
void web_socket_client::getPage()
{
    if (isConnected){
        WebSock.sendTextMessage("GP:");
    }
}
void web_socket_client::setPage(int)
{

}
