import QtQuick 2.0
import Felgo 3.0

import "../levels/utils.js" as JsUtils

EntityBase {

    entityId: "airplane"
    entityType: "airplaneEntity"

    width: 20
    height: 20
    //translate center of the sprite
    transform: Translate { x: -10
                            y: -10 }

    property int maxSpeed: 15
    property int currentSpeed: 10
    property int minSpeed: 5

    property alias movement: movementHandler

    Rectangle {
        id: rect

        anchors.fill: parent

        color: "red"
    }

    BoxCollider {
        anchors.fill: rect
    }

    MovementAnimation {
        id: movementHandler
        target: parent
        property: "pos"

        velocity: Qt.point(10, 10)

        // start running from the beginning
        running: true
    }

    MouseArea {
        id: movingMouseArea

        property var prevX;
        property var prevY;

        anchors.fill: parent

        /*
          Handles retracing airplane path by detecting mouse movements
          */
        onPressed: {
            //stopping airplane from flying when triggered
            movement.stop();

            console.debug("airplane pressed")

            //when using MouseArea to catch input, mouseX and mouseY are relative to the MouseArea coordinate system
            prevX = mouseX
            prevY = mouseY


        }
        onPositionChanged:{
            //console.debug("currentx: "+mouseX+", currenty: "+mouseY);
            //console.debug("airplane position changed");
        }
        onReleased: {
            console.debug("airplane released")

            var vector = JsUtils.get2DVectorFromPoints([prevX,prevY],[mouseX,mouseY]);
            movement.velocity = JsUtils.getNormalizedVelocityFromVector(vector, parent.maxSpeed);

            movement.start();
        }

    }
}
