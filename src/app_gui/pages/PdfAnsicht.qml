import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.2


import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.2

import QtQuick.Layouts 1.0
//BEGIN ACCELEROMETER
import QtSensors 5.3
import QtQuick 2.5
//END ACCELEROMETER


Item {
    id: item
    property alias button_forward: button_forward
    property alias button_back: button_back
    ColumnLayout {
        id: columnLayout1
        anchors.fill: parent

        Image {
            id: image1
            fillMode: Image.PreserveAspectFit
            Layout.fillHeight: true
            Layout.fillWidth: true
            sourceSize.width: paintedWidth;
            sourceSize.height: paintedHeight;
            cache: false
            source: "image://pdfrenderer/" + pagenr
        }

        RowLayout {
            id: rowLayout1
            Layout.fillWidth: true
            Button {
                id: button_back
                text: qsTr("Zurück")
                anchors.centerIn: rowLayout1.Center
                Layout.fillWidth: true
                //Layout.preferredWidth: -1
            }
            Button {
                id: button_forward
                text: qsTr("Vorwärts")
                anchors.centerIn: rowLayout1.Center
                Layout.fillWidth: true
            }

            Text {
                id: text1
                text: qsTr(" ") + pagenr
                anchors.centerIn: rowLayout1.Center
                Layout.fillWidth: true
                font.pixelSize: 20
            }
        }
    }
}
