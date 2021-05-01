import QtQuick 2.0
import Felgo 3.0
import "../common" as Common
import "../entities" as MyEntities

import "utils.js" as MyGameUtils

Common.LevelBase {
    levelName: "Level1"

    MyEntities.Airplane{
        id: myAirplane
    }

    /*
    MouseArea {
        anchors.fill: parent
        // since the level is loaded in the gameScene, and is therefore a child of the gameScene, you could also access gameScene.score here and modify it. But we want to keep the logic in the gameScene rather than spreading it all over the place
        onPressed: rectanglePressed()
    }
    */

}
