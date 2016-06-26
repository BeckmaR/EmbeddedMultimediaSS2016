#include <QDebug>
#include "handcontrol.h"
#include "opencv2/opencv.hpp"

using namespace cv;

handcontrol::handcontrol(QObject *parent) : QObject(parent)
{

}

void handcontrol::test_with_video()
{
   char video_name[] = "test.mp4";
   VideoCapture cap(video_name);
   if(!cap.isOpened())
   {
       qDebug() << "Video konnte nicht geoeffnet werden";
       // check if we succeeded
       return;
   }
   Mat edges;
   namedWindow("edges",1);
  for(;;)
  {
      Mat frame;
      cap >> frame; // get a new frame from camera
      cvtColor(frame, edges, COLOR_BGR2GRAY);
      GaussianBlur(edges, edges, Size(7,7), 1.5, 1.5);
      Canny(edges, edges, 0, 30, 3);
      imshow("edges", edges);
      if(waitKey(30) >= 0) break;
  }

}
