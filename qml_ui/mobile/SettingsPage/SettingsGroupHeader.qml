import QtQuick
import QtQuick.Controls
import "../BaseElements"

Item {
    id: root
    property alias name: headerText.text
    property alias color: headerText.color
    property double contentWidth: headerText.contentWidth + headerText.anchors.leftMargin

    implicitHeight: headerText.implicitHeight + 30*appWindow.zoom
    implicitWidth: headerText.implicitWidth + headerText.anchors.leftMargin + headerText.anchors.rightMargin

    BaseLabel {
        id: headerText
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: (appWindow.uiver === 1 ? 20 : appWindow.theme_v2.mainContentMargins)*appWindow.zoom
        anchors.rightMargin: anchors.leftMargin
        anchors.verticalCenter: parent.verticalCenter
        font: uicore.buildFont({weight: appWindow.uiver === 1 ? Font.Bold : Font.Normal},
                               (appWindow.uiver === 1 ? 17 : appWindow.theme_v2.fontSize)*appWindow.fontZoom)
        wrapMode: Text.WordWrap
    }
}
