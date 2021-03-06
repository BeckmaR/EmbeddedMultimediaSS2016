import QtQuick 2.6 //import QtQuick 2.7
import QtQuick.Layouts 1.3 //import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.Universal 2.0
import Qt.labs.settings 1.0
import QtMultimedia 5.6
import QtQuick.Dialogs 1.0


ApplicationWindow {
    id: window
    x: 600
    y: 60
    width: 360
    height: 620
    visible: true
    title: qsTr("Presentao_APP")


    Settings {
        id: settings
        property string style: "Universal"
    }

    //Zustandsvariablen
    property int appState: 0 //initialer Wert im main stackView
    property int appStateStartVerbindungsaufbau: 1
    property int appStateRollenwahl: 2
    property int appStateSprecherSet: 3
    property int appStateHörerSet: 4
    property int appStateSprecherReady: 5
    property int appStateHörerReady: 6

    //Optionen
    property int autoSyncON: 0 //Wenn = 1 --> Sync Button angezeigt
    property int gestensteuerungON: 0 //Wenn = 1 --> Sync Button grün angezeigt
    property int sprachsteuerungON: 0 //Wenn = 1 --> Sync Button grün angezeigt
    property int kippsteuerungON: 0 //Wenn = 1 --> Sync Button grün angezeigt

    //Serveranbindung
    property int pwFalsch: 0
    property int rmOK: 0  //rm_success()--> masterOK = 1
    signal toServer_pdf(string path)
    signal connect(string url)
    signal sendFile(url u)
    signal registerMaster(string password)
    signal download_pdf(string filename)
    signal getPage()
    signal setPage(string page)
    function rm_success(){
            //rmOK=1//Könnte noch ausgewärtet werden.
    }
    function connection_success(){
            listView.currentIndex = 1
            titleLabel.text = "Rollenwahl"
            stackView.replace("qrc:/pages/Rollenwahl.qml")
            appState=appStateRollenwahl
    }

    //Pdf-Controll
    property int pdf_pagenr: -1
    property int pdf_page_count: 0
    function pdf_nextpage()
    {
        var temp_pagenr = pdf_pagenr;
        if(temp_pagenr+1 > pdf_page_count) {
            temp_pagenr = pdf_page_count;
        }   else {
            temp_pagenr++;
        }
        setCurrentPageNr(temp_pagenr);
    }

    function pdf_prevpage()
    {
        var temp_pagenr = pdf_pagenr;
        if (temp_pagenr > 0)
        {
            temp_pagenr--;
        }
        setCurrentPageNr(temp_pagenr);
    }
    function setTotalPageCount(nr)
    {
        pdf_page_count = nr-1;
    }

    signal openfile(url u)
    function setCurrentPageNr(nr) {
        pdf_pagenr = nr
        if ((appState==appStateSprecherReady)&&(autoSyncON==1)){
            setPage(""+pdf_pagenr);
        }
    }

    // Klopfsteuerung
    signal startstopKlopfen()
    function klopf_weiter() {
        if (sprachsteuerungON==1)
        {
            pdf_nextpage();
        }
    }
    function klopf_zurück() {
        if (sprachsteuerungON==1)
        {
            pdf_prevpage();
        }
    }
    function handcontrol_change_page(dir){
        if (gestensteuerungON ==1)
        {
            if(dir ===1)
            {
                pdf_nextpage();
            } else if(dir === -1){
                pdf_prevpage();
            }
        }
    }
    function handcontrol_debugOut(msg){
        console.log(msg);
    }

    // Gestensteuerung
    signal handcontrol_enable(int enable)
    VideoOutput {
        source: camera
        visible: false
        autoOrientation: true
        Camera {
            id: camera
            objectName: "camera"
            position: Camera.FrontFace
//                imageProcessing {
//                    contrast: 0.5
//                }
           Component.onCompleted: {
               camera.stop()
           }
        }
    }
    function handcontrol_start(){
        if(Qt.platform.os !== "windows")
        {
            camera.start()
        }
        handcontrol_enable(1)

    }
    function handcontrol_stop(){
        if(Qt.platform.os !== "windows")
        {
            camera.stop()
        }
        handcontrol_enable(0)
    }

    Drawer {//Einblendbare Leiste am linken Bildschirmrand
        id: drawer
        width: Math.min(window.width, window.height) / 3 * 2
        height: window.height

        ListView {
            id: listView
            enabled: appState >= 5
            visible: appState >= 5
            currentIndex: -1
            anchors.fill: parent

            delegate: ItemDelegate {
                width: parent.width
                text: model.title
                highlighted: ListView.isCurrentItem
                onClicked: {
                    if (index == 0) { //Start & Verbindungsaufbau
                        listView.currentIndex = index
                        titleLabel.text = model.title
                        stackView.replace(model.source)
                        appState=appStateStartVerbindungsaufbau
                        rmOK=0
                        autoSyncON= 0 //Wenn = 1 --> Sync Button angezeigt
                        gestensteuerungON= 0 //Wenn = 1 --> Sync Button grün angezeigt
                        sprachsteuerungON= 0 //Wenn = 1 --> Sync Button grün angezeigt
                        kippsteuerungON= 0 //Wenn = 1 --> Sync Button grün angezeigt
                        //Hier muss noch ein disconnect hin, oder ich zeige Verbindungsstatus an
                    }else if (index == 1){ //Rollenauswahl
                        listView.currentIndex = index
                        titleLabel.text = model.title
                        stackView.replace(model.source)
                        appState=appStateRollenwahl
                        rmOK=0
                        autoSyncON= 0 //Wenn = 1 --> Sync Button angezeigt
                        gestensteuerungON= 0 //Wenn = 1 --> Sync Button grün angezeigt
                        sprachsteuerungON= 0 //Wenn = 1 --> Sync Button grün angezeigt
                        kippsteuerungON= 0 //Wenn = 1 --> Sync Button grün angezeigt
                    }else if (index == 2){ //Vor-Einstellungen
                        listView.currentIndex = index
                        titleLabel.text = model.title
                        if (appState==appStateHörerReady){
                            appState=appStateHörerSet
                        }
                        if (appState==appStateSprecherReady){
                            appState=appStateSprecherSet
                        }
                        //rmOK=0
                        autoSyncON= 0 //Wenn = 1 --> Sync Button angezeigt
                        gestensteuerungON= 0 //Wenn = 1 --> Sync Button grün angezeigt
                        sprachsteuerungON= 0 //Wenn = 1 --> Sync Button grün angezeigt
                        kippsteuerungON= 0 //Wenn = 1 --> Sync Button grün angezeigt
                        stackView.replace(model.source)
                    }else if (listView.currentIndex != index) {
                        listView.currentIndex = index
                        titleLabel.text = model.title
                        stackView.replace(model.source)
                        }
                    drawer.close()
                }
            }

            model: ListModel {
                ListElement { title: "Verbindungsaufbau"; source: "qrc:/pages/Verbindungsaufbau.qml" }
                ListElement { title: "Rollenwahl"; source: "qrc:/pages/Rollenwahl.qml" }
                ListElement { title: "Voreinstellungen"; source: "qrc:/pages/Voreinstellungen.qml" }
                ListElement { title: "Pdf-Ansicht"; source: "qrc:/pages/PdfSteuerung.qml" } //PdfSteuerung ruft PdfAnsicht auf
                ListElement { title: "Kippsteuerung"; source: "qrc:/pages/Schwingsteuerung.qml" }
                ListElement { title: "Klatschsteuerung"; source: "qrc:/pages/Klatschsteuerung.qml" }
                ListElement { title: "Gestensteuerung"; source: "qrc:/pages/Gestensteuerung.qml" }
            }
            ScrollIndicator.vertical: ScrollIndicator { }
        }
    }

    StackView {//Startseite / Verbindungsaufbau
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

                Label {//Verbindungsaufbau:

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
                        connect("ws://"+ipAdress.text+":1234")
                        }
                }
            }
        }
    }

    header: ToolBar { //Leiste am oberen Bildschirmrand
        Material.foreground: "white"

        RowLayout {
            spacing: 20
            anchors.fill: parent

            ToolButton {//Wichtiger gezeichneter Knopf um das Listen-Menu aufzurufen
                contentItem: Image {
                    fillMode: Image.Pad
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                    source: if (appState <= appStateStartVerbindungsaufbau){
                                return "qrc:/images/blue.png"
                            }else if (appState <=appStateHörerSet){
                                return "qrc:/images/arrow.png"
                            }else{
                                return "qrc:/images/drawer.png"
                            }
                }
                onClicked: if (appState <= appStateStartVerbindungsaufbau){
                               //Nothing
                           }else if (appState <= appStateRollenwahl){
                               listView.currentIndex = 0
                               titleLabel.text = "Verbindungsaufbau"
                               stackView.replace("qrc:/pages/Verbindungsaufbau.qml")
                               appState=appStateStartVerbindungsaufbau
                               rmOK=0
                           }else if (appState <= appStateHörerSet){
                               listView.currentIndex = 1
                               titleLabel.text = "Rollenwahl"
                               stackView.replace("qrc:/pages/Rollenwahl.qml")
                               appState=appStateRollenwahl
                               rmOK=0
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
                    + "Beckmann, René<br>Brexeler, Sascha<br>Hebbler, Tim<br>Castano, Diana<br>Micke, Jens"
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

    FileDialog{//Um Dateien aufrufen zu können
        id: fileDialog
        title: "Please choose a PDF file"
        folder: shortcuts.home
        nameFilters: [ "Pdf files (*.pdf)" ]
        onAccepted: {
            console.log("You open: " + fileDialog.fileUrl)
            //var pdf_path = fileDialog.fileUrl.toString()
            //pdf_path= pdf_path.replace(/^(file:\/{3})|(qrc:\/{2})|(http:\/{2})/,"");
            openfile(fileDialog.fileUrl)
            //pdf_nextpage();//Da die Neue Pdf sonst erst beim ersten Blättern geladen wird
            //prevpage();
            setCurrentPageNr(0)
            sendFile(fileDialog.fileUrl);
            setPage("0")
        }
        onRejected: {
            console.log("Canceled")
        }
    }
}
