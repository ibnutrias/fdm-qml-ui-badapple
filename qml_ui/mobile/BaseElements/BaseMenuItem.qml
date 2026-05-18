import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import "V2"

MenuItem
{
    id: menuItem

    property bool useEnabledLookAlways: false
    property int xOffset: 0

    implicitHeight: visible ?
                        contentItem.implicitHeight + (appWindow.uiver === 1 ? 2 : 4*2)*appWindow.zoom :
                        0

    indicator: SvgImage_V2 {
        id: img
        visible: menuItem.checkable && menuItem.checked
        sourceSize: appWindow.uiver === 1 ?
                        Qt.size(16, 16) :
                        Qt.size(width, height)
        anchors.left: parent.left
        anchors.leftMargin: 5*appWindow.zoom + xOffset
        anchors.verticalCenter: parent.verticalCenter
        source: Qt.resolvedUrl(appWindow.uiver === 1 ?
                                   "../../images/mobile/check.svg" :
                                   "V2/menu_checkmark.svg")
        imageColor: appWindow.uiver === 1 ?
                        appWindow.theme.sortCheck :
                        appWindow.theme_v2.primary
    }

    contentItem: BaseLabel {
        text: menuItem.text
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        leftPadding: qtbug.leftPadding(indicator.width - 4 + xOffset, 0)
        rightPadding: qtbug.rightPadding(indicator.width - 4 + xOffset, 0)
        font: uicore.buildFont({}, uicore.fontSizeV1(16)*appWindow.fontZoom)
        wrapMode: Text.WordWrap
        opacity: useEnabledLookAlways ?
                     1.0 :
                     (enabled ? 1 : (appWindow.uiver === 1 ? 0.5 : appWindow.theme_v2.opacityDisabled))
    }
}
