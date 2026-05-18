import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import QtQuick.Controls.Material
import "../../common"
import "../BaseElements"

CenteredDialog
{
    id: root

    modal: true

    parent: Overlay.overlay

    property int failedId

    BaseLabel
    {
        text: qsTr("A bug report will be sent to the server and used to improve %1 performance. We do not collect your personal data and do not share data with third parties.").arg(App.shortDisplayName) + App.loc.emptyString
        Layout.fillWidth: true
        Layout.maximumWidth: Math.min(ctMaxWidth, 500*appWindow.zoom)
        wrapMode: Label.WordWrap
        horizontalAlignment: Text.AlignLeft
        font: uicore.buildFont({}, uicore.fontSizeV1(16*appWindow.fontZoom))
    }

    BaseCheckBox {
        id: agree
        text: qsTr("I agree (do not show it again)") + App.loc.emptyString
        Layout.fillWidth: true
        Layout.maximumWidth: ctMaxWidth
        wrapMode: Text.WordWrap
    }

    BaseDialogButtonsLayout 
    {
        BaseDialogButton {
            text: qsTr("Send report") + App.loc.emptyString
            primary: true
            onClicked: root.accept()
            enabled: agree.checked
        }

        BaseDialogButton {
            text: qsTr("Cancel") + App.loc.emptyString
            onClicked: root.reject()
        }
    }

    onOpened: forceActiveFocus()
    onClosed: {
        failedId = -1;
    }

    function showDialog(id) {
        failedId = id;
        open();
    }

    function accept() {
        uiSettingsTools.settings.reportProblemAccept = true;
        App.downloads.errorsReportsMgr.reportError(failedId);
        appWindow.reportError(failedId);
        close();
    }

    function reject() {
        close();
    }
}
