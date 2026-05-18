import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.dmcoresettings
import org.freedownloadmanager.fdm.appsettings
import org.freedownloadmanager.fdm.tum
import "../Dialogs"
import "../BaseElements"
import "../BaseElements/V2"
import "../V2"
import "../../common"

BaseSettingsPage
{
    id: root

    title: qsTr("Settings") + App.loc.emptyString
    isRoot: true

    Flickable
    {
        anchors.fill: parent

        flickableDirection: Flickable.VerticalFlick
        ScrollIndicator.vertical: ScrollIndicator { }
        boundsBehavior: Flickable.StopAtBounds

        contentWidth: width
        contentHeight: all.height

        clip: true

        ColumnLayout
        {
            id: all
            spacing: 0
            width: parent.width

            //General settings
            GeneralSettings {
                Layout.fillWidth: true
            }
            Item {implicitHeight: 7; implicitWidth: 1}

            Rectangle {
                id: contentColumnRect
                Layout.fillWidth: true
                Layout.preferredHeight: contentColumn.height
                color: appWindow.uiver === 1 ?
                           appWindow.theme.background :
                           appWindow.theme_v2.bgColor
                radius: (appWindow.uiver === 1 ? 26 : 16)*appWindow.zoom

                Column {
                    id: contentColumn

                    anchors.left: parent.left
                    anchors.right: parent.right

                    GeneralSettings2 {}

                    //Downloads settings
                    SettingsItem {
                        visible: appWindow.hasDownloadMgr
                        description: qsTr("Downloads settings") + App.loc.emptyString
                        onClicked: stackView.waPush(Qt.resolvedUrl("DownloadsSettings.qml"))
                        textWeight: appWindow.uiver === 1 ? Font.Bold : Font.Normal
                    }

                    SettingsSeparator{
                        visible: appWindow.hasDownloadMgr
                        x: appWindow.uiver === 1 ? 0 : appWindow.theme_v2.mainContentMargins*appWindow.zoom
                        width: parent.width - 2*x
                    }

                    //Proxy settings
                    SettingsItem {
                        description: qsTr("Network settings") + App.loc.emptyString
                        onClicked: stackView.waPush(Qt.resolvedUrl("NetworkSettings.qml"))
                        textWeight: appWindow.uiver === 1 ? Font.Bold : Font.Normal
                    }

                    SettingsSeparator{
                        x: appWindow.uiver === 1 ? 0 : appWindow.theme_v2.mainContentMargins*appWindow.zoom
                        width: parent.width - 2*x
                    }

                    //Traffic settings
                    SettingsItem {
                        visible: appWindow.hasDownloadMgr
                        description: qsTr("Traffic limits") + App.loc.emptyString
                        onClicked: stackView.waPush(Qt.resolvedUrl("TrafficLimitsSettings.qml"))
                        textWeight: appWindow.uiver === 1 ? Font.Bold : Font.Normal
                    }

                    SettingsSeparator{
                        visible: appWindow.hasDownloadMgr
                        x: appWindow.uiver === 1 ? 0 : appWindow.theme_v2.mainContentMargins*appWindow.zoom
                        width: parent.width - 2*x
                    }

                    SettingsItem {
                        visible: appWindow.hasDownloadMgr
                        description: qsTr("Sounds settings") + App.loc.emptyString
                        onClicked: stackView.waPush(Qt.resolvedUrl("SoundsSettings.qml"))
                        textWeight: appWindow.uiver === 1 ? Font.Bold : Font.Normal
                    }

                    SettingsSeparator{
                        visible: appWindow.hasDownloadMgr
                        x: appWindow.uiver === 1 ? 0 : appWindow.theme_v2.mainContentMargins*appWindow.zoom
                        width: parent.width - 2*x
                    }

                    SettingsItem {
                        visible: appWindow.btSupported
                        description: appWindow.btSupported ? appWindow.btS.settingsTitle : ""
                        onClicked: stackView.waPush(Qt.resolvedUrl("../../bt/mobile/BtSettings.qml"))
                        textWeight: appWindow.uiver === 1 ? Font.Bold : Font.Normal
                    }

                    SettingsSeparator {
                        visible: appWindow.btSupported
                        x: appWindow.uiver === 1 ? 0 : appWindow.theme_v2.mainContentMargins*appWindow.zoom
                        width: parent.width - 2*x
                    }

                    SettingsItem {
                        description: qsTr("Remote control settings") + App.loc.emptyString
                        onClicked: stackView.waPush(Qt.resolvedUrl("RemoteControlSettings.qml"))
                        textWeight: appWindow.uiver === 1 ? Font.Bold : Font.Normal
                    }

                    SettingsSeparator{
                        x: appWindow.uiver === 1 ? 0 : appWindow.theme_v2.mainContentMargins*appWindow.zoom
                        width: parent.width - 2*x
                    }

                    SettingsItem {
                        description: qsTr("Advanced settings") + App.loc.emptyString
                        onClicked: stackView.waPush(Qt.resolvedUrl("AdvancedSettings.qml"))
                        textWeight: appWindow.uiver === 1 ? Font.Bold : Font.Normal
                    }

                    SettingsSeparator{
                        visible: uiSettingsTools.settings.showTroubleshootingUi
                        x: appWindow.uiver === 1 ? 0 : appWindow.theme_v2.mainContentMargins*appWindow.zoom
                        width: parent.width - 2*x
                    }
                    SettingsItem {
                        visible: uiSettingsTools.settings.showTroubleshootingUi
                        description: qsTr("Troubleshooting") + App.loc.emptyString
                        onClicked: stackView.waPush(Qt.resolvedUrl("TroubleshootingSettings.qml"))
                        textWeight: appWindow.uiver === 1 ? Font.Bold : Font.Normal
                    }

                    SettingsSeparator{
                        visible: appWindow.uiver !== 1
                        x: appWindow.uiver === 1 ? 0 : appWindow.theme_v2.mainContentMargins*appWindow.zoom
                        width: parent.width - 2*x
                    }
                }
            }

            DialogButton_V1
            {
                visible: appWindow.uiver === 1
                Layout.leftMargin: qtbug.leftMargin(10*appWindow.zoom, 0)
                Layout.rightMargin: qtbug.rightMargin(10*appWindow.zoom, 0)
                enabled: App.settings.hasNonDefaultValues || uiSettingsTools.hasNonDefaultValues
                text: qsTr("Reset settings") + App.loc.emptyString
                onClicked: okToResetMsg.open()
            }

            BasePageLabel
            {
                enabled: App.settings.hasNonDefaultValues || uiSettingsTools.hasNonDefaultValues
                visible: appWindow.uiver !== 1
                text: qsTr("Reset settings") + App.loc.emptyString
                font: uicore.buildFont({}, (appWindow.theme_v2.fontSize+1)*appWindow.fontZoom)
                Layout.topMargin: 15*appWindow.zoom
                Layout.bottomMargin: 25*appWindow.zoom
                Layout.leftMargin: appWindow.theme_v2.mainContentMargins*appWindow.zoom
                MouseArea {
                    anchors.fill: parent
                    onClicked: okToResetMsg.open()
                }
            }
        }
    }

    AppMessageDialog
    {
        id: okToResetMsg
        title: qsTr("Default settings") + App.loc.emptyString
        text: qsTr("Restore default settings?") + App.loc.emptyString
        hasCancelButton: true
        onOkClicked: {
            App.settings.resetToDefaults();
            uiSettingsTools.resetToDefaults();
            stackView.pop();
            stackView.waPush(Qt.resolvedUrl("SettingsPage.qml"));
        }
    }
}
