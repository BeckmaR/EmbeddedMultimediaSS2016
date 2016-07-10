#ifndef HANDCONTROL_H
#define HANDCONTROL_H

#include <QObject>
#include <QVariant>
#include <QThread>
#include <QAbstractVideoFilter>
#include <QVideoFilterRunnable>
#include "opencv2/opencv.hpp"

class OpenCV_Worker;
class QMLRenderer;

class handcontrol : public QAbstractVideoFilter
{
    Q_OBJECT
    OpenCV_Worker *opencv_worker;
    QThread thread;

public:
    //explicit handcontrol(QObject *parent = 0);
    handcontrol();
    virtual ~handcontrol();
    QVideoFilterRunnable * createFilterRunnable();

signals:
    void change_page(QVariant dir);
    void debugMessage(QVariant msg);
    void errorMessage(QVariant msg);
    void finished(QObject *result);
public slots:
    void enable(int);

};

#endif // HANDCONTROL_H
