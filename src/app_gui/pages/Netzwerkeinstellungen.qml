import QtQuick 2.6
import QtQuick.Controls 2.0

import QtQuick 2.0


Flickable {
    id: flickable

    contentHeight: pane.height


    Timer{
        id: getPageTimer
        interval: 100
        running: false
        repeat: true
        onTriggered: {
            console.log("GP-Send")
            getPage();
        }
    }

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


            Label {//Netzwerkeinstellungen werden hier vorgenommen:
                width: parent.width
                wrapMode: Label.Wrap
                horizontalAlignment: Qt.AlignHCenter
                text: "Netzwerkeinstellungen werden hier vorgenommen:"
            }

            Label {//IP-Adress
                width: parent.width
                wrapMode: Label.Wrap
                horizontalAlignment: Qt.AlignHCenter
                text: "IP-Adress:"
            }

            TextField {//IP-Adress
                 id: ipAdress
                  placeholderText: qsTr("IP-Adress")
              }

            Label {//Hörer
                visible: if ((appState == appStateHörerSet)||(appState == appStateHörerReady)){
                             return true
                         }else{
                             return false
                         }
                width: parent.width
                wrapMode: Label.Wrap
                horizontalAlignment: Qt.AlignHCenter
                text: "Hörer:"
            }
            Button{//Test_Hörer_Connect-->active=true
                id: connectButtonHörer
                visible: if ((appState == appStateHörerSet)||(appState == appStateHörerReady)){
                             return true
                         }else{
                             return false
                         }
                text: "Test_Hörer_Connect"
                onClicked: {
                    webSocketId.active = true
                    }
            }
            Label {//MASTER
                visible: if ((appState == appStateSprecherSet)||(appState == appStateSprecherReady)){
                             return true
                         }else{
                             return false
                         }
                width: parent.width
                wrapMode: Label.Wrap
                horizontalAlignment: Qt.AlignHCenter
                text: "Master:"
            }

            Button{//Connect-Network
                id: connectButton
                visible: true
                text: "Connect-Network"
                onClicked: {
                    connect(ipAdress);
                    //registerMaster("mpw12345");
                    }
            }
            Button{//Connect-Master
                id: connectButtonMaster
                visible: if ((appState == appStateSprecherSet)||(appState == appStateSprecherReady)){
                             return true
                         }else{
                             return false
                         }
                text: "Connect-Master"
                onClicked: {
                    registerMaster("mpw12345");
                    }
            }
            Button{//Download-File
                id: openButton
                visible: if ((appState == appStateHörerSet)||(appState == appStateHörerReady)){
                             return true
                         }else{
                             return false
                         }
                text: "Download-File"
                onClicked: {
                    console.log("Hörer try download")
                    download_pdf("Presention.pdf")
                    }
            }
            Button{//Set Page
                id: setPageButton
                visible: if ((appState == appStateSprecherSet)||(appState == appStateSprecherReady)){
                             return true
                         }else{
                             return false
                         }
                text: "Set Page"
                onClicked: {
                    console.log("Master set Page")
                    setPage(12);
                    }
            }
            Button{//Get-Page
                id: getPageButtonHörer
                text: "Get-Page"
                onClicked: {
                        getPage();
                    }
            }
            Button{//Upload-File
                id: uploadButton
                visible: if ((appState == appStateSprecherSet)||(appState == appStateSprecherReady)){
                             return true
                         }else{
                             return false
                         }
                text: "Upload-File"
                onClicked: {
                        console.log("Choose Data")
                        fileDialog.open();
                        openfile(fileDialog.fileUrl)
                        sendFile(fileDialog.fileUrl);
                    }
            }

            Button{//Hörer_Fertig-->appState=appStateHörerReady
                id: readyButtonHörer
                visible: if ((appState == appStateHörerSet)||(appState == appStateHörerReady)){
                             return true
                         }else{
                             return false
                         }
                text: "Übernehmen"
                onClicked: {
                    listView.currentIndex = 2
                    titleLabel.text = "Pdf-Ansicht"
                    stackView.replace("qrc:/pages/PdfSteuerung.qml")
                    appState=appStateHörerReady
                    }
            }
            Button{//Sprecher_Fertig-->appState=appStateSprecherReady
                id: readyButtonSprecher
                visible: if ((appState == appStateSprecherSet)||(appState == appStateSprecherReady)){
                             return true
                         }else{
                             return false
                         }
                text: "Übernehmen"
                onClicked: {
                    listView.currentIndex = 2
                    titleLabel.text = "Pdf-Ansicht"
                    stackView.replace("qrc:/pages/PdfSteuerung.qml")
                    appState=appStateSprecherReady
                    }
            }
            /*Label {//webSocketId.status == WebSocket.Open ? qsTr("Sending...") : qsTr("Welcome!")
                id: messageBox
                width: parent.width
                wrapMode: Label.Wrap
                horizontalAlignment: Qt.AlignHCenter
                text: webSocketId.status == WebSocket.Open ? qsTr("Sending...") : qsTr("Welcome!")

               /* MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        socket.active = !socket.active
                        //Qt.quit();
                    }
                }*/
         //   }


        }
    }

    ScrollIndicator.vertical: ScrollIndicator { }
}
