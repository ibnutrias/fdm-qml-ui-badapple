import QtQuick

Item
{
    implicitHeight: 9*appWindow.zoom

    Rectangle
    {
        height: 1*appWindow.zoom
        width: parent.width
        anchors.verticalCenter: parent.verticalCenter
        color: appWindow.theme_v2.separator
    }
}
