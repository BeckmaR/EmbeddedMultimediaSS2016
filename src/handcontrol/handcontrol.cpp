#include <QDebug>
#include <QString>
#include <QThread>
#include <QAbstractVideoSurface>
#include "handcontrol.h"
#include "opencv2/opencv.hpp"

using namespace cv;

class handcontrol_worker : public QThread, public QAbstractVideoSurface
{
    //Q_OBJECT
    handcontrol *p_handcontrol;
    void run() Q_DECL_OVERRIDE {

        VideoCapture cap(0);
        quit_signal = 0;
        if(!cap.isOpened())
        {
            qDebug() << "Kamera konnte nicht geoeffnet werden";
            emit p_handcontrol->errorMessage("Kamera konnte nicht geoeffnet werden");
            // check if we succeeded
            return;
        }
        int dir = -1;
        int dir_count = 0;
        int prev_index = 0;
        int frame_count = 0;
        Mat prev_frame;
        Mat tempframe;
        Mat frame_sub;
        Mat frame;
        Mat hist;
        //cap >> tempframe;
        if(!cap.read(tempframe))
        {
            qDebug() << "Erster Frame konnte nicht ausgelesen werden";
            emit p_handcontrol->errorMessage("Erster Frame konnte nicht ausgelesen werden");
        }
        cvtColor(tempframe, prev_frame,CV_BGRA2GRAY);

        while(!quit_signal) {
            if(!cap.read(tempframe))
            {
                qDebug() << "Frame:"<< frame_count <<" konnte nicht ausgelesen werden";
                emit p_handcontrol->errorMessage("Frame:" + QString::number(frame_count) +" konnte nicht ausgelesen werden");
                continue;
            }
            cvtColor(tempframe, frame,CV_BGRA2GRAY);
            frame_sub = frame - prev_frame;
            reduce(frame_sub,hist,1,CV_REDUCE_AVG);
            //Point maxIdx;
            //minMaxLoc(hist,0,0,0,&maxIdx);
            int hist_sum =0;
            int hist_max =0;
            for(int i=0; i<hist.rows;++i)
            {
                int value = hist.at<uchar>(i);
                hist_sum += value;
                if (value > hist_max)
                {
                    hist_max = value;
                }
            }
            int current_index = 0;
            if (hist_max > 20) //30
            {
                int hist_sum_mean_point = hist_sum/2;

                for(int hist_cumsum = 0;current_index<hist.rows;current_index++)
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
                    qDebug() << "dir: " << dir << "dir_count: " << dir_count;
                    if(dir == 1)  {
                        emit p_handcontrol->change_page(dir);
                    }
                }
                emit p_handcontrol->debugMessage("Frame: " + QString::number(frame_count) + " index: " + QString::number(current_index) + " dir: " + QString::number(dir) + " dir_count: " + QString::number(dir_count));
            }
            else
            {
                dir_count = 0;
            }
            qDebug() << "Frame: " << frame_count << "index: " << current_index << " dir: " << dir << " dir_count: " << dir_count << "hist_max: " << hist_max;
            ++frame_count;
            prev_index = current_index;
            prev_frame = frame.clone();
            //imshow("test Frames",frame_sub);
            //waitKey(0);
        }
    }

public:
    int quit_signal = 0;
    handcontrol_worker(handcontrol *ptr)
    {
        p_handcontrol = ptr;
    }
};

handcontrol::handcontrol(QObject *parent) : QObject(parent)
{
    worker = new handcontrol_worker(this);
    camera = new QCamera();
    camera->setViewfinder(worker);

    //worker->p_handcontrol = this;
}

void handcontrol::enable(int enable)
{
    if(enable) {
        worker->start();
        qDebug() << "handcontrol gestartet";
    } else {
        worker->quit_signal = 1;
        worker->quit();
        qDebug() << "handcontrol gestoppt";
    }
}


handcontrol::~handcontrol()
{
    delete(worker);
    delete(cameraCapture);
    delete(camera);
}

