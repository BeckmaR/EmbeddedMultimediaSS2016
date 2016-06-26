#ifndef TEST_HANDCONTROL_H
#define TEST_HANDCONTROL_H

#include <QObject>
#include <QQuickImageProvider>
#include "opencv2/opencv.hpp"

class test_handcontrol : public QObject, public QQuickImageProvider
{
    Q_OBJECT
    cv::VideoCapture *cap;
    int frame_count=0;

public:
    explicit test_handcontrol(QObject *parent = 0);
    ~test_handcontrol();
    void openFile(QString);
    int getNrOfFrames();
    QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize);

signals:

public slots:
};

#endif // TEST_HANDCONTROL_H
