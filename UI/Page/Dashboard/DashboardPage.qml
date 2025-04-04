import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Style 1.0
import Route 1.0
import "../../Component"

Page {
    id: dashboardPage
    title: qsTr("Dashboard")
    background: Rectangle { color: Style.backgroundColor }

    property var viewModel
    property bool isExpanded: false

    property var itemList: [
        { title: "Flight Map", description: "View aircraft positions in real-time.", icon: "../../Resources/Image/ic_flight.svg", onClickAction: function() { viewModel.navigateToFlightMap() } },
        { title: "Radar", description: "Monitor air traffic using ADS-B signals.", icon: "../../Resources/Image/ic_radar.svg", onClickAction: function() { viewModel.navigateToRadar() } },
        { title: "Radio", description: "Listen to aviation and communication frequencies.", icon: "../../Resources/Image/ic_radio.svg", onClickAction: function() { viewModel.toBack() } },
        { title: "Marine Map", description: "Track ships and maritime traffic in real-time.", icon: "../../Resources/Image/ic_marine.svg", onClickAction: function() { viewModel.toBack() } },
        { title: "Spectrum", description: "Analyze radio frequency spectrum visually.", icon: "../../Resources/Image/ic_spectrum.svg", onClickAction: function() { viewModel.toBack() } },
        { title: "Weather", description: "Access real-time weather data and forecasts.", icon: "../../Resources/Image/ic_weather.svg", onClickAction: function() { viewModel.toBack() } },
        { title: "Future Module", description: "A new feature is on the way.", icon: "../../Resources/Image/ic_loading.svg", onClickAction: function() { viewModel.toBack() } },
        { title: "Future Module", description: "A new feature is on the way.", icon: "../../Resources/Image/ic_loading.svg", onClickAction: function() { viewModel.toBack() } },
        { title: "Future Module", description: "A new feature is on the way.", icon: "../../Resources/Image/ic_loading.svg", onClickAction: function() { viewModel.toBack() } },
        { title: "Future Module", description: "A new feature is on the way.", icon: "../../Resources/Image/ic_loading.svg", onClickAction: function() { viewModel.toBack() } },
        { title: "Future Module", description: "A new feature is on the way.", icon: "../../Resources/Image/ic_loading.svg", onClickAction: function() { viewModel.toBack() } },
        { title: "Future Module", description: "A new feature is on the way.", icon: "../../Resources/Image/ic_loading.svg", onClickAction: function() { viewModel.toBack() } }
    ]

    Toolbar {
        id: toolbar
        title: qsTr("Dashboard")
        leftActionVisible: false
    }

    Item {
        anchors.fill: parent
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        GridLayout {
            id: itemsGrid
            columns: 4
            rowSpacing: 30
            columnSpacing: 30
            anchors.centerIn: parent

            Repeater {
                model: dashboardPage.itemList.length
                delegate: ModuleCard {
                    width: 250
                    height: 250

                    iconSource: itemList[index].icon
                    title: itemList[index].title
                    description: itemList[index].description

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            itemList[index].onClickAction()
                        }
                    }
                }
            }
        }
    }
}
