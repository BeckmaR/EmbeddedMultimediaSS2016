import QtQuick 2.6
import QtQuick.Controls 2.0

Flickable {
    id: flickable

    contentHeight: pane.height

    Pane {
        id: pane
        width: flickable.width
        height: if (flickable.height<column.height) {
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
                font.pixelSize: 22
                font.italic: true
                color: "steelblue"
                text: "Wenn diese Funktion und die Kamara aktiviert sind, können langsame horizontale Wischebewegungen vor der Frontkamera zum Blättern in der Pdf genutzt werden! Wischen nach rechs bedingt Vorwärt- Wischen nach links Rückwärtsblättern. Eine ausreichende Helligkeit und ein nicht bewegter Hintergrund sorgen für gute Einsatzbedingungen"
            }
        }
    }

    ScrollIndicator.vertical: ScrollIndicator { }
}

