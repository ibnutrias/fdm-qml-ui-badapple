import QtQuick
import QtQml.Models
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.appfeatures

Item
{
    id: root

    readonly property var model: ListModel
    {
        readonly property var actions: {
            "startAllDownloadsWithPostFinishedTasks": function(){ App.downloads.mgr.startAllDownloadsWithPostFinishedTasks();},
            "stopAllDownloadsWithPostFinishedTasks": function(){ App.downloads.mgr.stopAllDownloadsWithPostFinishedTasks();},
            "browser": function(){ root.browserBtnClicked()},
            "settings": function(){ appWindow.openSettings() },
            "support": function(){ Qt.openUrlExternally('https://www.freedownloadmanager.org/support.htm?origin=menu&' + App.serverCommonGetParameters); },
            "bugReport": function() {appWindow.openSubmitBugReportUi();},
            "connectToRemoteApp": function() {connectToRemoteAppDlg.open();},
            "disconnectFromRemoteApp": function() {App.rc.client.disconnectFromRemoteApp();},
            "donate": () => {App.donate.onDonateDialogAccepted();},
            "about": function(){ aboutDlg.open(); },
            "quit": function(){ App.quit(); },
            "selfTest": function(){ App.launchSelfTest(); }
        }

        function build()
        {
            // WARNING: QTBUG-96397. Qt.resolvedUrl must be called the last when defining item's properties

            clear();

            if (appWindow.btSupported &&
                    App.downloads.tracker.hasPostFinishedTasksDownloadsCount &&
                    appWindow.btS)
            {
                append({"text": appWindow.btS.startAllSeedingDownloadsUiText,
                       "actionLabel": "startAllDownloadsWithPostFinishedTasks",
                       "enabled": App.downloads.tracker.finishedHasDisabledPostFinishedTasks,
                       "externalLink": false,
                       "icon": imageUrl("play.svg")});
                append({"text": appWindow.btS.stopAllSeedingDownloadsUiText,
                        "actionLabel": "stopAllDownloadsWithPostFinishedTasks",
                        "enabled": App.downloads.tracker.finishedHasEnabledPostFinishedTasks,
                        "externalLink": false,
                        "icon": imageUrl("pause.svg")});
            }

            if (App.features.hasFeature(AppFeatures.BuiltinWebBrowser))
            {
                append({
                           "text": qsTr("Browser"),
                           "actionLabel": "browser",
                           "enabled": true,
                           "externalLink": false,
                           "icon": imageUrl("browser.svg")
                       });
            }

            if (appWindow.uiver === 1 && !App.rc.client.active)
                append({"text": qsTr("Settings"), "actionLabel": "settings", "enabled": true, "externalLink": false, "icon": Qt.resolvedUrl("../../images/mobile/settings.svg")});

            append({"text": qsTr("Contact support"), 'actionLabel': "support", "enabled": true, "externalLink": true, "icon": imageUrl("support.svg")});

            if (App.features.hasFeature(AppFeatures.SubmitBugReport))
                append({"text": qsTr("Submit a bug report"), 'actionLabel': "bugReport", "enabled": !App.bugReporter.sending, "externalLink": false, "icon": imageUrl("bug_report.svg")});

            if (App.features.hasFeature(AppFeatures.RemoteControlClient))
            {
                if (App.rc.client.active)
                    append({"text": qsTr("Disconnect from remote %1").arg(App.shortDisplayName), "actionLabel": "disconnectFromRemoteApp", "enabled": true, "externalLink": false, "icon": imageUrl("rc.svg")});
                else
                    append({"text": qsTr("Connect to remote %1").arg(App.shortDisplayName), "actionLabel": "connectToRemoteApp", "enabled": true, "externalLink": false, "icon": imageUrl("rc.svg")});
            }

            if (App.features.hasFeature(AppFeatures.Donate))
                append({"text": qsTr("Support development"), "actionLabel": "donate", "enabled": true, "externalLink": true, "icon": imageUrl("donate.svg")});

            append({"text": qsTr("About"), "actionLabel": "about", "enabled": true, "externalLink": false, "icon": imageUrl("about.svg")});

            append({"text": qsTr("Quit"), "actionLabel": "quit", "enabled": true, "externalLink": false, "icon": imageUrl("quit.svg")});

            if (App.isSelfTestAvail)
                append({"text": "Self Test", "actionLabel": "selfTest", "enabled": true, "externalLink": false, "icon": imageUrl("self_test.svg")});
        }
    }

    Component.onCompleted: model.build()

    function browserBtnClicked() {
        if (uiSettingsTools.settings.browserIntroShown) {
            appWindow.openBrowser();
        } else {
            uiSettingsTools.settings.browserIntroShown = true;
            browserIntroDlg.open();
        }
    }

    function imageUrl(name) {
        return Qt.resolvedUrl(appWindow.uiver === 1 ? "../../images/mobile/" + name : "../V2/MainMenu/" + name);
    }

    Connections
    {
        target: App
        onIsSelfTestAvailChanged: model.build()
    }

    Connections
    {
        target: App.downloads.tracker
        onHasPostFinishedTasksDownloadsCountChanged: model.build()
        onFinishedHasDisabledPostFinishedTasksChanged: model.build()
        onFinishedHasEnabledPostFinishedTasksChanged: model.build()
    }

    Connections
    {
        target: App.loc
        onCurrentTranslationChanged: model.build()
    }

    Connections
    {
        target: appWindow
        onBtSChanged: model.build()
    }
}
