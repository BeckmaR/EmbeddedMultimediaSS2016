import QtQuick 2.6 //import QtQuick 2.7
import QtQuick.Layouts 1.3 //import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.Universal 2.0
import Qt.labs.settings 1.0

import QtQuick.Dialogs 1.0


ApplicationWindow {
    id: window
    width: 360
    height: 820
    visible: true
    title: qsTr("Presentao_APP")


    Settings {
        id: settings
        property string style: "Universal"
    }

    //SIGNALE

    property int appState: 0 //initialer Wert im main stackView
    property int appStateStart: 1
    property int appStateSprecherSet: 2
    property int appStateHörerSet: 3
    property int appStateSprecherReady: 4
    property int appStateHörerReady: 5

    signal toServer_pdf(string path)
    signal connect(string url)
    signal sendFile(string filename)
    signal registerMaster(string password)
    signal download_pdf(string filename)
    signal getPage()
    signal setPage(int pagenumber)

    property int pagenr: -1
    signal nextpage()
    signal prevpage()
    signal openfile(string _url)
    function qml_setPage(nr) {
        pagenr = nr
    }
    function connection_success(){
    //SPÄTAA
    }

    Drawer {//Liste mit z.B. sämtlichen Geräteeinstellungen
        id: drawer
        width: Math.min(window.width, window.height) / 3 * 2
        height: window.height

        ListView {
            id: listView
            enabled: appState >= 4
            visible: appState >= 4
            currentIndex: -1
            anchors.fill: parent

            delegate: ItemDelegate {
                width: parent.width
                text: model.title
                highlighted: ListView.isCurrentItem
                onClicked: {// Wenn der ausgewählte Eintrag nicht bereits ausgewählt ist, wird ersetzt er den Stack
                    if (index == 0) { //Start
                        listView.currentIndex = index
                        titleLabel.text = model.title
                        stackView.replace(model.source)
                        appState=appStateStart
                    }else if (index == 1){
                        listView.currentIndex = index
                        titleLabel.text = model.title
                        stackView.replace(model.source)
                        if (appState==appStateHörerReady){
                            appState=appStateHörerSet
                        }
                        if (appState==appStateSprecherReady){
                            appState=appStateSprecherSet
                        }
                    }else if (listView.currentIndex != index) {
                        listView.currentIndex = index
                        titleLabel.text = model.title
                        stackView.replace(model.source)
                        }
                    drawer.close()
                }
            }

            model: ListModel {
                ListElement { title: "Rollenwahl"; source: "qrc:/pages/Rollenwahl.qml" }
                ListElement { title: "Netzwerkeinstellungen"; source: "qrc:/pages/Netzwerkeinstellungen.qml" }
                ListElement { title: "Pdf-Ansicht"; source: "qrc:/pages/PdfSteuerung.qml" } //PdfSteuerung ruft PdfAnsicht auf
                ListElement { title: "Bildschirmeinstellungen"; source: "qrc:/pages/Bildschirmeinstellungen.qml" }
                ListElement { title: "Audioeinstellungen"; source: "qrc:/pages/Audioeinstellungen.qml" }
                ListElement { title: "Touchsteuerung"; source: "qrc:/pages/Touchsteuerung.qml" }
                ListElement { title: "Schwingsteuerung"; source: "qrc:/pages/Schwingsteuerung.qml" }
                ListElement { title: "Gestensteuerung"; source: "qrc:/pages/Gestensteuerung.qml" }
                ListElement { title: "Audio/Klatschsteuerung"; source: "qrc:/pages/Klatschsteuerung.qml" }
            }
            ScrollIndicator.vertical: ScrollIndicator { }
        }
    }

    StackView {//Startseite
        id: stackView
        anchors.fill: parent
        initialItem: Pane {
            id: pane
            ColumnLayout {
                id: columnLayout1
                //anchors.fill: parent

                Label {
                    text: "Willkommen zur Ihrer Präsentationsapp! "
                }

                Label {
                    text: "<br><b>Starten der App: "
                }
                Button{
                    id: startButton
                    text: "Start"
                    onClicked: {
                        listView.currentIndex = 0
                        titleLabel.text = "Rollenwahl"
                        stackView.replace("qrc:/pages/Rollenwahl.qml")
                        appState=appStateStart
                    }
                }
            }
        }
    }


    header: ToolBar { //Leiste am Bildschirm unten
        Material.foreground: "white"

        RowLayout {
            spacing: 20
            anchors.fill: parent

            ToolButton {//Wichtiger gezeichneter Knopf um das Listen-Menu aufzurufen
                contentItem: Image {
                    fillMode: Image.Pad
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                    source: if (appState <= appStateStart){
                                return "qrc:/images/blue.png"
                            }else if ((appState == appStateHörerSet)||(appState == appStateSprecherSet)){
                                return "qrc:/images/arrow.png"
                            }else{
                                return "qrc:/images/drawer.png"
                            }
                }
                onClicked: if (appState <= appStateStart){
                               //Nothing
                           }else if ((appState == appStateHörerSet)||(appState == appStateSprecherSet)){
                               listView.currentIndex = 0
                               titleLabel.text = "Rollenwahl"
                               stackView.replace("qrc:/pages/Rollenwahl.qml")
                               appState=appStateStart
                           }else{
                                drawer.open()
                            }
            }

            Label {//App-Namen zur Orientierung (ausblenden nach Zeit x?)
                id: titleLabel
                text: "Presentao-App"
                font.pixelSize: 20
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }

            ToolButton {//Gezeichneter Knopf um Menu fürs Hilfe und Team Info aufzurufen
                visible: true //masterv
                contentItem: Image {
                    fillMode: Image.Pad
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                    source: "qrc:/images/menu.png"
                }
                onClicked: optionsMenu.open()

                Menu {//Zum öffnen von Filebrowser und Info - Popups
                    id: optionsMenu
                    x: parent.width - width
                    transformOrigin: Menu.TopRight

                    MenuItem {
                        text: "Hilfe"
                        onTriggered: {
                            hilfeDialog.open()
                        }
                    }
                    MenuItem {
                        text: "Das Team"
                        onTriggered: infoDialog.open()
                    }
                }
            }
        }
    }


    Popup {//Hilfe POPUP-Menu
        id: hilfeDialog
        modal: true
        focus: true
        x: (window.width - width) / 2
        y: window.height / 6
        width: Math.min(window.width, window.height) / 3 * 2
        contentHeight: hilfeSpalte.height
        Column {//Infobox
            id: hilfeSpalte
            spacing: 20
            Label {//Überschrift
                text: "Hilfe zur App:"
                font.bold: true
            }
            Label {//Applicationsname
                width: infoDialog.availableWidth
                text: "Presentao"
                wrapMode: Label.Wrap
                font.pixelSize: 12
            }
            Label {//EntwicklerTeam
                width: infoDialog.availableWidth
                text: "Diese App dient dem:<br>"
                    + "Erstellen einer Präsentation<br>Anschauen einer Präsentation<br>"
                wrapMode: Label.Wrap
                font.pixelSize: 12
            }
            Label {//Weitere Informationen
                width: infoDialog.availableWidth
                text: "Für Tipps und weitere Informationen"
                +" lesen Sie bitte den ausführlichen Abschlussbericht"
                wrapMode: Label.Wrap
                font.pixelSize: 8
            }
        }
    }

    Popup {//Information übers Team
        id: infoDialog
        modal: true
        focus: true
        x: (window.width - width) / 2
        y: window.height / 6
        width: Math.min(window.width, window.height) / 3 * 2
        contentHeight: infoSpalte.height
        Column {//Infobox
            id: infoSpalte
            spacing: 20
            Label {//Überschrift
                text: "Team der App:"
                font.bold: true
            }
            Label {//Applicationsname
                width: infoDialog.availableWidth
                text: "Presentao"
                wrapMode: Label.Wrap
                font.pixelSize: 12
            }
            Label {//EntwicklerTeam
                width: infoDialog.availableWidth
                text: "Diese App ist entwickelt von:<br>"
                    + "Beckmann, René<br>Brexeler, Sascha<br>Hebbler, Tim<br>Kastano, Diana<br>Miken, Jens"
                wrapMode: Label.Wrap
                font.pixelSize: 12
            }
            Label {//Weitere Informationen
                width: infoDialog.availableWidth
                text: "Für Tipps und weitere Informationen"
                +" lesen Sie bitte den ausführlichen Abschlussbericht"
                wrapMode: Label.Wrap
                font.pixelSize: 8
            }
        }
    }


    FileDialog{//Um Dateien später aufrufen zu können
        id: fileDialog
        title: "Please choose a PDF file"
        folder: shortcuts.home
        nameFilters: [ "Pdf files (*.pdf)" ]
        onAccepted: {

            console.log("You chose: " + fileDialog.fileUrl)
            console.log("You chose2: " + fileDialog.fileUrl.toString())
            var pdf_path = fileDialog.fileUrl.toString()
            pdf_path= pdf_path.replace(/^(file:\/{3})|(qrc:\/{2})|(http:\/{2})/,"");
            openfile(pdf_path)
            nextpage();//Da die Neue Pdf sonst erst beim ersten Blättern geladen wird
            prevpage();
            if (listView.currentIndex != 1) {
                listView.currentIndex = 1
                titleLabel.text = "Pdf-Ansicht"
                stackView.replace("qrc:/pages/PdfSteuerung.qml")
            }
        }
        onRejected: {
            console.log("Canceled")
        }
   //     Component.onCompleted: visible = false
    }
}
