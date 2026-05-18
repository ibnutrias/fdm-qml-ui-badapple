import QtQuick
import QtQuick.Controls
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.abstractdownloadsui
import "../../BaseElements"

Rectangle
{
    //property alias priority: model.priority

    implicitWidth: l.implicitWidth + 8*appWindow.zoom
    implicitHeight: l.implicitHeight + 8*appWindow.zoom

    radius: 4*appWindow.zoom

    color: appWindow.theme_v2.opacityColor(priorityColor(model.priority), 0.2)

    BaseLabel
    {
        id: l
        text: uicore.priorityText(model.priority) + App.loc.emptyString
        color: priorityColor(model.priority)
        font: uicore.buildFont({}, (appWindow.theme_v2.fontSize-1)*appWindow.fontZoom)
        anchors.centerIn: parent
    }

    BaseMenu
    {
        id: menu

        Repeater
        {
            model: uicore.allPriorities

            BaseMenuItem
            {
                required property int modelData
                text: uicore.priorityText(modelData) + App.loc.emptyString
                checkable: true
                checked: model.priority === modelData
                onClicked: model.priority = modelData
            }
        }
    }

    TapHandler
    {
        gesturePolicy: TapHandler.WithinBounds
        onTapped: menu.open()
    }

    function priorityColor(priority)
    {
        switch(priority)
        {
        case AbstractDownloadsUi.DownloadPriorityHigh: return appWindow.theme_v2.secondary;
        case AbstractDownloadsUi.DownloadPriorityLow: return appWindow.theme_v2.danger;
        default: return appWindow.theme_v2.primary;
        }
    }
}
