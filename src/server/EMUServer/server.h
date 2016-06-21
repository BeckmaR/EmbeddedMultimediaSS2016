#ifndef SERVER_H
#define SERVER_H

#include <QtCore/QObject>
#include <QtCore/QList>
#include <QtCore/QFile>
#include <QtCore/QByteArray>
#include <QtCore/QString>

QT_FORWARD_DECLARE_CLASS(QWebSocketServer)
QT_FORWARD_DECLARE_CLASS(QWebSocket)

class server : public QObject
{
    Q_OBJECT
public:
    explicit server(quint16 port, QObject *parent = Q_NULLPTR);
    virtual ~server();
    int getpdfpage();
    QFile getpdf();

private:
    bool setpdfpage(int pagenum);
    void broadcast(QString message);
    void setpdf(QFile* pdf);
    QFile* savepdf(QByteArray data);


    QWebSocketServer *m_pWebSocketServer;
    QList<QWebSocket *> m_clients;

    QWebSocket* m_master;

    int pdfpage;
    QFile* pdffile;
    QByteArray pdfcontents;


private Q_SLOTS:
    void onNewConnection();
    void processMessage(QString message);
    void processBinary(QByteArray message);
    void socketDisconnected();
};

#endif // SERVER_H
