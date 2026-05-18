import QtQuick
import QtQuick.Effects

MultiEffect
{
    id: root

    property int radius: 4*appWindow.zoom

    anchors.fill: source

    maskEnabled: enabled
    maskSource: previewImgMask
    maskThresholdMin: 0.5
    maskSpreadAtMin: 1.0

    Item
    {
        id: previewImgMask

        visible: false

        width: parent.width
        height: parent.height

        layer.enabled: true
        layer.smooth: true

        Rectangle
        {
            anchors.fill: parent
            radius: root.radius
            color: "black"
        }
    }
}
