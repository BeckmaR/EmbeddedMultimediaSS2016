#ifndef HANDCONTROL_H
#define HANDCONTROL_H

#include <QObject>
#include <QVariant>
#include <QThread>
#include <QVideoProbe>
#include <QCamera>
#include <QTimer>
#include "opencv2/opencv.hpp"

class OpenCV_Worker;
//class QMLRenderer;

class handcontrol : public QObject
{
    Q_OBJECT
    OpenCV_Worker *opencv_worker;
    QVideoProbe probe;
    QThread thread;
    QTimer Timer;
    QCamera *camera=0;

public:
    //explicit handcontrol(QObject *parent = 0);
    handcontrol();
    virtual ~handcontrol();
    void setCamera(QCamera *);

signals:
    void change_page(QVariant dir);
    void debugMessage(QVariant msg);
    void errorMessage(QVariant msg);
    void finished(QObject *result);
public slots:
    void enable(int);

};

#endif // HANDCONTROL_H
