#ifndef OPENCV_WORKER_H
#define OPENCV_WORKER_H

#include <QObject>
#include <QVideoFrame>
#include "opencv2/opencv.hpp"

class handcontrol;

class OpenCV_Worker : public QObject
{
    Q_OBJECT
    handcontrol *p_handcontrol;

    int counter = 0;
    //cv::Mat orginal_frame;
    int firstFrame = 1;
    int dir = -1;
    int dir_count = 0;
    int prev_index = 0;
    int frame_count = 0;
    cv::Mat frame_gray;
    cv::Mat prev_frame;
    cv::Mat frame_sub;
    cv::Mat hist;
public:
    cv::Mat current_frame;
    explicit OpenCV_Worker(handcontrol *parent);

signals:

public slots:
    void AnalyzeFrame(QVideoFrame::PixelFormat pixelFormat);
};

#endif // OPENCV_WORKER_H
