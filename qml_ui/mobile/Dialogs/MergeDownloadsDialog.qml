import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import "../../common/Tools"
import "../BaseElements"

CenteredDialog {
    id: root

    parent: Overlay.overlay

    modal: true

    title: qsTr("The download already exists") + App.loc.emptyString

    BaseLabel {
        visible: mergeTools.dialogEnabled
        text: downloadsItemTools.resourceUrl.length > 0 ? downloadsItemTools.resourceUrl : downloadsItemTools.title
        elide: Text.ElideMiddle
        Layout.fillWidth: true
        Layout.maximumWidth: root.ctMaxWidth
        horizontalAlignment: Text.AlignLeft
        font: uicore.buildFont({}, uicore.fontSizeV1(16*appWindow.fontZoom))
        DownloadsItemTools {
            id: downloadsItemTools
            itemId: mergeTools.existingDownloadId
        }
    }

    BaseDialogButtonsLayout 
    {
        BaseDialogButton {
            text: qsTr("Skip") + App.loc.emptyString
            onClicked: mergeTools.accept()
        }

        BaseDialogButton {
            visible: App.downloads.mergeOptionsChooser.pendingNewDownloadIdsCount > 1
            text: qsTr("Skip all (%1)").arg(App.downloads.mergeOptionsChooser.pendingNewDownloadIdsCount) + App.loc.emptyString
            onClicked: mergeTools.acceptAll()
        }

        BaseDialogButton {
            visible: mergeTools.mergeBtnEnabled
            text: qsTr("Download") + App.loc.emptyString
            onClicked: mergeTools.dontMerge()
        }
    }

    onRejected: {
        mergeTools.reject();
    }

    MergeDownloadsTools {
        id: mergeTools
    }

    Connections {
        target: App.downloads.mergeOptionsChooser
        onGotAbortMergeRequest: function(newDownloadId, existingDownloadId) {
            if (mergeTools.newDownloadId == newDownloadId)
            {
                root.close();
                mergeTools.abortRequest();
            }
        }
    }

    function newMergeByRequest(newDownloadId, existingDownloadId)
    {
        if (mergeTools.newMergeRequest(newDownloadId, existingDownloadId)) {
            root.open();
        }
    }

}
