import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.2


ApplicationWindow {
    width: 200
    height: 200

    property int pagenr: -1
    visible: true
    visibility: Window.FullScreen
    signal nextpage()
    signal prevpage()
    signal openfile(url _url)

    function qml_setPage(nr) {
        pagenr = nr
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

    ColumnLayout {
            id: columnLayout1
            anchors.fill: parent

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

            RowLayout {

                Button {

                    text: qsTr("Zurück")
                    onClicked: {
                                //console.log("Button back")
                                prevpage();
                   }
                }
                Button {

                    text: qsTr("Vorwärts")
                    onClicked: {
                                //console.log("Button forward")
                                nextpage();
                    }
                }

                Text {
                    id: text1
                    text: qsTr("Seite: ") + pagenr
                }
            }
        }

}
