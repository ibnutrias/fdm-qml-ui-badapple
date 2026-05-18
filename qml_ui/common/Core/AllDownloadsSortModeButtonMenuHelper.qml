import QtQuick
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.abstractdownloadsui

Item
{
    property var model: []

    readonly property string title: mode2name(sortTools.sortBy, sortTools.sortAscendingOrder) + App.loc.emptyString

    function build()
    {
        model = [
                    modelItem(AbstractDownloadsUi.DownloadsSortByCreationTime, false),
                    modelItem(AbstractDownloadsUi.DownloadsSortByCreationTime, true),
                    modelItem(AbstractDownloadsUi.DownloadsSortByTitle, true),
                    modelItem(AbstractDownloadsUi.DownloadsSortByTitle, false),
                    modelItem(AbstractDownloadsUi.DownloadsSortBySize, false),
                    modelItem(AbstractDownloadsUi.DownloadsSortBySize, true),
                    modelItem(AbstractDownloadsUi.DownloadsSortByStatus, true),
                    modelItem(AbstractDownloadsUi.DownloadsSortByStatus, false)
                ];
    }

    function modelItem(sortBy, acsending)
    {
        return {
            sortBy: sortBy,
            acsending: acsending,
            text: mode2name(sortBy, acsending),
            action: () => sortTools.setSortByAndAsc(sortBy, acsending)
        }
    }

    function mode2name(m, a)
    {
        switch(m)
        {
        case AbstractDownloadsUi.DownloadsSortByCreationTime:
            return a ? qsTr("Old") : qsTr("Newest");
        case AbstractDownloadsUi.DownloadsSortByTitle:
            //: sort by title mode
            return a ? qsTr("A-Z") : qsTr("Z-A");
        case AbstractDownloadsUi.DownloadsSortBySize:
            return a ? qsTr("By size: small") : qsTr("By size: large");
        case AbstractDownloadsUi.DownloadsSortByStatus:
            return a ? qsTr("By status: ascending") : qsTr("By status: descending")
        }
    }

    Component.onCompleted: build()

    Connections
    {
        target: App.loc
        onCurrentTranslationChanged: build()
    }
}
