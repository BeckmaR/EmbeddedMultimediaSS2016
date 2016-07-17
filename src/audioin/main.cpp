#include "audioWindow.h"
#include <QApplication>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    app.setApplicationName("Audio Input Test");

    audioWindow input;
    input.show();

    return app.exec();
}
