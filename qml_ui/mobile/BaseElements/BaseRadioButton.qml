import QtQuick
import QtQuick.Controls
import "V2"

RadioButton
{
    id: root

    property bool v1_white: false

    property color textColor: appWindow.uiver === 1 ?
                                  (v1_white ? "white" : appWindow.theme.foreground) :
                                  appWindow.theme_v2.textColor

    topPadding: 0
    bottomPadding: 0
    leftPadding: 0
    rightPadding: 0

    // Math.ceil prevents unwanted word wrap in some cases
    implicitWidth: Math.ceil(contentItem.implicitWidth + leftPadding + rightPadding)

    spacing: 8*appWindow.zoom

    font: uicore.buildFont({}, uicore.fontSizeV1(16)*appWindow.fontZoom)

    indicator: Item
    {
        implicitWidth: appWindow.uiver === 1 ? indicator_v1.implicitWidth : indicator_v2.implicitWidth
        implicitHeight: appWindow.uiver === 1 ? indicator_v1.implicitHeight : indicator_v2.implicitHeight

        anchors.left: parent.left
        anchors.leftMargin: root.leftPadding
        anchors.verticalCenter: parent.verticalCenter

        Rectangle
        {
            id: indicator_v1
            visible: appWindow.uiver === 1
            implicitWidth: 18
            implicitHeight: 18
            radius: 9
            color: root.checked ? border.color : "transparent"
            border.color: v1_white ?
                              "white" :
                              appWindow.theme.toolbarBackground
            border.width: 2
            Rectangle
            {
                width: 8
                height: 8
                x: 5
                y: 5
                radius: 4
                color: v1_white ?
                           appWindow.theme.toolbarBackground :
                           "white"
                visible: root.checked
            }
        }

        SvgImage_V2
        {
            id: indicator_v2
            visible: appWindow.uiver !== 1
            source: Qt.resolvedUrl("V2/radio_" + (root.checked ? "checked" : "unchecked") + ".svg")
            imageColor: root.enabled && root.checked ? appWindow.theme_v2.primary : appWindow.theme_v2.bg600
        }
    }

    contentItem: BaseLabel
    {
        anchors.left: parent.left
        anchors.verticalCenter: root.verticalCenter
        verticalAlignment: Text.AlignVCenter
        leftPadding: qtbug.leftPadding(root.leftPadding + root.indicator.width + (text ? root.spacing : 0), root.rightPadding)
        rightPadding: qtbug.rightPadding(root.leftPadding + root.indicator.width + (text ? root.spacing : 0), root.rightPadding)
        text: root.text
        color: root.textColor
        wrapMode: Label.WordWrap
        font: root.font
    }
}
