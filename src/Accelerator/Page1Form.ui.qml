import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Window 2.2

Item {
    property alias button2: button2
    property alias button1: button1
    property alias button3: button3

    ColumnLayout {
        id: columnLayout1
        anchors.fill: parent


        Button {
            id: button1
            text: qsTr("Press Me 1")
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        }

        Button {
            id: button2
            text: qsTr("Press Me 2")
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        }

        Button {
            id: button3
            text: Screen.orientation
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        }
    }

}
