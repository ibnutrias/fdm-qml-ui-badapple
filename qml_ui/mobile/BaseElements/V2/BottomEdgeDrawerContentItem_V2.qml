import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import ".."

ColumnLayout
{
    property alias title: titleLabel.text

    spacing: 0

    Rectangle
    {
        implicitHeight: 4*appWindow.zoom
        implicitWidth: 48*appWindow.zoom
        radius: 3*appWindow.zoom
        color: appWindow.theme_v2.bg400
        Layout.alignment: Qt.AlignHCenter
    }

    Item
    {
        implicitHeight: 10*appWindow.zoom
        implicitWidth: 1
    }

    BaseLabel
    {
        id: titleLabel
        visible: text
        font: uicore.buildFont({weight: 500},
                               (appWindow.theme_v2.fontSize+3)*appWindow.fontZoom)
    }

    Item
    {
        implicitHeight: 10*appWindow.zoom // default (and minimum) distance between title and content
        implicitWidth: 1
    }
}
