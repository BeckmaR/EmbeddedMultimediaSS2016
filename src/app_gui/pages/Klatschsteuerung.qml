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
                text: "Wenn diese Funktion und das Mikrofon aktiviert sind, können Audiosignale mit einem breiten Frequenzspektrum bei einem ausreichen hohen Schalldruckpegel zum Blättern in der Pdf genutzt werden! Geeignete Signale entstehen beim Klopfen, oder Klatschen. Einmaliges Ausführen innerhalb einer Sekunde dieht zum Vorwärt- zweimaliges zum Rückwärtsblättern"
            }
        }
    }

    ScrollIndicator.vertical: ScrollIndicator { }
}

