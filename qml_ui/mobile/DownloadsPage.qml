import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material
import org.freedownloadmanager.fdm
import "../common"
import "./BaseElements"
import "./BaseElements/V2"
import "./Dialogs"
import "./Dialogs/TumModeDialog"
import "../common/Tools"
import "V2"

BaseMainPage
{
    id: root

    readonly property bool isSearchModeActive: state === "searchView"

    objectName: uicore.downloadsPageName

    function openSearchMode()
    {
        if (!isSearchModeActive)
        {
            if (appWindow.uiver !== 1)
                searchText_V2.apply(true);
            state = "searchView";
            if (appWindow.uiver !== 1)
                searchText_V2.forceActiveFocus();
        }

        return true;
    }

    function closeSearchMode()
    {
        if (isSearchModeActive)
        {
            downloadsViewTools.resetDownloadsTitleFilter(true);
            downloadsViewLoader.forceActiveFocus();
            state = "mainView";
        }

        return true;
    }

    function showAll()
    {
        downloadsViewTools.resetFilters();
        downloadsViewLoader.forceActiveFocus();
        root.state = "mainView";
    }

    background: Rectangle
    {
        color: appWindow.uiver === 1 ?
                   appWindow.theme.background :
                   appWindow.theme_v2.bgColor

        Rectangle
        {
            visible: appWindow.uiver !== 1
            width: parent.width
            height: header.height + 8 + 16
            color: appWindow.theme_v2.bg300_2
        }

        HalfRoundRect_V2
        {
            visible: appWindow.uiver !== 1
            where: HalfRoundRect_V2.Where.Top
            radius: 16
            color: appWindow.theme_v2.bgColor
            anchors.fill: parent
            anchors.topMargin: header.height + 8
        }
    }

    Component {
        id: header_v1
        DownloadsPageHeader {state: root.state}
    }

    Component {
        id: header_v2
        DownloadsPageHeader_V2 {state: root.state}
    }

    header: Loader {
        sourceComponent: appWindow.uiver === 1 ? header_v1 : header_v2
    }

    state: "mainView"

    states: [
        State {
            name: "mainView"
            PropertyChanges {
                target: appWindow;
                showDownloadIcon: true;
                showDownloadCheckbox: false;
                showDownloadItemMenuBtn: true;
                selectMode: false;
                searchMode: false;
            }
            StateChangeScript {
                script: {
                    App.downloads.model.checkAll(false);
                }
            }
            PropertyChanges {
                target: selectModeBar;
                visible: false;
            }
        },
        State {
            name: "mainViewSelectMode"
            PropertyChanges {
                target: appWindow;
                showDownloadIcon: false;
                showDownloadCheckbox: true;
                showDownloadItemMenuBtn: false;
                selectMode: true;
                searchMode: false;
            }
            PropertyChanges {
                target: selectModeBar;
                visible: true;
            }
        },
        State {
            name: "searchView"
            PropertyChanges {
                target: appWindow;
                showDownloadIcon: true;
                showDownloadCheckbox: false;
                showDownloadItemMenuBtn: true;
                selectMode: false;
                searchMode: true;
            }
            StateChangeScript {
                script: {
                    App.downloads.model.checkAll(false);
                }
            }
            PropertyChanges {
                target: selectModeBar;
                visible: false;
            }
        },
        State {
            name: "searchViewSelectMode"
            PropertyChanges {
                target: appWindow;
                showDownloadIcon: false;
                showDownloadCheckbox: true;
                showDownloadItemMenuBtn: false;
                selectMode: true;
                searchMode: false;
            }
            PropertyChanges {
                target: selectModeBar;
                visible: true;
            }
        }
    ]

    ColumnLayout
    {
        visible: !App.downloads.infos.empty

        anchors.fill: parent
        anchors.topMargin: appWindow.uiver === 1 ? 0 : 8*appWindow.zoom

        SearchField_V2
        {
            id: searchText_V2
            visible: appWindow.uiver !== 1 && root.isSearchModeActive
            bgColor: appWindow.theme_v2.bg200
            Layout.fillWidth: true
            Layout.leftMargin: 16*appWindow.zoom
            Layout.rightMargin: Layout.leftMargin
            Layout.topMargin: Layout.leftMargin
            Layout.minimumHeight: 48*appWindow.zoom
            onDisplayTextChanged: apply()
            onClearClicked: text = ""
            function apply(applyImmediately) {
                downloadsViewTools.setDownloadsTitleFilter(displayText, applyImmediately)
            }
        }

        Loader {
            id: downloadsViewLoader
            Layout.fillWidth: true
            Layout.fillHeight: true
            source: Qt.resolvedUrl(appWindow.uiver === 1 ? "DownloadsView.qml" : "V2/DownloadsView_V2.qml")
            onLoaded: {
                if (appWindow.uiver === 1) {
                    item.downloadSelected.connect(() => root.switchSelectModeOn());
                    item.downloadUnselected.connect(
                                () => {
                                    var checked_ids = App.downloads.model.checkedIds;
                                    if (checked_ids.length === 0) {
                                        root.switchSelectModeOff();
                                    }
                                });
                }
            }
        }
    }

    SelectSortFieldDialog {
        id: selectSortFieldDialog
    }

    ColumnLayout
    {
        visible: appWindow.hasDownloadMgr && App.downloads.infos.empty

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 12*appWindow.zoom
        anchors.right: parent.right
        anchors.rightMargin: 12*appWindow.zoom

        spacing: 32*appWindow.zoom

        SvgImage_V2
        {
            visible: appWindow.uiver !== 1
            source: Qt.resolvedUrl("V2/empty_downloads_list.svg")
            imageColor: appWindow.theme_v2.bg300_2
            Layout.alignment: Qt.AlignHCenter
        }

        BaseLabel {
            text: qsTr("Download list is empty. Add new download URL.") + App.loc.emptyString
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            Layout.alignment: Qt.AlignHCenter
            horizontalAlignment: Text.AlignHCenter
            color: appWindow.uiver === 1 ?
                       appWindow.theme.foreground :
                       appWindow.theme_v2.textColor2
            font: uicore.buildFont({}, uicore.fontSizeV2(appWindow.theme_v2.fontSize+5)*appWindow.fontZoom)
        }

        Item {
            visible: appWindow.uiver === 1
            implicitHeight: parent.parent.height / 3
        }
    }

    BaseLabel
    {
        visible: !appWindow.hasDownloadMgr && !App.rc.client.active
        text: "<a href='#'>" + qsTr("Connect to remote %1").arg(App.shortDisplayName) + "</a>" + App.loc.emptyString
        onLinkActivated: connectToRemoteAppDlg.open()
        Material.accent: appWindow.theme.link
        anchors.centerIn: parent
        font: uicore.buildFont({}, uicore.fontSizeV1(16*appWindow.fontZoom))
    }

    //empty search results
    Item {
        anchors.fill: parent
        anchors.margins: 15*appWindow.zoom

        visible: !App.downloads.infos.empty &&
                 (downloadsViewTools.emptySearchResults ||
                  downloadsViewTools.emptyActiveDownloadsList ||
                  downloadsViewTools.emptyCompleteDownloadsList)

        ColumnLayout {
            anchors.top: parent.top
            anchors.topMargin: appWindow.uiver === 1 ?
                                   Math.round(parent.height * 0.3) :
                                   searchText_V2.height + 52*appWindow.zoom
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            spacing: (appWindow.uiver === 1 ? 5 : 16)*appWindow.zoom

            BaseLabel {
                Layout.alignment: Qt.AlignHCenter
                text: (downloadsViewTools.emptySearchResults ? qsTr("No results found for") + " \"" + downloadsViewTools.downloadsTitleFilter + "\"" :
                       downloadsViewTools.emptyActiveDownloadsList ? qsTr("No active downloads") :
                       downloadsViewTools.emptyCompleteDownloadsList ? qsTr("No completed downloads") : "") + App.loc.emptyString
                font: uicore.buildFont({}, (appWindow.uiver === 1 ? 14 : appWindow.theme_v2.fontSize)*appWindow.fontZoom)
                Layout.preferredWidth: parent.width
                wrapMode: Label.Wrap
                horizontalAlignment: Text.AlignHCenter
                opacity: appWindow.uiver === 1 ? 0.5 : 1.0
                color: appWindow.uiver === 1 ?
                           appWindow.theme.foreground :
                           appWindow.theme_v2.bg500
            }

            BaseLabel {
                visible: appWindow.uiver === 1
                Layout.alignment: Qt.AlignHCenter
                text: "<a href='#'>" + qsTr("Show all") + App.loc.emptyString + "</a>"
                Layout.preferredWidth: parent.width
                wrapMode: Label.Wrap
                horizontalAlignment: Text.AlignHCenter
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: showAll()
                }
            }

            DialogFlatButton_V2 {
                visible: appWindow.uiver !== 1
                text: qsTr("Show all") + App.loc.emptyString
                Layout.fillWidth: true
                Layout.leftMargin: 16*appWindow.zoom
                Layout.rightMargin: Layout.leftMargin
                Layout.minimumHeight: 40*appWindow.zoom
                primary: true
                onClicked: showAll()
            }
        }
    }

