import QtQuick 2.7

Page1Form {
    filefinder.onClicked: {
//        onTriggered: fileDialog.open();
        fileDialog.open();
}
    button1.onClicked: {
        console.log("Button 1 clicked.");
    }
    button2.onClicked: {
        console.log("Button 2 clicked.");
    }
}
