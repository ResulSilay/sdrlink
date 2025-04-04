import QtQuick 2.15
import Route 1.0

QtObject {
    id: dashboardViewModel

    property var navigationHandler

    function navigateToRadar() {
        navigationHandler.navigate(Route.radar)
    }

    function navigateToFlightMap() {
        navigationHandler.navigate(Route.flightMap)
    }

    function toBack() {
        navigationHandler.back()
    }
}
