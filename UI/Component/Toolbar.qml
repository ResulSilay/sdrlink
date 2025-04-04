import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Style 1.0

Rectangle {
    id: toolbar
    width: parent.width
    height: 50
    color: Style.backgroundColor

    property alias title: titleLabel.text
    property alias leftActionVisible: leftButton.visible
    property alias leftActionIcon: leftButtonIcon.source

    signal leftActionTriggered()

    default property alias rightContent: rightContentArea.data

    Row {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 10
        anchors.verticalCenter: parent.verticalCenter

        Item {
            id: leftButton
            width: 20
            height: 20
            visible: toolbar.leftActionVisible

            Image {
                id: leftButtonIcon
                anchors.fill: parent
                source: "../../Resources/Image/ic_arrow_back.svg"
                fillMode: Image.PreserveAspectFit
            }

            MouseArea {
                anchors.fill: parent
                onClicked: toolbar.leftActionTriggered()
            }
        }

        Label {
            id: titleLabel
            text: ""
            font.pixelSize: 21
            font.bold: false
            color: Style.textColor
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: leftButton.right
            horizontalAlignment: Text.AlignHCenter
        }

        RowLayout {
            id: rightContentArea
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            spacing: 10
            Layout.alignment: Qt.AlignRight
        }
    }
}
