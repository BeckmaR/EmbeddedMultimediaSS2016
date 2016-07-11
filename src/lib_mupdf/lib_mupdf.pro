#-------------------------------------------------
#
# Project created by QtCreator 2016-06-17T15:59:55
#
#-------------------------------------------------

TARGET = lib_mupdf
TEMPLATE = lib

DEFINES += LIB_MUPDF_LIBRARY

#contains(CONFIG,"debug") {
#    error("Lib bitte im Release compilieren")
#}

SOURCES += \
    ../../thirdparty/mupdf-qt/src/mupdf-document.cpp \
    ../../thirdparty/mupdf-qt/src/mupdf-link.cpp \
    ../../thirdparty/mupdf-qt/src/mupdf-outline.cpp \
    ../../thirdparty/mupdf-qt/src/mupdf-page.cpp \
    ../../thirdparty/mupdf-qt/src/mupdf-textbox.cpp

INCLUDEPATH += ../../thirdparty/mupdf-qt/src/private \
    ../../thirdparty/mupdf-qt/include  \
    ../../thirdparty/mupdf-qt/mupdf/include

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
        message("RaspberryPi: Kein Cross Compile")
        OS_PATH_NAME = raspberry
    }
    target.path = /usr/lib
    INSTALLS += target
}

CONFIG(debug, debug|release) {
    DESTDIR = ../../build/lib_mupdf/$${OS_PATH_NAME}/debug
} else {
    DESTDIR = ../../build/lib_mupdf/$${OS_PATH_NAME}/release
}

LIBS += -L$$PWD/../../thirdparty/mupdf-qt/mupdf/build/$${OS_PATH_NAME}/release/

message($$QMAKESPEC)

LIBS +=    -lmupdf \
            -ljbig2dec \
            -ljpeg \
            -lmujs \
            -lfreetype \
            -lopenjpeg \
            -lz
