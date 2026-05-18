import QtQuick
import QtQuick.Controls
import "../BaseElements"

Column {
    id: root

    property int trafficUsageMode
    property int maxDownloadSpeedSetting
    property string labelText

    BasePageLabel
    {
         text: root.labelText
         font: uicore.buildFont({}, (appWindow.uiver === 1 ? 16 : appWindow.theme_v2.fontSize)*appWindow.fontZoom)
         padding: 3
         anchors.left: parent.left
         horizontalAlignment: Text.AlignLeft
     }

    TumSettingTextField
    {
        id: tumSettingTextField
        mode: root.trafficUsageMode
        setting: root.maxDownloadSpeedSetting
        anchors.left: parent.left
    }

    function isValidTumSetting() {
        return tumSettingTextField.isValid(tumSettingTextField.displayText);
    }
}
