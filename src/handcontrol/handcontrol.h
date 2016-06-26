#ifndef HANDCONTROL_H
#define HANDCONTROL_H

#include <QObject>

class handcontrol : public QObject
{
    Q_OBJECT
public:
    explicit handcontrol(QObject *parent = 0);
    void test_with_video();

signals:

public slots:
};

#endif // HANDCONTROL_H
