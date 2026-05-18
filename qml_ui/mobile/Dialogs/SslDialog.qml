import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import "../../common/Tools"
import "../BaseElements"

CenteredDialog {
    id: root

    readonly property int maximumWidth: root.ctMaxWidth

    parent: Overlay.overlay

    modal: true

    title: qsTr("Security risk") + App.loc.emptyString

    BaseLabel {
        text: downloadTools.sslHost
        wrapMode: Text.Wrap
        Layout.fillWidth: true
        Layout.maximumWidth: root.maximumWidth
        horizontalAlignment: Text.AlignLeft
    }

    BaseLabel {
        text: downloadTools.sslHostIsUnknownErr ?
                  qsTr("The authenticity of the host can't be established.") + App.loc.emptyString :
                  qsTr("SSL Certificate is not valid.") + App.loc.emptyString
        color: appWindow.uiver === 1 ?
                   appWindow.theme.errorMessage :
                   appWindow.theme_v2.danger
        wrapMode: Text.Wrap
        Layout.fillWidth: true
        horizontalAlignment: Text.AlignLeft
    }

    BaseLabel {
        Layout.fillWidth: true
        text: downloadTools.sslHostIsUnknownErr ?
                  qsTr("%1 key fingerprints").arg(downloadTools.sslAlg) + App.loc.emptyString :
                  qsTr("Certificate fingerprints") + App.loc.emptyString
    }

    ColumnLayout {
        Layout.fillWidth: true
        spacing: 5*appWindow.zoom
        BaseLabel {
            text: qsTr("SHA-256:") + App.loc.emptyString
            wrapMode: Text.Wrap
        }
        BaseLabel {
            text: downloadTools.sslSha256Fingerprint
            wrapMode: Text.Wrap
            Layout.fillWidth: true
            Layout.maximumWidth: root.maximumWidth
        }
    }

    ColumnLayout {
        Layout.fillWidth: true
        spacing: 5*appWindow.zoom
        BaseLabel {
            text: qsTr("SHA1:") + App.loc.emptyString
            wrapMode: Text.Wrap
        }

        BaseLabel {
            text: downloadTools.sslSha1Fingerprint
            wrapMode: Text.Wrap
            Layout.fillWidth: true
            Layout.maximumWidth: root.maximumWidth
        }
    }

    BaseLabel {
        visible: downloadTools.sslHostIsUnknownErr
        Layout.fillWidth: true
        text: qsTr("If you trust this host, select Accept to remember the key and carry on connecting.") + App.loc.emptyString
        wrapMode: Text.Wrap
    }

    BaseDialogButtonsLayout 
    {
        BaseDialogButton {
            text: downloadTools.sslHostIsUnknownErr ?
                      qsTr("Accept") + App.loc.emptyString :
                      qsTr("Continue") + App.loc.emptyString
            onClicked: {
                downloadTools.acceptSsl();
                root.close();
            }
        }

        BaseDialogButton {
            text: qsTr("Cancel") + App.loc.emptyString
            primary: true
            onClicked: {
                downloadTools.rejectSsl();
                root.close();
            }
        }
    }

    onRejected: downloadTools.rejectSsl()

    BuildDownloadTools {
        id: downloadTools
        onReject: {
            stackView.pop();
        }
    }

    function newSslRequest(request)
    {
        downloadTools.buildSslDialog(request);
        root.open();
    }
}
