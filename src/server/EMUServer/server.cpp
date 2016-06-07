#include "server.h"
#include "QtWebSockets/QWebSocketServer"
#include "QtWebSockets/QWebSocket"

server::server(quint16 port, QObject *parent) :
    QObject(parent),
    m_pWebSocketServer(Q_NULLPTR),
    m_clients(),
    m_master()
{
    m_pWebSocketServer = new QWebSocketServer(QStringLiteral("PresentationServer"),
                                              QWebSocketServer::NonSecureMode,
                                              this);
    if(m_pWebSocketServer->listen(QHostAddress::Any, port))
    {
        connect(m_pWebSocketServer,
                &QWebSocketServer::newConnection,
                this,
                &server::onNewConnection);
    }
}
