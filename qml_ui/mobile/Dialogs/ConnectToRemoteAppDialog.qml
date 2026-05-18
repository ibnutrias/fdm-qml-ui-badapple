import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import "../../common"
import "../BaseElements"

CenteredDialog
{
    id: root

    focus: true

    parent: Overlay.overlay

    readonly property string remoteId: idField.text.trim()

    modal: true

    title: qsTr("Connect to remote %1").arg(App.shortDisplayName) + App.loc.emptyString

    BaseLabel {
        text: qsTr("Here you can connect to %1 running on your Windows/macOS/Linux PC").arg(App.shortDisplayName) + App.loc.emptyString
        Layout.maximumWidth: root.ctMaxWidth
        Layout.fillWidth: true
        wrapMode: Text.WordWrap
        font: uicore.buildFont({}, uicore.fontSizeV1(16*appWindow.fontZoom))
    }

    BaseLabel {
        text: qsTr("Please enter %1, or <a href='#'>scan QR code</a>").arg("ID") + App.loc.emptyString
        Layout.maximumWidth: root.ctMaxWidth
        Layout.fillWidth: true
        wrapMode: Text.WordWrap
        onLinkActivated: App.scanQrCodeWithAppUrlCall()
        font: uicore.buildFont({}, uicore.fontSizeV1(16*appWindow.fontZoom))
    }

    BaseLabel {
        text: qsTr("Both %1 and QR code are located inside of Preferences page of %2 you're going to connect to.").arg("ID").arg(App.shortDisplayName) + App.loc.emptyString
        Layout.maximumWidth: root.ctMaxWidth
        Layout.fillWidth: true
        wrapMode: Text.WordWrap
        font: uicore.buildFont({}, uicore.fontSizeV1(16*appWindow.fontZoom))
    }

    RowLayout {
        spacing: parent.spacing

        Layout.maximumWidth: root.ctMaxWidth
        Layout.fillWidth: true

        BaseLabel {
            text: "ID:"
            horizontalAlignment: Text.AlignLeft
            font: uicore.buildFont({}, uicore.fontSizeV1(16*appWindow.fontZoom))
        }

        BaseTextField {
            id: idField
            text: uiSettingsTools.settings.lastRemoteAppId
            focus: true
            Layout.fillWidth: true

            enable_QTBUG_110471_workaround_2: true
            selectAllAtInit: true
            onAccepted: root.accept()
            Keys.onEscapePressed: root.close()
            inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
            onTextChanged: {
                var s = text.toUpperCase();
                if (text != s)
                    text = s;
            }
        }
    }

    BaseCheckBox {
        id: alwaysConnectOnAppStart
        text: qsTr("Automatically connect at %1 startup").arg(App.shortDisplayName) + App.loc.emptyString
        Layout.maximumWidth: root.ctMaxWidth
        wrapMode: Text.WordWrap
    }

    BaseDialogButtonsLayout
    {
        BaseDialogButton {
            text: qsTr("Cancel") + App.loc.emptyString
            onClicked: root.close()
        }

        BaseDialogButton {
            enabled: root.remoteId !== '' && root.remoteId !== App.rc.id
            text: qsTr("OK") + App.loc.emptyString
            primary: true
            onClicked: root.accept()
        }
    }

    onAboutToShow: {
        if (!idField.text)
            setRemoteId(uiSettingsTools.settings.lastRemoteAppId);
    }

    onOpened: {
        idField.selectAll();
        idField.forceActiveFocus();
    }

    onAccepted: {
        uiSettingsTools.settings.lastRemoteAppId = remoteId;
        App.rc.client.connectToRemoteApp(remoteId, alwaysConnectOnAppStart.checked);
    }

    function setRemoteId(remoteId)
    {
        idField.text = remoteId.toUpperCase();
    }
}
