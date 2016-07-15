#include <QDebug>
#include <QObject>
#include <QString>
#include <QThread>
//#include "QMLRenderer.h"
#include <QCamera>
#include "handcontrol.h"
#include "opencv_worker.h"

//using namespace cv;

handcontrol::handcontrol()/*(QObject *parent) : public QAbstractVideoFilter(parent)*/
{
    opencv_worker = new OpenCV_Worker(this);
    //camera->setCaptureMode(QCamera::CaptureViewfinder);
    //worker->setHandcontrolPtr(this);
    opencv_worker->moveToThread(&thread);
    QObject::connect(&probe, SIGNAL(videoFrameProbed(QVideoFrame)), opencv_worker, SLOT(processFrame(QVideoFrame)));
    thread.start();

}

void handcontrol::enable(int enable)
{
    if(enable) {
        //worker->prepareStart();
        thread.start();
        qDebug() << "handcontrol gestartet";
        emit debugMessage("handcontrol gestartet");
    } else {
        //worker->quit_signal = 1;
        thread.quit();
        qDebug() << "handcontrol gestoppt";
        emit debugMessage("handcontrol gestoppt");
    }
}


handcontrol::~handcontrol()
{
    thread.quit();
    delete(opencv_worker);
}
void handcontrol::setCamera(QCamera *camera)
{
    if(probe.setSource(camera))
    {
        qDebug() << "setSource geklappt";
    }else {
        qDebug() << "setSource nicht geklappt";
    }
}

