import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.abstractdownloadsui 
import org.freedownloadmanager.fdm.dmcoresettings
import org.freedownloadmanager.fdm.appconstants
import "../BaseElements"

CenteredDialog {
    id: root

    property int downloadId
    property int fileIndex
    property var files: []

    property int timeout: AppConstants.FileExistsActionTimeout
    property int countdown: root.timeout

    closePolicy: Popup.NoAutoClose

    parent: Overlay.overlay

    modal: true

    title: qsTr("Warning: file exists already") + App.loc.emptyString

    ListView
    {
        clip: true
        Layout.fillWidth: true
        Layout.maximumWidth: ctMaxWidth
        Layout.preferredHeight: Math.min(contentHeight, 150)
        ScrollBar.vertical: ScrollBar {
            active: parent.contentHeight > 150
        }
        model: root.files
        BaseFontMetrics {id: fm}
        implicitWidth: {
            let result = 0;
            for (let i = 0; i < model.length; ++i)
                result = Math.max(result, fm.advanceWidth(model[i]));
            return result;
        }

        delegate: BaseLabel {
            id: lbl
            width: parent.width
            elide: Text.ElideMiddle
            text: modelData
        }
    }

    BaseCheckBox {
        id: remember
        text: qsTr("Remember my choice for all downloads") + App.loc.emptyString
        Layout.fillWidth: true
        Layout.maximumWidth: ctMaxWidth
        wrapMode: Text.WordWrap
    }

    BaseDialogButtonsLayout 
    {
        BaseDialogButton {
            text: qsTr("Rename (%1)").arg(root.countdown) + App.loc.emptyString
            primary: true
            onClicked: root.actionSelected(AbstractDownloadsUi.DfeaRename)
        }

        BaseDialogButton {
            text: qsTr("Overwrite") + App.loc.emptyString
            onClicked: root.actionSelected(AbstractDownloadsUi.DfeaOverwrite)
        }

        BaseDialogButton {
            text: qsTr("Abort") + App.loc.emptyString
            onClicked: root.actionSelected(AbstractDownloadsUi.DfeaAbort)
        }

        Timer {
            id: countdownTimer
            interval: 1000
            running: false
            repeat: true
            onTriggered: timerHandler()
        }
    }

    function timerHandler() {
        root.countdown--

        if (!root.countdown) {
            root.actionSelected(AbstractDownloadsUi.DfeaRename)
        }
    }

    onOpened: {
        forceActiveFocus();
        countdown = timeout;
        countdownTimer.restart();
    }

    onClosed: {
        downloadId = -1;
        fileIndex = -1;
        files = [];
    }

    function actionSelected(action) {
        countdownTimer.stop();
        if (remember.checked) {
            if (action === AbstractDownloadsUi.DfeaRename) {
                App.settings.dmcore.setValue(DmCoreSettings.ExistingFileReaction, AbstractDownloadsUi.DefrRename);
            } else if (action === AbstractDownloadsUi.DfeaOverwrite) {
                App.settings.dmcore.setValue(DmCoreSettings.ExistingFileReaction, AbstractDownloadsUi.DefrOverwrite);
            } else if (action === AbstractDownloadsUi.DfeaAbort) {
                App.settings.dmcore.setValue(DmCoreSettings.ExistingFileReaction, AbstractDownloadsUi.DefrAsk);
            }
        }
        App.downloads.filesExistsActionsMgr.submitAction(downloadId, fileIndex, action, true);
        root.close();
    }
}
