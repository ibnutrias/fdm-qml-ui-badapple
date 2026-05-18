import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material
import org.freedownloadmanager.fdm
import "../../mobile/BaseElements"
import "../../mobile/BaseElements/V2"
import "../../mobile/Dialogs"

BasePage {
    property var downloadIds

    title: App.my_BT_qsTranslate("AddTrackersPage", "Add trackers") + App.loc.emptyString

    v1_okButtonVisible: true
    v1_okButtonEnabled: trackers.text.trim()
    onV1_okButtonClicked: doOK()
    goBackHandler: cancel

    BaseTextArea
    {
        id: trackers
        Layout.fillWidth: true
        selectByMouse: true
        inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
        wrapMode: TextArea.Wrap
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

    Component.onCompleted: {
        trackers.text = uiSettingsTools.settings.btAddTString;
        trackers.selectAll();
        forceActiveFocus();
    }

    function doOK() {
        App.downloads.mgr.doCustomCommand(downloadIds, "addTrackers", trackers.text.trim());
        uiSettingsTools.settings.btAddTString = trackers.text.trim();
        stackView.pop();
    }

    function cancel() {
        if (!trackers.text.trim())
            uiSettingsTools.settings.btAddTString = "";
        stackView.pop();
    }
}
