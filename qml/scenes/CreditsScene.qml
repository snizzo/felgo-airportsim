import Felgo 3.0
import QtQuick 2.0
import "../common"

SceneBase {
    id:creditsScene

    // background
    Rectangle {
        anchors.fill: parent.gameWindowAnchorItem
        color: "#64ccff"
    }

    // back button to leave scene
    MenuButton {
        text: "Back"

        // anchor the button to the gameWindowAnchorItem to be on the edge of the screen on any device
        anchors.top: creditsText.bottom
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter

        onClicked: backButtonPressed()
    }

    // credits
    Text {
        id: creditsText
        text: "Credits to: YOU :)"
        color: "white"
        anchors.centerIn: parent
    }
}
