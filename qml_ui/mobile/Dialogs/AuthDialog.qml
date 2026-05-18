import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import "../BaseElements"

CenteredDialog {
    id: root

    property string remoteName
    property string realm
    property bool passwordOnly: false
    property alias user: usernameField.text
    property alias password: passField.text
    property alias save: rememberField.checked

    parent: Overlay.overlay

    title: qsTr("Authentication required") + App.loc.emptyString

    BaseLabel
    {
        visible: remoteName
        Layout.fillWidth: true
        text: qsTr("%1 requires authentication").arg(remoteName) + App.loc.emptyString
        wrapMode: Text.Wrap
        font: uicore.buildFont({}, uicore.fontSizeV1(16*appWindow.fontZoom))
    }

    BaseLabel
    {
        visible: realm
        Layout.fillWidth: true
        text: qsTr("The site says: \"%1\".").arg(realm) + App.loc.emptyString
        wrapMode: Text.Wrap
        font: uicore.buildFont({}, uicore.fontSizeV1(16*appWindow.fontZoom))
    }

    GridLayout
    {
        columns: 2
        columnSpacing: 10*appWindow.zoom
        rowSpacing: columnSpacing

        BaseLabel
        {
            visible: !passwordOnly
            text: qsTr("Username:") + App.loc.emptyString
            font: uicore.buildFont({}, uicore.fontSizeV1(16*appWindow.fontZoom))
        }

        BaseTextField
        {
            id: usernameField
            visible: !passwordOnly
            focus: !passwordOnly
            Layout.preferredWidth: 400
            onAccepted: {
                if (text)
                    root.accept()
            }
            Keys.onEscapePressed: root.reject()
            inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
            enable_QTBUG_110471_workaround_2: true
        }

        BaseLabel
        {
            id: password
            text: qsTr("Password:") + App.loc.emptyString
            font: uicore.buildFont({}, uicore.fontSizeV1(16*appWindow.fontZoom))
        }

        BaseTextField
        {
            id: passField
            focus: passwordOnly
            inputMethodHints: Qt.ImhHiddenText | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
            echoMode: TextInput.Password
            passwordMaskDelay: 100
            Layout.fillWidth: true
            enable_QTBUG_110471_workaround_2: true
            onAccepted: {
                if (text)
                    root.accept()
            }
            Keys.onEscapePressed: root.reject()
        }
    }

    BaseCheckBox
    {
        id: rememberField
        text: qsTr("remember") + App.loc.emptyString
        font: uicore.buildFont({capitalization: Font.Capitalize}, uicore.fontSizeV1(16*appWindow.fontZoom))
    }

    BaseDialogButtonsLayout
    {
        BaseDialogButton
        {
            text: qsTr("Cancel") + App.loc.emptyString
            onClicked: root.reject()
        }

        BaseDialogButton
        {
            text: qsTr("OK") + App.loc.emptyString
            primary: true
            onClicked: root.accept()
        }
    }
}
