import QtQuick
import QtQuick.Controls
import "../BaseElements"

Column {
    id: root

    property string comboBoxText
    property int speedLimitMode
    property int speedLimitSetting

    BasePageLabel
    {
        text: root.comboBoxText
        font: uicore.buildFont({}, (appWindow.uiver === 1 ? 16 : appWindow.theme_v2.fontSize)*appWindow.fontZoom)
        padding: 3
        anchors.left: parent.left
        horizontalAlignment: Text.AlignLeft
    }

    TumMaxURatioComboBox
    {
        mode: root.speedLimitMode
        setting: speedLimitSetting
        anchors.left: parent.left
    }
}
