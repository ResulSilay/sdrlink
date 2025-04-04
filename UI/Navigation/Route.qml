pragma Singleton

import QtQuick 2.15

QtObject {
    
    property string basePath: "UI/Page/"

    readonly property string devices: basePath + "Device/DevicePage.qml"
    readonly property string dashboard: basePath + "Dashboard/DashboardPage.qml"
    readonly property string splash: basePath + "Splash/SplashPage.qml"
    readonly property string about: basePath + "About/AboutPage.qml"
    readonly property string radar: basePath + "Module/Radar/RadarPage.qml"
    readonly property string flightMap: basePath + "Module/Flight/Map/FlightMapPage.qml"
}
