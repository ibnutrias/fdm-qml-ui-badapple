import QtQuick
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import "../BaseElements"
import "../BaseElements/V2"

RowLayout
{
    required property double speed
    required property bool running
    required property int priority
    required property bool isDownload

    spacing: 0

    Item
    {
        implicitWidth: 10*appWindow.zoom
        implicitHeight: 10*appWindow.zoom
        SvgImage_V2
        {
            source: Qt.resolvedUrl(isDownload ?
                                       "view_item_arrow_down.svg" :
                                       "view_item_arrow_up.svg")
            anchors.centerIn: parent
        }
    }

    BaseLabel
    {
        text: App.speedAsText(speed) + App.loc.emptyString
        color: running ?
                   uicore.priorityAndSnailColor(priority) :
                   uicore.priorityColor(priority)
        font: uicore.buildFont({}, (appWindow.theme_v2.fontSize-2)*appWindow.fontZoom)
    }
}
