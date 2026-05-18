import QtQuick
import QtQuick.Layouts
import ".."

Item
{
    signal clicked

    property alias text: label.text
    property bool showSortIndicator: false
    property bool sortAscendingOrder: false

    implicitWidth: ct.implicitWidth
    implicitHeight: ct.implicitHeight

    RowLayout
    {
        id: ct

        anchors.fill: parent

        spacing: 0

        BaseLabel
        {
            id: label

            Layout.fillWidth: true
            Layout.maximumWidth: Math.ceil(implicitWidth)

            font: uicore.buildFont({}, (appWindow.theme_v2.fontSize-1)*appWindow.fontZoom)

            elide: Text.ElideRight
        }

        Item {implicitWidth: 4*appWindow.zoom}

        SvgImage_V2
        {
            visible: showSortIndicator
            source: Qt.resolvedUrl("expand_more.svg")
            rotation: sortAscendingOrder ? 0 : 180
        }

        Item {Layout.fillWidth: true}
    }

    TapHandler
    {
        gesturePolicy: TapHandler.WithinBounds
        onTapped: clicked()
    }

}
