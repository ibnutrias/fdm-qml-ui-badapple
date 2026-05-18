import QtQuick
import QtQuick.Controls

Label {
    id: label

    property bool adaptive: false
    property int labelSize: adaptiveTools.labelSize.smallSize

    opacity: enabled ? 1 : (appWindow.uiver === 1 ? 0.5 : appWindow.theme_v2.opacityDisabled)

    color: appWindow.uiver === 1 ?
               appWindow.theme.foreground :
               appWindow.theme_v2.textColor

    linkColor: appWindow.uiver === 1 ?
                   appWindow.theme.link :
                   appWindow.theme_v2.primary

    font: uicore.buildFont({}, uicore.fontSizeV1(getPointSize())*appWindow.fontZoom)

    horizontalAlignment: Text.AlignLeft

    function getPointSize()
    {
        if (adaptive) {
            var small, medium, high;
            switch (labelSize) {
                case adaptiveTools.labelSize.smallSize:
                    small = 12; medium = 13; high = 14;
                    break;
                case adaptiveTools.labelSize.mediumSize:
                    small = 14; medium = 15; high = 16;
                    break;
                case adaptiveTools.labelSize.highSize:
                    small = 16; medium = 17; high = 18;
                    break;
            }
            return adaptiveTools.adaptiveByWidth(small, medium, high)
        } else {
            return 12;
        }
    }
}
