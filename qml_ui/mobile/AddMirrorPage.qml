import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import QtQuick.Controls.Material
import "BaseElements"
import "BaseElements/V2"
import "../common/Tools"

BasePage {
    property var downloadModel

    title: qsTr("Add mirror") + App.loc.emptyString

    v1_okButtonVisible: true
    v1_okButtonEnabled: newUrl.displayText
    onV1_okButtonClicked: doOK()

    BasePageLabel {
        text: qsTr("Enter mirror URL") + App.loc.emptyString
    }

    BaseTextField {
        id: newUrl
        Layout.fillWidth: true
        selectByMouse: true
        inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
        onAccepted: doOK()
        focus: true
    }

    DialogFlatButton_V2
    {
        visible: appWindow.uiver !== 1
        text: qsTr("OK") + App.loc.emptyString
        enabled: v1_okButtonEnabled
        primary: true
        onClicked: doOK()
        Layout.fillWidth: true
        Layout.minimumHeight: 40*appWindow.zoom
    }

    Item {Layout.fillHeight: true}

    Component.onCompleted: forceActiveFocus()

    function doOK()
    {
        var user_input = newUrl.text.trim();
        var urlTools = App.tools.url(user_input)
        if (urlTools.correctUserInput()) {
            user_input = urlTools.url
        }

        App.downloads.infos.info(downloadModel.id).addMirrorUrl(user_input);

        stackView.pop();
    }
}
