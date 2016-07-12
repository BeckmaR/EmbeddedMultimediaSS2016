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
    //opencv_worker->moveToThread(&thread);
    //connect(&_1msTimer, SIGNAL(timeout()), opencv_worker, SLOT(One_sec_Timer()));
    connect(&probe, SIGNAL(videoFrameProbed(QVideoFrame)), opencv_worker, SLOT(processFrame(QVideoFrame)));
}

void handcontrol::enable(int enable)
{
    if(enable) {
        //worker->prepareStart();
        thread.start();
        //_1msTimer.start(1000);
        qDebug() << "handcontrol gestartet";
        emit debugMessage("handcontrol gestartet");
    } else {
        //worker->quit_signal = 1;
        thread.quit();
        //_1msTimer.stop();
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
        // Android
    }else {
        qDebug() << "setSource nicht geklappt";
        // Windows
        //camera->setViewfinder(opencv_worker);
    }
}

