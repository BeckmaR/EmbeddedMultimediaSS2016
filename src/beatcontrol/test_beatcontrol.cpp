#include "test_beatcontrol.h"

test_beatcontrol::test_beatcontrol(QObject *parent) : QObject(parent)
{

    // set up the format you want, eg.
    format.setFrequency(8000);
    format.setChannels(1);
    format.setSampleSize(8);
    format.setCodec("audio/pcm");
    format.setByteOrder(QAudioFormat::LittleEndian);
    format.setSampleType(QAudioFormat::UnSignedInt);

}

QAudioInput *audioInput;  // class member.
...
void test_beatcontrol::startRecording()
{

    QAudioDeviceInfo info = QAudioDeviceInfo::defaultInputDevice();
    if (!info.isFormatSupported(format)) {
        qWarning()<<"default format not supported try to use nearest";
        format = info.nearestFormat(format);
    }

    audioInput = new QAudioInput(format, this);
    QTimer::singleShot(3000, this, SLOT(stopRecording()));
    audioInput->start(&outputFile);
    // Records audio for 3000ms
}
