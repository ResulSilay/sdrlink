import QtQuick 2.15
import QtQuick.Controls 2.15
import Style 1.0
import Route 1.0
import "../../Component"

Page {
    id: aboutPage
    title: qsTr("About")
    background: Rectangle { color: Style.backgroundColor }

    property var viewModel

    Toolbar {
        id: toolbar
        title: qsTr("About")
        leftActionVisible: true
        onLeftActionTriggered: {
            aboutPage.viewModel.toBack()
        }
    }

    Item {
        anchors.fill: parent
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        Column {
            anchors.centerIn: parent
            spacing: 20

            Text {
                text: qsTr("Welcome to the Radar Application!")
                font.pointSize: 20
                horizontalAlignment: Text.AlignHCenter
                color: Style.textColor
            }

            Text {
                text: qsTr("This application provides real-time radar information of airplanes.")
                font.pointSize: 16
                horizontalAlignment: Text.AlignHCenter
                color: Style.textColor
                wrapMode: Text.WordWrap
                width: parent.width * 0.8
            }
        }
    }
}
