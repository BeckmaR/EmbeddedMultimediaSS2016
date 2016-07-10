#ifndef HANDCONTROL_WORKER_H
#define HANDCONTROL_WORKER_H

#include <QObject>

class handcontrol_worker : public QObject
{
    Q_OBJECT
public:
    explicit handcontrol_worker(QObject *parent = 0);

signals:

public slots:
};

#endif // HANDCONTROL_WORKER_H