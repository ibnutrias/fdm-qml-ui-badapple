import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.appsettings
import org.freedownloadmanager.fdm.appfeatures
import org.freedownloadmanager.fdm.dmcoresettings
import "../BaseElements"

BaseSettingsPage {
    id: root

    readonly property int myMargins: (appWindow.uiver === 1 ? 20 : appWindow.theme_v2.mainContentMargins)*appWindow.zoom

    title: qsTr("Advanced settings") + App.loc.emptyString

    Flickable
    {
        anchors.fill: parent
        flickableDirection: Flickable.VerticalFlick
        ScrollIndicator.vertical: ScrollIndicator { }
        boundsBehavior: Flickable.StopAtBounds

        contentHeight: contentColumn.height

        clip: true

        Column {
            id: contentColumn
            anchors.left: parent.left
            anchors.right: parent.right
            topPadding: appWindow.theme_v2.mainContentMargins*appWindow.zoom
            spacing: (appWindow.uiver === 1 ? 10 : 16)*appWindow.zoom

            component VNLayout : GridLayout {
                anchors.left: parent.left

                rowSpacing: parent.spacing
                columnSpacing: 16*appWindow.zoom

                rows: appWindow.uiver === 1 ? 100 : 1
                columns: appWindow.uiver === 1 ? 1 : 100
            }

            VNLayout
            {
                visible: appWindow.uiver !== 1

                anchors.left: parent.left
                anchors.leftMargin: myMargins

                BasePageLabel {
                    text: qsTr("Fonts zoom") + App.loc.emptyString
                    font: uicore.buildFont({}, (appWindow.uiver === 1 ? 16 : appWindow.theme_v2.fontSize)*appWindow.fontZoom)
                }

                BaseComboBox {
                    model: [
                        {text: "70%", value: 0.7},
                        {text: "80%", value: 0.8},
                        {text: "90%", value: 0.9},
                        {text: "100%", value: 1.0},
                        {text: "110%", value: 1.1},
                        {text: "120%", value: 1.2},
                        {text: "130%", value: 1.3},
                        {text: "140%", value: 1.4}
                    ]
                    currentIndex: {
                        let z2 = uiSettingsTools.settings.scheduledZoom2 ?
                                uiSettingsTools.settings.scheduledZoom2 :
                                uiSettingsTools.zoom2;
                        for (let i = 0; i < model.length; ++i) {
                            if (model[i].value === z2)
                                return i;
                        }
                        return 0;
                    }
                    onActivated: (index) => uiSettingsTools.settings.zoom2 = model[index].value //uiSettingsTools.settings.scheduledZoom2 = model[index].value
                }
            }

            SwitchSetting {
                id: switchSetting1
                textHeighIncrement: 0
                description: qsTr("Launch at startup (minimized)") + App.loc.emptyString
                visible: App.features.hasFeature(AppFeatures.Autorun)
                switchChecked: App.autorunEnabled()
                onClicked: {
                    switchChecked = !switchChecked;
                    App.enableAutorun(switchChecked);
                }
            }

            SettingsSeparator{
                visible: switchSetting1.visible && appWindow.uiver === 1
            }

            SwitchSetting {
                id: switchSetting3
                textHeighIncrement: 0
                description: qsTr("Do not share files when running on battery") + App.loc.emptyString
                visible: App.features.hasFeature(AppFeatures.Battery) && appWindow.hasDownloadMgr
                switchChecked: App.settings.toBool(App.settings.dmcore.value(DmCoreSettings.DisablePostFinishedTasksOnBattery))
                onClicked: {
                    switchChecked = !switchChecked;
                    App.settings.dmcore.setValue(
                                DmCoreSettings.DisablePostFinishedTasksOnBattery,
                                App.settings.fromBool(switchChecked));
                }
            }

            SettingsSeparator{
                visible: switchSetting3.visible && appWindow.uiver === 1
            }

            SwitchSetting {
                id: switchSetting4
                textHeighIncrement: 0
                description: qsTr("Do not allow downloads if battery level drops below") + App.loc.emptyString
                visible: App.features.hasFeature(AppFeatures.Battery) && appWindow.hasDownloadMgr
                switchChecked: App.settings.dmcore.value(DmCoreSettings.BatteryMinimumPowerLevelToRunDownloads) > 0
                onClicked: {
                    switchChecked = !switchChecked;
                    if (switchChecked) {
                        batteryCombo.saveBatteryMinimumPowerLevelToRunDownloads(batteryCombo.currentText);
                    } else {
                        batteryCombo.saveBatteryMinimumPowerLevelToRunDownloads(0);
                    }
                }
            }

            BatteryComboBox {
                id: batteryCombo
                visible: App.features.hasFeature(AppFeatures.Battery) && appWindow.hasDownloadMgr
                enabled: switchSetting4.switchChecked
                anchors.left: parent.left
                anchors.leftMargin: myMargins
                comboMinimumWidth: 100
            }

            SettingsSeparator{
                visible: switchSetting4.visible && appWindow.uiver === 1
            }

            SwitchSetting {
                id: switchSetting2
                textHeighIncrement: 0
                visible: appWindow.hasDownloadMgr
                description: qsTr("Backup the list of downloads every") + App.loc.emptyString
                switchChecked: App.settings.dbBackupMinInterval() != -1
                onClicked: {
                    switchChecked = !switchChecked;
                    if (switchChecked) {
                        App.settings.setDbBackupMinInterval(backupCombo.model[backupCombo.currentIndex].value);
                    } else {
                        App.settings.setDbBackupMinInterval(-1);
                    }
                }
            }

            BackupSlider {
                id: backupSlider
                visible: false
            }

            BaseComboBox
            {
                id: backupCombo

                visible: switchSetting2.visible
                enabled: switchSetting2.switchChecked

                anchors.left: parent.left
                anchors.leftMargin: myMargins

                model: backupSlider.model

                onActivated: (index) => App.settings.setDbBackupMinInterval(model[index].value)

                Component.onCompleted: applyCurrentValueToCombo()

                function applyCurrentValueToCombo()
                {
                    let cv = App.settings.dbBackupMinInterval();
                    let index = model.findIndex(e => e.value === cv);
                    currentIndex = index === -1 ? 3 : index;
                }
            }

            SettingsSeparator{
                visible: switchSetting2.visible && appWindow.uiver === 1
            }

            BasePageLabel {
                id: fileExistsReactionLabel
                visible: appWindow.hasDownloadMgr
                text: qsTr("File exists reaction") + App.loc.emptyString
                font: uicore.buildFont({}, (appWindow.uiver === 1 ? 16 : appWindow.theme_v2.fontSize)*appWindow.fontZoom)
                leftPadding: qtbug.leftPadding(myMargins, 0)
                rightPadding: qtbug.rightPadding(myMargins, 0)
                anchors.left: parent.left
                horizontalAlignment: Text.AlignLeft
            }

            ExistingFileReactionCombobox {
                visible: fileExistsReactionLabel.visible
                anchors.left: parent.left
                anchors.leftMargin: myMargins
            }

            SettingsSeparator{
                visible: fileExistsReactionLabel.visible && appWindow.uiver === 1
            }

            SwitchSetting {
                textHeighIncrement: 0
                description: qsTr("Enable logging") + " (" + qsTr("Restart is required") + ")" + App.loc.emptyString
                visible: App.features.hasFeature(AppFeatures.Autorun)
                switchChecked: !App.isLogDisabled()
                onClicked: {
                    switchChecked = !switchChecked;
                    App.setLogDisabled(!switchChecked)
                }
            }

            Item {implicitHeight: 1; implicitWidth: 1}
        }
    }
}



