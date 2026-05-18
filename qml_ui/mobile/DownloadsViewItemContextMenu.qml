import QtQuick
import QtQuick.Controls
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.appfeatures
import org.freedownloadmanager.fdm.abstractdownloadsui 
import "BaseElements"
import "../common/Tools"


BaseMenu
{
    id: root

    property var modelIds: []
    property bool downloadItemPage: false
    property bool supportsDisablePostFinishedTasks: false
    property bool supportsAddT: false
    property bool supportsForceReann: false
    property bool supportsIgnoreURatioLimit: false
    readonly property var info: modelIds.length === 1 ? App.downloads.infos.info(modelIds[0]) : null
    readonly property var error: info ? info.error : null
    readonly property bool showReportError: error && error.hasError
    readonly property bool showAllowAutoRetry: info && (showReportError || App.downloads.autoRetryMgr.isDownloadSetToAutoRetry(modelIds[0]))
    property bool threeDotsMenu: false
    property bool hideDisabledItems: threeDotsMenu

    modal: true
    dim: false

    DownloadsItemsTools {
        id: tools
        ids: modelIds
    }

    DownloadsItemTools {
        id: singleItemTools
        itemId: modelIds.length === 1 ? modelIds[0] : -1
    }

    DownloadsItemContextMenuTools {
        id: contextMenuTools
        modelId: modelIds[0]
        singleDownload: modelIds.length === 1
        finished: tools.finished
    }

    transformOrigin: Menu.TopRight

    BaseMenuItem {
        id: finishDownloadingItem
        visible: tools.canBeFinalized && (enabled || !hideDisabledItems)
        text: qsTr("Save and complete") + App.loc.emptyString
        enabled: !tools.locked
        onTriggered: tools.finalizeDownloads()
    }
    BaseMenuSeparator {visible: finishDownloadingItem.visible}

    readonly property bool abortVisible: singleItemTools.performingLo && singleItemTools.loAbortable
    BaseMenuItem {
        visible: abortVisible
        text: qsTr("Abort") + App.loc.emptyString
        onTriggered: singleItemTools.abortLo()
    }
    BaseMenuSeparator {
        visible: abortVisible
    }

    ActionGroup {
        id: priorityGroup
    }
    BaseMenuItem {
        visible: tools.canChangePriority
        text: qsTr("Set priority") + App.loc.emptyString
        enabled: false
        useEnabledLookAlways: true
    }
    Repeater {
        model: uicore.allPriorities
        BaseMenuItem {
            required property int modelData
            visible: tools.canChangePriority
            text: uicore.priorityText(modelData) + App.loc.emptyString
            checkable: true
            checked: (modelData === AbstractDownloadsUi.DownloadPriorityHigh && tools.highPriority) ||
                     (modelData === AbstractDownloadsUi.DownloadPriorityNormal && tools.normalPriority) ||
                     (modelData === AbstractDownloadsUi.DownloadPriorityLow && tools.lowPriority)
            onTriggered: tools.setDownloadsPriority(modelData)
            ActionGroup.group: priorityGroup
            xOffset: 30*appWindow.zoom
        }
    }
    BaseMenuSeparator {
        visible: tools.canChangePriority
    }

    BaseMenuItem {
        id: restartItem
        text: qsTr("Restart") + App.loc.emptyString
        visible: tools.canBeRestarted && (enabled || !hideDisabledItems)
        enabled: !tools.locked
        onTriggered: tools.restartDownloads()
    }

    BaseMenuItem {
        id: openItem
        text: qsTr("Open") + App.loc.emptyString
        visible: !App.rc.client.active && contextMenuTools.canBeOpened
        enabled: !tools.locked
        onTriggered: contextMenuTools.openClick()
    }

    BaseMenuItem {
        id: showInFolderItem
        visible: !App.rc.client.active &&
                 (modelIds.length === 1 && contextMenuTools.canBeShownInFolder)
        text: qsTr("Show in folder") + App.loc.emptyString
        onTriggered: contextMenuTools.showInFolderClick()
    }

    BaseMenuItem {
        id: shareFileItem
        visible: !App.rc.client.active && contextMenuTools.canShareFile
        text: qsTr("Share file") + App.loc.emptyString
        onTriggered: contextMenuTools.shareFileClick()
    }

    BaseMenuSeparator {
        visible: restartItem.visible || openItem.visible || showInFolderItem.visible || shareFileItem.visible
    }

    BaseMenuItem {
        visible: showReportError
        text: qsTr("Report problem") + App.loc.emptyString
        enabled: !tools.locked
        onTriggered: contextMenuTools.reportProblem()
    }
    BaseMenuItem {
        visible: showAllowAutoRetry
        text: qsTr("Enable auto retry for this kind of errors") + App.loc.emptyString
        checkable: true
        enabled: !App.downloads.autoRetryMgr.isErrorAutoRetryAllowedByCore(error)
        checked: App.downloads.autoRetryMgr.isErrorAutoRetryAllowedByUser(error)
        onTriggered: {
            App.downloads.autoRetryMgr.setErrorAllowAutoRetryByUser(error, checked);
            if (checked && !info.running)
                App.downloads.mgr.startDownload(modelIds[0], false);
        }
    }
    BaseMenuSeparator {
        visible: showReportError || showAllowAutoRetry
    }

    readonly property bool showInfoVisible: modelIds.length === 1 && !downloadItemPage
    BaseMenuItem {
        visible: showInfoVisible
        text: qsTr("Show info") + App.loc.emptyString
        onTriggered: stackView.waPush(Qt.resolvedUrl("DownloadItemPage/Page.qml"), {downloadItemId: modelIds[0]});
    }
    readonly property bool filesVisible: !downloadItemPage && info && info.filesCount > 1
    BaseMenuItem {
        visible: filesVisible
        text: qsTr("Files") + App.loc.emptyString
        onTriggered: stackView.waPush(Qt.resolvedUrl("DownloadItemPage/Page.qml"), {downloadItemId: modelIds[0], tabIndex: 1});
    }
    BaseMenuSeparator {
        visible: showInfoVisible || filesVisible
    }

    BaseMenuItem {
        text: qsTr("Rename file") + App.loc.emptyString
        visible: info ? (info.finished && info.filesCount === 1) : false
        enabled: !tools.locked && tools.canRename
        onTriggered: stackView.waPush(Qt.resolvedUrl("RenameDownloadFilePage.qml"), {downloadId:modelIds[0]})
    }
    BaseMenuItem {
        visible: !App.rc.client.active
        text: qsTr("Move to...") + App.loc.emptyString
        enabled: !tools.locked && tools.canMove
        onTriggered: stackView.waPush(filePicker.filePickerPageComponent, {initiator: "fileMoving", downloadId: modelIds[0]});
    }
    BaseMenuItem {
        text: qsTr("Delete file") + App.loc.emptyString
        enabled: !tools.locked
        onTriggered: {
            deleteDownloadsDialog.downloadIds = modelIds;
            deleteDownloadsDialog.open();
        }
    }
    BaseMenuItem {
        text: qsTr("Remove from list") + App.loc.emptyString
        enabled: !tools.locked
        onTriggered: selectedDownloadsTools.removeFromList(tools.ids)
    }
    BaseMenuSeparator {}

    BaseMenuItem {
        id: sequentialDownloadItem
        visible: tools.supportsSequentialDownload && (enabled || !hideDisabledItems)
        enabled: !tools.locked
        text: qsTr("Sequential download") + App.loc.emptyString
        checkable: true
        checked: tools.sequentialDownload
        onTriggered: tools.setSequentialDownload(checked)
    }
    BaseMenuItem {
        id: playFileWhileDownloadingItem
        visible: tools.supportsPlayAsap && (enabled || !hideDisabledItems)
        enabled: !tools.locked
        text: qsTr("Play file while it is still downloading") + App.loc.emptyString
        checkable: true
        checked: tools.playAsap
        onTriggered: tools.setPlayAsap(checked)
    }
    BaseMenuItem {
        id: addMirrorItem
        visible: tools.ids.length === 1 && (tools.info.flags & AbstractDownloadsUi.SupportsMirrors) && (enabled || !hideDisabledItems)
        text: qsTr("Add mirror") + App.loc.emptyString
        enabled: !tools.locked
        onTriggered: {
            stackView.waPush(Qt.resolvedUrl("AddMirrorPage.qml"), {downloadModel: info})
        }
    }
    BaseMenuSeparator {
        visible: sequentialDownloadItem.visible || playFileWhileDownloadingItem.visible ||
                 addMirrorItem.visible || supportsDisablePostFinishedTasks ||
                 supportsAddT || supportsIgnoreURatioLimit || supportsForceReann
    }

    BaseMenuItem {
        enabled: modelIds.length === 1 && contextMenuTools.openDownloadPageAllowed()
        text: qsTr("Open download page") + App.loc.emptyString
        onTriggered: contextMenuTools.openDownloadPageClick()
    }
    BaseMenuItem {
        text: qsTr("Copy link") + App.loc.emptyString
        visible: modelIds.length === 1
        onTriggered: contextMenuTools.copyLinkClick()
    }
    BaseMenuItem {
        text: qsTr("Check for update") + App.loc.emptyString
        visible: tools.canCheckForUpdate
        onTriggered: tools.checkForUpdate()
    }
    BaseMenuSeparator {}

    BaseMenuItem {
        id: changeUrlItem
        visible: tools.ids.length === 1 &&
                 (tools.info.flags & AbstractDownloadsUi.AllowChangeSourceUrl) &&
                 (enabled || !hideDisabledItems)
        enabled: !tools.locked
        text: qsTr("Change URL") + App.loc.emptyString
        onTriggered: {
            stackView.waPush(Qt.resolvedUrl("ChangeUrlPage.qml"), {downloadModel: info})
        }
    }
    BaseMenuSeparator {
        visible: changeUrlItem.visible
    }

    BaseMenuItem {
        enabled: !tools.locked && tools.canConvertToMp3
        text: qsTr("Convert to mp3") + App.loc.emptyString
        onTriggered: {
            stackView.waPush(Qt.resolvedUrl("Mp3ConverterPage.qml"), {downloadsIds: tools.ids, filesIndices: []})
        }
    }

    BaseMenuItem {
        enabled: !tools.locked && tools.canConvertToMp4
        text: qsTr("Convert to mp4") + App.loc.emptyString
        onTriggered: {
            stackView.waPush(Qt.resolvedUrl("Mp4ConverterPage.qml"), {downloadsIds: tools.ids, filesIndices: []})
        }
    }
    BaseMenuSeparator {}

    BaseMenuItem {
        id: fileIntegrityItem
        visible: tools.ids.length === 1 && tools.finished && tools.info.filesCount === 1 && (enabled || !hideDisabledItems)
        text: qsTr("File integrity") + App.loc.emptyString
        enabled: !tools.locked && info && !info.missingFiles && !info.missingStorage
        onTriggered: {
            stackView.waPush(Qt.resolvedUrl("FileIntegrityPage.qml"), {fileIndex: 0, downloadModel: info})
        }
    }
    BaseMenuSeparator {
        visible: fileIntegrityItem.visible
    }

    BaseMenuItem {
        enabled: !tools.locked && tools.canSchedule
        text: qsTr("Schedule") + App.loc.emptyString
        onTriggered: schedulerDlg.setUpSchedulerAction(tools.ids)
    }

    Component.onCompleted: {
        if (appWindow.btSupported) {
            let index = 0;
            for (let i = 0; i < root.count; ++i) {
                if (root.itemAt(i) == sequentialDownloadItem) {
                    index = i;
                    break;
                }
            }
            if (btTools.item.addTAllowed()) {
                supportsAddT = true;
                root.insertItem(index++, Qt.createQmlObject('import "../bt/mobile"; AddTMenuItem {}', root));
            }
            if (btTools.item.disablePostFinishedTasksAllowed()) {
                supportsDisablePostFinishedTasks = true;
                root.insertItem(index++, Qt.createQmlObject('import "../bt/mobile"; DisableSMenuItem {}', root));
            }
            if (btTools.item.ignoreURatioLimitAllowed()) {
                supportsIgnoreURatioLimit = true;
                root.insertItem(index++, Qt.createQmlObject('import "../bt/mobile"; IgnoreURatioMenuItem {}', root));
            }
            if (btTools.item.forceReannounceAllowed()) {
                supportsForceReann = true;
                root.insertItem(index++, Qt.createQmlObject('import "../bt/mobile"; ForceReannMenuItem {}', root));
            }
        }
    }
}
