import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Item {
    id: item1
    property alias button1: button1
    property alias button2: button2
    property alias columnLayout1: columnLayout1
    property alias filefinder: filefinder

    ColumnLayout {
        id: columnLayout1
        x: 35
        y: 96
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter


        Label {
            id: label4
            text: qsTr("Choose your Network")
            horizontalAlignment: Text.AlignLeft
            font.bold: true
        }

        TextField {
            id: textField2
            text: qsTr("enter IP-Address")
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.columnSpan: 2
        }

        Label {
            id: label3
            text: qsTr("Choose your role")
            font.bold: true
            horizontalAlignment: Text.AlignLeft
        }

        Label {
            id: label1
            text: qsTr("Speaker")
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            font.underline: true
            font.italic: true
        }

        TextField {
            id: textField1
            text: qsTr("enter password")
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.columnSpan: 2
        }

        Button {
            id: button1
            text: qsTr("Connect")
            Layout.fillWidth: true
        }

        Label {
            id: label2
            text: qsTr("Listener")
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.fillHeight: false
            Layout.fillWidth: false
            font.underline: true
            font.italic: true
        }


        Button {
            id: button2
            text: qsTr("Connect")
            Layout.fillWidth: true
        }

        Button {
            id: filefinder
            text: qsTr("Open File")
            Layout.fillWidth: true
        }
    }
}
