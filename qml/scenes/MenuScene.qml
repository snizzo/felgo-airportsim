import Felgo 3.0
import QtQuick 2.0
import "../common"

SceneBase {
    id: menuScene

    // signal indicating that the selectLevelScene should be displayed
    signal playPressed
    // signal indicating that the creditsScene should be displayed
    signal creditsPressed

    // background
    Rectangle {
        anchors.fill: parent.gameWindowAnchorItem
        color: "#64ccff"
    }

    FontLoader {
        id: webFont;
        source: "../../assets/fonts/PoiretOne-Regular.ttf"
    }

    // menu
    Column {
        anchors.centerIn: parent
        spacing: 10
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 40
            font.family: webFont.name
            color: "#e9e9e9"
            text: "Airport Simulator"
        }
        MenuButton {
            anchors.horizontalCenter: parent.horizontalCenter

            text: "Play"
            onClicked: playPressed()
        }
        MenuButton {
            anchors.horizontalCenter: parent.horizontalCenter

            text: "Credits"
            onClicked: creditsPressed()
        }
    }

    // a little Felgo logo is always nice to have, right?
    Image {
        source: "../../assets/img/felgo-logo.png"
        width: 60
        height: 60
        anchors.right: menuScene.gameWindowAnchorItem.right
        anchors.rightMargin: 10
        anchors.bottom: menuScene.gameWindowAnchorItem.bottom
        anchors.bottomMargin: 10
    }
}
