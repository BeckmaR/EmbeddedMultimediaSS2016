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

            Label {//"Willkommen zur Ihrer Präsentationsapp! "
                text: "Willkommen zur Ihrer Präsentationsapp! "
            }
            Label {//Bitte verbinden Sie sich mit dem Server.
                text: "<br>Bitte verbinden Sie sich mit dem Server.<br>"
            }
            Label {//IP-Adress
                text: "<br><b>IP-Adresse:"
            }
            TextField {//IP-Adress
                 id: ipAdress
                  placeholderText: qsTr("IP-Adresse")
            }
            Button{//Vom Verbindungsaufbau zur Rollenwahl
                id: connectButton
                text: "Verbinden"
                onClicked: {
             //       connectionOK=0
                    connect("ws://"+ipAdress.text+":1234")//
                }
            }
        }
    }
    ScrollIndicator.vertical: ScrollIndicator { }
}
