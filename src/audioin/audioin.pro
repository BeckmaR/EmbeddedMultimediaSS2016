#-------------------------------------------------
#
# Project created by QtCreator 2016-06-30T20:35:50
#
#-------------------------------------------------

QT       += multimedia widgets

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = audioin
TEMPLATE = app


SOURCES += main.cpp\
    audioWindow.cpp \
    ffft/fftreal_wrapper.cpp


HEADERS  += \
    audioWindow.h \
    ffft/Array.h \
    ffft/Array.hpp \
    ffft/def.h \
    ffft/DynArray.h \
    ffft/DynArray.hpp \
    ffft/FFTReal.h \
    ffft/FFTReal.hpp \
    ffft/FFTRealFixLen.h \
    ffft/FFTRealFixLen.hpp \
    ffft/FFTRealFixLenParam.h \
    ffft/FFTRealPassDirect.h \
    ffft/FFTRealPassDirect.hpp \
    ffft/FFTRealPassInverse.h \
    ffft/FFTRealPassInverse.hpp \
    ffft/FFTRealSelect.h \
    ffft/FFTRealSelect.hpp \
    ffft/FFTRealUseTrigo.h \
    ffft/FFTRealUseTrigo.hpp \
    ffft/OscSinCos.h \
    ffft/OscSinCos.hpp \
    ffft/fftreal_wrapper.h

CONFIG += mobility
MOBILITY = 

