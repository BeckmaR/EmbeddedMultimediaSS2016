#ifndef TEST_BEATCONTROL_H
#define TEST_BEATCONTROL_H

#include <QObject>

class test_beatcontrol : public QObject
{
    Q_OBJECT
    QAudioFormat format;
public:
    explicit test_beatcontrol(QObject *parent = 0);

signals:

public slots:
};

#endif // TEST_BEATCONTROL_H
