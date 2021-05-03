import Felgo 3.0
import QtQuick 2.0
import "scenes"
import "levels/utils.js" as JsUtils
import "entities"

GameWindow {
    id: window

    // just desktop window size
    screenWidth: 960
    screenHeight: 640

    // virtual resolution, necessary for different screen scaling
    property int currentWidth: 480
    property int currentHeight: 320

    signal airplaneDestroyed(string entityId)

    // You get free licenseKeys from https://felgo.com/licenseKey
    // With a licenseKey you can:
    //  * Publish your games & apps for the app stores
    //  * Remove the Felgo Splash Screen or set a custom one (available with the Pro Licenses)
    //  * Add plugins to monetize, analyze & improve your apps (available with the Pro Licenses)
    //licenseKey: "<generate one from https://felgo.com/licenseKey>"

    PhysicsWorld {
    // set no gravity, the collider is not physics-based
    }

    // create and remove entities at runtime
    EntityManager {
        id: entityManager
        entityContainer: gameScene

        property int idCounter: 0

        function spawnAirplane(){

            var entityProperties = JsUtils.getRandomAirplaneProperties();
            entityProperties["entityId"] = "airplane"+idCounter;

            idCounter++;

            createEntityFromUrlWithProperties(Qt.resolvedUrl("entities/Airplane.qml"), entityProperties);
        }

        function destroyAirplane(id){
            removeEntityById(id);
        }

        //removing all airplane entities
        function destroyAllAirplanes(){
            removeEntitiesByFilter(["airplaneEntity"])
        }
    }

    Connections {
        target: gameScene
        onDestroyAirplane : {
            console.log("destroying airplane")
        // compare the monsters entityId with the on that is passed from the signal
            entityManager.destroyAirplane(entityId);
        }

        onSpawnAirplane : {
            entityManager.spawnAirplane();
        }

        onDestroyAllAirplanes : {
            entityManager.destroyAllAirplanes();
        }

        onGameLost : {
            gameLostScene.finalScore = finalScore
            state = "gamelost"
        }

    }

    // menu scene
    MenuScene {
        id: menuScene
        // listen to the button signals of the scene and change the state according to it
        onPlayPressed: window.state = "game"
        onCreditsPressed: window.state = "credits"

        // the menu scene is our start scene, so if back is pressed there we ask the user if he wants to quit the application
        onBackButtonPressed: {
            nativeUtils.displayMessageBox(qsTr("Really quit the game?"), "", 2);
        }
        // listen to the return value of the MessageBox
        Connections {
            target: nativeUtils
            onMessageBoxFinished: {
                // only quit, if the activeScene is menuScene - the messageBox might also get opened from other scenes in your code
                if(accepted && window.activeScene === menuScene)
                    Qt.quit()
            }
        }
    }

    // credits scene
    CreditsScene {
        id: creditsScene
        onBackButtonPressed: window.state = "menu"
    }

    // game scene to play a level
    GameScene {
        id: gameScene
        onBackButtonPressed: window.state = "menu"
    }

    // game scene to play a level
    GameLostScene {
        id: gameLostScene
        onBackButtonPressed: window.state = "menu"
    }

    // menuScene is our first scene, so set the state to menu initially
    state: "menu"
    activeScene: menuScene

    // state machine, takes care reversing the PropertyChanges when changing the state, like changing the opacity back to 0
    states: [
        State {
            name: "menu"
            PropertyChanges {target: menuScene; opacity: 1}
            PropertyChanges {target: window; activeScene: menuScene}
        },
        State {
            name: "gamelost"
            PropertyChanges {target: gameLostScene; opacity: 1}
            PropertyChanges {target: window; activeScene: gameLostScene}
        },
        State {
            name: "credits"
            PropertyChanges {target: creditsScene; opacity: 1}
            PropertyChanges {target: window; activeScene: creditsScene}
        },
        State {
            name: "game"
            PropertyChanges {target: gameScene; opacity: 1}
            PropertyChanges {target: window; activeScene: gameScene}
        }
    ]
}
