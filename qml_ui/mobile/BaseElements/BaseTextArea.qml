import QtQuick
import QtQuick.Controls

TextArea
{
    id: root

    property var background_V2: Rectangle
    {
        border.color: root.activeFocus ?
                          appWindow.theme_v2.primary :
                          appWindow.theme_v2.editTextBorderColor
        border.width: 1*appWindow.zoom
        color: appWindow.theme_v2.bgColor
        radius: 8*appWindow.zoom
    }

    color: appWindow.uiver === 1 ?
               appWindow.theme.foreground :
               appWindow.theme_v2.textColor

    font: uicore.buildFont({}, uicore.fontSizeV1(16)*appWindow.fontZoom)

    placeholderTextColor: appWindow.uiver === 1 ?
                              appWindow.theme.settingsPlaceholder :
                              appWindow.theme_v2.placeholderTextColor

    horizontalAlignment: Text.AlignLeft

    PropertyOverride
    {
        id: bgOverride
        name: "background"
        value: background_V2
        override: appWindow.uiver !== 1
    }

    Component.onCompleted:
    {
        bgOverride.initialize();

        if (appWindow.uiver !== 1)
        {
            leftPadding = 12*appWindow.zoom;
            rightPadding = leftPadding;
            topPadding = leftPadding;
            bottomPadding = leftPadding;
        }
    }
}
