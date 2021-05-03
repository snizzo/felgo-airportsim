import QtQuick 2.0
import Felgo 3.0

import "../levels/utils.js" as JsUtils

EntityBase {

    entityId: "airport"
    entityType: "airportEntity"

    width: 100
    height: 50

    property alias sprite: rect

    signal airplaneLanded(string entityId)

    //placeholder for planes
    Rectangle {
        id: rect

        anchors.fill: parent

        //source: "../../assets/img/airplane.png"
        color: "green"
    }

    // used for collisions between planes
    BoxCollider {
        anchors.fill: parent

        fixture.onBeginContact: {
            var body = other.getBody();
            var collidedEntity = body.target;
            var collidedEntityType = collidedEntity.entityType;
            var collidedEntityId = collidedEntity.entityId;

            // not checking entityType because airplane is the only type
            // we'll ever encounter
            //entityManager.destroyAirplane(collidedEntityId);
            airplaneLanded(collidedEntityId);
        }
    }
}
