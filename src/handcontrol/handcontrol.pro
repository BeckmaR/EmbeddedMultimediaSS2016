TEMPLATE = app

QT += qml quick multimedia

CONFIG += c++11

SOURCES += main.cpp \
    handcontrol.cpp \
    #test_handcontrol.cpp

TARGET = test_handcontrol

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
#include(deployment.pri)



win32 {
    INCLUDEPATH += ../../build/opencv/include
    LIBS += -L"../../build/opencv/x86/mingw/bin"
    LIBS += -lopencv_core310 \
        #-lopencv_highgui310 \
        -lopencv_imgproc310 \
        #-lopencv_imgcodecs310 \
        #-lopencv_video310 \
        -lopencv_videoio310
        #-lopencv_bgsegm310
}

android {
    INCLUDEPATH += ../../build/opencv/sdk/native/jni/include
    LIBS += -L"../../build/opencv/sdk/native/libs/armeabi-v7a" \
            -L"../../build/opencv/sdk/native/3rdparty/libs/armeabi-v7a"

    LIBS += -llibtiff\
        -llibjpeg\
        -llibjasper\
        -llibpng\
        -lIlmImf\
        -ltbb\
        -lopencv_core\
        #-lopencv_androidcamera\
        -lopencv_flann\
        -lopencv_imgproc\
        -lopencv_highgui\
        -lopencv_features2d\
        -lopencv_calib3d\
        -lopencv_ml\
        -lopencv_objdetect\
        -lopencv_videoio\
        -lopencv_video\
        #-lopencv_contrib\
        -lopencv_photo\
        #-lopencv_java\
        #-lopencv_legacy\
        #-lopencv_ocl\
        -lopencv_stitching\
        -lopencv_superres\
        #-lopencv_ts\
        -lopencv_videostab\
        -lopencv_java3
}

contains(ANDROID_TARGET_ARCH,armeabi-v7a) {
    ANDROID_EXTRA_LIBS = \
        $$PWD/../../build/opencv/sdk/native/libs/armeabi-v7a/libopencv_java3.so
}




HEADERS += \
    handcontrol.h \
    #test_handcontrol.h

DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
