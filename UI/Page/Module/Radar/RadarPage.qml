import QtQuick
import QtQuick.Controls
import Style 1.0
import Route 1.0
import "../../../Component"

Page {
    id: radarPage
    title: qsTr("Radar Page")
    background: Rectangle { color: Style.backgroundColor }

    property var viewModel
    property real radarCenterLat: 37.7749
    property real radarCenterLong: -122.4194
    property real radarCoverage: 10
    property real radarRotation: 0
    property real scanAngle: 0

    Connections {
        target: deviceManager

        function onFlightChanged() {
            onFlights()
        }
    }

    property var airplanes: []

    Toolbar {
        id: toolbar
        title: "Radar"
        leftActionVisible: true
        onLeftActionTriggered: {
            radarPage.viewModel.toBack()
        }
    }

    Column {
        anchors.fill: parent
        anchors.topMargin: 50

        Rectangle {
            width: parent.width
            height: parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            color: Style.backgroundColor

            Row {
                width: parent.width
                anchors.top: parent.top

                Column {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    padding: {
                        left: 15
                    }

                    Text {
                        id: liveTimeText
                        text: "Time: " + Qt.formatTime(new Date(), "hh:mm:ss")
                        color: "white"
                    }

                    Text {
                        id: scanAngleText
                        text: "Scan Angle: " + radarPage.scanAngle + "°"
                        color: "white"
                    }
                }

                Column {
                    anchors.top: parent.top
                    anchors.right: parent.right
                    padding: {
                        right: 15
                    }

                    Text {
                        id: airplaneCountText
                        text: "Detected Airplanes: " + radarPage.airplanes.length
                        color: "white"
                    }
                }
            }

            Row {
                width: parent.width
                anchors.bottom: parent.bottom

                Column {
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    padding: {
                        left: 15
                    }

                    Text {
                        id: scannedAreaText
                        text: "Scanned Area: " + radarPage.radarCoverage + " km"
                        color: "white"
                    }

                    Text {
                        id: radarCoordinatesText
                        text: "Center: (" + radarPage.radarCenterLat + ", " + radarPage.radarCenterLong + ")"
                        color: "white"
                    }
                }

                Column {
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    padding: {
                        right: 15
                    }

                    Text {
                        text: "Compass: " + "N"
                        color: "white"
                    }
                }
            }

            // Radar Canvas
            Canvas {
                id: radarCanvas
                width: 900
                height: 900
                anchors.centerIn: parent

                onPaint: {
                    var ctx = radarCanvas.getContext('2d');
                    ctx.clearRect(0, 0, radarCanvas.width, radarCanvas.height);
                    ctx.strokeStyle = "lightgray";
                    ctx.lineWidth = 4;
                    ctx.beginPath();
                    ctx.arc(radarCanvas.width / 2, radarCanvas.height / 2, radarCanvas.width / 2 - 30, 0, 2 * Math.PI);
                    ctx.stroke();

                    drawConcentricCircles(ctx);
                    drawRadarLines(ctx);
                    drawAirplanes();
                    drawScanEffect();
                    drawRadarPointer(radarPage.radarRotation);
                }

                function drawConcentricCircles(ctx)
                {
                    ctx.strokeStyle = "lightgray";
                    ctx.lineWidth = 1;

                    var outerRadius = (radarCoverage * 1000) / 2;
                    var numberOfCircles = 3;
                    var radiusIncrement = outerRadius / numberOfCircles;

                    for (var i = 1; i <= numberOfCircles; i++) {
                        var radius = 100 * i;

                        ctx.beginPath();
                        ctx.arc(radarCanvas.width / 2, radarCanvas.height / 2, radius, 0, 2 * Math.PI);
                        ctx.stroke();
                    }
                }

                function drawRadarLines(ctx)
                {
                    ctx.strokeStyle = "lightgray";
                    ctx.lineWidth = 2;
                    for (var i = 0; i < 24; i++) {
                        ctx.save();
                        ctx.translate(radarCanvas.width / 2, radarCanvas.height / 2);
                        ctx.rotate(i * (Math.PI / 12));
                        ctx.beginPath();
                        ctx.moveTo(0, -radarCanvas.height / 2 + 30);
                        ctx.lineTo(0, -radarCanvas.height / 2 + 20);
                        ctx.stroke();
                        ctx.fillStyle = "white";
                        ctx.font = "bold 14px Arial";
                        var angleText = i * 15 + "°";
                        var textWidth = ctx.measureText(angleText).width;
                        ctx.fillText(angleText, -textWidth / 2, -radarCanvas.height / 2 + 15);
                        ctx.restore();
                    }
                }

                function drawAirplanes()
                {
                    var ctx = radarCanvas.getContext('2d');
                    for (var i = 0; i < radarPage.airplanes.length; i++) {
                        var airplane = airplanes[i];
                        var lat = airplane.lat;
                        var longitude = airplane.longitude;
                        var coords = latLongToRadarCoords(lat, longitude);

                        ctx.fillStyle = "white";
                        ctx.beginPath();
                        ctx.moveTo(coords.x, coords.y - 10);
                        ctx.lineTo(coords.x - 5, coords.y + 5);
                        ctx.lineTo(coords.x + 5, coords.y + 5);
                        ctx.closePath();
                        ctx.fill();
                    }
                }

                function drawRadarPointer(rotation)
                {
                    var ctx = radarCanvas.getContext('2d');
                    ctx.save();
                    ctx.translate(radarCanvas.width / 2, radarCanvas.height / 2);
                    ctx.rotate(rotation * Math.PI / 180);
                    ctx.fillStyle = "red";
                    ctx.beginPath();
                    ctx.moveTo(-2, -radarCanvas.height / 2 + 10);
                    ctx.lineTo(2, -radarCanvas.height / 2 + 10);
                    ctx.lineTo(0, -radarCanvas.height / 2 + 30);
                    ctx.closePath();
                    ctx.fill();
                    ctx.restore();
                }

                function drawScanEffect()
                {
                    var ctx = radarCanvas.getContext('2d');
                    ctx.save();
                    ctx.translate(radarCanvas.width / 2, radarCanvas.height / 2);
                    ctx.rotate(radarPage.scanAngle * Math.PI / 180);
                    ctx.beginPath();
                    ctx.moveTo(0, 0);
                    ctx.lineTo(-100, -radarCanvas.height / 2);
                    ctx.lineTo(100, -radarCanvas.height / 2);
                    ctx.closePath();

                    var gradient = ctx.createRadialGradient(0, 0, 0, 0, 0, radarCanvas.height / 2);
                    gradient.addColorStop(0, "rgba(0, 255, 0, 0.5)");
                    gradient.addColorStop(1, "rgba(0, 0, 0, 0)");

                    ctx.fillStyle = gradient;
                    ctx.fill();
                    ctx.restore();
                }

                Timer {
                    interval: 20
                    repeat: true
                    running: true
                    onTriggered: {
                        radarRotation = (radarPage.radarRotation + 1) % 360;
                        scanAngle = radarRotation;
                        radarCanvas.requestPaint();
                    }
                }

            }

            MouseArea {
                id: clickArea
                anchors.fill: radarCanvas
                onClicked: function(mouse) {
                    var mouseX = mouse.x;
                    var mouseY = mouse.y;

                    for (var i = 0; i < radarPage.airplanes.length; i++) {
                        var airplane = airplanes[i];
                        var lat = airplane.lat;
                        var longitude = airplane.longitude;
                        var coords = latLongToRadarCoords(lat, longitude);

                        if (Math.abs(mouseX - coords.x) < 10 && Math.abs(mouseY - coords.y) < 10) {
                            airplaneDialog.title = airplane.info;
                            dialogText.text = "Airplane Info: " + airplane.info;
                            airplaneDialog.open();
                            return;
                        }
                    }
                }
            }

            Dialog {
                id: airplaneDialog
                modal: true
                title: ""
                standardButtons: Dialog.Ok

                Text {
                    id: dialogText
                    text: ""
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    padding: 10
                }
            }
        }

        Component.onCompleted: {
            onFlights()
        }
    }

    function onFlights() {
        airplanes = deviceManager.getFlights();
        airplaneCountText.text = "Detected Airplanes: " + airplanes.length;
        radarCanvas.requestPaint();
    }

    function latLongToRadarCoords(lat, longitude) {
        var earthRadius = 6371;
        var latDiff = (lat - radarCenterLat) * (Math.PI / 180);
        var longDiff = (longitude - radarCenterLong) * (Math.PI / 180);
        var x = radarCanvas.width / 2 + (earthRadius * longDiff * Math.cos(radarCenterLat * (Math.PI / 180))) / radarCoverage * radarCanvas.width / 2;
        var y = radarCanvas.height / 2 - (earthRadius * latDiff) / radarCoverage * radarCanvas.height / 2;
        return {x: x, y: y};
    }
}
