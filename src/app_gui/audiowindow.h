#ifndef AUDIOIN_H
#define AUDIOIN_H

#include <QAudioInput>
#include <QTime>
#include <QTimer>
#include <QObject>
#include <QVector>

#include "ffft/fftreal_wrapper.h"

class audioWindow : public QObject
{
    Q_OBJECT

public:
    audioWindow();
    ~audioWindow();
    void initializeWindow();
    void initializeAudio();
    void createAudioInput();
    float pcmToReal(qint16 pcm);

private:
    void recognitionTime(qint64 len, int bytesPerSample);
    QVector<float> calculateWindow(qreal frameSize);
    void calculateSpectrum();
    float sumVector(QVector<float> m_out);
    void register_knock();
    QTimer knock_timer;

private slots:
    void readMore();
    void startStopRecording();
    void updateCaption();
    void test_knock_slot();

signals:
    void knock();
    void double_knock();

private:
    QAudioFormat m_format;
    QAudioDeviceInfo m_device;
    QAudioInput* m_audioInput;

    QIODevice* m_input;
    bool m_mode;
    QByteArray m_buffer;
    QVector<float> m_audiodata;
    QVector<float> m_window;

    FFTRealWrapper fft;

};

#endif // AUDIOIN_H
