#ifndef OPENCV_WORKER_H
#define OPENCV_WORKER_H

#include <QObject>
#include <QVideoFrame>
#include <QTime>
#include <QAbstractVideoSurface>
#include "opencv2/opencv.hpp"

class handcontrol;

class OpenCV_Worker : public QAbstractVideoSurface
{
    Q_OBJECT
    handcontrol *p_handcontrol;
    int timer_period_ms;
    int counter = 0;
    int processFrame_cnt =0;
    int AnalyzeFrame_cnt =0;
    int time_elapse= 0;
    //cv::Mat orginal_frame;
    int firstFrame = 1;
    int dir = -1;
    int dir_count = 0;
    int prev_index = 0;
    int frame_count = 0;
    int Frame_counter = 0;
    cv::Mat current_frame;
    cv::Mat frame_gray;
    cv::Mat prev_frame;
    cv::Mat frame_sub;
    cv::Mat hist;
    QTime time;
public:
    explicit OpenCV_Worker(handcontrol *);
    bool present(const QVideoFrame &frame);
    QList<QVideoFrame::PixelFormat> supportedPixelFormats(QAbstractVideoBuffer::HandleType handleType) const;
    void setTimerPeriodms(int period_ms);
signals:
    void sendFrame(QVideoFrame::PixelFormat pixelFormat);

public slots:
    void processFrame(const QVideoFrame &frame);
    void AnalyzeFrame(QVideoFrame::PixelFormat pixelFormat);
    void PeriodTimer();
};

#endif // OPENCV_WORKER_H
