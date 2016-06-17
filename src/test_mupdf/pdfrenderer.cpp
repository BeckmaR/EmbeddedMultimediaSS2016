#include <QDebug>
#include <QUrl>
#include "pdfrenderer.h"

PdfRenderer::PdfRenderer() : QQuickImageProvider(QQuickImageProvider::Image)
{

}

void PdfRenderer::prevPage(void)
{
    //qDebug() << "PDF prev Page";
    if (NULL == m_doc) {
        return;
    }
    if (m_index > 0) {
        --m_index;
    }
    //openPage(m_index);
    setPage(m_index);
}

void PdfRenderer::nextPage(void)
{
    //qDebug() << "PDF next Page";
    if (NULL == m_doc) {
        return;
    }
    if (m_index < m_numPages - 1) {
        ++m_index;
    }
    //openPage(m_index);
    setPage(m_index);
}

void PdfRenderer::OpenPDF(const QUrl &url)
{
    qDebug() << "Url: " << url;
    if (m_doc) {
        delete m_doc;
        m_doc = NULL;
    }
    QString filepath = url.toLocalFile();
    m_doc = MuPDF::loadDocument(filepath);
    if (NULL == m_doc) {
        qDebug() << "PDF konnte nicht geöffnet werden";
        return;
    }
    m_title = m_doc->title();
    m_numPages = m_doc->numPages();

    m_index = 0;
    //openPage(0);
    setPage(m_index);

}

QImage PdfRenderer::requestImage(const QString &id, QSize *size, const QSize &requestedSize)
{
    QImage image;
    if (m_page) {
        delete m_page;
        m_page = NULL;
    }
    int index = id.toInt();
    if (index == -1) {
        return image;
    }
    m_page = m_doc->page(index);
    if (NULL == m_page) {
        return image;
    }
    image = m_page->renderImage(1, 1);
    return image;
}
