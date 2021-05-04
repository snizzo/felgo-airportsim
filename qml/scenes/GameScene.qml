import Felgo 3.0
import QtQuick 2.0
import "../common"
import "../entities"
import "../levels/utils.js" as JsUtils

SceneBase {
    id:gameScene

    signal spawnAirplane()
    signal destroyAirplane(string entityId)
    signal destroyAllAirplanes()
    signal airplanesCollided()
    signal gameLost(int finalScore)

    // score
    property int score: 0
    // countdown shown at level start
    property int timeCounter: 0
    //if opacity > 0 game scene is considered active
    property bool isActive: opacity > 0

    // background
    Rectangle {
        anchors.fill: parent.gameWindowAnchorItem
        color: "#64ccff"
    }

    Airport{
        id: airport
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Connections{
        target: airport
        onAirplaneLanded : {
            score++;
            destroyAirplane(entityId);
        }
    }

    // back button to leave scene
    MenuButton {
        id: gameSceneBackButton
        text: "Back to menu"
        // anchor the button to the gameWindowAnchorItem to be on the edge of the screen on any device
        anchors.right: gameScene.gameWindowAnchorItem.right
        anchors.rightMargin: 10
        anchors.bottom: gameScene.gameWindowAnchorItem.bottom
        anchors.bottomMargin: 10
        onClicked: {
            backButtonPressed()
        }
    }

    Text {
        anchors.top: parent.top
        anchors.right: parent.right
        color: "white"
        font.pixelSize: 20
        text: score
    }

    // binding isActive with stop and start functions
    onIsActiveChanged: {
        isActive ? start() : stop()
    }

    onAirplanesCollided: {
        if(gameTimer.running){
            gameLost(score);
        }
        stop();
    }

    function stop(){
        gameTimer.running = false;
        score = 0;

        //sending signal of level closing
        destroyAllAirplanes();
    }

    function start(){
        gameTimer.running = true;
        timeCounter = 0;
        score = 0;
    }

    // if the countdown is greater than 0, this timer is triggered every second, decreasing the countdown (until it hits 0 again)
    Timer {
        id: gameTimer
        repeat: true
        running: false
        onTriggered: {
            // every 7 seconds spawn a new airplane
            timeCounter++

            // every 5 planes becomes -100ms (10% faster)
            // with a minimum of 100ms (1000% original speed)
            // because seconds last one tenth of original time
            if(interval>200){
                interval -= 20; // 20ms
            }

            if (timeCounter % 7 == 0){
                // signal
                spawnAirplane();
            }
        }
    }
}
