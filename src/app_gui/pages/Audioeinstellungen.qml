import QtQuick 2.6
import QtQuick.Controls 2.0

Flickable {
    id: flickable

    contentHeight: pane.height

    Pane {
        id: pane
        width: flickable.width

        height:  if (flickable.height<column.height) {
                     return column.height + 50
                 } else {
                     return flickable.height * 1.25
                 }

        Column {
            id: column
            spacing: 40
            width: parent.width

            Label {
                width: parent.width
                wrapMode: Label.Wrap
                horizontalAlignment: Qt.AlignHCenter
                text: "Audioeinstellungen werden hier vorgenommen:"

              }

            Image {
                rotation: 90
                source: "qrc:/images/arrows.png"
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    ScrollIndicator.vertical: ScrollIndicator { }
}

