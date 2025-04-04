import QtQuick
import QtQuick.Controls
import QtQuick.Window
import Qt.labs.qmlmodels
import Style 1.0
import Route 1.0
import "../../../../Component"

Page {
    id: flightMapPage
    title: qsTr("Flight Map")
    background: Rectangle { color: Style.backgroundColor }

    property var viewModel
    property var flightRows: []
    property int mapType: 0

    Connections {
        target: sdrManager

        function onFlightsReady(flights) {
            onFlights(flights);
        }
    }

    Component.onCompleted: {
        sdrManager.startAdsbReceiver()
    }

    Toolbar {
        id: toolbar
        title: qsTr("Flight Map")
        leftActionVisible: true
        onLeftActionTriggered: {
            flightMapPage.viewModel.toBack()
        }
    }

    Item {
        anchors.fill: parent
        anchors.topMargin: 50

        Column {
            width: parent.width
            height: parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            HorizontalHeaderView {
                id: horizontalHeader
                height: 50
                anchors.left: parent.left
                anchors.right: parent.right
                syncView: flightTableView
                model: ["Country", "Callsign", "ICAO24", "Latitude", "Longitude", "Altitude", "Vertical Rate", "Vertical Rate Source", "Heading", "Squawk", "Type"]
            }

            ScrollView {
                anchors.top: horizontalHeader.bottom
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right

                TableModel {
                    id: flightModel
                    TableModelColumn { display: "country" }
                    TableModelColumn { display: "callsign" }
                    TableModelColumn { display: "icao24" }
                    TableModelColumn { display: "latitude" }
                    TableModelColumn { display: "longitude" }
                    TableModelColumn { display: "altitude" }
                    TableModelColumn { display: "verticalRate" }
                    TableModelColumn { display: "verticalRateSource" }
                    TableModelColumn { display: "heading" }
                    TableModelColumn { display: "squawk" }
                    TableModelColumn { display: "type" }
                }

                TableView {
                    id: flightTableView
                    anchors.fill: parent
                    columnSpacing: 1
                    rowSpacing: 1
                    interactive: true
                    clip: true

                    model: flightModel

                    selectionModel: ItemSelectionModel {}

                    delegate: Rectangle {
                        implicitWidth: 150
                        implicitHeight: 50
                        border.width: current ? 2 : 0
                        color: selected ? "lightblue" : palette.base

                        required property bool selected
                        required property bool current

                        Text {
                            id: text
                            wrapMode: Text.Wrap
                            text: display
                            color: "white"
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter

                        }
                    }
                }
            }
        }
    }

    function onFlights(flights) {
        flightModel.clear();
        flightRows = [];
        if (flights.length > 0) {
            for (var i = 0; i < flights.length; i++) {
                var flight = flights[i];
                var item = {
                    country:  flight.country,
                    callsign:  flight.callsign,
                    icao24:  flight.icao24,
                    latitude:  flight.latitude,
                    longitude:  flight.longitude,
                    altitude:  flight.altitude,
                    verticalRate:  flight.verticalRate,
                    verticalRateSource:  flight.verticalRateSource,
                    heading:  flight.heading,
                    squawk:  flight.squawk,
                    type:  flight.type
                }

                flightRows.push(item)
                flightModel.appendRow(item)
            }
        }
        flightModel.rows = flightRows
    }
}
