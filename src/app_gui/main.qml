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
    height: 520
    visible: true
    title: qsTr("Presentao_APP")

    Settings {
        id: settings
        property string style: "Universal"
    }

    //SIGNALE
    property int pagenr: -1
    signal nextpage()
    signal prevpage()
    signal openfile(url _url)
    function qml_setPage(nr) {
        pagenr = nr
    }

    Drawer {//Liste mit z.B. sämtlichen Geräteeinstellungen
        id: drawer
        width: Math.min(window.width, window.height) / 3 * 2
        height: window.height

        ListView {
            id: listView
            currentIndex: -1
            anchors.fill: parent

            delegate: ItemDelegate {
                width: parent.width
                text: model.title
                highlighted: ListView.isCurrentItem
                onClicked: {// Wenn der ausgewählte Eintrag nicht bereits ausgewählt ist, wird ersetzt er den Stack
                    if (listView.currentIndex != index) {
                        listView.currentIndex = index
                        titleLabel.text = model.title
                        stackView.replace(model.source)
                    }
                    drawer.close()
                }
            }

            model: ListModel {
                ListElement { title: "Pdf-Ansicht"; source: "qrc:/pages/PdfSteuerung.qml" } //PdfSteuerung ruft PdfAnsicht auf
                ListElement { title: "Netzwerkeinstellungen"; source: "qrc:/pages/Netzwerkeinstellungen.qml" }
                ListElement { title: "Bildschirmeinstellungen"; source: "qrc:/pages/Bildschirmeinstellungen.qml" }
                ListElement { title: "Audioeinstellungen"; source: "qrc:/pages/Audioeinstellungen.qml" }
                ListElement { title: "Touchsteuerung"; source: "qrc:/pages/Touchsteuerung.qml" }
                ListElement { title: "Schwingsteuerung"; source: "qrc:/pages/Schwingsteuerung.qml" }
                ListElement { title: "Gestensteuerung"; source: "qrc:/pages/Gestensteuerung.qml" }
                ListElement { title: "Audio/Klatschsteuerung"; source: "qrc:/pages/Klatschsteuerung.qml" }

                /*
                ListElement { title: "ScrollIndicator"; source: "qrc:/pages/ScrollIndicatorPage.qml" }
                  */
/*                ListElement { title: "BusyIndicator"; source: "qrc:/pages/BusyIndicatorPage.qml" }
                ListElement { title: "ScrollBar"; source: "qrc:/pages/ScrollBarPage.qml" }
                ListElement { title: "Button"; source: "qrc:/pages/ButtonPage.qml" }
                ListElement { title: "CheckBox"; source: "qrc:/pages/CheckBoxPage.qml" }
                ListElement { title: "ComboBox"; source: "qrc:/pages/ComboBoxPage.qml" }
                ListElement { title: "Dial"; source: "qrc:/pages/DialPage.qml" }
                ListElement { title: "Delegates"; source: "qrc:/pages/DelegatePage.qml" }
                ListElement { title: "Drawer"; source: "qrc:/pages/DrawerPage.qml" }
                ListElement { title: "Frame"; source: "qrc:/pages/FramePage.qml" }
                ListElement { title: "GroupBox"; source: "qrc:/pages/GroupBoxPage.qml" }
                ListElement { title: "Menu"; source: "qrc:/pages/MenuPage.qml" }
                ListElement { title: "PageIndicator"; source: "qrc:/pages/PageIndicatorPage.qml" }
                ListElement { title: "Popup"; source: "qrc:/pages/PopupPage.qml" }
                ListElement { title: "ProgressBar"; source: "qrc:/pages/ProgressBarPage.qml" }
                ListElement { title: "RadioButton"; source: "qrc:/pages/RadioButtonPage.qml" }
                ListElement { title: "RangeSlider"; source: "qrc:/pages/RangeSliderPage.qml" }
                ListElement { title: "Slider"; source: "qrc:/pages/SliderPage.qml" }
                ListElement { title: "SpinBox"; source: "qrc:/pages/SpinBoxPage.qml" }
                ListElement { title: "StackView"; source: "qrc:/pages/StackViewPage.qml" }
                ListElement { title: "SwipeView"; source: "qrc:/pages/SwipeViewPage.qml" }
                ListElement { title: "Switch"; source: "qrc:/pages/SwitchPage.qml" }
                ListElement { title: "TabBar"; source: "qrc:/pages/TabBarPage.qml" }
                ListElement { title: "TextArea"; source: "qrc:/pages/TextAreaPage.qml" }
                ListElement { title: "TextField"; source: "qrc:/pages/TextFieldPage.qml" }
                ListElement { title: "ToolTip"; source: "qrc:/pages/ToolTipPage.qml" }
                ListElement { title: "Tumbler"; source: "qrc:/pages/TumblerPage.qml" }
*/
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
                anchors.fill: parent

                /*
                Image {
                    id: image1
                    fillMode: Image.PreserveAspectFit
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    sourceSize.width: paintedWidth;
                    sourceSize.height: paintedHeight;
                    cache: false
                    source: "image://pdfrenderer/" + pagenr
                }
                              */
            }

            Image {
                id: logo
                width: pane.availableWidth / 2
                height: pane.availableHeight / 2
                anchors.centerIn: parent
                anchors.verticalCenterOffset: -50
                fillMode: Image.PreserveAspectFit
                source: "qrc:/images/qt-logo.png"
            }

            Label {
                text: "Startbildschirm."
                anchors.margins: 20
                anchors.top: logo.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: arrow.top
                horizontalAlignment: Label.AlignHCenter
                verticalAlignment: Label.AlignVCenter
                wrapMode: Label.Wrap
            }

            Image {
                id: arrow
                source: "qrc:/images/arrow.png"
                anchors.left: parent.left
                anchors.bottom: parent.bottom
            }
        }
    }

    footer: ToolBar { //Leiste am Bildschirm unten
        Material.foreground: "white"

        RowLayout {
            spacing: 20
            anchors.fill: parent

            ToolButton {//Wichtiger gezeichneter Knopf um das Listen-Menu aufzurufen
                contentItem: Image {
                    fillMode: Image.Pad
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                    source: "qrc:/images/drawer.png"
                }
                onClicked: drawer.open()
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
            ToolButton {//Gezeichneter Knopf um Menu fürs Pdf öffnen und die Info aufzurufen
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
                        text: "Pdf öffnen"
                        onTriggered: {
                            fileDialog.open();
                        }
                    }
                    MenuItem {
                        text: "Information"
                        onTriggered: infoDialog.open()
                    }
                }
            }
        }
    }

    Popup {//Hilfe POPUP-Menu
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
                text: "Info zur App:"
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
            openfile(fileDialog.fileUrl)
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
   //         tabBar.currentIndex = tabBar.currentIndex +1
        }
   //     Component.onCompleted: visible = false
    }
}
