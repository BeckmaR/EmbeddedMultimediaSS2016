import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
//BEGIN ACCELEROMETER
import QtQuick.Window 2.2
import QtSensors 5.3
//END ACCELEROMETER

Page2Form {
    button_forward.onClicked: {
        console.log("Button forward")
        nextpage();
}
    button_back.onClicked: {
        console.log("Button back")
        prevpage();
        }
    //BEGIN ACCELEROMETER
    /*
      Set which orientations can be detected
      (Screen.orientation won't work without it)
      1 Portrait
      2 Landscape
      4 Inverted Portrait
      8 Inverted Landscape
    */
    Screen.orientationUpdateMask:{
        1 + 2 + 4 + 8
    }
    /*
      Activate and Contol the behaviour of the Accelerometer
    */
    Item{
        id: direction
        property var dead : 5
        property var oldX : 0
        property var oldY : 0
    }

    Accelerometer {
        id: accel
        dataRate: 10
        active:true
        onReadingChanged: {
            if ((Screen.orientation === 1) || (Screen.orientation === 4))
            {
                var currentX = accel.reading.x
                if (currentX > direction.dead){
                    direction.oldX = 1
                }
                if (currentX < - direction.dead){
                    direction.oldX = -1
                }
                else{
                    if (((direction.oldX === 1) && (Screen.orientation === 1)) || ((direction.oldX === -1) && (Screen.orientation === 4))){
                        prevpage()
                    }
                    if (((direction.oldX === 1) && (Screen.orientation === 4)) || ((direction.oldX === -1) && (Screen.orientation === 1))){
                        nextpage()
                    }

                    direction.oldX = 0
                }
            }
            if ((Screen.orientation === 2) || (Screen.orientation === 8))
            {
                var currentY = accel.reading.y
                if (currentY > direction.dead){
                    direction.oldY = 1
                }
                if (currentY < - direction.dead){
                    direction.oldY = -1
                }
                else{
                    if (((direction.oldY === 1) && (Screen.orientation === 2)) || ((direction.oldY === -1) && (Screen.orientation === 8))){
                        nextpage()
                    }
                    if (((direction.oldY === 1) && (Screen.orientation === 8)) || ((direction.oldY === -1) && (Screen.orientation === 2))){
                        prevpage()
                    }

                    direction.oldY = 0
                }
            }
        }
    }
    Screen.onOrientationChanged: {
        direction.oldX = 0
        direction.oldY = 0
    }
    //END ACCELEROMETER
}

/*import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.1
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0

Item {
    width: 580
    height: 400
    SystemPalette { id: palette }
    clip: true

    FileDialog {
        id: fileDialog
        visible: fileDialogVisible.checked
        modality: fileDialogModal.checked ? Qt.WindowModal : Qt.NonModal
        title: fileDialogSelectFolder.checked ? "Choose a folder" :
            (fileDialogSelectMultiple.checked ? "Choose some files" : "Choose a file")
        selectExisting: fileDialogSelectExisting.checked
        selectMultiple: fileDialogSelectMultiple.checked
        selectFolder: fileDialogSelectFolder.checked
        nameFilters: [ "Image files (*.png *.jpg)", "All files (*)" ]
        selectedNameFilter: "All files (*)"
        sidebarVisible: fileDialogSidebarVisible.checked
        onAccepted: {
            console.log("Accepted: " + fileUrls)
            if (fileDialogOpenFiles.checked)
                for (var i = 0; i < fileUrls.length; ++i)
                    Qt.openUrlExternally(fileUrls[i])
        }
        onRejected: { console.log("Rejected") }
    }

    ScrollView {
        id: scrollView
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: bottomBar.top
            leftMargin: 12
        }
        ColumnLayout {
            spacing: 8
            Item { Layout.preferredHeight: 4 } // padding
            Label {
                font.bold: true
                text: "File dialog properties:"
            }
            CheckBox {
                id: fileDialogModal
                text: "Modal"
                checked: true
                Binding on checked { value: fileDialog.modality != Qt.NonModal }
            }
            CheckBox {
                id: fileDialogSelectFolder
                text: "Select Folder"
                Binding on checked { value: fileDialog.selectFolder }
            }
            CheckBox {
                id: fileDialogSelectExisting
                text: "Select Existing Files"
                checked: true
                Binding on checked { value: fileDialog.selectExisting }
            }
            CheckBox {
                id: fileDialogSelectMultiple
                text: "Select Multiple Files"
                Binding on checked { value: fileDialog.selectMultiple }
            }
            CheckBox {
                id: fileDialogOpenFiles
                text: "Open Files After Accepting"
            }
            CheckBox {
                id: fileDialogSidebarVisible
                text: "Show Sidebar"
                checked: fileDialog.sidebarVisible
                Binding on checked { value: fileDialog.sidebarVisible }
            }
            CheckBox {
                id: fileDialogVisible
                text: "Visible"
                Binding on checked { value: fileDialog.visible }
            }
            Label {
                text: "<b>current view folder:</b> " + fileDialog.folder
            }
            Label {
                text: "<b>name filters:</b> {" + fileDialog.nameFilters + "}"
            }
            Label {
                text: "<b>current filter:</b>" + fileDialog.selectedNameFilter
            }
            Label {
                text: "<b>chosen files:</b> " + fileDialog.fileUrls
            }
            Label {
                text: "<b>chosen single path:</b> " + fileDialog.fileUrl
            }
        }
    }

    Rectangle {
        id: bottomBar
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        height: buttonRow.height * 1.2
        color: Qt.darker(palette.window, 1.1)
        border.color: Qt.darker(palette.window, 1.3)
        Row {
            id: buttonRow
            spacing: 6
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 12
            height: implicitHeight
            width: parent.width
            Button {
                text: "Open"
                anchors.verticalCenter: parent.verticalCenter
                onClicked: fileDialog.open()
            }
            Button {
                text: "Pictures"
                tooltip: "go to my Pictures directory"
                anchors.verticalCenter: parent.verticalCenter
                enabled: fileDialog.shortcuts.hasOwnProperty("pictures")
                onClicked: fileDialog.folder = fileDialog.shortcuts.pictures
            }
            Button {
                text: "Home"
                tooltip: "go to my home directory"
                anchors.verticalCenter: parent.verticalCenter
                enabled: fileDialog.shortcuts.hasOwnProperty("home")
                onClicked: fileDialog.folder = fileDialog.shortcuts.home
            }
        }
    }
}
*/

