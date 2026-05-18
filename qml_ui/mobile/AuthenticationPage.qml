import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
//import QtQuick.Controls.Material
import "../common/Tools"
import "BaseElements"
import "BaseElements/V2"
import "SettingsPage"

BasePage {
    id: root

    property string pageName: "AuthenticationPage"
    property var request: null
    property bool rememberStatus: false

    title: qsTr("Authentication required") + App.loc.emptyString

    v1_okButtonVisible: true
    v1_okButtonEnabled: usernameField.displayText
    onV1_okButtonClicked: accept()
    goBackHandler: () => downloadTools.rejectAuth()

    BaseLabel
    {
        text: downloadTools.authProxyText
        wrapMode: Text.Wrap
        Layout.fillWidth: true
        horizontalAlignment: Text.AlignLeft
        font: uicore.buildFont({}, uicore.fontSizeV1(16*appWindow.fontZoom))
    }

    BaseLabel
    {
        visible: downloadTools.authRealm.length > 0
        text: qsTr("The site says: \"%1\".").arg(downloadTools.authRealm) + App.loc.emptyString
        wrapMode: Text.Wrap
        Layout.fillWidth: true
        horizontalAlignment: Text.AlignLeft
        font: uicore.buildFont({}, uicore.fontSizeV1(16*appWindow.fontZoom))
    }

    ColumnLayout
    {
        spacing: 5*appWindow.zoom

        BasePageLabel
        {
            text: qsTr("Username") + App.loc.emptyString
            horizontalAlignment: Text.AlignLeft
            font: uicore.buildFont({}, uicore.fontSizeV1(16*appWindow.fontZoom))
        }

        BaseTextField
        {
            id: usernameField
            Layout.fillWidth: true
            selectByMouse: true
            onAccepted: accept()
            focus: true
            inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
            horizontalAlignment: Text.AlignLeft
        }
    }

    ColumnLayout
    {
        spacing: 5*appWindow.zoom

        BasePageLabel
        {
            text: qsTr("Password") + App.loc.emptyString
            horizontalAlignment: Text.AlignLeft
            font: uicore.buildFont({}, uicore.fontSizeV1(16*appWindow.fontZoom))
        }

        BaseTextField
        {
            id: passField
            Layout.fillWidth: true
            selectByMouse: true
            onAccepted: accept()
            focus: true
            inputMethodHints: Qt.ImhHiddenText
            echoMode: TextInput.Password
            passwordMaskDelay: 100
            horizontalAlignment: Text.AlignLeft
        }
    }

    SwitchSetting {
        id: rememberField
        textMargins: 0
        textHeighIncrement: 0
        settingsPageStyle: false
        description: qsTr("Remember") + App.loc.emptyString
        switchChecked: rememberStatus
        Layout.fillWidth: true
        anchors.left: undefined
        anchors.right: undefined
        onClicked: {
            rememberStatus = !rememberStatus
        }
    }

    DialogFlatButton_V2
    {
        visible: appWindow.uiver !== 1
        text: qsTr("OK") + App.loc.emptyString
        enabled: v1_okButtonEnabled
        primary: true
        onClicked: accept()
        Layout.fillWidth: true
        Layout.minimumHeight: 40*appWindow.zoom
    }

    Item {Layout.fillHeight: true}

    function accept() {
        downloadTools.doAuth(usernameField.text, passField.text, rememberField.switchChecked)
        stackView.pop();
    }

    Component.onCompleted: {
        downloadTools.buildAuthenticationDialog(request);
    }

    BuildDownloadTools {
        id: downloadTools
        onReject: {
            stackView.pop();
        }
    }
}
