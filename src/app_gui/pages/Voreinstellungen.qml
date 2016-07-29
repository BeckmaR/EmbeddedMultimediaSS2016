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
                if (position!=0){
                    autoSyncON=1
                    getPage();
                    console.log("autoSyncON=1")
                }else{
                    autoSyncON=0
                }
            }
        }
    }
    Component {
        id: swDeCompGesten

        SwitchDelegate {
            text: "Gestensteuerung"
            onClicked: {
                if (position!=0){
                    gestensteuerungON=1
                    console.log("gestensteuerungON=1")
                }else{
                    gestensteuerungON=0
                }
            }
        }
    }
    Component {
        id: swDeCompSprach

        SwitchDelegate {
            text: "Sprachsteuerung"
            onClicked: {
                if (position!=0){
                    sprachsteuerungON=1
                    console.log("sprachsteuerungON=1")
                    startstopKlopfen();
                }else{
                    sprachsteuerungON=0
                    startstopKlopfen();
                }
            }
        }
    }
    Component {
        id: swDeCompKipp

        SwitchDelegate {
            text: "Kippsteuerung"
            onClicked: {
                if (position!=0){
                    kippsteuerungON=1
                    console.log("kippsteuerungON=1")
                }else{
                    kippsteuerungON=0
                }
            }
        }
    }

    ColumnLayout {
        id: column
        spacing: 10
        anchors.fill: parent
        anchors.topMargin: 20
        Label {//Sprecher
            Layout.fillWidth: true
            wrapMode: Label.Wrap
            horizontalAlignment: Qt.AlignHCenter
            visible: if (((appState == appStateSprecherSet)&&(!rmOK))||((appState == appStateSprecherReady))&&(!rmOK)){
                         return true
                     }else{
                         return false
                     }
            text: "<b>Sprecher:"
        }
        Label {//Zuhörer
            Layout.fillWidth: true
            wrapMode: Label.Wrap
            horizontalAlignment: Qt.AlignHCenter
            visible: if ((appState == appStateHörerSet)||(appState == appStateHörerReady)){
                         return true
                     }else{
                         return false
                     }
            text: "<b>Zuhörer:"
        }
        Label {//Master Password setzen
            Layout.fillWidth: true
            wrapMode: Label.Wrap
            horizontalAlignment: Qt.AlignHCenter
            visible: if (((appState == appStateSprecherSet)&&(!rmOK))||((appState == appStateSprecherReady))&&(!rmOK)){
                        return true
                     }else{
                        return false
                     }
            text: "Geben Sie bitte das Masterpasswort an:"
        }
        TextField {//Masterpasswort
            Layout.fillWidth: true
            wrapMode: Label.Wrap
            horizontalAlignment: Qt.AlignHCenter
             id: masterPW
             visible: if (((appState == appStateSprecherSet)&&(!rmOK))||((appState == appStateSprecherReady))&&(!rmOK)){
                          return true
                      }else{
                          return false
                      }
              placeholderText: qsTr("Masterpasswort")
        }
        Label {//Sprecher Passwort falsch
            Layout.fillWidth: true
            wrapMode: Label.Wrap
            horizontalAlignment: Qt.AlignHCenter
            visible: if ((appState == appStateSprecherSet)&&(pwFalsch)){
                         return true
                     }else{
                         return false
                     }
            text: "<b>Bitte überprüfen Sie Ihre Passworteingabe.</b>"
        }
        Button{//Master bestätigen
            id: connectButtonMaster
            Layout.fillWidth: true
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
            Layout.fillWidth: true
            wrapMode: Label.Wrap
            horizontalAlignment: Qt.AlignHCenter
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
        Button{//PDF-Hochladen
            id: uploadButton
            Layout.fillWidth: true
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
            Layout.fillWidth: true
            wrapMode: Label.Wrap
            horizontalAlignment: Qt.AlignHCenter
            visible: if ((appState == appStateHörerSet)||(appState == appStateHörerReady)){
                         return true
                     }else{
                         return false
                     }
            text: "Bitte laden Sie nun eine Pdf vom Server herunter."
        }
        Button{//Download-File
            id: openButton
            Layout.fillWidth: true
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
        Label {//Sprecher: Wählen sie aus
            Layout.fillWidth: true
            wrapMode: Label.Wrap
            horizontalAlignment: Qt.AlignHCenter
            text: "Wählen Sie bitte gewünschte Optionen aus: "
        }
        ListView {
            id: listView2
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
                width: listView2.width
                sourceComponent: delegateComponentMap[text]
            }
        }
        Label {//"Zur Pdf"
            Layout.fillWidth: true
            wrapMode: Label.Wrap
            horizontalAlignment: Qt.AlignHCenter
            visible: if ((((appState == appStateSprecherSet)&&(rmOK))||((appState == appStateSprecherReady))&&(rmOK))||((appState == appStateHörerSet)||(appState == appStateHörerReady))){
                         return true
                     }else{
                         return false
                     }
            text: "Mit bestätigen wechseln sie zur Pdf-Ansicht"
        }
        Button{//Voreinstellungen Fertig --> Pdf Ansicht
            id: readyButtonSprecher
            Layout.fillWidth: true
            visible: if ((((appState == appStateSprecherSet)&&(rmOK))||((appState == appStateSprecherReady))&&(rmOK))||((appState == appStateHörerSet)||(appState == appStateHörerReady))){
                         return true
                     }else{
                         return false
                     }
            text: "Bestätigen"
            onClicked: {
                if ((appState == appStateSprecherSet)||(appState == appStateSprecherReady)){
                    appState=appStateSprecherReady
                 }else if((appState == appStateHörerSet)||(appState == appStateHörerReady)){
                     appState=appStateHörerReady
                 }
                listView.currentIndex = 3
                titleLabel.text = "Pdf-Ansicht"
                stackView.replace("qrc:/pages/PdfSteuerung.qml")
            }
        }
    }
}
