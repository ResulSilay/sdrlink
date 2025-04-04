import QtQuick 2.15
import QtQuick.Controls 2.15
import Style 1.0

Item {
    id: deviceCard
    width: 400
    height: 125
    anchors.horizontalCenter: parent.horizontalCenter

    property int deviceId
    property alias name: titleText.text
    property bool enabled
    property string frequencyRange

    signal clicked()

    Rectangle {
        id: outerCard
        anchors.fill: parent
        radius: Style.cardRadius
        color: "#1A1A1A"

        Rectangle {
            anchors.fill: parent
            radius: outerCard.radius
            color: Qt.transparent

            gradient: Gradient {
                GradientStop { position: 0.0; color: "#444444" }
                GradientStop { position: 1.0; color: "#111111" }
            }
        }

        Rectangle {
            id: innerCard
            anchors.fill: parent
            anchors.margins: 1
            radius: outerCard.radius - 1
            color: "#181818"
        }

        Column {
            spacing: 10
            padding: 20

            Text {
                id: titleText
                text: deviceCard.name
                color: "white"
                font.pixelSize: 22
                font.bold: true
            }

            Text {
                text: "Frequency Range: " + deviceCard.frequencyRange
                color: "white"
                font.pixelSize: 14
            }

            Text {
                text: enabled ? "Status: Enabled" : "Status: Disabled"
                color: enabled ? "lightgreen" : "red"
                font.pixelSize: 14
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            deviceCard.clicked();
        }
    }
}