//    SnailButton
//    {
//        id: snailBtn
//        anchors {
//            left: parent.left
//            bottom: parent.bottom
//            leftMargin: 20
//            bottomMargin: 20
//        }
//    }

    //Round add button - BEGIN
    RoundButton
    {
        visible: appWindow.uiver === 1 &&
                 appWindow.hasDownloadMgr &&
                 root.state !== "mainViewSelectMode" &&
                 root.state !== "searchView" &&
                 root.state !== "searchViewSelectMode" &&
                 downloadsViewLoader.item &&
                 !downloadsViewLoader.item.flicking &&
                 !downloadsViewLoader.item.dragging

        onClicked: appWindow.createDownloadDialog()

        width: 58
        height: 58
        radius: Math.round(width / 2)

        padding: 0
        spacing: 0

        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 20
        anchors.bottomMargin: 20

        Material.elevation: 0
        Material.background: appWindow.theme.selectModeBarAndPlusBtn
        display: AbstractButton.IconOnly

        icon.source: Qt.resolvedUrl("../images/mobile/plus.svg")
        icon.width: 24
        icon.height: 24
        icon.color: "#fff"
    }
    //Round add button - End

    SelectModeBar {
        id: selectModeBar

        onSwitchSelectModeOff: root.switchSelectModeOff()
    }

    TumModeDialog {
        id: tumModeDialog
    }

    DeleteDownloadsDialog {
        id: deleteDownloadsDialog

        onDownloadsRemoved: root.switchSelectModeOff()
    }

    DeleteDownloadsFailedDialog {}

    ConfirmDeleteExtraneousFilesDialog {}

    SchedulerDialog {
        id: schedulerDlg
    }

    SchedulerTools {
        id: schedulerTools
        onBuildingFinished: {
            schedulerDlg.initialization();
            schedulerDlg.open();
        }
        onSettingsSaved: schedulerDlg.close()
    }

    Connections {
        target: App.downloads.infos
        onEmptyChanged: {
            if (App.downloads.infos.empty) {
                root.switchSelectModeOff();
            }
        }
    }

    function switchSelectModeOff()
    {
        if (root.state === "searchViewSelectMode") {
            root.state = "searchView";
        } else if (root.state === "mainViewSelectMode") {
            root.state = "mainView";
        }
    }

    function switchSelectModeOn()
    {
        if (root.state === "searchView") {
            root.state = "searchViewSelectMode";
        } else if (root.state === "mainView") {
            root.state = "mainViewSelectMode";
        }
    }

    ConvertFilesFailedDialog
    {
        id: convertFilesFailedDialog
    }

    ConvertDestinationFilesExistsDialog
    {
        id: convertDestinationFilesExistsDialog

        onClosed: {
            if (requests.length)
                onGotRequest();
        }

        property var requests: []

        function onGotRequest()
        {
            if (opened || !requests.length)
                return;

            var r = requests.shift();

            taskId = r.taskId;
            files = r.files;

            open();
        }
    }

    Connections
    {
        target: App.downloads.mgr

        onConvertDestinationFilesExists: function(taskId, files)
        {
            files.forEach((e,i,a) => a[i] = App.toNativeSeparators(e));

            convertDestinationFilesExistsDialog.requests.push(
                        {
                            taskId: taskId,
                            files: files
                        });

            convertDestinationFilesExistsDialog.onGotRequest();
        }

        onConvertTaskFinished: function(taskId, failedFiles)
        {
            if (convertDestinationFilesExistsDialog.opened &&
                    convertDestinationFilesExistsDialog.taskId == taskId)
            {
                convertDestinationFilesExistsDialog.close();
            }

            if (failedFiles.length > 0)
            {
                failedFiles.forEach((e,i,a) => a[i] = App.toNativeSeparators(e));

                if (convertFilesFailedDialog.opened)
                {
                    var arr = convertFilesFailedDialog.failedFiles;
                    arr.push(...files);
                    convertFilesFailedDialog.files = arr;
                }
                else
                {
                    convertFilesFailedDialog.files = failedFiles;
                    convertFilesFailedDialog.open();
                }
            }
        }
    }

    Connections {
        target: appWindow
        onOpenScheduler: (downloadId) => schedulerDlg.setUpSchedulerAction([downloadId])
    }
}
