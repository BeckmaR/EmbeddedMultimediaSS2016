#include "opencv_worker.h"
#include "handcontrol.h"
#include <QDebug>

using namespace cv;

OpenCV_Worker::OpenCV_Worker(handcontrol *parent)
{
    p_handcontrol = parent;
    QObject::connect(this, SIGNAL(sendFrame(QVideoFrame::PixelFormat)), this, SLOT(AnalyzeFrame(QVideoFrame::PixelFormat)));
}

void OpenCV_Worker::setTimerPeriodms(int period_ms)
{
    timer_period_ms = period_ms;
}

bool OpenCV_Worker::present(const QVideoFrame &frame)
{
    processFrame(frame);
    return true;
}

void OpenCV_Worker::processFrame(const QVideoFrame &frame) {

    time.start();
    QVideoFrame temp_frame(frame);
    if (temp_frame.isValid()) {
        //qDebug() << input->pixelFormat();
        //emit p_handcontrol->debugMessage("AbstractVideoBuffer: " + QString::number(input->pixelFormat()));
        if(temp_frame.map(QAbstractVideoBuffer::ReadOnly))
        {

            if(temp_frame.pixelFormat() == QVideoFrame::Format_RGB32) {
                Mat cv_temp_frame(temp_frame.height(),temp_frame.width(),CV_8UC4,(void *) temp_frame.bits(),temp_frame.bytesPerLine());
                current_frame = cv_temp_frame.clone();
            } else if(temp_frame.pixelFormat() == QVideoFrame::Format_NV21) {
                Mat cv_temp_frame(temp_frame.height(),temp_frame.width(),CV_8UC1,(void *) temp_frame.bits(),temp_frame.bytesPerLine());
                resize(cv_temp_frame,frame_gray,Size(640,480),0,0,INTER_NEAREST);
                //frame_gray = cv_temp_frame.clone();
            }
            if(firstFrame)
            {
                emit p_handcontrol->debugMessage("orginal frame: height: " + QString::number(temp_frame.height()) + " width: " + QString::number(temp_frame.width()));
            }

            //Mat cv_temp_frame(temp_frame.height(),temp_frame.width(),CV_8UC4,(void *) temp_frame.bits(),temp_frame.bytesPerLine());
            //emit p_handcontrol->errorMessage("height:" + QString::number(temp_frame.height()) + "width:" + QString::number(temp_frame.width()));
            //current_frame = cv_temp_frame.clone();

            //qDebug() << "height:" << temp_frame.height() << "width:" << temp_frame.width() << "bytesPerline: " << temp_frame.bytesPerLine();
            //qDebug() << *temp_frame.bits();

            temp_frame.unmap();
            //emit p_handcontrol->debugMessage("Mat kopiert");
            //current_frame =  Mat(temp_frame.height(),temp_frame.width(),CV_8UC4,(void *) temp_frame.bits(),temp_frame.bytesPerLine());
            //qDebug() << "temp_frame.bits(): "<< temp_frame.bits();

            //imshow("test Frames",orginal_frame);
            //waitKey(0);
            //qDebug() << "orginal_frame:" << orginal_frame.data;

            emit sendFrame(temp_frame.pixelFormat());
        } else {
            qDebug() << "Kann AbstractVideoBuffer nicht mappen";
            emit p_handcontrol->errorMessage("Kann AbstractVideoBuffer nicht mappen: " + temp_frame.pixelFormat());
        }
    } else {
        qDebug()<< __FILE__ << __LINE__ << "Frame konnte nicht gelesen werden";
        emit p_handcontrol->errorMessage("Camera Frame konnte nicht gelesen werden");
    }
    //qDebug() << " in map part";

}
void OpenCV_Worker::PeriodTimer()
{
    int Framerate_per_sec = (Frame_counter*1000)/timer_period_ms;
    emit p_handcontrol->debugMessage("Framerate per sec: " + QString::number(Framerate_per_sec));
    emit p_handcontrol->debugMessage("Time for AnalyseFrame: " + QString::number(time_elapse/Framerate_per_sec));
    Frame_counter = 0;
    time_elapse = 0;
}

