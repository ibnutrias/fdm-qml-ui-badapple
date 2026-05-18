import QtQuick
import QtQuick.Controls
import QtQuick.Effects

Menu
{
    //////////////////////////////////////////////////////////////////////
    // QTBUG-139695 workaround
    topMargin: appWindow.SafeArea.margins.top
    leftMargin: appWindow.SafeArea.margins.left
    bottomMargin: appWindow.SafeArea.margins.bottom
    rightMargin: appWindow.SafeArea.margins.right
    //////////////////////////////////////////////////////////////////////

    implicitWidth: {
        var result = 0;
        for (var i = 0; i < count; ++i) {
            var item = itemAt(i);
            if (item.visible && item.contentItem)
                result = Math.max(item.contentItem.implicitWidth, result);
        }
        return result + 40*appWindow.zoom;
    }

    background: Item
    {
        MultiEffect
        {
            visible: appWindow.uiver === 1 || appWindow.theme_v2.useGlow
            anchors.fill: menuBackground
            source: menuBackground
            shadowEnabled: true
            shadowBlur: 0.5
            shadowColor: appWindow.uiver === 1 ?
                             "black" :
                             appWindow.theme_v2.glowColor
        }
        Rectangle
        {
            id: menuBackground
            anchors.fill: parent
            color: appWindow.uiver === 1 ?
                       appWindow.theme.background :
                       appWindow.theme_v2.bgColor
            radius: (appWindow.uiver === 1 ? 6 : 8)*appWindow.zoom
        }
    }

    delegate: BaseMenuItem {}
}
