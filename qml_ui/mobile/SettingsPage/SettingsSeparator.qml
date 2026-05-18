import QtQuick
import QtQuick.Layouts

Rectangle {
    width: parent.width
    Layout.fillWidth: true
    implicitHeight: 1*appWindow.zoom
    color: appWindow.uiver === 1 ?
               appWindow.theme.generalSettingsBorder :
               appWindow.theme_v2.separator
}
