#ifndef OPENCV_WORKER_H
#define OPENCV_WORKER_H

#include <QObject>
#include <QVideoFrame>
#include <QAbstractVideoSurface>
#include "opencv2/opencv.hpp"

class handcontrol;

class OpenCV_Worker : public QAbstractVideoSurface
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
    int Frame_counter = 0;
    cv::Mat current_frame;
    cv::Mat frame_gray;
    cv::Mat prev_frame;
    cv::Mat frame_sub;
    cv::Mat hist;
public:
    explicit OpenCV_Worker(handcontrol *);
    bool present(const QVideoFrame &frame);
    QList<QVideoFrame::PixelFormat> supportedPixelFormats(QAbstractVideoBuffer::HandleType handleType) const;
signals:
    void sendFrame(QVideoFrame::PixelFormat pixelFormat);

public slots:
    void processFrame(const QVideoFrame &frame);
    void AnalyzeFrame(QVideoFrame::PixelFormat pixelFormat);
    void One_sec_Timer();
};

#endif // OPENCV_WORKER_H
