import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import "../../common/Tools"
import "../BaseElements"

CenteredDialog {
    id: root

    property string path

    parent: Overlay.overlay

    modal: true

    title: qsTr("Create folder") + App.loc.emptyString

    BaseTextField {
        id: folderName
        selectByMouse: true
        Layout.fillWidth: true
        Layout.maximumWidth: ctMaxWidth
        focus: true
        onAccepted: accept()
        inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
        enable_QTBUG_110471_workaround_2: true
    }

    BaseDialogButtonsLayout
    {
        BaseDialogButton
        {
            text: qsTr("OK") + App.loc.emptyString
            enabled: folderName.displayText.length > 0
            primary: true
            onClicked: accept()
        }

        BaseDialogButton
        {
            text: qsTr("Cancel") + App.loc.emptyString
            onClicked: root.close()
        }
    }

    function accept() {
        App.tools.createLocalFolder(path + '/' + folderName.displayText);
        root.close();
    }

    function openDialog(currentPath) {
        path = currentPath;
        folderName.text = "";
        root.open();
        folderName.forceActiveFocus()
    }
}
