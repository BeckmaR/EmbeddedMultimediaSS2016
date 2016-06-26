TEMPLATE = app

QT += qml quick

CONFIG += c++11

SOURCES += main.cpp \
    handcontrol.cpp \
    test_handcontrol.cpp

TARGET = test_handcontrol

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

INCLUDEPATH += ../../thirdparty/opencv_build_win/install/include

LIBS += -L"../../thirdparty/opencv_build_win/install/x86/mingw/bin"

LIBS += -lopencv_core310 -lopencv_highgui310 -lopencv_imgproc310 \
-lopencv_imgcodecs310 -lopencv_video310 -lopencv_videoio310

HEADERS += \
    handcontrol.h \
    test_handcontrol.h
