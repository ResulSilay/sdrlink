import QtQuick 2.15
import QtQuick.Layouts 1.15
import Style 1.0

Item {
    id: dashboardItem
    property alias title: title.text
    property alias description: description.text
    property alias iconSource: iconImage.source

    width: 250
    height: 250

    Rectangle {
        id: outerCard
        anchors.fill: parent
        radius: Style.cardRadius
        color: "#131313"
        clip: true
        border.color: "#353535"
        border.width: 2

        Rectangle {
            id: rootCard
            anchors.fill: parent
            radius: outerCard.radius
            color: Qt.transparent

            gradient: Gradient {
                GradientStop { position: 0.0; color: "#353535" }
                GradientStop { position: 1.0; color: "#111111" }
            }
        }

        Rectangle {
            id: innerCard
            anchors.fill: parent
            anchors.margins: 1
            radius: outerCard.radius - 1
            color: "#141414"
        }

        Column {
            anchors.centerIn: parent
            spacing: 10
            width: parent.width - 30
            anchors.horizontalCenter: parent.horizontalCenter

            Image {
                id: iconImage
                sourceSize.width: 80
                sourceSize.height: 80
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                id: title
                color: "#FFFFFF"
                font.pixelSize: 17
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                elide: Text.ElideRight
                wrapMode: Text.WordWrap
                anchors {
                    topMargin: 80
                    leftMargin: 0
                    rightMargin: 0
                    bottomMargin: 0
                }
            }

            Text {
                id: description
                color: "#b1b1b1"
                font.pixelSize: 14
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
                width: parent.width - 20
                elide: Text.ElideRight
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: rootCard.border.color = "#FFFFFF"
            onExited: rootCard.border.color = null
        }

        Behavior on border.color {
            ColorAnimation { duration: 200 }
        }
    }
}
