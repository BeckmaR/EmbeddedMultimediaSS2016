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

            Label {//Sprecher
                visible: if (((appState == appStateSprecherSet)&&(!rmOK))||((appState == appStateSprecherReady))&&(!rmOK)){
                             return true
                         }else{
                             return false
                         }
                text: "<b>Sprecher:"
            }
            Label {//Zuhörer
                visible: if ((appState == appStateHörerSet)||(appState == appStateHörerReady)){
                             return true
                         }else{
                             return false
                         }
                text: "<b>Zuhörer:"
            }
            Label {//Master Password setzen
                visible: if (((appState == appStateSprecherSet)&&(!rmOK))||((appState == appStateSprecherReady))&&(!rmOK)){
                            return true
                         }else{
                            return false
                         }
                text: "Geben Sie bitte das Masterpasswort an:"
            }
            TextField {//Masterpasswort
                 id: masterPW
                 visible: if (((appState == appStateSprecherSet)&&(!rmOK))||((appState == appStateSprecherReady))&&(!rmOK)){
                              return true
                          }else{
                              return false
                          }
                  placeholderText: qsTr("Masterpasswort")
            }
            Label {//Sprecher Passwort falsch
                visible: if ((appState == appStateSprecherSet)&&(pwFalsch)){
                             return true
                         }else{
                             return false
                         }
                text: "<b>Bitte überprüfen Sie Ihre Passworteingabe.</b>"
            }
            Button{//Master bestätigen
                id: connectButtonMaster
                visible: if (((appState == appStateSprecherSet)&&(!rmOK))||((appState == appStateSprecherReady))&&(!rmOK)){
                             return true
                          }else{
                             return false
                          }
                text: "Bestätigen"
                onClicked: {
                    if(masterPW.text=="mpw12345"){
                        registerMaster(masterPW.text); //mpw12345//masterPW
                        pwFalsch=0
                        rmOK=1//SPÄTER hier raus, da sonst global property
                    }else {
                        pwFalsch=1
                    }

                }
            }
            Label {//Sprecher Regestiert?
                visible: if ((appState == appStateSprecherSet)||(appState == appStateSprecherReady)){
                             return true
                         }else{
                             return false
                         }
                text: if(rmOK){
                          return "<br><b>Sie sind als Sprecher regestriert!</b><br><br>Bitte laden Sie zunächst eine Pdf hoch."
                      } else {
                        return "<br>Sie sind nicht als Sprecher regestriert!<br><br>"
                      }
            }
            Button{//Upload-File
                id: uploadButton
                visible: if (((appState == appStateSprecherSet)&&(rmOK))||((appState == appStateSprecherReady))&&(rmOK)){
                             return true
                         }else{
                             return false
                         }
                text: "Pdf hochladen"
                onClicked: {
                        console.log("Choose Data")
                        fileDialog.open();
                    }
            }
            Label{//"Bitte laden Sie nun eine Pdf vom Server herunter."
                visible: if ((appState == appStateHörerSet)||(appState == appStateHörerReady)){
                             return true
                         }else{
                             return false
                         }
                text: "Bitte laden Sie nun eine Pdf vom Server herunter."
            }
            Button{//Download-File
                id: openButton
                visible: if ((appState == appStateHörerSet)||(appState == appStateHörerReady)){
                             return true
                         }else{
                             return false
                         }
                text: "Pdf herunterladen"
                onClicked: {
                    console.log("Hörer try download")
                    download_pdf("Presention.pdf")
                    }
            }
            Label {//Sprecher Regestiert?
                visible: if ((appState == appStateSprecherSet)||(appState == appStateSprecherReady)){
                             return true
                         }else{
                             return false
                         }
                text: if(rmOK){
                          return "<br><b>Bitte wählen Sie aus."
                      }
            }
            Button{//Upload-File
                id: syncButtonSprecher
                visible: if (((appState == appStateSprecherSet)&&(rmOK))||((appState == appStateSprecherReady))&&(rmOK)){
                             return true
                         }else{
                             return false
                         }
                text: "AutoSync"
                onClicked: {
                    autoSyncON=1
                    }
            }
            Label {//"Möchten Sie dass"
                visible: if ((((appState == appStateSprecherSet)&&(rmOK))||((appState == appStateSprecherReady))&&(rmOK))||((appState == appStateHörerSet)||(appState == appStateHörerReady))){
                             return true
                         }else{
                             return false
                         }
                text: "Mit bestätigen wechseln sie zur Pdf-Ansicht"
            }
            Button{//Voreinstellungen Fertig --> Pdf Ansicht
                id: readyButtonSprecher
                visible: if ((((appState == appStateSprecherSet)&&(rmOK))||((appState == appStateSprecherReady))&&(rmOK))||((appState == appStateHörerSet)||(appState == appStateHörerReady))){
                             return true
                         }else{
                             return false
                         }
                text: "Bestätigen"
                onClicked: {
                    listView.currentIndex = 3
                    titleLabel.text = "Pdf-Ansicht"
                    stackView.replace("qrc:/pages/PdfSteuerung.qml")
                    if ((appState == appStateSprecherSet)||(appState == appStateSprecherReady)){
                        appState=appStateSprecherReady
                     }else if((appState == appStateHörerSet)||(appState == appStateHörerReady)){
                         appState=appStateHörerReady
                     }
                }
            }
        }
    }
    ScrollIndicator.vertical: ScrollIndicator { }
}


//            Button{//Get-Page
//                id: getPageButtonHörer
//                text: "Get-Page"
//                onClicked: {
//                        getPage();
//                    }
//            }

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

/*  Timer{
      //id: getPageTimer
      id: registerMasterTimer
      interval: 100
      running: false
      repeat: true
      onTriggered: {
          console.log("RM-Send")
          connect("ws://"+ipAdress.text);
          registerMasterTimer.stop()
          //console.log("GP-Send")
          //getPage();
      }
  }*/
