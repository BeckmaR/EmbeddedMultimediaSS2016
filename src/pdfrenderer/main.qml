import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.2


ApplicationWindow {
    width: 200
    height: 200
    property alias mainForm1: mainForm1
    property int pagenr: -1
    visible: true
    visibility: Window.FullScreen
    signal nextpage()
    signal prevpage()
    signal openfile(url _url)

    function qml_setPage(nr) {
        pagenr = nr
    }

    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("&Open")
                onTriggered: fileDialog.open();
            }
            MenuItem {
                text: qsTr("Exit")
                onTriggered: Qt.quit();
            }
        }
    }
    FileDialog {
        id: fileDialog
        title: "Please choose a PDF file"
        //folder: shortcuts.home
        nameFilters: [ "Pdf files (*.pdf)" ]
        onAccepted: {
            console.log("You chose: " + fileDialog.fileUrl)
            openfile(fileDialog.fileUrl)
        }
        onRejected: {
            console.log("Canceled")
        }
        //Component.onCompleted: visible = true
    }

    MainForm {
        id: mainForm1
        anchors.fill: parent
        button_back.onClicked: {
            //console.log("Button back")
            prevpage();
        }
        button_forward.onClicked: {
            //console.log("Button forward")
            nextpage();
        }
    }

    Image {
        id: image1
        fillMode: Image.PreserveAspectFit
        Layout.fillHeight: true
        Layout.fillWidth: true
        //anchors.fill: parent
        sourceSize.width: paintedWidth

        //sourceSize.height: paintedHeight;
        cache: false
        source: "image://pdfrenderer/" + pagenr
    }




}
