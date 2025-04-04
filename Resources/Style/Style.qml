pragma Singleton

import QtQuick 2.15
import QtQuick.Controls 2.15

QtObject {
    property bool isDarkMode: true
    readonly property color backgroundColor: isDarkMode ? "#000000" : "#FFFFFF"
    readonly property color textColor: isDarkMode ? "#FFFFFF" : "#000000"
    readonly property string fontFamily: "Syncopate"

    readonly property int cardRadius: 15

    property string fontSource: "qrc:/Resources/Font/SyncopateRegular.ttf"

    Component.onCompleted: {
        var fontLoader = Qt.createQmlObject('import QtQuick 2.15; FontLoader { source: "' + fontSource + '" }', this);
        if (fontLoader.loaded) {
            fontFamily = fontLoader.name;
        } else {
            fontLoader.statusChanged.connect(function() {
                if (fontLoader.status === FontLoader.Error) {
                    console.error("Error: " + fontLoader.errorString);
                }
            });
        }
    }

    function toggleTheme() {
        isDarkMode = !isDarkMode;
    }
}
