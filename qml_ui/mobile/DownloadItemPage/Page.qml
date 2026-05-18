import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material
import org.freedownloadmanager.fdm
import "../"
import "../BaseElements"
import "../Dialogs"
import "../../common"
import "../../common/Tools"

Page {
    id: root
    property var downloadItemId
    property int tabIndex: 0
    property var currentTabsModel: []

    DownloadsItemTools2 {
        id: downloadsItemTools
        itemId: downloadItemId
        onHasDetailsChanged: updateCurrentTabsModel()

        property bool locked: downloadsItemTools.lockReason != ""
        property var itemOpacity: downloadsItemTools.locked ? 0.4 : 1
    }

    header: Loader {
        source: Qt.resolvedUrl(appWindow.uiver === 1 ?
                                   "PageHeader.qml" :
                                   "V2/PageHeader_V2.qml")
    }

    footer: Loader {
        source: appWindow.uiver === 1 ?
                    "" :
                    Qt.resolvedUrl("V2/PageFooter_V2.qml")

    }

    readonly property int filter: appWindow.uiver === 1 ?
                                      header.item.filter :
                                      footer.item.filter

    Loader {
        visible: filter === 0
        anchors.fill: parent
        anchors.margins: appWindow.uiver === 1 ? 14 : appWindow.theme_v2.mainContentMargins*appWindow.zoom
        source: Qt.resolvedUrl(appWindow.uiver === 1 ? "GeneralTab.qml" : "V2/GeneralTab_V2.qml")
    }

    DetailsTab {
        visible: filter === 3
    }

    Loader {
        visible: filter === 1
        anchors.fill: parent
        anchors.margins: appWindow.uiver === 1 ? 0 : appWindow.theme_v2.mainContentMargins*appWindow.zoom
        source: Qt.resolvedUrl(appWindow.uiver === 1 ? "Files.qml" : "V2/FilesTab_V2.qml")
    }

    Loader {
        visible: filter === 2
        anchors.fill: parent
        anchors.margins: appWindow.uiver === 1 ? 14 : appWindow.theme_v2.mainContentMargins*appWindow.zoom
        source: Qt.resolvedUrl(appWindow.uiver === 1 ? "ConnectionsTab.qml" : "V2/ConnectionsTab_V2.qml")
    }

    DeleteDownloadsDialog {
        id: deleteDownloadsDialog
        downloadIds: [downloadItemId]

        onDownloadsRemoved: stackView.pop()
    }

    SchedulerDialog {
        id: schedulerDlg
    }

    SchedulerTools {
        id: schedulerTools
        onBuildingFinished: {
            schedulerDlg.initialization();
            schedulerDlg.open();
        }
        onSettingsSaved: schedulerDlg.close()
    }

    Component.onCompleted: updateCurrentTabsModel();

    function updateCurrentTabsModel()
    {
        var ids = [0];
        var tabs = [{id: 0, name: qsTr("Info") + App.loc.emptyString}];

        var downloadInfo = App.downloads.infos.info(downloadItemId);

        if (downloadInfo.details) {
            tabs.push({id: 3, name: qsTr("Details") + App.loc.emptyString});
            ids.push("details");
        }

        if (downloadInfo.filesCount > 1) {
            tabs.push({id: 1, name: qsTr("Files") + App.loc.emptyString});
            ids.push("files");
        }

        if (!downloadInfo.finished || downloadInfo.hasPostFinishedTasks) {
            tabs.push({id: 2, name: qsTr("Connections") + App.loc.emptyString});
            ids.push("connections");
        }

        currentTabsModel = tabs;
    }
}
