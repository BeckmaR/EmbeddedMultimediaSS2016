import QtQuick 2.6
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.0

Pane {
    padding: 0

    property var delegateComponentMap: {
        "AutoSynchronisation": swDeCompSyn,
        "Gestensteuerung": swDeCompGesten,
        "Sprachsteuerung": swDeCompSprach,
        "Kippsteuerung": swDeCompKipp
    }
    Component {
        id: swDeCompSyn

        SwitchDelegate {
            text: "AutoSynchronisation"
            onClicked: {
                if (position!=0)
                console.log("KLAPPPERT")
            }
        }
    }
    Component {
        id: swDeCompGesten

        SwitchDelegate {
            text: "Gestensteuerung"
            onClicked: {
                if (position!=0)
                console.log("KLAPPPERT")
            }
        }
    }
    Component {
        id: swDeCompSprach

        SwitchDelegate {
            text: "Sprachsteuerung"
            onClicked: {
                if (position!=0)
                console.log("KLAPPPERT")
            }
        }
    }
    Component {
        id: swDeCompKipp

        SwitchDelegate {
            text: "Kippsteuerung"
            onClicked: {
                if (position!=0)
                console.log("KLAPPPERT")
            }
        }
    }

    ColumnLayout {
        id: column
        spacing: 40
        anchors.fill: parent
        anchors.topMargin: 20

        Label {
            Layout.fillWidth: true
            wrapMode: Label.Wrap
            horizontalAlignment: Qt.AlignHCenter
            text: "Wählen Sie bitte gewünschte Optionen aus: "
        }

        ListView {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: ListModel {
                ListElement { type: "SwitchDelegate"; text: "AutoSynchronisation" }
                ListElement { type: "SwitchDelegate"; text: "Gestensteuerung" }
                ListElement { type: "SwitchDelegate"; text: "Sprachsteuerung" }
                ListElement { type: "SwitchDelegate"; text: "Kippsteuerung" }
            }
            section.property: "type"
            delegate: Loader {
                id: delegateLoader
                width: listView.width
                sourceComponent: delegateComponentMap[text]
            }
        }
    }
}
