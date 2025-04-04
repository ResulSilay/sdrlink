import QtQuick 2.15
import Route 1.0

QtObject {
    id: deviceViewModel

    property var navigationHandler

    function getDevices() {
        return sdrManager.getAvailableDevices();
    }
    
    function startDevice() {
        sdrManager.start()
        navigationHandler.navigate(Route.dashboard)
    }

    function stopDevice() {
        sdrManager.stop()
    }

    function navigateToAbout() {
        navigationHandler.navigate(Route.about)
    }
}
