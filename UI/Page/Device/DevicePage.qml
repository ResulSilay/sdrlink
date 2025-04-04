import QtQuick 2.15
import QtQuick.Controls 2.15
import Style 1.0
import "../../Component"

Page {
    id: devicePage
    title: qsTr("Devices")
    background: Rectangle { color: Style.backgroundColor }

    property var viewModel

    Column {
        anchors.fill: parent

        Toolbar {
            id: toolbar
            title: qsTr("Devices")
            leftActionVisible: false
        }

        CircleLoadingBar { }

        Timer {
            id: deviceCheckTimer
            interval: 500
            repeat: true
            running: true
            onTriggered: getDevices()
        }
    }

    Component.onCompleted: {
        deviceCheckTimer.start();
    }

    function getDevices() {
        var devices = devicePage.viewModel.getDevices();

        if(devices.length > 0){
            deviceCheckTimer.stop()
            viewModel.startDevice();
        }
    }
}
