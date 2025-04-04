import QtQuick 2.15
import QtQuick.Controls 2.15
import Style 1.0

Canvas {
    id: circularLoader
    anchors.centerIn: parent
    width: 100
    height: 100
    antialiasing: true

    onPaint: {
        var ctx = getContext("2d");
        ctx.clearRect(0, 0, width, height);

        ctx.lineWidth = 8;
        ctx.strokeStyle = "#FFFFFF";

        ctx.beginPath();
        ctx.arc(width / 2, height / 2, 40, 0, Math.PI * 2 * progress, false);
        ctx.stroke();
    }

    property real progress: 0.0

    Timer {
        interval: 15
        running: true
        repeat: true
        onTriggered: {
            circularLoader.progress += 0.01;
            if (circularLoader.progress > 1) circularLoader.progress = 0;
            circularLoader.requestPaint();
        }
    }
}
