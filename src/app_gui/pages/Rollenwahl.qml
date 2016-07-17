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

            Label {//"Bitte wählen Sie Ihrer Rolle: "
                text: "Bitte wählen Sie Ihrer Rolle: "
            }
            Label {//Sprecher
                text: "<br><b>Sprecher: "
            }
            Button{//Ja, weiter
                id: sprecherButton
                text: "Ja, weiter"
                onClicked: {
                    listView.currentIndex = 2
                    titleLabel.text = "Voreinstellungen"
                    stackView.replace("qrc:/pages/Voreinstellungen.qml")
                    appState=appStateSprecherSet
                }
            }
            Label {//Zuhörer
                text: "<br><b>Zuhörer: "
            }
            Button{//Ja, weiter
                id: zuhörerButton
                text: "Ja, weiter"
                onClicked: {
                    listView.currentIndex = 2
                    titleLabel.text = "Voreinstellungen"
                    stackView.replace("qrc:/pages/Voreinstellungen.qml")
                    appState=appStateHörerSet
                }
            }
        }
    }

    ScrollIndicator.vertical: ScrollIndicator { }
}
