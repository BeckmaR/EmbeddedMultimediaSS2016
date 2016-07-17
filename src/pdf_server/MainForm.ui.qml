import QtQuick 2.5
import QtQuick.Controls 1.3
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.2

Item {
    id: item
    ColumnLayout {
        id: columnLayout1
        anchors.fill: parent

        Image {
            id: image1
            height: 342
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
            id: rowLayout1
        }
    }
}

