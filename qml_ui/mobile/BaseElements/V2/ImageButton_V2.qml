import QtQuick

Item
{
    signal clicked()

    property alias source: img.source

    implicitHeight: 32
    implicitWidth: 32

    SvgImage_V2
    {
        id: img
        anchors.centerIn: parent
    }

    TapHandler
    {
        gesturePolicy: TapHandler.WithinBounds
        onTapped: clicked()
    }
}
