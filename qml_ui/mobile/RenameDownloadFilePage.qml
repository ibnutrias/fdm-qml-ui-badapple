import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material
import org.freedownloadmanager.fdm
import "BaseElements"
import "BaseElements/V2"
import "../common/Tools"

BasePage
{
    id: root

    property double downloadId: 0
    property int fileIndex: 0

    title: qsTr("Rename file") + App.loc.emptyString

    v1_okButtonVisible: true
    v1_okButtonEnabled: !tools.renaming && (tools.canBeRenamed || !tools.hasChanges)
    onV1_okButtonClicked: tools.doOK()

    RenameDownloadFileTools {
        id: tools
        newNameField: newNameField
        onFinished: stackView.pop()
    }

    Component.onCompleted: {
        tools.initialize(root.downloadId, root.fileIndex);
        newNameField.forceActiveFocus();
    }

    BasePageLabel {
        text: qsTr("Enter new name") + ':' + App.loc.emptyString
    }

    BaseTextField {
        id: newNameField
        selectByMouse: true
        inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
        focus: true
        Layout.fillWidth: true
    }

    BaseLabel
    {
        visible: tools.alreadyExistsError
        text: qsTr("A file with that name already exists.") + App.loc.emptyString
        color: appWindow.uiver === 1 ?
                   appWindow.theme.errorMessage :
                   appWindow.theme_v2.danger
    }

    BaseLabel
    {
        visible: tools.error
        text: tools.error
        color: appWindow.uiver === 1 ?
                   appWindow.theme.errorMessage :
                   appWindow.theme_v2.danger
    }

    DialogFlatButton_V2
    {
        visible: appWindow.uiver !== 1
        text: qsTr("OK") + App.loc.emptyString
        enabled: v1_okButtonEnabled
        primary: true
        onClicked: tools.doOK()
        Layout.fillWidth: true
        Layout.minimumHeight: 40*appWindow.zoom
    }

    Item {Layout.fillHeight: true}
}
