#-------------------------------------------------
#
# Project created by QtCreator 2016-06-17T15:59:55
#
#-------------------------------------------------

TARGET = lib_mupdf
TEMPLATE = lib

DEFINES += LIB_MUPDF_LIBRARY
#CONFIG += shared

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

unix {
    target.path = /usr/lib
    INSTALLS += target
}

Release:DESTDIR = ../../build/lib_mupdf/$${OS_PATH_NAME}/release
Debug:DESTDIR = ../../build/lib_mupdf/$${OS_PATH_NAME}/debug

 LIBS += -L$$PWD/../../thirdparty/mupdf-qt/mupdf/build/release/$${OS_PATH_NAME}/ -lmupdf \
    -L$$PWD/../../thirdparty/mupdf-qt/mupdf/build/release/$${OS_PATH_NAME}/ -ljbig2dec \
    -L$$PWD/../../thirdparty/mupdf-qt/mupdf/build/release/$${OS_PATH_NAME}/ -ljpeg \
    -L$$PWD/../../thirdparty/mupdf-qt/mupdf/build/release/$${OS_PATH_NAME}/ -lmujs \
    -L$$PWD/../../thirdparty/mupdf-qt/mupdf/build/release/$${OS_PATH_NAME}/ -lfreetype \
    -L$$PWD/../../thirdparty/mupdf-qt/mupdf/build/release/$${OS_PATH_NAME}/ -lopenjpeg \
    -L$$PWD/../../thirdparty/mupdf-qt/mupdf/build/release/$${OS_PATH_NAME}/ -lz

message("$${OS_PATH_NAME} Version")
