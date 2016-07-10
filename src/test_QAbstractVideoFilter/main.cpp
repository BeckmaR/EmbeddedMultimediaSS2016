#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QVideoFilterRunnable>
#include <QAbstractVideoFilter>
#include <QDebug>

class MyFilterRunnable : public QVideoFilterRunnable {
public:
    QVideoFrame run(QVideoFrame *input, const QVideoSurfaceFormat &surfaceFormat, RunFlags flags) {
        //qDebug() << " Test";
        input->map(QAbstractVideoBuffer::ReadOnly);
        //qDebug() << " in map part";
        qDebug() << "height:" << input->height() << "width:" << input->width();
        input->unmap();
        return *input;

    }
};

class MyFilter : public QAbstractVideoFilter {
public:
    QVideoFilterRunnable *createFilterRunnable() { return new MyFilterRunnable; }
signals:
    void finished(QObject *result);
};


//QVideoFilterRunnable *FaceRecogFilter::createFilterRunnable()
//{
//    return new FaceRecogFilterRunnable(this);
//}

//QVideoFrame FaceRecogFilterRunnable::run(QVideoFrame *input, const QVideoSurfaceFormat &surfaceFormat, RunFlags flags)
//{
//    // Convert the input into a suitable OpenCV image format, then run e.g. cv::CascadeClassifier,
//    // and finally store the list of rectangles into a QObject exposing a 'rects' property.
//    ...
//    emit m_filter->finished(result);
//    return *input;
//}

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    qmlRegisterType<MyFilter>("my.uri", 1, 0, "MyFilter");
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
