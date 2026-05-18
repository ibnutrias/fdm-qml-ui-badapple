import QtQuick

Item
{
    id: root

    enum Where {Top, Bottom}

    required property int where
    required property int radius
    property color color: "white"

    Rectangle
    {
        radius: root.radius
        color: root.color
        width: root.width
        height: radius * 2
        anchors.bottom: where === HalfRoundRect_V2.Where.Bottom ?
                            parent.bottom :
                            undefined
    }

    Rectangle
    {
        color: root.color
        width: root.width
        height: root.height - root.radius
        anchors.bottom: where === HalfRoundRect_V2.Where.Top ?
                            parent.bottom :
                            undefined
    }
}
