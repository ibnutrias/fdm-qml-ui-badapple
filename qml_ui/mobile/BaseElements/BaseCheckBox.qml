import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import "V2"

CheckBox {
    id: root

    property bool vertical: false
    property string textColor
    property int wrapMode: Text.NoWrap
    property int indicatorSize: (appWindow.uiver === 1 ? 12 : 16)*appWindow.zoom

    padding: 0

    leftPadding: appWindow.uiver === 1 ? undefined : 0
    rightPadding: appWindow.uiver === 1 ? undefined : 0
    topPadding: appWindow.uiver === 1 ? undefined : 0
    bottomPadding: appWindow.uiver === 1 ? undefined : 0

    spacing: vertical ? 20 : undefined
    focusPolicy: Qt.NoFocus

    font: uicore.buildFont({}, uicore.fontSizeV1(indicatorSize === 16 ? 14 : 12)*appWindow.fontZoom)

    indicator: Rectangle {
        implicitWidth: indicatorSize
        implicitHeight: indicatorSize

        anchors.left: vertical ? undefined : parent.left
        anchors.horizontalCenter: vertical ? parent.horizontalCenter : undefined
        anchors.bottom: vertical ? parent.bottom : undefined
        anchors.verticalCenter: vertical ? undefined : parent.verticalCenter

        color: appWindow.uiver === 1 ?
                   (checkState === Qt.Unchecked ? "transparent" : appWindow.theme.toolbarBackground) :
                   (checkState === Qt.Unchecked ? appWindow.theme_v2.bg200 : appWindow.theme_v2.secondary)

        border.color: appWindow.uiver === 1 ?
                          appWindow.theme.border :
                          appWindow.theme_v2.bg500

        border.width: checkState === Qt.Unchecked ? 1 : 0

        radius: appWindow.uiver === 1 ? 0 : 4

        opacity: root.enabled ? 1 : (appWindow.uiver === 1 ? 0.5 : appWindow.theme_v2.opacityDisabled)

        SvgImage_V2 {
            id: img
            visible: checkState === Qt.Checked
            sourceSize: appWindow.uiver === 1 ?
                            Qt.size(12, 12) :
                            Qt.size(width, height)
            source: Qt.resolvedUrl(appWindow.uiver === 1 ?
                                       "../../images/mobile/checkbox.svg" :
                                       "V2/checkmark.svg")
            applyImageColor: appWindow.uiver !== 1
            imageColor: appWindow.theme_v2.bg200
            anchors.centerIn: parent
        }

        Rectangle {
            visible: checkState === Qt.PartiallyChecked
            width: indicatorSize - 6
            height: width
            x: (indicatorSize - width) / 2
            y: x
            color: "#FFFFFF"
        }
    }

    contentItem: BaseLabel {
        leftPadding: qtbug.leftPadding(vertical ? 0 : appWindow.uiver === 1 ? 20 : (indicator.width + (text ? 8 : 0)), 0)
        rightPadding: qtbug.rightPadding(vertical ? 0 : appWindow.uiver === 1 ? 20 : (indicator.width + (text ? 8 : 0)), 0)
        bottomPadding: vertical ? indicatorSize : 0
        text: parent.text
        anchors.horizontalCenter: vertical ? parent.horizontalCenter : undefined
        anchors.top: vertical ? parent.top : undefined
        opacity: root.enabled ? 1 : (appWindow.uiver === 1 ? 0.5 : appWindow.theme_v2.opacityDisabled)
        font: root.font
        wrapMode: root.wrapMode
    }
}
