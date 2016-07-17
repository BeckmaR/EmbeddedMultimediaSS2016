#ifndef AUDIOIN_H
#define AUDIOIN_H

#include <QMainWindow>
#include <QAudioInput>
#include <QPushButton>


class audioWindow : public QMainWindow
{
    Q_OBJECT

public:
    audioWindow();
    ~audioWindow();
    void initializeWindow();
    void initializeAudio();
    void createAudioInput();
    qreal pcmToReal(qint16 pcm);

private:
    void recognitionTime(qint64 len, int bytesPerSample);
    QVector<qreal> calculateWindow(qreal frameSize);
    void calculateSpectrum();

private slots:
    void readMore();
    void startStopRecording();
    void updateCaption();

private:
    QPushButton *m_modeButton;
    QPushButton *m_Button;

    QAudioFormat m_format;
    QAudioDeviceInfo m_device;
    QAudioInput* m_audioInput;

    QIODevice* m_input;
    bool m_mode;
    QByteArray m_buffer;
    QVector<qreal> m_audiodata;
    QVector<qreal> m_window;

    /* Before:
       AudioDevice *m_audioInfo;
       QAudioInput *m_audioInput;
       QIODevice *m_input;
    */

};

#endif // AUDIOIN_H
