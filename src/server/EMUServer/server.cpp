#include "server.h"
#include <QtCore/QObject>
#include <QtCore/QList>
#include <QtCore/QFile>
#include <QtCore/QByteArray>
#include <QtCore/QString>
#include "QtWebSockets/QWebSocketServer"
#include "QtWebSockets/QWebSocket"

QT_USE_NAMESPACE

server::server(quint16 port, QObject *parent) :
    QObject(parent),
    m_pWebSocketServer(new QWebSocketServer(QStringLiteral("PresentationServer"),
                                            QWebSocketServer::NonSecureMode,
                                            this)),
    m_clients(),
    m_master()
{
    if(m_pWebSocketServer->listen(QHostAddress::Any, port))
    {
        connect(m_pWebSocketServer,
                &QWebSocketServer::newConnection,
                this,
                &server::onNewConnection);
    }

    m_master = Q_NULLPTR;
    pdfpage = -1;
    QFile pdffile();
}

server::~server()
{
    m_pWebSocketServer->close();
    qDeleteAll(m_clients.begin(), m_clients.end());
}

void server::onNewConnection()
{
    QWebSocket *pSocket = m_pWebSocketServer->nextPendingConnection();

    connect(pSocket, &QWebSocket::textMessageReceived, this, &server::processMessage);
    connect(pSocket, &QWebSocket::binaryMessageReceived, this, &server::processBinary);
    connect(pSocket, &QWebSocket::disconnected, this, &server::socketDisconnected);

    m_clients << pSocket;
}

void server::processMessage(QString message)
{
    bool is_master = false;
    QString masterpassword = "mpw12345";
    QWebSocket *pSender = qobject_cast<QWebSocket *>(sender());

    if(m_master != Q_NULLPTR && pSender == m_master)
    {
        is_master = true;
    }

    /*
     * All commands to the server should be in the following Format:
     * CC:PPPPPPP....PPPP
     * With CC being exactly two chars command, and PP...PPP a payload, whatever the size. The : is important.
     */

    QString command = message.left(2);
    QString payload = message.mid(3);

    if(QString(message[2]) != ":")
    {
        pSender->sendTextMessage("BADCMD");
        return;
    }

    if(command == "RM") // Register as master, with master password as payload. Yeah, super secure.
    {
            if(m_master == Q_NULLPTR && payload == masterpassword)
            {
                m_master = pSender;
                m_master->sendTextMessage("ACK");
            }
            else if(payload != masterpassword)
            {
                pSender->sendTextMessage("BADPW");
            }
            else
            {
                pSender->sendTextMessage("MASTERISSET");
            }
    }
    else if(command == "SP") // Set page. Rejected if client is not the master.
    {
            if(is_master)
            {
                bool conversion;
                int pagenum = payload.toInt(&conversion);
                if(!conversion)
                {
                    pSender->sendTextMessage("BADPAGENUM");
                    return;
                }
                if(setpdfpage(pagenum))
                {
                    broadcast(message); // send pagenumber to all connected clients
                }
            }
            else
            {
                pSender->sendTextMessage("NOTALLOWED");
            }
    }
    else if(command == "GP") // return current pdf page, useful after pdf was downloaded
    {
        pSender->sendTextMessage(QString("PN:%1").arg(getpdfpage()));
    }
    else if(command == "DL") // Download pdf presentation. Will return BINARY message with pdf file contents, or whatever master uploaded.
    {
        if(!pdfcontents.isEmpty())
        {
            pSender->sendBinaryMessage(pdfcontents);
        }
        else
        {
            pSender->sendTextMessage("NOFILE");
        }
    }
    else if(command == "UL") // Ask if Upload is possible. Currently only checks if pSender is the master.
    {
        if(is_master)
        {
            pSender->sendTextMessage("ACK");
        }
        else
        {
            pSender->sendTextMessage("NOTALLOWED");
        }
    }
    else // No command found
    {
        pSender->sendTextMessage("BADCMD");
    }
}

void server::processBinary(QByteArray message)
{
    QWebSocket *pSender = qobject_cast<QWebSocket *>(sender());

    if(m_master != Q_NULLPTR && pSender == m_master)
    {
        setpdf(savepdf(message));
        pdfcontents = message;
        pSender->sendTextMessage("ACK");
        broadcast("PDFAVAILABLE");
        pdfpage = 1;
    }
    else
    {
        pSender->sendTextMessage("NOTALLOWED");
    }
}

void server::socketDisconnected()
{
    QWebSocket *pClient = qobject_cast<QWebSocket *>(sender());
    if (pClient)
    {
        m_clients.removeAll(pClient);
        pClient->deleteLater();
        if(m_master != Q_NULLPTR && pClient == m_master)
        {
            m_master = Q_NULLPTR;
            pdfpage = -1;
            pdfcontents = QByteArray();
            pdffile->close();
            broadcast("CANCELPRESENTATION");
        }
    }
}

bool server::setpdfpage(int pagenum)
{
    pdfpage = pagenum;
    return true;
}

int server::getpdfpage()
{
    return pdfpage;
}

void server::broadcast(QString message)
{
    Q_FOREACH (QWebSocket *pClient, m_clients)
    {
        pClient->sendTextMessage(message);
    }
}

QFile* server::savepdf(QByteArray)
{
    pdffile = new QFile();
    return pdffile;
}

void server::setpdf(QFile* file)
{
    pdffile = file;
}
