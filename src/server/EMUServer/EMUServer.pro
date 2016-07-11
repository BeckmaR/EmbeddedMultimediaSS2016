QT += core websockets
QT -= gui

CONFIG += c++11

TARGET = EMUServer
CONFIG += console
CONFIG -= app_bundle

TEMPLATE = app

SOURCES += main.cpp \
    server.cpp \
    pdfrender.cpp

HEADERS += \
    server.h \
    pdfrender.h
