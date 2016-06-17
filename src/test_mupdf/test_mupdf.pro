TEMPLATE = app

QT += qml quick

CONFIG += c++11

SOURCES += pdfrenderer.cpp \
    main.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    pdfrenderer.h

INCLUDEPATH += $$PWD/../../thirdparty/mupdf-qt/include

win32 {
    OS_PATH_NAME = Windows_NT
    LIBS += ../../build/lib_mupdf/$${OS_PATH_NAME}/release/lib_mupdf.dll
}

android {
    OS_PATH_NAME = android
    LIBS += -L$$PWD/../build-lib_mupdf-Android_f_r_armeabi_v7a_GCC_4_9_Qt_5_6_0-Release/ -llib_mupdf
}


Release:DESTDIR = ../../build/test_mupdf/$${OS_PATH_NAME}/release
Debug:DESTDIR = ../../build/test_mupdf/$${OS_PATH_NAME}/debug

contains(ANDROID_TARGET_ARCH,armeabi-v7a) {
    ANDROID_EXTRA_LIBS = \
        $$PWD/../build-lib_mupdf-Android_f_r_armeabi_v7a_GCC_4_9_Qt_5_6_0-Release/liblib_mupdf.so
}
