import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.2

//import QtQuick.Layouts 1.0
//BEGIN ACCELEROMETER
import QtSensors 5.3
import QtQuick 2.5
//END ACCELEROMETER


Item {
    id: item
    property alias button_forward: button_forward
    property alias button_back: button_back
    ColumnLayout {
        id: columnLayout1
        anchors.fill: parent

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

        RowLayout {
            id: rowLayout1
            Layout.fillWidth: true
            Rectangle{//left
                id: rect_left
                width: 35
                height: 35
                anchors.centerIn: rowLayout1.Center
                Image {
                    width: 35
                    height: 35
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                    source: "qrc:/images/PdfControll/left_button_green.png"
                }
                MouseArea {
                    id: button_back
                    anchors.fill: parent

                }
            }
            Rectangle{//rect_sync
                id: rect_sync
                width: 35
                height: 35
                anchors.centerIn: rowLayout1.Center
                Image {
                    width: 35
                    height: 35
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                    source: if(autoSyncON==1){
                                return "qrc:/images/PdfControll/refresh_green.png"
                            }else{
                                return "qrc:/images/PdfControll/refresh_grey.png"
                            }
                }
                MouseArea {
                    id: button_sync //############TODO
                    anchors.fill: parent
                    onClicked:{
                        if(autoSyncON==1){
                            autoSyncON=0
                        }else{
                            autoSyncON=1

                        }
                    }
                }
            }
//            if ((appState == appStateHörerReady)&&(autoSyncON==1)){
//                    getPage();
//            }else{
//                getPage();
//            }
            Rectangle{//rect_audio
                id: rect_audio
                width: 35
                height: 35
                anchors.centerIn: rowLayout1.Center
                Image {
                    width: 35
                    height: 35
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                    source: if(sprachsteuerungON==1){
                                return "qrc:/images/PdfControll/audio_button_grenn.png"
                            }else{
                                return "qrc:/images/PdfControll/audio_button_grey.png"
                            }
                }
                MouseArea {
                    id: button_audio//###########TODO
                    anchors.fill: parent
                    onClicked:{
                        if(sprachsteuerungON==1){
                            sprachsteuerungON=0
                            startstopKlopfen();
                        }else{
                            sprachsteuerungON=1
                            startstopKlopfen();
                        }
                    }

                }
            }
            Rectangle{//rect_gesten
                id: rect_gesten
                width: 35
                height: 35
                anchors.centerIn: rowLayout1.Center
                Image {
                    width: 35
                    height: 35
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                    source: if(gestensteuerungON==1){
                                return "qrc:/images/PdfControll/cam_button_green.png"
                            }else{
                                return "qrc:/images/PdfControll/cam_button_grey.png"
                            }
                }
                MouseArea {
                    id: button_gesten//##############TODO
                    anchors.fill: parent
                    onClicked:{
                        if(gestensteuerungON==1){
                            gestensteuerungON=0
                        }else{
                            gestensteuerungON=1
                        }
                    }
                }
            }
            Rectangle{//rect_kipp
                id: rect_kipp
                width: 35
                height: 35
                anchors.centerIn: rowLayout1.Center
                Image {
                    width: 35
                    height: 35
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                    source: if(kippsteuerungON==1){
                                return "qrc:/images/PdfControll/kipp_button_green.png"
                            }else{
                                return "qrc:/images/PdfControll/kipp_button_grey.png"
                            }
                }
                MouseArea {
                    id: button_kipp//##########TODO
                    anchors.fill: parent
                    onClicked:{
                        if(kippsteuerungON==1){
                            kippsteuerungON=0
                        }else{
                            kippsteuerungON=1
                        }
                    }

                }
            }
            Text {//PageNumber
                id: text1
                text: qsTr("  ") + pagenr
                anchors.centerIn: rowLayout1.Center
                Layout.fillWidth: true
                font.pixelSize: 20
            }
            Rectangle{//rect_reload
                id: rect_reload
                visible: if (autoSyncON==1){
                             setPage(""+pagenr);
                             getPage();
                             return true
                         }else{
                             return false
                         }
                width: 35
                height: 35
                anchors.centerIn: rowLayout1.Center
                Image {
                    width: 35
                    height: 35
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                    source: "qrc:/images/PdfControll/reload.png"
                }
                MouseArea {
                    id: button_reload
                    anchors.fill: parent
                    onClicked: {
                        if ((appState == appStateHörerSet)||(appState == appStateHörerReady)){
                            getPage();
                         }else{
                            console.log("Sprecher set Page")
                            setPage(""+pagenr);
                         }
                    }
                }
            }
            Rectangle{
                id: rect_right
                width: 35
                height: 35
                anchors.centerIn: rowLayout1.Center
                //Layout.fillWidth: true
                Image {
                    width: 35
                    height: 35
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                    source: "qrc:/images/PdfControll/right_button_green.png"
                }
                MouseArea {
                    id: button_forward
                    anchors.fill: parent

                }
            }
        }
    }
}
