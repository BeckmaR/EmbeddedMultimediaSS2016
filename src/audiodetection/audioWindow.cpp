#include <stdlib.h>
#include <math.h>
#include <QDebug>
#include <QVBoxLayout>
#include <QBuffer>
#include <QAudioBuffer>
#include <QtMath>
#include <QTimer>
#include "audioWindow.h"

#define STOP_LABEL   "Stop recording"
#define START_LABEL    "Start recording"

const int BufferSize = 16000;
//Win: const int BufferSize = 128000 & sampleRate = 8000;
//Win: const int BufferSize = 16000 & sampleRate = 1000;
//Android: const int BufferSize = 25600;

audioWindow::audioWindow()
    : m_device(QAudioDeviceInfo::defaultInputDevice())
    , m_audioInput(0)
    , m_input(0)
    , m_mode(true)
    , m_buffer(BufferSize, 0)
{
    initializeWindow();
    initializeAudio();
}

audioWindow::~audioWindow() {}

void audioWindow::initializeWindow()
{
    QScopedPointer<QWidget> window(new QWidget);
    QScopedPointer<QVBoxLayout> layout(new QVBoxLayout);

    m_modeButton = new QPushButton(this);
    m_modeButton->setText("Start Recording");
    connect(m_modeButton, SIGNAL(clicked()), SLOT(startStopRecording()));
    layout->addWidget(m_modeButton);

    m_Button = new QPushButton(this);
    m_Button->setText("Hello World!");
    layout->addWidget(m_Button);

    window->setLayout(layout.data());
    layout.take(); // ownership transferred
    setCentralWidget(window.data());
    QWidget *const windowPtr = window.take(); // ownership transferred
    windowPtr->show();
}

void audioWindow::readMore()
{
    //=============================================================================
    // Reading and analysing the buffer
    //=============================================================================

    if (!m_audioInput)
        return;
    qint64 len = m_audioInput->bytesReady();
    qDebug() << "Bytes Ready AudioInput" << len;

    if (len > BufferSize)
        len = BufferSize;
    qint64 l = m_input->read(m_buffer.data(), BufferSize);
    qDebug() << "Number of Bytes Read" << l;

    const char *ptr = m_buffer.constData();
    int bytesPerSample = m_format.sampleSize() / 8;
    //int numSamples = m_buffer.size() / bytesPerSample;
    //buffer.size() = numSamples * bytesPerSample
    //const int bufferLength = numSamples * bytesPerSample;

    m_audiodata = QVector<qreal>(len/2, 0);

    for (int i=0; i<len/2; ++i) {
        const qint16 pcmSample = *reinterpret_cast<const qint16*>(ptr);
        // Scale down to range [-1.0, 1.0]
        const qreal realSample = pcmToReal(pcmSample);
        m_audiodata[i] = realSample;
        ptr += bytesPerSample;
        qDebug() << "vec" << m_audiodata.at(i);
    }

    //=============================================================================
    // Recognition in the time domain
    //=============================================================================

    recognitionTime(len, bytesPerSample);

    //=============================================================================
    // Recognition in the frequency domain
    //=============================================================================

    calculateSpectrum();
}

void audioWindow::updateCaption() {
    m_Button->setText(" ");
}

qreal audioWindow::pcmToReal(qint16 pcm)
{
    const quint16 PCMS16MaxAmplitude =  32768; // because minimum is -32768
    return qreal(pcm) / PCMS16MaxAmplitude;
}

void audioWindow::initializeAudio()
{
    //Win: 1000 Hz
    //Android: 8000 Hz
    m_format.setSampleRate(1000);
    m_format.setChannelCount(1);
    m_format.setSampleSize(16);
    m_format.setSampleType(QAudioFormat::SignedInt);
    m_format.setByteOrder(QAudioFormat::LittleEndian);
    m_format.setCodec("audio/pcm");

    QAudioDeviceInfo info(m_device);
    if (!info.isFormatSupported(m_format)) {
        qWarning() << "Default format not supported - trying to use nearest";
        m_format = info.nearestFormat(m_format);
    }

    qDebug() << "Chosen Sample Rate" << m_format.sampleRate();
    qDebug() << "Chosen No. of Channels" << m_format.channelCount();
    qDebug() << "Chosen Sample Size in bits" << m_format.sampleSize();
    qDebug() << "Chosen Sample Type" << m_format.sampleType();
    qDebug() << "Chosen Byte order" << m_format.byteOrder();
    qDebug() << "Chosen Codec" << m_format.codec();

    createAudioInput();
}

void audioWindow::createAudioInput()
{
    m_audioInput = new QAudioInput(m_device, m_format, this);
    m_audioInput->setBufferSize(BufferSize);
}

