import QtQuick
import QtQuick.Controls

MenuSeparator {
    implicitHeight: visible ? 15*appWindow.zoom : 0
    contentItem: Item {
        visible: true
        implicitHeight: visible ? 1*appWindow.zoom : 0

        Rectangle {
            width: parent.width
            anchors.verticalCenter: parent.verticalCenter
            implicitHeight: 1*appWindow.zoom
            color: appWindow.uiver === 1 ?
                       appWindow.theme.border :
                       appWindow.theme_v2.separator
        }
    }
}
