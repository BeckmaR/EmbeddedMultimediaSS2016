#include <QDebug>
#include <QUrl>
#include "pdfrenderer.h"

PdfRenderer::PdfRenderer() : QQuickImageProvider(QQuickImageProvider::Image)
{
    m_doc = 0;
    m_page = 0;
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

void PdfRenderer::OpenPDF(QUrl url)
{
    QString filepath = url.toLocalFile();
    qDebug() << "Attempting to open1 " + filepath;
    m_doc = MuPDF::loadDocument(filepath);
    qDebug() << "Attempting to open2 " + filepath;
    if (NULL == m_doc) {
        qDebug() << "PDF konnte nicht geöffnet werden";
        return;
    }
    qDebug() << "Attempting to open3 " + filepath;
    m_title = m_doc->title();
    m_numPages = m_doc->numPages();

    m_index = 0;
    //openPage(0);
    setPage(m_index);
}


QImage PdfRenderer::requestImage(const QString &id, QSize *size, const QSize &requestedSize)
{
    QImage image;

    //qDebug() << "req width: " << requestedSize.width() << "req height: " << requestedSize.height();
//    if (size != 0)
//    {
//        qDebug() << "width: " << size->width() << "height: " << size->height();
//        //*size = QSize(100, 100);
//    }
    if (m_page) {
        delete m_page;
        m_page = NULL;
    }
    int index = id.toInt();
    if (index == -1) {
        return image;
    }
    m_page = m_doc->page(index);
    QSizeF pdf_size = m_page->size();
    //qDebug() << "image size: " << pdf_size;
    float ratio = requestedSize.width()/pdf_size.width();
    if(ratio < 1)
    {
        ratio = 1;
    }
    if (NULL == m_page) {
        return image;
    }
    image = m_page->renderImage(ratio, ratio);
    //qDebug() << "image width: " << image.width() << "image height: " << image.height();
    if(size)
    {
        size->setHeight(image.height());
        size->setWidth(image.width());
        //qDebug() << "size gesetzt";
    }
    return image;
}
