import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import "BaseElements"
import "Dialogs"

BasePage {

    property string pageName: "WaitingPage"

    title: qsTr("Loading") + (App.asyncLoadMgr.remoteName ?
                                  " (" + qsTr("Connection to %1").arg(App.asyncLoadMgr.remoteName) + ")" + App.loc.emptyString :
                                  "")

    backButtonVisible: false

    Item {Layout.fillHeight: true}

    BaseLabel
    {
        visible: App.asyncLoadMgr.status

        text: App.asyncLoadMgr.status +
              (App.asyncLoadMgr.error ? " " + qsTr("Error: %1").arg(App.asyncLoadMgr.error) : "") +
              App.loc.emptyString

        Layout.fillWidth: true
        wrapMode: Text.WordWrap
        horizontalAlignment: lineCount === 1 ? Text.AlignHCenter : Text.AlignLeft
    }

    RowLayout
    {
        visible: !App.asyncLoadMgr.loading
        spacing: 10*appWindow.zoom
        Layout.alignment: Qt.AlignHCenter

        DialogButton
        {
            visible: App.asyncLoadMgr.canUserRetryLoad
            text: qsTr("Retry") + App.loc.emptyString
            onClicked: App.asyncLoadMgr.retryLoad()
        }

        DialogButton
        {
            visible: App.asyncLoadMgr.canUserCancelLoad
            text: qsTr("Cancel") + App.loc.emptyString
            onClicked: App.asyncLoadMgr.cancelLoad()
        }
    }

    DialogButton
    {
        visible: App.asyncLoadMgr.loading && App.asyncLoadMgr.canUserCancelLoad
        text: qsTr("Abort") + App.loc.emptyString
        onClicked: App.asyncLoadMgr.cancelLoad()
        Layout.alignment: Qt.AlignHCenter
    }

    Item {Layout.fillHeight: true}

    AuthDialog
    {
        id: authDlg
        remoteName: App.asyncLoadMgr.remoteName
        passwordOnly: true
        onAccepted: App.asyncLoadMgr.authorize(password, save)
        onRejected: App.asyncLoadMgr.cancelLoad()
    }

    Connections
    {
        target: App.asyncLoadMgr
        onUnauthorized: {
            authDlg.open();
            authDlg.forceActiveFocus();
        }
    }
}
