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
}

android {
    OS_PATH_NAME = android
}

linux {
    OS_PATH_NAME = linux
    contains($$QMAKESPEC,"/usr/lib/arm-linux-gnueabihf")
    {
        OS_PATH_NAME = raspberry
        QMLSCENE_DEVICE=softwarecontext

    }
    target.path = /usr/lib
    INSTALLS += target

}

LIBS += -L$$PWD/../../build/lib_mupdf/$${OS_PATH_NAME}/release/ -llib_mupdf

contains(ANDROID_TARGET_ARCH,armeabi-v7a) {
    ANDROID_EXTRA_LIBS = \
        $$PWD/../../build/lib_mupdf/$${OS_PATH_NAME}/release/liblib_mupdf.so
}

#INCLUDEPATH += $$PWD/../../thirdparty/mupdf-qt/build
#DEPENDPATH += $$PWD/../../thirdparty/mupdf-qt/build

#unix:!macx: PRE_TARGETDEPS += $$PWD/../../thirdparty/mupdf-qt/build/linux/libmupdf-qt.a
