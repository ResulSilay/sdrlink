import QtQuick 2.15
import QtQuick.Window 2.15
import Style 1.0

Rectangle {
    id: splashPage
    width: parent.width
    height: parent.height
    anchors.centerIn: parent
    color: Style.backgroundColor

    Image {
        id: logoImage
        source: "qrc:/Resources/Image/ic_logo.png"
        anchors.centerIn: parent
        opacity: 0
        scale: 1

        Behavior on x {
            NumberAnimation {
                duration: 1000
                from: splashPage.parent.width / 2
                to: splashPage.parent.width / 2
                easing.type: Easing.OutCubic
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: 750
                from: 0
                to: 1
                easing.type: Easing.InOutQuad
            }
        }

        Behavior on scale {
            NumberAnimation {
                duration: 500
                from: 0.5
                to: 1
                easing.type: Easing.InOutQuad
            }
        }
    }

    Timer {
        id: splashTimer
        interval: 1000
        running: true
        repeat: false
        onTriggered: {
            animateExit();
        }
    }

    signal completed()

    function animateExit() {
        logoImage.x = parent.width;
        logoImage.opacity = 0;
        completed();
    }

    Component.onCompleted: {
        logoImage.opacity = 1;
        logoImage.scale = 1;
    }
}
