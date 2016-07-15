
#TEMPLATE = app
#TARGET = gallery
QT += quick quickcontrols2 qml websockets


CONFIG += c++11

SOURCES += ../pdfrenderer/pdfrenderer.cpp \
            main.cpp \
    web_socket_client.cpp

HEADERS += ../pdfrenderer/pdfrenderer.h \
    web_socket_client.h

RESOURCES += qml.qrc

#OTHER_FILES += \
 #   gallery.qml \
  #  pages/*.qml

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
#include(deployment.pri) nur für qnx

FORMS +=
#    Page2Form.ui.qml
#DISTFILES += \


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


#target.path = $$[QT_INSTALL_EXAMPLES]/quickcontrols2/gallery
#INSTALLS += target

