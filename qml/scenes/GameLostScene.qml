import QtQuick 2.0
import Felgo 3.0
import "../common"

SceneBase {
    id:gameLostScene

    property int finalScore: 0

    // background
    Rectangle {
        anchors.fill: parent.gameWindowAnchorItem
        color: "#49a349"
    }

    // credits
    Text {
        id: scoreText

        anchors.centerIn: parent

        text: "Oh no! Airplanes have crashed!\n Total airplanes landed: "+ finalScore
        color: "white"
        font.pixelSize: 30
    }

    // back button to leave scene
    MenuButton {

        // anchor the button to the gameWindowAnchorItem to be on the edge of the screen on any device
        anchors.top: scoreText.bottom
        anchors.rightMargin: 10
        anchors.topMargin: 10
        anchors.horizontalCenter: scoreText.horizontalCenter

        text: "Back"

        onClicked: backButtonPressed()
    }
}

