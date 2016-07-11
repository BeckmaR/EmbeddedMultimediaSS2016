TEMPLATE = app

QT += qml quick

SOURCES += pdfrenderer.cpp \
    main.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
#include(deployment.pri)

HEADERS += \
    pdfrenderer.h

INCLUDEPATH += $$PWD/../../thirdparty/mupdf-qt/include

win32 {
    OS_PATH_NAME = Windows_NT
    #LIBS += ../../build/lib_mupdf/$${OS_PATH_NAME}/release/lib_mupdf.dll
    LIBS += -L$$PWD/../../build/lib_mupdf/$${OS_PATH_NAME}/release/ -llib_mupdf
}

android {
    OS_PATH_NAME = android
    LIBS += -L$$PWD/../../build/lib_mupdf/$${OS_PATH_NAME}/release/ -llib_mupdf
}

unix {
    OS_PATH_NAME = unix
    target.path = /usr/lib
    INSTALLS += target
    LIBS += -L$$PWD/../../build/lib_mupdf/$${OS_PATH_NAME}/release/ -llib_mupdf
}

contains(ANDROID_TARGET_ARCH,armeabi-v7a) {
    ANDROID_EXTRA_LIBS = \
        $$PWD/../../build/lib_mupdf/$${OS_PATH_NAME}/release/liblib_mupdf.so
}

INCLUDEPATH += $$PWD/../../thirdparty/mupdf-qt/build
DEPENDPATH += $$PWD/../../thirdparty/mupdf-qt/build

unix:!macx: PRE_TARGETDEPS += $$PWD/../../thirdparty/mupdf-qt/build/lib/libmupdf-qt.a
