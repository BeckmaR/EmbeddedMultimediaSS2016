#ifndef PDFRENDERER_H
#define PDFRENDERER_H

#include <QObject>
#include <QQuickImageProvider>
#include <QByteArray>
#include "../../thirdparty/mupdf-qt/include/mupdf-qt.h"

class PdfRenderer : public QObject, public QQuickImageProvider
{
    Q_OBJECT

public:
    explicit PdfRenderer();
    virtual QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize);

signals:
    void setPage(QVariant nr);

public slots:
    void prevPage();
    void nextPage();
    void OpenPDF(QString filepath);
    void savePDF(QByteArray data);
    void slot_setPage(int pagenum);

private:
    void updatePage();

    MuPDF::Document *m_doc = 0;
    MuPDF::Page *m_page = 0;
    QString m_title;
    int m_numPages;
    int m_index;
};

#endif // PDFRENDERER_H
