import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")
    property int frame_count: 1
    property int back_subtraction_end_pos: 0
    //property var frame_nr: 0

//    menuBar: MenuBar {
//        Menu {
//            title: qsTr("File")
//            MenuItem {
//                text: qsTr("&Open")
//                onTriggered: console.log("Open action triggered");
//            }
//            MenuItem {
//                text: qsTr("Exit")
//                onTriggered: Qt.quit();
//            }
//        }
//    }
    ColumnLayout {
            id: columnLayout1
            anchors.fill: parent
            Image {
                id: orginal_image_frame
                fillMode: Image.PreserveAspectFit
                Layout.fillHeight: true
                Layout.fillWidth: true
                //sourceSize.width: paintedWidth;
                //sourceSize.height: paintedHeight;

                cache: false
                source: "image://test_handcontrol/0/" + slider.value
            }
            Image {
                id: background_substraction
                fillMode: Image.PreserveAspectFit
                Layout.fillHeight: true
                Layout.fillWidth: true
                //sourceSize.width: paintedWidth;
                //sourceSize.height: paintedHeight;

                cache: false
                source: "image://test_handcontrol/1/" + back_subtraction_end_pos
            }
            RowLayout{
                Slider {
                    id: slider
                    maximumValue: frame_count
                    Layout.fillWidth: true
                    stepSize: 1

                }
                Text {
                    text: "Frame Nr.: " + slider.value
                }

                Button {
                    text: "<<"
                    onClicked: {
                        if(slider.value)
                        {
                            slider.value--;
                        }
                    }

                }
                Button {
                    text: ">>"
                    onClicked: {
                        if(slider.value<frame_count)
                        {
                            slider.value++;
                        }
                    }

                }
                Button {
                    text: "start background substraction"
                    onClicked: {
                        back_subtraction_end_pos = slider.value;
                    }

                }
            }
        }
}
