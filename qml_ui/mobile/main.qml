import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Controls.Material
import "../common"
import "../common/Tools"
import "./Tools"
//import "../common/Tests"
import "FilePicker"
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.appfeatures
import org.freedownloadmanager.fdm.qtsystemtheme
import org.freedownloadmanager.fdm.dmcoresettings
import "./Themes"
import "./BaseElements"
import "./Dialogs"

ApplicationWindow
{
    id: appWindow

    property bool mobileVersion: true

    property alias uiver: uiSettingsTools.uiVersion

    readonly property bool smallScreen: width < 500
    readonly property bool verySmallScreen: width < 400

    property real screenWidthInches: width / ( Screen.pixelDensity * 25.4 )

    property bool showDownloadIcon: true
    property bool showDownloadCheckbox: false
    property bool showDownloadItemMenuBtn: true
//    property int checkedDownloadsCount: 0
    property bool selectMode: false
    property bool searchMode: false
    property bool btSupported: App.features.hasFeature(AppFeatures.BT)
    property bool hasDownloadMgr: App.features.hasFeature(AppFeatures.LocalDownloadManager) || App.rc.client.active
    property alias btS: btStrings.item

    signal newDownloadAdded
    signal uiReadyStateChanged
    signal appWindowStateChanged
    signal tumSettingsChanged
    signal openScheduler(double downloadId)
    signal stopDownload(var downloadIds)
    signal openBrowser
    signal startDownload
    signal reportError(double failedId)

    LayoutMirroring.enabled: App.loc.layoutDirection == Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    visible: true
    width: 360
    height: 640

    title: App.displayName

    readonly property double zoom: appWindow.uiver === 1 ? 1.0 : uiSettingsTools.zoom
    readonly property double zoom2: appWindow.uiver === 1 ? 1.0 : uiSettingsTools.zoom2
    readonly property double fontZoom: zoom*zoom2

    SystemPalette {id: sp; colorGroup: SystemPalette.Active}
    readonly property bool isSystemPaletteLight: sp.text.r < 0.2 && sp.text.g < 0.2 && sp.text.b < 0.2

    readonly property bool isSystemThemeDark: App.systemTheme == QtSystemTheme.Dark

    readonly property bool useDarkTheme: (uiSettingsTools.settings.theme === 'dark') ||
                                         (uiSettingsTools.settings.theme === 'system' && (isSystemThemeDark || !isSystemPaletteLight))

    DarkTheme {id: darkTheme}
    LightTheme {id: lightTheme}
    readonly property var theme: useDarkTheme ? darkTheme : lightTheme

    property var theme_v2: Theme_V2 {isLightTheme: !appWindow.useDarkTheme}

    Material.theme: Material.Light
    Material.background: uiver === 1 ? theme.background : theme_v2.bgColor
    Material.primary: uiver === 1 ? theme.primary : theme_v2.primary
    Material.foreground: uiver === 1 ? theme.foreground : theme_v2.textColor
    Material.accent: uiver === 1 ? theme.accent : theme_v2.primary

    Text {id: defaultText; visible: false}

    onOpenBrowser: App.launchBuiltInWebBrowser()

    UiReadyTools {
        id: uiReadyTools
        firstPageComponent: Component {
            DownloadsPage {}
        }
        waitingPageComponent: Component {
            WaitingPage {}
        }
    }

    background: Rectangle {
        color: appWindow.uiver === 1 ?
                   theme.primary :
                   (uicore.snailTools.isSnail ?
                        appWindow.theme_v2.appTitleBgColorInSnailMode :
                        theme_v2.appTitleBgColor)
        anchors.fill: parent
    }

    property bool forceShowDonateUi: false

    footer: MainWindowFooter {}

    WaStackView {
        id: stackView
        anchors.fill: parent
        onCurrentItemChanged: appWindowStateChanged()
    }

    UiSettingsTools {
        id: uiSettingsTools
    }

    Loader {
        id: aboutDlg
        active: false
        source: "Dialogs/AboutDialog.qml"
        anchors.centerIn: parent
        property bool opened: active && item.opened
        function open() {
            active = true;
            item.open();
        }
    }

    Loader {
        id: selfTestDlg
        active: App.isSelfTestMode
        source: "../desktop/Dialogs/SelfTestDialog.qml"
        anchors.centerIn: parent
        width: parent.width - 100
        height: parent.height - 200
        Component.onCompleted: {
            if (App.isSelfTestMode) {
                item.width = Qt.binding(()=>{return selfTestDlg.width;});
                item.height = Qt.binding(()=>{return selfTestDlg.height;});
                uiReadyTools.onReady(function(){selfTestDlg.item.open();});
            }
        }
    }

    Loader {
        id: btTools
        active: btSupported
        source: "../bt/Tools.qml"
    }

    Loader {
        id: btStrings
        active: btSupported
        source: "../bt/BtStrings.qml"
    }

    MovingFailedDialog {
        id: movingFailedDlg
    }

    Loader {
        id: privacyDlg
        source: "Dialogs/PrivacyDialog.qml"
        active: false
        anchors.centerIn: parent
        property bool opened: active && item.opened
        function open(failedId) {
            if (uiSettingsTools.settings.reportProblemAccept) {
                App.downloads.errorsReportsMgr.reportError(failedId);
                appWindow.reportError(failedId);
            } else {
                active = true;
                if (!item.opened) {
                    item.showDialog(failedId);
                }
            }
        }
    }

    Loader {
        id: quitConfDlg
        active: false
        source: "Dialogs/QuitConfirmationDialog.qml"
        anchors.centerIn: parent
        function open(message) {
            active = true;
            item.text = message;
            item.open();
        }
    }

    AppMessageDialog
    {
        id: reportSentDlg
        property string errorMessage
        text: (errorMessage.length > 0 ? qsTr("Sorry, the report hasn't been sent, an error occurred: %1").arg(errorMessage) : qsTr("The report has been sent. Thank you for your cooperation!")) + App.loc.emptyString
    }

    Connections
    {
        target: App.downloads.errorsReportsMgr
        onReportFinished: (downloadId, error) => {
            reportSentDlg.errorMessage = error.displayTextLong;
            reportSentDlg.open();
        }
    }

    FilePicker {
        id: filePicker
    }

    Connections {
        target: filePicker
        onFolderSelected: {
            if (initiator == 'fileMoving') {
                selectedDownloadsTools.moveCurrentDownloads(folderName)
            }
        }
    }

    onClosing: (close) => {
        if(stackView.depth > 1) {
            stackView.pop();
            close.accepted = false;
        } else if (selectMode || searchMode) {
            stackView.currentItem.state = "mainView"
            close.accepted = false;
        } else {
            close.accepted = true;
        }
    }

    onStopDownload: stopDownloadDlg.show(downloadIds)

    DownloadsInterceptionTools {
        id: interceptionTools
        onHasDownloadRequests: appWindow.onDownloadRequest(false)
        onNewDownloadRequests: appWindow.onDownloadRequest(true)
        onHasMergeRequests: appWindow.onMergeRequest(false)
        onNewMergeRequests: appWindow.onMergeRequest(true)
        onNewAuthenticationRequest: appWindow.onAuthenticationRequest()
        onNewSslRequest: onSslRequest()
        onHasMovingFailedDownloads: onMovingFailed(downloadId, error)
    }

    MergeDownloadsDialog {
        id: mergeDownloadsDlg
    }

    StopDownloadDialog {
        id: stopDownloadDlg
    }

    SslDialog {
        id: sslDlg
    }

    BrowserIntroDialog {
        id: browserIntroDlg
    }

    MobileDataUsageDialog {
        id: mobileDataUsageDlg
    }

    FileManagerSupportDialog {
        id: fileManagerSupportDlg
    }

    OsPermissionsDialog {
        id: osPermissionsDlg
    }

    SortTools {
        id: sortTools
    }

//    AddManyDownloads {
//        countAdd: 100
//    }

    ScreenTools {
        id: screenTools
    }

    AdaptiveTools {
        id: adaptiveTools
    }

    EnvTools {
        id: envTools
    }

    SelectedDownloadsTools {
        id: selectedDownloadsTools
    }

    DownloadsViewTools {
        id: downloadsViewTools
    }

    DownloadsWithMissingFilesTools {
        id: downloadsWithMissingFilesTools
    }

    TagsTools {
        id: tagsTools
    }

    Loader {
        active: uiver === 1
        source: Qt.resolvedUrl("VoteBlock.qml")
        anchors.fill: parent
    }

    function createDownloadDialog(uiNewDownloadRequest)
    {
        uiNewDownloadRequest = uiNewDownloadRequest || null;
        stackView.waPush(Qt.resolvedUrl("BuildDownloadPage.qml"), {downloadRequest: uiNewDownloadRequest});
    }

    function createAuthDialog(request)
    {
        stackView.waPush(Qt.resolvedUrl("AuthenticationPage.qml"), {request: request});
    }

    function createAddTDialog(ids)
    {
        if (btSupported) {
            stackView.waPush(Qt.resolvedUrl("../bt/mobile/AddTPage.qml"), {downloadIds: ids});
        }
    }

    function canShowCreateDownloadDialog(force)
    {
        if (stackView.depth === 0) {
            return false;
        }
        var page = stackView.get(0);
        var page_name = page.pageName;
        if (['WaitingPage'].indexOf(page_name) >= 0) {
            return false;
        }
        if (!(force && !mergeDownloadsDlg.opened)) {
            var current_page = stackView.currentItem;
            var current_page_name = current_page.pageName;
            if (['BuildDownloadPage', 'TuneAndAddDownloadPage', "AuthenticationPage.qml"].indexOf(current_page_name) >= 0 || mergeDownloadsDlg.opened) {
                return false;
            }
        }
        return true;
    }

    function canShowAuthDialog()
    {
        if (!App.rc.client.active)
        {
            if (stackView.depth === 0) {
                return false;
            }
            var page = stackView.get(0);
            var page_name = page.pageName;
            if (['WaitingPage'].indexOf(page_name) >= 0) {
                return false;
            }
        }

        var current_page = stackView.currentItem;
        var current_page_name = current_page.pageName;
        if (['AuthenticationPage'].indexOf(current_page_name) >= 0 || mergeDownloadsDlg.opened) {
            return false;
        }

        return true;
    }

    function canShowMergeDownloadsDialog(force)
    {
        if (stackView.depth === 0) {
            return false;
        }
        var page = stackView.get(0);
        var page_name = page.pageName;
        if (['WaitingPage'].indexOf(page_name) >= 0) {
            return false;
        }
        if (mergeDownloadsDlg.opened || sslDlg.opened) {
            return false;
        }
        return true;
    }

    function onDownloadRequest(force)
    {
        if (canShowCreateDownloadDialog(force)) {
            var uiNewDownloadRequest = interceptionTools.getDownloadRequest();
            if (uiNewDownloadRequest) {
                appWindow.createDownloadDialog(uiNewDownloadRequest);
            }
        }
    }

    function onMergeRequest(force)
    {
        if (canShowMergeDownloadsDialog(force)) {
            var mergeRequestId = interceptionTools.getMergeRequestId();
            if (mergeRequestId) {
                var existingRequestId = interceptionTools.getExistingRequestId(mergeRequestId);
                mergeDownloadsDlg.newMergeByRequest(mergeRequestId, existingRequestId);
            }
        }
    }

    function onAuthenticationRequest() {
        if (canShowAuthDialog()) {
            var request = interceptionTools.getAuthRequest();
            if (request) {
                appWindow.createAuthDialog(request);
            }
        }
    }

    function onSslRequest() {
        if (canShowMergeDownloadsDialog()) {
            var request = interceptionTools.getSslRequest();
            if (request) {
                sslDlg.newSslRequest(request);
            }
        }
    }

    function onMovingFailed(downloadId, error) {
        error = error !== '' ? error : getDownloadMovingError(downloadId);

        if (!movingFailedDlg.opened) {
            movingFailedDlg.movingFailedAction(downloadId, error);
        }
    }

    function getDownloadMovingError(downloadId) {
        return App.downloads.infos.info(downloadId).loError.displayTextShort;
    }

    Loader {
        id: remoteResourceChangedDlg
        active: false
        source: "Dialogs/RemoteResourceChangedDialog.qml"
        anchors.centerIn: parent
        property bool opened: active && item.opened
        function open(id) {
            active = true;
            item.remoteResourceChanged(id);
            if (!item.opened) {
                item.open();
            }
        }
    }

    Connections {
        target: App.downloads.tracker
        onRemoteResourceChanged: (id) => {
            if (!App.settings.toBool(App.settings.dmcore.value(DmCoreSettings.AutoRestartFinishedDownloadIfRemoteResourceChanged))) {
                remoteResourceChangedDlg.open(id);
            }
        }
    }

    Loader {
        id: filesExistsDlg
        active: false
        source: "Dialogs/FilesExistsDialog.qml"
        anchors.centerIn: parent
        property bool opened: active && item.opened
        function open(downloadId, fileIndex, files) {
            active = true;
            item.downloadId = downloadId;
            item.fileIndex = fileIndex;
            item.files = files;
            if (!item.opened) {
                item.open();
            }
        }
        function closeFor(downloadId, fileIndex) {
            if (item.opened && item.downloadId === downloadId && item.fileIndex === fileIndex)
                item.close();
        }
    }

    Connections {
        target: App.downloads.filesExistsActionsMgr
        onActionRequired: (downloadId, fileIndex, files) => {
            filesExistsDlg.open(downloadId, fileIndex, files);
        }
        onActionApplied: (downloadId, fileIndex) => {
            filesExistsDlg.closeFor(downloadId, fileIndex);
        }
    }

    Connections {
        target: App
        onShowQuitConfirmation: (message) => quitConfDlg.open(message)
    }

    Connections {
        target: appWindow
        onNewDownloadAdded: downloadsViewTools.resetAllFilters()
    }

    DownloadExpiredDialog {
        id: downloadExpiredDlg
        onClosed: {
            App.downloads.expiredDownloads.onExpiredDownloadNotificationFinished(downloadId);
            openDownloadExpiredDialogForNextDownload();
        }
    }
    function openDownloadExpiredDialog(downloadId)
    {
        downloadExpiredDlg.downloadId = downloadId;
        downloadExpiredDlg.open();
    }
    function openDownloadExpiredDialogForNextDownload()
    {
        if (!downloadExpiredDlg.opened &&
                App.downloads.expiredDownloads.hasNewExpiredDownloads)
        {
            openDownloadExpiredDialog(App.downloads.expiredDownloads.nextNewExpiredDownloadId());
        }
    }
    Connections {
        target: App.downloads.expiredDownloads
        onHasNewExpiredDownloadsChanged: openDownloadExpiredDialogForNextDownload()
        onNotExpiredAnymore: {
            if (downloadExpiredDlg.opened && downloadExpiredDlg.downloadId == id)
                downloadExpiredDlg.close();
        }
    }

    Loader {
        id: connectToRemoteAppDlg
        active: App.features.hasFeature(AppFeatures.RemoteControlClient)
        source: "Dialogs/ConnectToRemoteAppDialog.qml"
        anchors.centerIn: parent
        property bool opened: active && item.opened
        function open() {
            active = true;
            item.open();
        }
    }

    function openSubmitBugReportUi()
    {
        stackView.waPush(Qt.resolvedUrl("SubmitBugReportPage.qml"))
    }

    Connections
    {
        target: App.commands
        onShowConnectToRemoteAppUi: function(remoteId)
        {
            connectToRemoteAppDlg.item.setRemoteId(remoteId);
            if (!connectToRemoteAppDlg.opened)
                connectToRemoteAppDlg.open();
        }
    }

    QTBUG {
        id: qtbug
    }

    Component.onCompleted: {
        flags |= Qt.ExpandedClientAreaHint;
        uiReadyTools.onReady(function()
        {
            let r = App.downloads.filesExistsActionsMgr.pendingRequest();
            if (r)
                filesExistsDlg.open(r.downloadId, r.fileIndex, r.files);

            if (App.osPermissionsMgr && App.osPermissionsMgr.hasNonGrantedPermissions())
            {
                osPermissionsDlg.requiredPermissions = App.osPermissionsMgr.nonGrantedRequiredPermissions();
                if (osPermissionsDlg.requiredPermissions.length || !uiSettingsTools.settings.dontShowOsPermissionsDialog)
                {
                    osPermissionsDlg.optionalPermissions = App.osPermissionsMgr.nonGrantedOptionalPermissions();
                    osPermissionsDlg.open();
                }
            }
        });
    }

    UiCore {
        id: uicore
    }

    //////////////////////////////////////////////////////////////////////////////
    // QTBUG-139724 workaround
    //
    Item {
        id: appWindowInvalidateItem
    }

    Timer {
        id: appWindowInvalidateTimer
        interval: 50
        onTriggered: {
            ++appWindowInvalidateItem.width;
            --appWindowInvalidateItem.width;
        }
    }

    Connections {
        target: Qt.application
        onStateChanged: {
            if (Qt.application.state == Qt.ApplicationActive)
                appWindowInvalidateTimer.restart();
        }
    }
    //////////////////////////////////////////////////////////////////////////////

    Loader {
        id: mainMenuDrawer
        source: Qt.resolvedUrl(appWindow.uiver === 1 ? "LeftDrawer.qml" : "V2/MainMenu/MainMenuDrawer_V2.qml")
    }

    readonly property bool isDownloadsPageActive: stackView.depth === 1 &&
                                                  stackView.currentItem &&
                                                  stackView.currentItem.objectName === uicore.downloadsPageName
    readonly property bool isDownloadsPageSearchModeActive: isDownloadsPageActive &&
                                                  stackView.currentItem.isSearchModeActive
    readonly property bool isSettingsPageActive: stackView.currentItem &&
                                                 stackView.currentItem.objectName === uicore.settingsPageName

    function openSettings()
    {
        if (!isSettingsPageActive)
        {
            if (!isDownloadsPageActive)
            {
                if (!openDownloadsPage())
                    return false;
            }

            stackView.waPush(Qt.resolvedUrl("SettingsPage/SettingsPage.qml"))
        }

        return true;
    }

    function openDownloadsPage()
    {
        if (isSettingsPageActive && !stackView.currentItem.validateSettings())
            return false;

        if (!isDownloadsPageActive)
        {
            while (stackView.depth > 1)
                stackView.pop();
        }

        if (isDownloadsPageSearchModeActive)
            stackView.currentItem.closeSearchMode();


        return isDownloadsPageActive;
    }

    function openDownloadsPageSearchMode()
    {
        if (!openDownloadsPage())
            return false;

        return stackView.currentItem.openSearchMode();
    }

    onActiveFocusItemChanged: {
        if (activeFocusItem)
        {
            // A weird Qt bug workaround. It sets active focus to a hidden page
            for (let i = 0; i < stackView.depth - 1; ++i)
            {
                let item = activeFocusItem;
                let stackViewItem = stackView.get(i, StackView.DontLoad);
                do
                {
                    if (stackViewItem === item)
                    {
                        stackView.currentItem.forceActiveFocus();
                        return;
                    }
                    item = item.parent;
                }
                while (item);
            }
        }
    }
}
