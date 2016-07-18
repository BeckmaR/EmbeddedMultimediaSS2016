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
    Timer.setInterval(2000);
    opencv_worker->setTimerPeriodms(2000);
    //thread.setPriority(QThread::InheritPriority);
    opencv_worker->moveToThread(&thread);
    connect(&Timer, SIGNAL(timeout()), opencv_worker, SLOT(PeriodTimer()));
    connect(&probe, SIGNAL(videoFrameProbed(QVideoFrame)), opencv_worker, SLOT(processFrame(QVideoFrame)));
}

void handcontrol::enable(int enable)
{
    if(enable) {
        //worker->prepareStart();
        thread.start();
        Timer.start();
        qDebug() << "handcontrol gestartet";
        if(camera)
        {
            camera->start();
        }
        emit debugMessage("handcontrol gestartet");
    } else {
        //worker->quit_signal = 1;
        thread.quit();
        Timer.stop();
        qDebug() << "handcontrol gestoppt";
        if(camera)
        {
            camera->stop();
        }
        emit debugMessage("handcontrol gestoppt");
    }
}


handcontrol::~handcontrol()
{
    thread.quit();
    delete(opencv_worker);
}
void handcontrol::setCamera(QCamera *qml_camera)
{
    if(probe.setSource(qml_camera))
    {
        qDebug() << "setSource geklappt";
        // Android
    }else {
        qDebug() << "setSource nicht geklappt";
        // Windows
        camera = new QCamera;
        camera->setViewfinder(opencv_worker);
    }
}

