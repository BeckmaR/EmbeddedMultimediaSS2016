import QtQuick 2.5
import QtQuick.Controls 1.4
import QtMultimedia 5.5
import my.uri 1.0

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("&Open")
                onTriggered: console.log("Open action triggered");
            }
            MenuItem {
                text: qsTr("Exit")
                onTriggered: Qt.quit();
            }
        }
    }

    Label {
        text: qsTr("Hello World")
        anchors.centerIn: parent
    }

    Camera {
        id: camera
        captureMode: CaptureViewfinder
        viewfinder {
            resolution: "320x240"
        }
    }
    MyFilter {
        id: filter
        // set properties, they can also be animated
        //onFinished: console.log("results of the computation: " + result)
    }
    VideoOutput {
        //resolution: "320x240"
        source: camera
        filters: [ filter ]
        //anchors.fill: parent

    }
}
