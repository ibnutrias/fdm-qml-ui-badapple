import QtQuick
import QtQuick.Controls

RoundButton {
    id: root
    height: 60
    width: Math.max(60, txt.contentWidth + 20)
    radius: height
    flat: true
    property color textColor: appWindow.theme.foreground

    contentItem: Text {
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        id: txt
        text: root.text
        font.pixelSize: 14*appWindow.fontZoom
        color: textColor
        opacity: root.enabled ? 1 : 0.3

        font.weight: Font.DemiBold
    }
}
