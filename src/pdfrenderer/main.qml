import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Dialogs 1.2
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
}
