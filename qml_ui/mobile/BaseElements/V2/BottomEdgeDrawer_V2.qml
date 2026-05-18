import QtQuick
import QtQuick.Controls

Drawer
{
    edge: Qt.BottomEdge
    width: parent.width

    leftPadding: appWindow.theme_v2.mainContentMargins*appWindow.zoom +
                 appWindow.SafeArea.margins.left
    rightPadding: appWindow.theme_v2.mainContentMargins*appWindow.zoom +
                  appWindow.SafeArea.margins.right
    topPadding: appWindow.theme_v2.mainContentMargins*appWindow.zoom +
                appWindow.SafeArea.margins.top
    bottomPadding: appWindow.theme_v2.mainContentMargins*appWindow.zoom*2 +
                   appWindow.SafeArea.margins.bottom

    background: HalfRoundRect_V2
    {
        where: HalfRoundRect_V2.Where.Top
        color: appWindow.theme_v2.bgColor
        radius: 16
    }
}
