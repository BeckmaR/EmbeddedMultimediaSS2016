import QtQuick 2.7
import QtSensors 5.3
import QtQuick.Window 2.2

Page1Form {
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
    button1.onClicked: {
        console.log("Button 1 clicked.");
    }
    button2.onClicked: {
        console.log("Button 2 clicked.");
    }
    button3.onClicked: {
        button3.text = Screen.orientation
    }
}
