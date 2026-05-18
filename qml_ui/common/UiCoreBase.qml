import QtQuick
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.abstractdownloadsui
import "Tools"

Item
{
    readonly property var snailTools : SnailTools {}

    readonly property string supportTheProjectText: qsTr("Support the project") + App.loc.emptyString
    readonly property string thankYouForUsingApp: qsTr("Thank you for using %1!").arg(App.shortDisplayName) + App.loc.emptyString

    property bool minuteUpdate: false // changes its value each minute
    Timer {
        interval: 60*1000
        repeat: true
        running: true
        onTriggered: minuteUpdate = !minuteUpdate
    }

    readonly property var allPriorities: [
        AbstractDownloadsUi.DownloadPriorityHigh,
        AbstractDownloadsUi.DownloadPriorityNormal,
        AbstractDownloadsUi.DownloadPriorityLow
    ]

    function priorityText(priority)
    {
        switch(priority)
        {
        case AbstractDownloadsUi.DownloadPriorityHigh: return qsTr("High");
        case AbstractDownloadsUi.DownloadPriorityLow: return qsTr("Low");
        default: return qsTr("Normal");
        }
    }

    function priorityColor(priority)
    {
        switch(priority)
        {
        case AbstractDownloadsUi.DownloadPriorityHigh: return appWindow.theme_v2.secondary;
        case AbstractDownloadsUi.DownloadPriorityLow: return appWindow.theme_v2.danger;
        default: return appWindow.theme_v2.textColor;
        }
    }

    function priorityAndSnailColor(priority)
    {
        return snailTools.isSnail ?
                    appWindow.theme_v2.amber :
                    priorityColor(priority);
    }
}
