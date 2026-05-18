import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.dmcoresettings
import org.freedownloadmanager.fdm.appsettings
import org.freedownloadmanager.fdm.appfeatures
import "../BaseElements"
import "../../common"

Column {
    id: clmn
    anchors.left: parent.left
    anchors.right: parent.right
    topPadding: 7

    SwitchSetting {
        id: switchSetting3
        visible: App.features.hasFeature(AppFeatures.Updates)
        description: qsTr("Check for updates automatically") + App.loc.emptyString
        switchChecked: App.settings.toBool(App.settings.app.value(AppSettings.CheckUpdatesAutomatically))
        onClicked: {
            switchChecked = !switchChecked;
            App.settings.app.setValue(
                        AppSettings.CheckUpdatesAutomatically,
                        App.settings.fromBool(switchChecked));
        }
    }

    SettingsSeparator{
        visible: switchSetting3.visible
        x: appWindow.uiver === 1 ? 0 : appWindow.theme_v2.mainContentMargins*appWindow.zoom
        width: parent.width - 2*x
    }

    SwitchSetting {
        id: switchSetting4
        visible: App.features.hasFeature(AppFeatures.Updates)
        description: qsTr("Install updates automatically") + App.loc.emptyString
        switchChecked: App.settings.toBool(App.settings.app.value(AppSettings.InstallUpdatesAutomatically))
        onClicked: {
            switchChecked = !switchChecked;
            App.settings.app.setValue(
                        AppSettings.InstallUpdatesAutomatically,
                        App.settings.fromBool(switchChecked));
        }
    }

    SettingsSeparator{
        visible: switchSetting4.visible
        x: appWindow.uiver === 1 ? 0 : appWindow.theme_v2.mainContentMargins*appWindow.zoom
        width: parent.width - 2*x
    }

    SwitchSetting {
        id: switchSetting5
        description: qsTr("Use mobile network") + App.loc.emptyString
        visible: App.features.hasFeature(AppFeatures.AllowedNetworkTypesList)
        switchChecked: App.settings.toBool(App.settings.dmcore.value(DmCoreSettings.AllowToUseMobileNetworks))
        onClicked: {
            switchChecked = !switchChecked;
            App.settings.dmcore.setValue(
                        DmCoreSettings.AllowToUseMobileNetworks,
                        App.settings.fromBool(switchChecked));
        }
    }

    SwitchSetting {
        id: switchSetting6
        description: qsTr("Allow data roaming") + App.loc.emptyString
        fontWeight: appWindow.uiver === 1 ? Font.Normal : Font.Medium
        visible: App.features.hasFeature(AppFeatures.AllowedNetworkTypesList)
        switchChecked: App.settings.toBool(App.settings.dmcore.value(DmCoreSettings.AllowToUseRoamingNetworks))
        onClicked: {
            switchChecked = !switchChecked;
            App.settings.dmcore.setValue(
                        DmCoreSettings.AllowToUseRoamingNetworks,
                        App.settings.fromBool(switchChecked));
        }
    }

    BaseLabel {
        visible: App.features.hasFeature(AppFeatures.AllowedNetworkTypesList)
        text: qsTr("Using mobile data while roaming may result in additional charges.") + App.loc.emptyString
        leftPadding: qtbug.leftPadding(switchSetting6.textMargins + 5, 0)
        rightPadding: qtbug.rightPadding(switchSetting6.textMargins + 5, 0)
        bottomPadding: switchSetting6.padding + 3
        wrapMode: Text.WordWrap
        width: clmn.width - leftPadding
        font: uicore.buildFont({}, uicore.fontSizeV2Rel(-2)*appWindow.fontZoom)
    }

    Item {implicitHeight: 6*appWindow.zoom; implicitWidth: 1}

    ColumnLayout
    {
        anchors.left: parent.left
        anchors.leftMargin: switchSetting6.textMargins
        anchors.right: parent.right
        anchors.rightMargin: switchSetting6.textMargins

        RowLayout
        {
            Layout.fillWidth: true

            BasePageLabel {
                text: qsTr("Choose theme") + App.loc.emptyString
                font: uicore.buildFont({}, (appWindow.uiver === 1 ? 16 : appWindow.theme_v2.fontSize)*appWindow.fontZoom)
                Layout.fillWidth: true
                Layout.minimumWidth: Math.ceil(implicitWidth)
            }

            ThemeComboBox {
                id: themeCb
                Layout.preferredWidth: Math.max(themeCb.implicitWidth, uiStyleCb.implicitWidth)
            }
        }

        BasePageLabel {
            visible: uiSettingsTools.settings.theme === 'system'
            text: qsTr("A light theme will be used, if the system theme is unknown.") + App.loc.emptyString
            font: uicore.buildFont({}, uicore.fontSizeV2Rel(-2)*appWindow.fontZoom)
            Layout.fillWidth: true
            wrapMode: Label.WordWrap
        }
    }

    Item {implicitHeight: 14*appWindow.zoom; implicitWidth: 1}

    RowLayout
    {
        anchors.left: parent.left
        anchors.leftMargin: switchSetting6.textMargins
        anchors.right: parent.right
        anchors.rightMargin: switchSetting6.textMargins

        BasePageLabel {
            text: qsTr("UI style") + App.loc.emptyString
            font: uicore.buildFont({}, (appWindow.uiver === 1 ? 16 : appWindow.theme_v2.fontSize)*appWindow.fontZoom)
            Layout.fillWidth: true
            Layout.minimumWidth: Math.ceil(implicitWidth)
        }

        BaseComboBox {
            id: uiStyleCb
            Layout.preferredWidth: Math.max(themeCb.implicitWidth, implicitWidth)
            model: [
                {text: qsTr("New") + App.loc.emptyString, value: 2},
                {text: qsTr("Classic") + App.loc.emptyString, value: 1}
            ]
            currentIndex: {
                for (let i = 0; i < model.length; ++i) {
                    if (model[i].value === uiSettingsTools.settings.uiVersion)
                        return i;
                }
                return -1;
            }
            onActivated: (index) => {
                             uiSettingsTools.settings.showUiUpdatedBanner = false;
                             uiSettingsTools.settings.uiVersion = model[index].value;
                         }
        }
    }

    Item {implicitHeight: 14*appWindow.zoom; implicitWidth: 1}

    SettingsSeparator {
        visible: switchSetting5.visible
        x: appWindow.uiver === 1 ? 0 : appWindow.theme_v2.mainContentMargins*appWindow.zoom
        width: parent.width - 2*x
    }
}
