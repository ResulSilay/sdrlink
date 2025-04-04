import QtQuick 2.15

QtObject {
    id: navigationViewModel

    property var navigationHandler

    signal toNavigate(string route)
    signal toBack()

    function navigate(route) {
        toNavigate(route)
    }

    function back() {
        toBack()
    }
}
