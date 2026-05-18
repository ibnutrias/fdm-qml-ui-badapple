import QtQuick
import org.freedownloadmanager.fdm
import "../BaseElements/V2"

ListView
{
    id: root

    flickableDirection: Flickable.HorizontalAndVerticalFlick
    boundsBehavior: Flickable.StopAtBounds

    clip: true

    model: App.downloads.model
    reuseItems: true

    delegate: DownloadsViewItem_V2
    {
        width: root.width
    }

    Component.onCompleted: selectedDownloadsTools.registerListView(this)
    Component.onDestruction: selectedDownloadsTools.unregisterListView(this)
}
