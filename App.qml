import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import Style 1.0
import Route 1.0

ApplicationWindow {
    id: app
    visible: true
    width: Screen.width
    height: Screen.height
    title: qsTr("Sdrlink")
    color: Style.backgroundColor
    visibility: Window.FullScreen

    SplashPage {
        id: splashPage
        anchors.fill: parent
    }

    NavigationViewModel {
        id: navigationViewModel
    }

    DeviceViewModel {
        id: deviceViewModel
        navigationHandler: navigationViewModel
    }

    DashboardViewModel {
        id: dashboardViewModel
        navigationHandler: navigationViewModel
    }

    StackView {
        id: stackView
        initialItem: DevicePage { viewModel: deviceViewModel }
        anchors.fill: parent
        background: Rectangle { color: Style.backgroundColor }
        visible: false
    }

    Connections {
        target: splashPage
        onCompleted: {
            splashPage.visible = false
            stackView.visible = true
        }
    }

    Connections {
        target: navigationViewModel

        function onToNavigate(route) {
            if (route === Route.dashboard) {
                stackView.push(Qt.resolvedUrl(route), { viewModel: dashboardViewModel });
            }
            else if (route === Route.about) {
                stackView.push(Qt.resolvedUrl(route), { viewModel: navigationViewModel });
            }
            else if (route === Route.radar) {
                stackView.push(Qt.resolvedUrl(route), { viewModel: navigationViewModel });
            }
            else if (route === Route.flightMap) {
                stackView.push(Qt.resolvedUrl(route), { viewModel: navigationViewModel });
            }
            else {
                stackView.push(Qt.resolvedUrl(route));
            }
        }

        function onToBack() {
            stackView.pop()
        }
    }
}
