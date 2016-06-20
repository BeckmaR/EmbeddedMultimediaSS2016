import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.2

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
            Button {
                id: button_back
                text: qsTr("Zurück")
                Layout.preferredWidth: -1
            }
            Button {
                id: button_forward
                text: qsTr("Vorwärts")
            }

            Text {
                id: text1
                text: qsTr("Seite: ") + pagenr
                font.pixelSize: 12
            }
        }
    }
}

