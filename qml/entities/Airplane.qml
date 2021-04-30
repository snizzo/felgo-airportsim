import QtQuick 2.0
import Felgo 3.0

// mathematics utilities for computing airplane speed
import "../levels/utils.js" as JsUtils

EntityBase {

    entityId: "airplane"
    entityType: "airplaneEntity"

    width: 20
    height: 20

    // translate center of the sprite such that coordinate system
    // has (0,0) centered in the middle of EntityBase
    // this is useful for later rotation transforms

    transform: Translate { x: -10
                            y: -10 }

    property int maxSpeed: 50
    property int currentSpeed: 10
    property int minSpeed: 25

    property alias movement: movementHandler
    property alias sprite: rect

    //placeholder for planes
    Rectangle {
        id: rect

        anchors.fill: parent

        color: "red"
    }

    // used for collisions between planes
    BoxCollider {
        anchors.fill: rect
    }

    MovementAnimation {
        id: movementHandler

        // the component that is subject to movement
        target: parent
        property: "pos"

        // velocity is defined as a 2D coordinate (QPointF) representing a vector
        // that describes the direction and speed of the movement
        velocity: Qt.point(10, 10)

        // start running from the beginning
        running: true
    }

    MouseArea {
        id: movingMouseArea

        //used to store movement mouse coordinates
        property var prevX;
        property var prevY;

        //make mousearea actually bigger than the plane itself
        //in order to be more usable
        width: parent.width+20
        height: parent.height+20

        anchors.centerIn: parent

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
            var vector = JsUtils.get2DVectorFromPoints([prevX,prevY],[mouseX,mouseY]);

            var hypotenuse = Math.sqrt(Math.pow(vector[0],2)+Math.pow(vector[1],2));
            // calculating hypotenuse makes us lose the sign info, so we have to multiply it again
            hypotenuse *= vector[1]<0 ? -1:1
            // radians to degrees
            var degrees = Math.acos(vector[0]/hypotenuse) * (180/Math.PI);
            // apply rotation
            sprite.rotation = degrees
        }
        onReleased: {

            //calculate current input velocity
            var vector = JsUtils.get2DVectorFromPoints([prevX,prevY],[mouseX,mouseY]);
            //and get new velocity based on current one
            var velocity = JsUtils.getNormalizedVelocityFromVector(vector, movement.velocity, parent.maxSpeed, parent.minSpeed);

            //modify only if velocity is zero, plane has to keep flying
            //at least at a minimum speed
            if(velocity!==Qt.point(0,0)){
                movement.velocity = velocity;
            }

            //restarting airplane animation
            movement.start();
        }

    }
}
