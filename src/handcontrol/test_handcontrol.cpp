#include "test_handcontrol.h"
#include <QDebug>
//#include "opencv2/"

using namespace cv;
using namespace cv::bgsegm;

test_handcontrol::test_handcontrol(QObject *parent) : QObject(parent), QQuickImageProvider(QQuickImageProvider::Image)
{

}

test_handcontrol::~test_handcontrol()
{
    if(cap)
    {
        delete(cap);
    }
}


void test_handcontrol::openFile(QString filepath)
{
    cap = new VideoCapture(filepath.toStdString().c_str());
    if(!cap->isOpened())
    {
        qDebug() << "Video konnte nicht geoeffnet werden";

        return;
    }
    frame_count = cap->get(CV_CAP_PROP_FRAME_COUNT);
    pBS = createBackgroundSubtractorMOG();
}

int test_handcontrol::getNrOfFrames()
{
    return frame_count;
}

QImage test_handcontrol::requestImage(const QString &id, QSize *size, const QSize &requestedSize)
{
    QImage image;

    QStringList list =id.split('/');
    if (list.at(0).toInt() == 0) // orginalFrame darstellen
    {
        Mat frame1;
        Mat frame2;

        int video_pos = list.at(1).toInt();
        int frame_nr = video_pos; // video_pos*frame_count;

        //qDebug() <<"From QML(1): " << id << " frame nr: " << frame_nr;
        if(frame_nr > frame_count-1 )
        {
            frame_nr = frame_count-1;
        }
        //qDebug() <<"From QML(2): " << id << " frame nr: " << frame_nr;
        cap->set(CV_CAP_PROP_POS_FRAMES,frame_nr);
        //Mat oc_image;
        *cap >> frame1;
        if (frame1.empty())
        {
            qDebug() << "Konnte Frame nicht öffnen";
            return image;
        }
        //*cap >> frame_bgr;
        cvtColor(frame1, frame1,CV_BGR2GRAY);
        Mat frame3;
        *cap >> frame3;
        cvtColor(frame3, frame3,CV_BGR2GRAY);
        frame2 = frame1-frame3;
        image = QImage((const uchar *) frame2.data,frame2.cols,frame2.rows,frame2.step,QImage::Format_Grayscale8);
        image.bits();

    }  else  {
        Mat fgMask;
        Mat frame;
        Mat prev_frame;
        int modus = 2;
        int end_pos = list.at(1).toInt();
        int start_pos = end_pos;
        switch(modus)
        {
            case 0:
                // Background-substraktion durchführen
                start_pos = end_pos-40;
                if(start_pos<1)
                {
                    start_pos=1;
                }
                cap->set(CV_CAP_PROP_POS_FRAMES,start_pos);
                for (int i=start_pos;i<end_pos;i++)
                {
                    *cap >> frame;
                    pBS->apply(frame,fgMask);
                }

                break;
            case 1:
                start_pos = end_pos-1;
                if(start_pos<1)
                {
                    start_pos=1;
                }
                cap->set(CV_CAP_PROP_POS_FRAMES,start_pos);
                *cap >> prev_frame;
                *cap >> frame;
                fgMask = frame - prev_frame;

                break;
            case 2:
                int dir = -1;
                int dir_count = 0;
                int prev_index = 0;
                prev_index = 0;
                Mat prev_frame;
                Mat tempframe;
                Mat frame_sub;
                cap->set(CV_CAP_PROP_POS_FRAMES,start_pos);
                *cap >> tempframe;
                cvtColor(tempframe, prev_frame,CV_BGRA2GRAY);
                for(int i=start_pos;i<15+start_pos;i++)
                {
                    *cap >> tempframe;
                    cvtColor(tempframe, frame,CV_BGRA2GRAY);
                    Mat hist;
                    reduce(frame - prev_frame,hist,1,CV_REDUCE_AVG);
                    Point maxIdx;
                    minMaxLoc(hist,0,0,0,&maxIdx);
                    Scalar_<int> hist_sum_mean = sum(hist)/2;
                    int cumsum_hist = 0;
                    int current_index = 0;
                    for(;current_index<hist.rows;current_index++)
                    {
                        cumsum_hist += hist.at<uchar>(current_index);
                        if(cumsum_hist >= hist_sum_mean[0])
                        {
                            break;
                        }
                    }
                    prev_frame = frame.clone();
                    int new_dir = 0;
                    if (prev_index < current_index) {
                        new_dir = 1;
                    } else if (prev_index > current_index) {
                        new_dir = -1;
                    } else {
                        dir_count = 0;
                    }
                    if(new_dir != 0) {
                        if(dir == new_dir) {
                            dir_count++;
                        } else {
                            dir_count = 0;
                            dir = new_dir;
                        }
                    }
                    qDebug() << "Frame: " << i << "maxidx: " << maxIdx.y << "index: " << current_index << " dir: " << new_dir << " dir_count: " << dir_count;
                    prev_index = current_index;
                    if(dir_count==5)
                    {
                        qDebug() << "dir: " << new_dir << "dir_count: " << dir_count;

                        fgMask = prev_frame;
                    }
                }
            break;


        }
        image = QImage((const uchar *) fgMask.data,fgMask.cols,fgMask.rows,fgMask.step,QImage::Format_Grayscale8);
        image.bits();
        //qDebug() << "BackSub start Frame:" << start_pos;
        //qDebug() << "BackSub end Frame:" << end_pos;
        qDebug() << "----------------------------------------------------------";

    }
    if(size)
    {
        size->setHeight(image.height());
        size->setWidth(image.width());
        //qDebug() << "size gesetzt";
    }
    return image;

//    char video_name[] = "test.mp4";
//    VideoCapture cap(video_name);
//    if(!cap.isOpened())
//    {
//        qDebug() << "Video konnte nicht geoeffnet werden";
//        return;
//    }
//    Mat edges;
//    namedWindow("edges",1);
//   for(;;)
//   {
//       Mat frame;
//       cap >> frame; // get a new frame from camera
//       cvtColor(frame, edges, COLOR_BGR2GRAY);
//       GaussianBlur(edges, edges, Size(7,7), 1.5, 1.5);
//       Canny(edges, edges, 0, 30, 3);
//       imshow("edges", edges);
//       if(waitKey(30) >= 0) break;
//   }

}
