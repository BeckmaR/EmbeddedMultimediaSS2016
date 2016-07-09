#ifndef HANDCONTROL_H
#define HANDCONTROL_H

#include <QObject>
#include <QVariant>
#include <QCamera>
#include <QCameraImageCapture>
#include "opencv2/opencv.hpp"

class handcontrol_worker;

class handcontrol : public QObject
{
    handcontrol_worker *worker;
    QCamera *camera;
    Q_OBJECT
public:
    explicit handcontrol(QObject *parent = 0);
    virtual ~handcontrol();

signals:
    void change_page(QVariant dir);
    void debugMessage(QVariant msg);
    void errorMessage(QVariant msg);
public slots:
    void enable(int);

};

#endif // HANDCONTROL_H
