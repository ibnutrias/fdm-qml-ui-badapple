import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import org.freedownloadmanager.fdm
import "../common"

ListView
{
    id: listView

    signal downloadSelected(double model_id)
    signal downloadUnselected()

    flickableDirection: Flickable.HorizontalAndVerticalFlick

    boundsBehavior: Flickable.StopAtBounds

    clip: true

    header: Rectangle
    {
        color: appWindow.theme.border
        width: parent.width
        height: 1
    }

    model: App.downloads.model
    //model: DownloadsViewTestModel {}

    delegate: Rectangle {
        id: downloadsViewItemWraper
        width: listView.width
        height: downloadsViewItem.height + itemDivider.height
//        height: downloadsViewItem.height + itemDivider.height
        color: "transparent"

        DownloadsViewItem
        {
            id: downloadsViewItem

            view: downloadsViewItemWraper.ListView.view
            width: listView.width

            onDownloadSelected: listView.downloadSelected(model.id)
            onDownloadUnselected: listView.downloadUnselected()
        }

        Rectangle
        {
            id: itemDivider
            color: appWindow.theme.border
            width: listView.width
            anchors.top: downloadsViewItem.bottom
            height: 1
        }

    }

    footer: Rectangle {
        width: listView.width
        height: 100
        color: appWindow.theme.background
    }

    ScrollIndicator.horizontal: ScrollIndicator { }
    ScrollIndicator.vertical: ScrollIndicator { }

    Component.onCompleted: {
        selectedDownloadsTools.registerListView(this);
    }

    Component.onDestruction: {
        selectedDownloadsTools.unregisterListView(this);
    }
}
