#ifndef SERVER_H
#define SERVER_H


class server : public QObject
{
    Q_OBJECT
public:
    explicit ChatServer(quint16 port, QObject *parent = Q_NULLPTR);
    virtual ~ChatServer();

private Q_SLOTS:
    void onNewConnection();
    void processMessage(QString message);
    void socketDisconnected();

private:
    QWebSocketServer *m_pWebSocketServer;
    QList<QWebSocket *> m_clients;

    QWebSocket* m_master;
};

#endif // SERVER_H
