#include "audioWindow.h"
#include <QApplication>
#include <QDebug>
#include <QByteArray>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    app.setApplicationName("Audio Input Test");

    audioWindow input;
    input.show();

/*    QByteArray ba("Hello world");
    char *data = ba.data();
    while (*data) {
        qDebug() << "vector" << *data;
        ++data;
    }

    while (*data) {
        qDebug() << "bla" << qAbs(*data)/0.05;
        ++data;

    QList<int> bla;
    for (int i = 0; i < 5; ++i) {
        //bla.insert(i, i);
        bla << i;
    }
    qDebug() << "masbla" << bla;

    QList<float> audiodata;
    for (int i = 0; i < buffer.sampleCount(); ++i) {
        //audiodata << (data)[i];
        audiodata.insert(i, data[i]);
    }
    qDebug() << "vec" << audiodata;

    if (m_audioInput->state() == QAudio::ActiveState) {
        m_modeButton->setText("Recording");
    }

    m_audioInput->stop();
    m_audioInput->resume();
*/

    return app.exec();
}
