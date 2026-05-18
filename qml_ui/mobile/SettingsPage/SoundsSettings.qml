import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import "../BaseElements"
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.appsettings
import org.freedownloadmanager.fdm.appnotificationevent

BaseSettingsPage {
    id: root

    title: qsTr("Sounds settings") + App.loc.emptyString

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
            topPadding: 7

            SwitchSetting {
                id: switchSetting1
                description: qsTr("Use sounds") + App.loc.emptyString
                switchChecked: App.settings.toBool(App.settings.app.value(AppSettings.EnableSoundNotifications))
                onClicked: {
                    switchChecked = !switchChecked;
                    App.settings.app.setValue(
                                AppSettings.EnableSoundNotifications,
                                App.settings.fromBool(switchChecked));
                }
            }

            Repeater {
                id: soundsList
                focus: true

                property int currentSetting: -1

                model: []

                delegate: RowLayout
                {
                    enabled: switchSetting1.switchChecked

                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: ((appWindow.uiver === 1 ? 20 : appWindow.theme_v2.mainContentMargins) +
                                         (appWindow.uiver === 1 ? 0 : 16))*appWindow.zoom
                    anchors.rightMargin: (appWindow.uiver === 1 ? 10 : 0)*appWindow.zoom

                    spacing: 15*appWindow.zoom

                    BasePageLabel {
                        text: modelData.text
                        font: uicore.buildFont({}, (appWindow.uiver === 1 ? 15 : appWindow.theme_v2.fontSize)*appWindow.fontZoom)
                        wrapMode: Text.WordWrap
                        horizontalAlignment: Text.AlignLeft
                        Layout.fillWidth: true
                        opacity: soundsList.enabled ? 1 : 0.5
                    }

                    ToolbarButton {
                        icon.source: Qt.resolvedUrl(appWindow.uiver === 1 ?
                                                        "../../images/mobile/music_note.svg" :
                                                        "V2/sound_on.svg")
                        icon.color: appWindow.uiver === 1 ?
                                        appWindow.theme.foreground :
                                        (enabled ? appWindow.theme_v2.primary : appWindow.theme_v2.textColor)

                        enabled: modelData.soundSource.toString()
                        onClicked: App.soundNotifMgr.playSound(modelData.setting)
                    }

                    ToolbarButton {
                        icon.source: Qt.resolvedUrl(appWindow.uiver === 1 ?
                                                        "../../images/mobile/music_off.svg" :
                                                        "V2/sound_off.svg")
                        icon.color: appWindow.uiver === 1 ?
                                        appWindow.theme.foreground :
                                        appWindow.theme_v2.textColor

                        enabled: modelData.soundSource.toString()
                        onClicked: {
                            soundsList.currentSetting = modelData.setting;
                            App.soundNotifMgr.setSoundSource(soundsList.currentSetting, '');
                            soundsList.reloadModel();
                        }
                    }

                    ToolbarButton {
                        icon.source: Qt.resolvedUrl(appWindow.uiver === 1 ?
                                                        "../../images/mobile/queue_music.svg" :
                                                        "V2/sound_browse.svg")
                        icon.color: appWindow.uiver === 1 ?
                                        appWindow.theme.foreground :
                                        appWindow.theme_v2.textColor

                        onClicked: {
                            soundsList.currentSetting = modelData.setting;
                            openFileDlg.open();
                        }
                    }
                }

                Component.onCompleted: soundsList.reloadModel()

                function reloadModel()
                {
                    soundsList.model = [
                                {
                                    text: qsTr("Downloads added"),
                                    setting: AppNotificationEvent.DownloadsAdded,
                                    soundSource: App.soundNotifMgr.soundSource(AppNotificationEvent.DownloadsAdded)
                                },
                                {
                                    text: qsTr("Downloads completed"),
                                    setting: AppNotificationEvent.DownloadsCompleted,
                                    soundSource: App.soundNotifMgr.soundSource(AppNotificationEvent.DownloadsCompleted)
                                },
                                {
                                    text: qsTr("Downloads failed"),
                                    setting: AppNotificationEvent.DownloadsFailed,
                                    soundSource: App.soundNotifMgr.soundSource(AppNotificationEvent.DownloadsFailed)
                                },
                                {
                                    text: qsTr("No active downloads"),
                                    setting: AppNotificationEvent.NoActiveDownloads,
                                    soundSource: App.soundNotifMgr.soundSource(AppNotificationEvent.NoActiveDownloads)
                                }
                            ];
                }
            }
        }
    }

    FileDialog
    {
        id: openFileDlg
        nameFilters: ["*"]
        fileMode: FileDialog.OpenFile
        flags: FileDialog.ReadOnly
        onAccepted: {
            App.soundNotifMgr.setSoundSource(soundsList.currentSetting, selectedFile);
            soundsList.reloadModel();
        }
    }

    Connections {
        target: App.loc
        onCurrentTranslationChanged: soundsList.reloadModel()
    }
}



