#ifndef WEB_SOCKET_CLIENT_H
#define WEB_SOCKET_CLIENT_H

#include <QObject>

#include <QCoreApplication>
#include <QtWebSockets/QWebSocket>
#include <QFile>
#include <QByteArray>

class web_socket_client : public QObject
{
    Q_OBJECT
public:
    explicit web_socket_client(QObject *parent = 0);
private:
    QWebSocket WebSock;
    bool isConnected;
    QString filePath;
signals:
    void OpenPDF(QString);
    void signal_setPage(QVariant);
    void connection_success();
    void rm_success();

public slots:
    void connect(QString);
    void onConnected();
    void onBinaryMessage(QByteArray);
    void onTextMessage(QString);
    void sendFile(QString filename);
    void registerMaster(QString);
    void download_pdf(QString filename);
    void getPage();
    void setPage(QString page);
};

#endif // WEB_SOCKET_CLIENT_H
