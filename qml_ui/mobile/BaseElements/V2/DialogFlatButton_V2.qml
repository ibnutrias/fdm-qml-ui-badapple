import QtQuick
import QtQuick.Layouts
import ".."

Rectangle
{
    signal clicked()

    property bool primary: false
    property alias imageSource: img.source
    property alias text: label.text
    property alias layoutDirection: ct.layoutDirection

    readonly property color supposedBgColor: (primary && enabled) ?
                                                 appWindow.theme_v2.primary :
                                                 appWindow.theme_v2.bg200

    readonly property color supposedFgColor:
        primary ? (enabled ? appWindow.theme_v2.bg100 : appWindow.theme_v2.bg500) :
                  appWindow.theme_v2.bg700


    implicitWidth: ct.implicitWidth + 12*2*appWindow.zoom
    implicitHeight: ct.implicitHeight + 8*2*appWindow.zoom

    color: supposedBgColor
    radius: 8*appWindow.zoom

    RowLayout
    {
        id: ct

        anchors.centerIn: parent

        spacing: 8*appWindow.zoom

        SvgImage_V2
        {
            id: img
            visible: source.toString()
            imageColor: supposedFgColor
        }

        BaseLabel
        {
            id: label
            visible: text
            font: uicore.buildFont({capitalization: Font.AllUppercase, weight: 600},
                  (appWindow.theme_v2.fontSize-1)*appWindow.fontZoom)
            color: supposedFgColor
        }
    }

    TapHandler
    {
        gesturePolicy: TapHandler.WithinBounds
        onTapped: clicked()
    }
}
