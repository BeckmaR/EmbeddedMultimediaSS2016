#include "opencv_worker.h"
#include "handcontrol.h"
#include <QDebug>

OpenCV_Worker::OpenCV_Worker(handcontrol *parent)
{
    p_handcontrol = parent;
}


void OpenCV_Worker::AnalyzeFrame(QVideoFrame::PixelFormat pixelFormat) {
    //p_handcontrol->debugMessage("AnalyzeFrame");
    //qDebug()<< __FILE__ << __LINE__  << "thread: "<< QThread::currentThreadId();
    if(pixelFormat == QVideoFrame::Format_RGB32) {
        cvtColor(current_frame, frame_gray,CV_RGB2GRAY);
    } else if(pixelFormat == QVideoFrame::Format_BGR32) {
        cvtColor(current_frame, frame_gray,CV_BGR2GRAY);
    } else {
        p_handcontrol->errorMessage("Nicht unterstütztes Format => QVideoFrame::PixelFormat" + QString::number(pixelFormat));
    }
    if(firstFrame)
    {
        firstFrame = 0;
        frame_count = 0;
        dir_count = 0;
        qDebug()<< __FILE__ << __LINE__  << "thread: "<< QThread::currentThreadId();
    } else {
        frame_sub = frame_gray - prev_frame;
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
            emit p_handcontrol->debugMessage("Frame: " + QString::number(frame_count) + " index: " + QString::number(current_index) + " dir: " + QString::number(dir) + " dir_count: " + QString::number(dir_count)+ " hist_max: " + QString::number(hist_max));
        }
        else
        {
            dir_count = 0;
        }
        qDebug() << "Frame: " << frame_count << "index: " << current_index << " dir: " << dir << " dir_count: " << dir_count << "hist_max: " << hist_max;
        prev_index = current_index;

    }
    ++frame_count;
    //imshow("test Frames",frame_gray);
    //waitKey(0);
    prev_frame = frame_gray.clone();
}
