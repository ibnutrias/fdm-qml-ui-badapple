import QtQuick
import QtQuick.Controls

TextField
{
    property bool enable_QTBUG_110471_workaround: true
    property bool enable_QTBUG_110471_workaround_2: false
    property bool selectAllAtInit: false
    property bool overrideImplicitHeight: true // https://bugreports.qt.io/browse/QTBUG-120505
    property bool setupPaddings: true
    property color bgColor: appWindow.theme_v2.bgColor

    property var background_V2: Rectangle
    {
        border.color: (parent && parent.activeFocus ? appWindow.theme_v2.primary : appWindow.theme_v2.editTextBorderColor)
        border.width: 1*appWindow.zoom
        color: bgColor
        radius: 8*appWindow.zoom
    }

    color: appWindow.uiver === 1 ?
               appWindow.theme.foreground :
               appWindow.theme_v2.textColor

    font: uicore.buildFont({}, uicore.fontSizeV1(16*appWindow.fontZoom))

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

        if (appWindow.uiver !== 1 && setupPaddings)
        {
            leftPadding = 12*appWindow.zoom;
            rightPadding = 8*appWindow.zoom;
            topPadding = 8*appWindow.zoom;
            bottomPadding = 8*appWindow.zoom;
        }

        // https://bugreports.qt.io/browse/QTBUG-110471
        if (enable_QTBUG_110471_workaround &&
                appWindow.LayoutMirroring.enabled &&
                !LayoutMirroring.enabled)
        {
            LayoutMirroring.enabled = Qt.binding(() => appWindow.LayoutMirroring.enabled);
            if (enable_QTBUG_110471_workaround_2)
            {
                let t = text;
                text = t + ' ';
                text = t;
            }
        }

        if (overrideImplicitHeight)
            implicitHeight = Qt.binding(() => contentHeight + topPadding + bottomPadding);

        if (selectAllAtInit)
            selectAll();
    }
}
