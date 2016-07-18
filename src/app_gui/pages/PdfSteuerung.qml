import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.2

import QtQuick.Layouts 1.0
//BEGIN ACCELEROMETER
import QtSensors 5.3
import QtQuick 2.5
//END ACCELEROMETER

PdfAnsicht{
    button_forward.onClicked: {        
            console.log("Button forward")
            nextpage();
            if ((appState==appStateSprecherReady)&&(autoSyncON==1)){
                setPage(""+pagenr);
            }
    }
    /*button_sync.onClicked: {
            console.log("Button forward")
            nextpage();
            if ((appState==appStateSprecherReady)&&(autoSyncON==1)){
                setPage(""+pagenr);
            }
    }
    button_audio.onClicked: {
            console.log("Button forward")
            nextpage();
            if ((appState==appStateSprecherReady)&&(autoSyncON==1)){
                setPage(""+pagenr);
            }
    }
    rect_gesten.button_gesten.onClicked: {
            console.log("Button forward")
            nextpage();
            if ((appState==appStateSprecherReady)&&(autoSyncON==1)){
                setPage(""+pagenr);
            }
    }
    button_kipp.onClicked: {
            console.log("Button forward")
            nextpage();
            if ((appState==appStateSprecherReady)&&(autoSyncON==1)){
                setPage(""+pagenr);
            }
    }*/
    button_back.onClicked: {
        console.log("Button back")
        prevpage();
        if ((appState==appStateSprecherReady)&&(autoSyncON==1)){
            setPage(""+pagenr);
        }
    }
    Item {
          Timer {
              id: autoSyncTimer; interval: 2000; running: true; repeat: true
              onTriggered: {
                  if ((appState==appStateHörerReady)&&(autoSyncON==1)){
                      getPage();
                  }
              }

            /*      time.text = Date().toString()
          }
          Text { id: time }*/
      }
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
      Used variables for Accelerometer evaluation
    */
    Item{
        id: accelEvaluation
        property var dead : 3
        property var oldX : 0
        property var oldY : 0
    }
    /*
      Timer to limit page turn rate
    */
    Item{
        Timer{
            id: accelTimer
            interval: 500
            running: false
            repeat: false
        }
    }

    /*
      Activate and Contol the behaviour of the Accelerometer
    */

    Accelerometer {
        id: accel
        dataRate: 10
        active:true
        onReadingChanged: {
            if (accelTimer.running === false)
            {
                if ((Screen.orientation === 1) || (Screen.orientation === 4))
                {
                    var currentX = accel.reading.x
                    if (currentX > accelEvaluation.dead){
                        accelEvaluation.oldX = 1
                    }
                    else if (currentX < - accelEvaluation.dead){
                        accelEvaluation.oldX = -1
                    }
                    else{
                        if (((accelEvaluation.oldX === 1) && (Screen.orientation === 1)) || ((accelEvaluation.oldX === -1) && (Screen.orientation === 4))){
                            if (kippsteuerungON==1)
                            {
                                prevpage();
                                accelTimer.restart()
                                if ((appState==appStateSprecherReady)&&(autoSyncON==1)){
                                    setPage(""+pagenr);
                                }
                            }
                        }
                        else if (((accelEvaluation.oldX === 1) && (Screen.orientation === 4)) || ((accelEvaluation.oldX === -1) && (Screen.orientation === 1))){
                            if (kippsteuerungON==1)
                            {
                                nextpage();
                                accelTimer.restart()
                                if ((appState==appStateSprecherReady)&&(autoSyncON==1)){
                                    setPage(""+pagenr);
                                }
                            }
                        }

                        accelEvaluation.oldX = 0
                    }
                }
                else if ((Screen.orientation === 2) || (Screen.orientation === 8))
                {
                    var currentY = accel.reading.y
                    if (currentY > accelEvaluation.dead){
                        accelEvaluation.oldY = 1
                    }
                    else if (currentY < - accelEvaluation.dead){
                        accelEvaluation.oldY = -1
                    }
                    else{
                        if (((accelEvaluation.oldY === 1) && (Screen.orientation === 2)) || ((accelEvaluation.oldY === -1) && (Screen.orientation === 8))){
                            if (kippsteuerungON==1)
                            {
                                nextpage();
                                accelTimer.restart()
                                if ((appState==appStateSprecherReady)&&(autoSyncON==1)){
                                    setPage(""+pagenr);
                                }
                            }
                        }
                        else if (((accelEvaluation.oldY === 1) && (Screen.orientation === 8)) || ((accelEvaluation.oldY === -1) && (Screen.orientation === 2))){
                            if (kippsteuerungON==1)
                            {
                                prevpage();
                                accelTimer.restart()
                                if ((appState==appStateSprecherReady)&&(autoSyncON==1)){
                                    setPage(""+pagenr);
                                }
                            }
                        }

                        accelEvaluation.oldY = 0
                    }
                }
            }
        }
    }
    Screen.onOrientationChanged: {
        accelTimer.restart()
        accelEvaluation.oldX = 0
        accelEvaluation.oldY = 0
    }
    //END ACCELEROMETER
}

