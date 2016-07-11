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

    function qml_setPage(nr) {
            pagenr = nr
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
