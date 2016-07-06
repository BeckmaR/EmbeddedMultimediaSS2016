import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

import QtQuick.Dialogs 1.2 //Für FileDialog

ApplicationWindow {
    id: window
    visible: true
    width: 640
    height: 480
    title: qsTr("Presentao")

//    property alias mainForm1: mainForm1
    property int pagenr: -1
    signal nextpage()
    signal prevpage()
    signal openfile(url _url)
    function qml_setPage(nr) {
        pagenr = nr
    }

    FileDialog{
        id: fileDialog
        title: "Please choose a PDF file"
        folder: shortcuts.home
        nameFilters: [ "Pdf files (*.pdf)" ]
        onAccepted: {
            console.log("You chose: " + fileDialog.fileUrl)
            openfile(fileDialog.fileUrl)
        }
        onRejected: {
            console.log("Canceled")
            tabBar.currentIndex = tabBar.currentIndex +1
        }
   //     Component.onCompleted: visible = false
    }

    footer: TabBar {

        id: tabBar
        currentIndex: swipeView.currentIndex
        TabButton {
            text: qsTr("Settings")
        }
        TabButton {
            text: qsTr("Pdf-View")
        }
    }

    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex
        Page1 {
        }
        Page2 {
        }
    }

    /*
    StackView {
              id: stack
              initialItem: mainView
              anchors.fill: parent
          }

          Component {
              id: mainView

              Row {
                  spacing: 10

                  MyButton {
                      text: "Push"
                      enabled: stack.depth < 3
                      onClicked: stack.push(mainView)
                  }

                  MyButton {
                      text: "Pop"
                      enabled: stack.depth > 1
                      onClicked: stack.pop()

                  }
                  Text {
                      text: stack.depth
                  }
              }
          }

    header: ToolBar {
      RowLayout {
          anchors.fill: parent
          ToolButton {
              text: qsTr("\u25C0 %1").arg(Qt.application.name)
              enabled: stack.depth > 1
              onClicked: stack.pop()
          }
          Item { Layout.fillWidth: true }
          Switch {
              checked: true
              text: qsTr("Syn")
          }
        }
    }*/
}
