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

    title: qsTr("Change download URL") + App.loc.emptyString

    v1_okButtonVisible: true
    v1_okButtonEnabled: newUrl.displayText
    onV1_okButtonClicked: doOK()

    BasePageLabel
    {
        text: qsTr("Enter new URL") + App.loc.emptyString
    }

    BaseTextField
    {
        id: newUrl
        selectByMouse: true
        inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
        onAccepted: doOK()
        focus: true
        wrapMode: TextInput.WrapAnywhere
        Layout.fillWidth: true
        Layout.maximumHeight: appWindow.height/2
    }

    BaseLabel
    {
        visible: downloadModel.destinationPath
        text: qsTr("File location: %1").arg(downloadModel.destinationPath)
        Layout.fillWidth: true
        elide: Text.ElideMiddle
    }

    BaseCheckBox {
        id: startDownload
        text: qsTr("Start download") + App.loc.emptyString
        enabled: !downloadModel.running && !downloadModel.finished
        checked: true
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

    Component.onCompleted: {
        newUrl.text = downloadModel.resourceUrl;
        newUrl.select(newUrl.text.length, 0);
        newUrl.forceActiveFocus();
    }

    function doOK()
    {
        var user_input = newUrl.text.trim();
        var urlTools = App.tools.url(user_input)
        if (urlTools.correctUserInput()) {
            user_input = urlTools.url
        }
        App.downloads.infos.info(downloadModel.id).resourceUrl = user_input;
        if (startDownload.checked && !downloadModel.running && !downloadModel.finished) {
            App.downloads.mgr.startDownload(downloadModel.id, true);
        }
        stackView.pop();
    }
}
