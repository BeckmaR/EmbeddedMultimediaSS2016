import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick 2.0


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
            spacing: 10
            width: parent.width

            /*Label {
                text: "Willkommen zur Ihrer Präsentationsapp! "
            }*/
            Label {
                text: "<br>Bitte wählen Sie Ihrer Rolle: "
            }
            Label {
                text: "<br><b>Sprecher: "
            }
            Button{
                id: sprecherButton
                text: "Ja, weiter"
                onClicked: {
                    listView.currentIndex = 1
                    titleLabel.text = "Einstellungen"
                    stackView.replace("qrc:/pages/Netzwerkeinstellungen.qml")
                    appState=appStateSprecherSet
                }
            }
            Label {
                text: "<b>Zuhörer: "
            }
            Button{
                id: zuhörerButton
                text: "Ja, weiter"
                onClicked: {
                    listView.currentIndex = 1
                    titleLabel.text = "Einstellungen"
                    stackView.replace("qrc:/pages/Netzwerkeinstellungen.qml")
                    appState=appStateHörerSet
                }
            }
        }
    }

    ScrollIndicator.vertical: ScrollIndicator { }
}
