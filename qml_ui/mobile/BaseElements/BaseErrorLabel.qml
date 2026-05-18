import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import org.freedownloadmanager.fdm
import "../../common"

BaseBaseErrorLabel
{
    id: root

    spacing: 3

    showIcon: appWindow.uiver === 1

    Image
    {
        visible: root.showIcon
        sourceSize.width: 16
        sourceSize.height: 16
        source: Qt.resolvedUrl("../../images/mobile/error.svg")
        layer {
            effect: MultiEffect {
                colorization: 1.0
                colorizationColor: appWindow.theme.errorMessage
            }
            enabled: true
        }
        Layout.alignment: Qt.AlignTop
        Layout.topMargin: 2
    }

    BaseLabel
    {
        Layout.fillWidth: true
        clip: true
        elide: Text.ElideRight
        text: root.errorText
        color: appWindow.uiver === 1 ?
                   appWindow.theme.errorMessage :
                   appWindow.theme_v2.danger
        verticalAlignment: Text.AlignVCenter
        font: uicore.buildFont({weight: appWindow.uiver === 1 ? Font.Light : Font.Medium},
                               (appWindow.uiver === 1 ? 14 : (appWindow.theme_v2.fontSize-2))*appWindow.fontZoom)
        wrapMode: root.shortVersion ? Text.NoWrap : Text.WordWrap
        onLinkActivated: root.onErrorLinkActivated()
    }
}
