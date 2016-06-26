#include "test_handcontrol.h"
#include <QDebug>

using namespace cv;

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
}

int test_handcontrol::getNrOfFrames()
{
    return frame_count;
}

QImage test_handcontrol::requestImage(const QString &id, QSize *size, const QSize &requestedSize)
{
    QImage qimage;
    Mat frame1;
    Mat frame2;

    double video_pos = id.toDouble();
    int frame_nr = video_pos; // video_pos*frame_count;

    //qDebug() <<"From QML(1): " << id << " frame nr: " << frame_nr;
    if(frame_nr > frame_count-1 )
    {
        frame_nr = frame_count-1;
    }
    //qDebug() <<"From QML(2): " << id << " frame nr: " << frame_nr;
    cap->set(CV_CAP_PROP_POS_FRAMES,frame_nr);
    //Mat oc_image;
    cap->retrieve(frame1);
    if (frame1.empty())
    {
        qDebug() << "Konnte Frame nicht öffnen";
        return qimage;
    }
    //*cap >> frame_bgr;
    cvtColor(frame1, frame2,CV_BGR2GRAY);
    qimage = QImage((const uchar *) frame2.data,frame2.cols,frame2.rows,frame2.step,QImage::Format_Grayscale8);
    qimage.bits();
    return qimage;

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
