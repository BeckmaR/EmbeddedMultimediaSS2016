#include <QDebug>
#include <QtMath>
#include <QTimer>
#include <QTime>
#include <QFile>
#include <QVector>
#include "audioWindow.h"

#define STOP_LABEL   "Stop recording"
#define START_LABEL  "Start recording"

const int BufferSize = 16000;
//Windows: const int BufferSize = 80000
//Android: const int BufferSize = 16000;

audioWindow::audioWindow()
    : m_device(QAudioDeviceInfo::defaultInputDevice())
    , m_audioInput(0)
    , m_input(0)
    , m_mode(true)
    , m_buffer(BufferSize, 0)
{
    initializeWindow();
    initializeAudio();
    knock_timer.setSingleShot(true);

    QObject::connect(&knock_timer, SIGNAL(timeout()), this, SLOT(test_knock_slot()));
}

audioWindow::~audioWindow() {}

void audioWindow::initializeWindow()
{
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

    m_audiodata = QVector<float>(len/bytesPerSample, 0);

    for (int i=0; i<len/bytesPerSample; ++i) {
        const qint16 pcmSample = *reinterpret_cast<const qint16*>(ptr);
        const float realSample = pcmToReal(pcmSample);
        m_audiodata[i] = realSample;
        ptr += bytesPerSample;
        //qDebug() << "vec" << m_audiodata.at(i);
    }

    //=============================================================================
    // Recognition in the time domain
    //=============================================================================

    //recognitionTime(len, bytesPerSample);

    //=============================================================================
    // Recognition in the frequency domain
    //=============================================================================

    qint64 processedSecs = m_audioInput->processedUSecs();
    qDebug() << "Processed secs" << processedSecs/1000000;
    qDebug() << "===============";
    calculateSpectrum();
}

void audioWindow::updateCaption() {

}

float audioWindow::pcmToReal(qint16 pcm)
{
    return float(pcm);
}

void audioWindow::initializeAudio()
{

    m_format.setSampleRate(8000);
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
        m_input = m_audioInput->start();
        connect(m_input, SIGNAL(readyRead()), SLOT(readMore()));
        //qDebug() << "Buffer size" << m_audioInput->bufferSize();
        m_mode = false;

    } else {
        m_audioInput->suspend();
        m_mode = true;
    }
}

void audioWindow::calculateSpectrum(){

    /*
     *
     */
    qreal audioSize = m_audiodata.size();
    quint32 inter1 = m_format.sampleRate() * 0.025;
    qreal frameSize = (qreal)qNextPowerOfTwo(inter1);
    int frameShift = m_format.sampleRate() * 0.01;
    int overlap = frameSize - frameShift;
    qreal numofFrames = qCeil((audioSize - overlap)/(frameSize - overlap));
    qreal verify = qCeil(audioSize/numofFrames);
    int lengthceros = (verify * numofFrames) - audioSize;
    QVector<float> ceros(lengthceros, 0);
    m_audiodata.append(ceros);
    float sumofFrames = 0;
    float last_sumofFrames = 0;
    int count = 0;
    //QTimer *timer = new QTimer(this);

    //qDebug() << "audioSize"    << audioSize;
    //qDebug() << "inter1"       << inter1;
    //qDebug() << "frameSize"    << frameSize;
    //qDebug() << "frameShift"   << frameShift;
    //qDebug() << "overlap"      << overlap;
    //qDebug() << "numofFrames"  << numofFrames;
    //qDebug() << "verify"       << verify;
    //qDebug() << "lengthceros"  << lengthceros;

    m_window = calculateWindow(frameSize);
    QVector<float> m_frames(frameSize, 0);
    QVector<float> m_framesWindowed(frameSize, 0);
    QVector<float> m_out(frameSize, 0);

    /* QFile matlab_out("matlab.csv");
    matlab_out.open(QIODevice::WriteOnly);
    QTextStream out(&matlab_out); */

    for (int i=0; i<numofFrames; i++) {
        for (int j=0; j<frameSize; j++) {
            m_frames[j] = m_audiodata[j + i*frameShift];
            m_framesWindowed[j] = m_frames[j] * m_window[j];
            //qDebug() << "vecWin" << m_framesWindowed.at(j);
        }
        fft.calculateFFT(m_out.data(), m_framesWindowed.data());

        sumofFrames = sumVector(m_out);

        if (last_sumofFrames >= 2400 && sumofFrames < 2400) {
            count = count + 1;
            register_knock();
        }

        last_sumofFrames = sumofFrames;

        /*if (count >= 1 && count<= 4) {
            m_Button->setText("Turn right -->");
            timer->singleShot(1000, this, SLOT(updateCaption()));
        } else if(count >= 5) {
            m_Button->setText("<-- Turn left");
            timer->singleShot(1000, this, SLOT(updateCaption()));
        }*/

        //qDebug() << "sumFrames" << sumofFrames;

        /*for(int i=0; i<numofFrames; i++)
        {
            out << QString::number(m_out.at(i)) + ",";
        }
        out << "\n"; */
    }

    //matlab_out.close();

}

float audioWindow::sumVector(QVector<float> m_out){
    float sum = 0;
    for (int i=0; i<m_out.size(); ++i) {
        sum = sum + log(qAbs(m_out.at(i)));
    }
    return sum;
}

QVector<float> audioWindow::calculateWindow(qreal frameSize){

    m_window = QVector<float>(frameSize, 0);

    for (int i=0; i<frameSize; ++i) {
        float x = 0.0;
        x = 0.5 * (1 - qCos((2 * M_PI * i) / (frameSize - 1)));
        m_window[i] = x;
    }
    return m_window;
}

void audioWindow::recognitionTime(qint64 len, int bytesPerSample){
}

void audioWindow::register_knock()
{
    int diff = knock_timer.remainingTime();
    if(knock_timer.isActive() && diff < 1000)
    {
        emit double_knock();
        qDebug() << "double knock";
        knock_timer.stop();
        return;
    }
    knock_timer.start(1000);
}

void audioWindow::test_knock_slot()
{
    qDebug() << "Single knock";
    emit knock();
}
