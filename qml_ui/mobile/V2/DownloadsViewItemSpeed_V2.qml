import QtQuick
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import "../BaseElements"
import "../BaseElements/V2"

RowLayout
{
    required property double downloadSpeed
    required property double uploadSpeed
    required property bool running
    required property int priority

    spacing: 0

    DownloadsViewItemSpeedItem_V2
    {
        speed: downloadSpeed
        isDownload: true
        running: running
        priority: priority
    }

    Item
    {
        implicitWidth: (6*2+1)*appWindow.zoom
        implicitHeight: 10*appWindow.zoom
        Rectangle
        {
            width: 1*appWindow.zoom
            height: 12*appWindow.zoom
            color: appWindow.theme_v2.bg500
            anchors.centerIn: parent
        }
    }

    DownloadsViewItemSpeedItem_V2
    {
        speed: uploadSpeed
        isDownload: false
        running: running
        priority: priority
    }
}
