import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    property int page_nr: 0
    property int handcontrol_enable_nr: 0
    signal handcontrol_enable(int enable)
    function print_errorMessage(msg) {
        //text1.text = text1.text + "<b>" + msg + "</b>"
        text1.append("<b>" + msg + "</b>")
    }
    function print_debugMessage(msg) {
        //text1.text = text1.text + msg
        text1.append(msg)
    }
    function count_page(value) {
        page_nr = page_nr + value
    }

    ColumnLayout {
        id: columnLayout1
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        anchors.fill: parent


        TextArea {
            id: text1
            text: qsTr("...Debug Window...")
            readOnly: true
            Layout.fillHeight: true
            Layout.fillWidth: true
            textFormat: Text.AutoText
            font.pixelSize: 12
        }
        RowLayout{
            Layout.fillHeight: false
            Layout.fillWidth: false
            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
            Text {
                text: "aktuelle Seite:" +page_nr
            }

            Button {
                id: handcontrolbutton
                text: "handcontrol gestoppt"
                onClicked: {
                    if(handcontrol_enable_nr) {
                        handcontrolbutton.text = "handcontrol deaktiviert"
                        handcontrol_enable(0)
                        handcontrol_enable_nr = 0
                    }else {
                        handcontrol_enable(1)
                        handcontrolbutton.text = "handcontrol aktiviert"
                        handcontrol_enable_nr = 1
                    }
                }

            }
        }
    }
}
