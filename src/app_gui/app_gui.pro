QT += qml quick

CONFIG += c++11

SOURCES += ../pdfrenderer/pdfrenderer.cpp \
            main.cpp

HEADERS += ../pdfrenderer/pdfrenderer.h

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
#include(deployment.pri) nur für qnx

FORMS +=

#DISTFILES += \
#    Page2Form.ui.qml


INCLUDEPATH += $$PWD/../../thirdparty/mupdf-qt/include \
               $$PWD/../pdfrenderer

win32 {
    OS_PATH_NAME = Windows_NT
    #LIBS += ../../build/lib_mupdf/$${OS_PATH_NAME}/release/lib_mupdf.dll
    LIBS += -L$$PWD/../../build/lib_mupdf/$${OS_PATH_NAME}/release/ -llib_mupdf
}

android {
    OS_PATH_NAME = android
    LIBS += -L$$PWD/../../build/lib_mupdf/$${OS_PATH_NAME}/release/ -llib_mupdf
}

contains(ANDROID_TARGET_ARCH,armeabi-v7a) {
    ANDROID_EXTRA_LIBS = \
        $$PWD/../../build/lib_mupdf/$${OS_PATH_NAME}/release/liblib_mupdf.so
}