void OpenCV_Worker::AnalyzeFrame(QVideoFrame::PixelFormat pixelFormat) {
    //p_handcontrol->debugMessage("AnalyzeFrame");
    //qDebug()<< __FILE__ << __LINE__  << "thread: "<< QThread::currentThreadId();
    if(pixelFormat == QVideoFrame::Format_RGB32) {
        cvtColor(current_frame, frame_gray,CV_RGB2GRAY);
    } else if(pixelFormat == QVideoFrame::Format_NV21) {
        // Nothing to do, we take only the Y Line
       // cvtColor(current_frame, frame_gray,CV_YUV2BGR_NV21);
    } else {
        p_handcontrol->errorMessage("Nicht unterstütztes Format => QVideoFrame::PixelFormat" + QString::number(pixelFormat));
    }
    if(firstFrame)
    {
        firstFrame = 0;
        frame_count = 0;
        dir_count = 0;
        emit p_handcontrol->debugMessage("thread: " + QString::number((int) QThread::currentThreadId()));
        emit p_handcontrol->debugMessage("frame_gray: height: " + QString::number(frame_gray.rows) + " width: " + QString::number(frame_gray.cols));
        qDebug() << "PixelFormat:" << pixelFormat;
    } else {
        frame_sub = frame_gray - prev_frame;
        reduce(frame_sub,hist,0,CV_REDUCE_AVG);
        //Point maxIdx;
        //minMaxLoc(hist,0,0,0,&maxIdx);
        int hist_sum =0;
        int hist_max =0;
        for(int i=0; i<hist.cols;++i)
        {
            int value = hist.at<uchar>(i);
            hist_sum += value;
            if (value > hist_max)
            {
                hist_max = value;
            }
        }
        int current_index = 0;
        if (hist_max > 15) //30
        {
            int hist_sum_mean_point = hist_sum/2;

            for(int hist_cumsum = 0;current_index<hist.cols;current_index++)
            {
                hist_cumsum += hist.at<uchar>(current_index);
                if(hist_cumsum >= hist_sum_mean_point)
                {
                    break;
                }
            }

            int new_dir = 0;
            if (prev_index < current_index) {
                new_dir = 1;
            } else {
                new_dir = -1;
            }
            if(dir == new_dir) {
                dir_count++;
            } else {
                dir_count = 0;
                dir = new_dir;
            }

            if(dir_count==5)
            {
                emit p_handcontrol->debugMessage("dir: " + QString::number(new_dir) + "dir_count: " + QString::number(dir_count));
                emit p_handcontrol->change_page(dir);
            }
            //emit p_handcontrol->debugMessage("Frame: " + QString::number(frame_count) + " index: " + QString::number(current_index) + " dir: " + QString::number(dir) + " dir_count: " + QString::number(dir_count)+ " hist_max: " + QString::number(hist_max));
        }
        else
        {
            dir_count = 0;
        }
        //qDebug() << "Frame: " << frame_count << "index: " << current_index << " dir: " << dir << " dir_count: " << dir_count << "hist_max: " << hist_max;
        prev_index = current_index;

    }
    ++frame_count;
    //imshow("test Frames",frame_gray);
    //waitKey(0);
    prev_frame = frame_gray.clone();
    Frame_counter++;
    time_elapse += time.elapsed();
}

QList<QVideoFrame::PixelFormat> OpenCV_Worker::supportedPixelFormats(QAbstractVideoBuffer::HandleType handleType) const
{
    Q_UNUSED(handleType);
    return QList<QVideoFrame::PixelFormat>()
        << QVideoFrame::Format_ARGB32
        << QVideoFrame::Format_ARGB32_Premultiplied
        << QVideoFrame::Format_RGB32
        << QVideoFrame::Format_RGB24
        << QVideoFrame::Format_RGB565
        << QVideoFrame::Format_RGB555
        << QVideoFrame::Format_ARGB8565_Premultiplied
        << QVideoFrame::Format_BGRA32
        << QVideoFrame::Format_BGRA32_Premultiplied
        << QVideoFrame::Format_BGR32
        << QVideoFrame::Format_BGR24
        << QVideoFrame::Format_BGR565
        << QVideoFrame::Format_BGR555
        << QVideoFrame::Format_BGRA5658_Premultiplied
        << QVideoFrame::Format_AYUV444
        << QVideoFrame::Format_AYUV444_Premultiplied
        << QVideoFrame::Format_YUV444
        << QVideoFrame::Format_YUV420P
        << QVideoFrame::Format_YV12
        << QVideoFrame::Format_UYVY
        << QVideoFrame::Format_YUYV
        << QVideoFrame::Format_NV12
        << QVideoFrame::Format_NV21
        << QVideoFrame::Format_IMC1
        << QVideoFrame::Format_IMC2
        << QVideoFrame::Format_IMC3
        << QVideoFrame::Format_IMC4
        << QVideoFrame::Format_Y8
        << QVideoFrame::Format_Y16
        << QVideoFrame::Format_Jpeg
        << QVideoFrame::Format_CameraRaw
        << QVideoFrame::Format_AdobeDng;
}
