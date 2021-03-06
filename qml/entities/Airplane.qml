import QtQuick 2.0
import Felgo 3.0

// mathematics utilities for computing airplane speed
import "../levels/utils.js" as JsUtils

EntityBase {

    entityId: "airplane"
    entityType: "airplaneEntity"

    width: 30
    height: 30

    // translate center of the sprite such that coordinate system
    // has (0,0) centered in the middle of EntityBase
    // this is useful for later rotation transforms

    transform: Translate { x: -10
                            y: -10 }

    property int maxSpeed: 100
    property int currentSpeed: 10
    property int minSpeed: 25

    property alias movement: movementHandler
    property alias velocity: movementHandler.velocity
    property alias sprite: rect

    //placeholder for planes
    Image {
        id: rect

        anchors.fill: parent

        source: "../../assets/img/airplane.png"
    }

    // used for collisions between planes


    CircleCollider {
        anchors.centerIn: parent
        radius: 9.5

        fixture.onBeginContact: {
            var body = other.getBody();
            var collidedEntity = body.target;
            var collidedEntityType = collidedEntity.entityType;
            var collidedEntityId = collidedEntity.entityId;

            if(collidedEntityType==="airplaneEntity"){
                gameScene.airplanesCollided()
            }
        }
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

    onVelocityChanged: {
        var vector = JsUtils.get2DVectorFromPoints([0,0],[velocity.x,velocity.y]);
        rotate(vector);
    }

    function applyVelocity(vector){
        //and get new velocity based on current one
        var newvel = JsUtils.getNormalizedVelocityFromVector(vector, movement.velocity, maxSpeed, minSpeed);


        //modify only if velocity is zero, plane has to keep flying
        //at least at a minimum speed
        if(newvel!==Qt.point(0,0)){
            movement.velocity = newvel;
        }

        rotate(vector);
    }

    //rotate airplane from given a rotation vector
    function rotate(vector){
        if(vector[0] === 0 && vector[1] === 0){
            return;
        }

        var hypotenuse = Math.sqrt(Math.pow(vector[0],2)+Math.pow(vector[1],2));
        // calculating hypotenuse makes us lose the sign info, so we have to multiply it again
        hypotenuse *= vector[1]<0 ? -1:1
        // radians to degrees
        var degrees = Math.acos(vector[0]/hypotenuse) * (180/Math.PI);
        if(hypotenuse<0){
            degrees += 180;
        }

        degrees += 90

        // apply rotation
        sprite.rotation = degrees
    }

    function start(){
        movement.start();
    }

    function stop(){
        movement.stop();
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
            stop();

            //when using MouseArea to catch input, mouseX and mouseY are relative to the MouseArea coordinate system
            prevX = mouseX
            prevY = mouseY
        }
        onPositionChanged:{
            //calculate distance between points
            var vector = JsUtils.get2DVectorFromPoints([prevX,prevY],[mouseX,mouseY]);

            rotate(vector);
        }
        onReleased: {

            //calculate current input velocity
            var vector = JsUtils.get2DVectorFromPoints([prevX,prevY],[mouseX,mouseY]);

            applyVelocity(vector);

            //restarting airplane animation
            start();
        }

    }
}
