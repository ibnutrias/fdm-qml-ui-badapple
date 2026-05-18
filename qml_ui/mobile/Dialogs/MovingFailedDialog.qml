import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import "../BaseElements"
import "../../common/Tools"

CenteredDialog {
    id: root

    property int downloadId
    property string errorMessage

    parent: Overlay.overlay

    modal: true

    title: qsTr("Moving download failed") + App.loc.emptyString

    BaseLabel
    {
        Layout.fillWidth: true
        Layout.maximumWidth: root.ctMaxWidth
        text: qsTr("Error: %1").arg(errorMessage) + App.loc.emptyString
        horizontalAlignment: Text.AlignLeft
        color: appWindow.uiver === 1 ?
                           appWindow.theme.errorMessage :
                           appWindow.theme_v2.danger
        font: uicore.buildFont({}, uicore.fontSizeV1(16*appWindow.fontZoom))
    }

    BaseLabel
    {
        id: lbl
        visible: downloadsItemTools.tplPathAndTitle.length > 0
        Layout.fillWidth: true
        Layout.maximumWidth: root.ctMaxWidth
        elide: Text.ElideMiddle
        DownloadsItemTools {
            id: downloadsItemTools
            itemId: root.downloadId
        }
        text: qsTr("Unable to move: %1").arg(downloadsItemTools.hasChildDownloads ? downloadsItemTools.destinationPath : downloadsItemTools.tplPathAndTitle) + App.loc.emptyString
        horizontalAlignment: Text.AlignLeft
        font: uicore.buildFont({}, uicore.fontSizeV1(16*appWindow.fontZoom))
    }

    BaseDialogButtonsLayout
    {
        BaseDialogButton {
            text: qsTr("Try again") + App.loc.emptyString
            primary: true
            onClicked: root.retryMoving()
        }

        BaseDialogButton {
            text: qsTr("Cancel") + App.loc.emptyString
            onClicked: root.abortMoving()
        }
    }

    onClosed: {
        downloadId = -1;
        errorMessage = "";
    }

    onRejected: {
        abortMoving();
    }

    function abortMoving()
    {
        App.downloads.moveFilesMgr.abortMove(downloadId);
        root.close();
    }

    function retryMoving()
    {
        App.downloads.moveFilesMgr.retryFailedMove(downloadId);
        root.close();
    }

    function movingFailedAction(id, error)
    {
        root.downloadId = id;
        root.errorMessage = error;
        root.open();
    }
}
