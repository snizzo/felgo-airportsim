import Felgo 3.0
import QtQuick 2.0
import "../common"
import "../entities"
import "../levels/utils.js" as JsUtils

SceneBase {
    id:gameScene
    // score
    property int score: 0
    // countdown shown at level start
    property int timeCounter: 1
    // flag indicating if game is running
    property bool gameRunning: countdown != 0

    /*
    // background
    Rectangle {
        anchors.fill: parent.gameWindowAnchorItem
        color: "#dd94da"

        Rectangle {
            color: "white"
            width: parent.width * 0.98
            height: parent.height * 0.98
            radius: 10
            anchors.centerIn: parent
        }
    }
    */

    Airplane{

    }

    // back button to leave scene
    MenuButton {
        id: gameSceneBackButton
        text: "Back to menu"
        // anchor the button to the gameWindowAnchorItem to be on the edge of the screen on any device
        anchors.right: gameScene.gameWindowAnchorItem.right
        anchors.rightMargin: 10
        anchors.top: gameScene.gameWindowAnchorItem.top
        anchors.topMargin: 10
        onClicked: {
            backButtonPressed()
        }
    }

    MenuButton {
        text: "spawn airplane"
        // anchor the button to the gameWindowAnchorItem to be on the edge of the screen on any device
        anchors.right: gameScene.gameWindowAnchorItem.right
        anchors.rightMargin: 10
        anchors.top: gameSceneBackButton.bottom
        anchors.topMargin: 10
        onClicked: {
            entityManager.spawnAirplane();
        }
    }

    /*
    // name of the current level
    Text {
        anchors.left: gameScene.gameWindowAnchorItem.left
        anchors.leftMargin: 10
        anchors.top: gameScene.gameWindowAnchorItem.top
        anchors.topMargin: 10
        color: "black"
        font.pixelSize: 20
        text: activeLevel !== undefined ? activeLevel.levelName : ""
    }
    */

    // load levels at runtime
    Loader {
        id: loader
        source: activeLevelFileName != "" ? "../levels/" + activeLevelFileName : ""
        onLoaded: {
            // reset the score
            timeCounter = 0
            // since we did not define a width and height in the level item itself, we are doing it here
            item.width = gameScene.width
            item.height = gameScene.height
            // store the loaded level as activeLevel for easier access
            activeLevel = item
            // restarts the time counter
            timeCounter = 0
            timeCounter.running = true
        }
    }

    // we connect the gameScene to the loaded level
    Connections {
        // only connect if a level is loaded, to prevent errors
        target: activeLevel !== undefined ? activeLevel : null
        // increase the score when the rectangle is clicked
    }

    /*
    // name of the current level
    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: gameScene.gameWindowAnchorItem.top
        anchors.topMargin: 30
        color: "white"
        font.pixelSize: 40
        text: score
    }
    */

    /*
    // text displaying either the time counter or "tap!"
    Text {
        anchors.centerIn: parent
        color: "black"
        font.pixelSize: timeCounter < 1 ? 160 : 18
        text: timeCounter > 0 ? timeCounter: "Let's go!"
    }
    */

    function reset(){
        gameTimer.running = false;
    }

    function startGame(){
        gameTimer.running = true;
    }

    // if the countdown is greater than 0, this timer is triggered every second, decreasing the countdown (until it hits 0 again)
    Timer {
        id: gameTimer
        repeat: true
        running: false
        onTriggered: {
            timeCounter++
            if (timeCounter % 1 == 0){

                entityManager.spawnAirplane();

            }
        }
    }
}
