import QtQuick 2.0
import Felgo 3.0

EntityBase {

    entityId: "airplane"
    entityType: "airplaneEntity"

    Rectangle {
        id: rect
        width: 20
        height: 20
        color: "red"
    }

    BoxCollider {
        anchors.fill: rect
    }

    PathMovement {
       velocity: 100
       rotationAnimationDuration: 200

       waypoints: [
         {x:0, y:0},
         {x:100, y:100}
       ]

       onPathCompleted: {
           console.debug("keep on flying on the same direction/rotation");
       }
    }

    MouseArea {
        id: movingArea

        property var prevX;
        property var prevY;

        anchors.fill: parent
        onPressed: {prevX = mouseX ; prevY = mouseY}
        onPositionChanged: console.log("x: "+prevX+", y: "+prevY);
    }
}
