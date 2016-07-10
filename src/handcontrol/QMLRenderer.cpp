
#include <QThread>
#include <QDebug>
#include "handcontrol.h"
#include "QMLRenderer.h"
#include "opencv_worker.h"
#include "opencv2/opencv.hpp"
using namespace cv;

QMLRenderer::QMLRenderer(handcontrol *parent,OpenCV_Worker *slot)
{
    p_handcontrol = parent;
    p_opencv_worker = slot;
}


QVideoFrame QMLRenderer::run(QVideoFrame *input, const QVideoSurfaceFormat &surfaceFormat, RunFlags flags)
{
    if (input->isValid()) {
        //qDebug() << input->pixelFormat();
        //emit p_handcontrol->debugMessage("AbstractVideoBuffer: " + QString::number(input->pixelFormat()));
        if(input->map(QAbstractVideoBuffer::ReadOnly))
        {
            Mat cv_temp_frame(input->height(),input->width(),CV_8UC4,(void *) input->bits(),input->bytesPerLine());
//            //cvtColor(cv_temp_frame, frame_gray,CV_RGB2GRAY);
//            //frame_gray = Mat::zeros(300, 300, CV_8UC1);
//            //cv_temp_frame.copyTo(current_frame);
            qDebug() << "input->bits(): "<< *input->bits();
            qDebug() << "height:" << input->height() << "width:" << input->width();
            emit p_handcontrol->errorMessage("height:" + QString::number(input->height()) + "width:" + QString::number(input->width()));
            p_opencv_worker->current_frame = cv_temp_frame.clone();
            input->unmap();
            //emit p_handcontrol->debugMessage("Mat kopiert");
            //current_frame =  Mat(temp_frame.height(),temp_frame.width(),CV_8UC4,(void *) temp_frame.bits(),temp_frame.bytesPerLine());
            //qDebug() << "temp_frame.bits(): "<< temp_frame.bits();

            //imshow("test Frames",orginal_frame);
            //waitKey(0);
            //qDebug() << "orginal_frame:" << orginal_frame.data;

            emit sendFrame(input->pixelFormat());
        } else {
            qDebug() << "Kann AbstractVideoBuffer nicht mappen";
            emit p_handcontrol->errorMessage("Kann AbstractVideoBuffer nicht mappen: " + input->pixelFormat());
        }
    } else {
        qDebug()<< __FILE__ << __LINE__ << "Frame konnte nicht gelesen werden";
        emit p_handcontrol->errorMessage("Camera Frame konnte nicht gelesen werden");
    }

    return *input;
}