void audioWindow::startStopRecording()
{
    if (m_mode) {
        m_audiodata.clear();
        m_modeButton->setText(tr(STOP_LABEL));
        m_input = m_audioInput->start();
        connect(m_input, SIGNAL(readyRead()), SLOT(readMore()));
        int size = m_audioInput->bufferSize();
        qDebug() << "Buffer size" << size;
        m_mode = false;

    } else {
        m_modeButton->setText(tr(START_LABEL));
        m_audioInput->suspend();
        m_mode = true;
    }
}

void audioWindow::calculateSpectrum(){

    qreal audioSize = m_audiodata.size();
    quint32 inter1 = m_format.sampleRate() * 0.025;
    qreal frameSize = (qreal)qNextPowerOfTwo(inter1);
    int frameShift = m_format.sampleRate() * 0.01;
    int overlap = frameSize - frameShift;
    qreal numofFrames = qCeil((audioSize - overlap)/(frameSize - overlap));
    qreal verify = qCeil(audioSize/numofFrames);
    int lengthceros = (verify * numofFrames) - audioSize;
    QVector<qreal> ceros(lengthceros, 0);
    m_audiodata.append(ceros);

    qDebug() << "audioSize"    << audioSize;
    qDebug() << "inter1"       << inter1;
    qDebug() << "frameSize"    << frameSize;
    qDebug() << "frameShift"   << frameShift;
    qDebug() << "overlap"      << overlap;
    qDebug() << "numofFrames"  << numofFrames;
    qDebug() << "verify"       << verify;
    qDebug() << "lengthceros"  << lengthceros;

    m_window = calculateWindow(frameSize);
    QVector<qreal> m_frames(frameSize, 0);
    QVector<qreal> m_framesWindowed(frameSize, 0);

    for (int i=0; i<numofFrames; i++) {
        for (int j=0; j<frameSize; j++) {
            m_frames[j] = m_audiodata[j + i*frameShift];
            m_framesWindowed[j] = m_frames[j] * m_window[j];

            //qDebug() << "vecWin" << m_framesWindowed.at(j);
        }
    }
}

void audioWindow::recognitionTime(qint64 len, int bytesPerSample){

    const int num = len/bytesPerSample;
    QVector<qreal> sum(num, 0);
    int count = 0;
    // Subsampling (Win)
    if (m_format.sampleRate() == 1000) {
        for (int i=0; i<num; i=i+80) {
            for (int j=i; j<i+80; ++j) {
                sum[i] = sum[i]  + qAbs(m_audiodata[j]);
            }
            if (sum[i] > 3) {
                count = count + 1;
            }
        }
    // Normal sample rate (Android)
    } else if (m_format.sampleRate() == 8000) {
        for (int i=0; i<num; i=i+80) {
            for (int j=i; j<i+80; ++j) {
                sum[i] = sum[i]  + qAbs(m_audiodata[j]);
            }
            if (sum[i] > 8) {
                count = count + 1;
            }
        }
    }

    qDebug() << "=============== Number Of Tocs ===============" << count;
    //m_Button->setText(QStringLiteral("Number of Tocs %1").arg(count));
    QTimer *timer = new QTimer(this);
    if (count == 1) {
        m_Button->setText("Turn right -->");
        timer->singleShot(1500, this, SLOT(updateCaption()));
    }  else if (count >= 2) {
        m_Button->setText("<-- Turn left");
        timer->singleShot(1500, this, SLOT(updateCaption()));
    }
}

QVector<qreal> audioWindow::calculateWindow(qreal frameSize){

    m_window = QVector<qreal>(frameSize, 0);

    for (int i=0; i<frameSize; ++i) {
        qreal x = 0.0;
        x = 0.5 * (1 - qCos((2 * M_PI * i) / (frameSize - 1)));
        m_window[i] = x;
    }
    return m_window;
}

/*
    //Adaptive Low-Pass Filter
    const qreal a = 0.8;
    QVector<qreal> audiolow(len/2, 0);
    for (int i=1; i<len/2; ++i) {
        audiolow[i] = a * audiolow[i-1] + (1-a) * qAbs(m_audiodata[i]);
        qDebug() << "vecLow" << audiolow.at(i);
    }

    QAudioBuffer buffer(m_buffer, m_format, -1);
    float *data = buffer.data<float>();
    QVector<float> m_audiodata(len, 0);
    for (int i = 0; i < m_audiodata.size(); ++i) {
        m_audiodata[i] = (data)[i]/0.05;
        qDebug() << "vec" << m_audiodata.at(i);
    }

    qint64 duration = buffer.duration();
    qDebug() << "Buffer Duration" << duration/1000 << "msecs";

    int numSamples = buffer.sampleCount();
    qDebug() << "Number of Samples" << numSamples;
*/
