import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.abstractdownloadsui 
import QtQuick.Controls.Material
import "../common"
import "../common/Tools"
import "./BaseElements"
import "./BaseElements/V2"
import "./FilesTree"
import "./FilesTree/V2"
import "./Dialogs"

Page {
    id: root

    property string pageName: "TuneAndAddDownloadPage"
    property double requestId: -1
    property var storages: []

    readonly property bool showFileStatus: downloadTools.fileSize >= 0 ||
                                           downloadTools.freeDiskSpace >= 0 ||
                                           !downloadTools.hasWriteAccess

    readonly property string fileStatusText: (!downloadTools.hasWriteAccess ? qsTr("No write access to the selected directory") :
           (downloadTools.freeDiskSpace >= 0 && downloadTools.fileSize >= 0) ? qsTr("Size: %1 (Disk space: %2)").arg(App.bytesAsText(downloadTools.fileSize)).arg(App.bytesAsText(downloadTools.freeDiskSpace)) :
           downloadTools.freeDiskSpace >= 0 ? qsTr("Disk space: %1").arg(App.bytesAsText(downloadTools.freeDiskSpace)) :
           downloadTools.fileSize >= 0 ? qsTr("Size: %1").arg(App.bytesAsText(downloadTools.fileSize)) :
           "") + App.loc.emptyString

    readonly property color fileStatusColor: !downloadTools.hasWriteAccess || downloadTools.notEnoughSpaceWarning ?
                                                 (appWindow.uiver === 1 ? appWindow.theme.errorMessage : appWindow.theme_v2.danger) :
                                                 (appWindow.uiver === 1 ? appWindow.theme.foreground : appWindow.theme_v2.textColor2)

    header: Loader
    {
        source: Qt.resolvedUrl(appWindow.uiver === 1 ?
                                   "TuneAndAddDownloadPageHeader.qml" :
                                   "V2/TuneAndAddDownloadPageHeader_V2.qml")
    }

    ColumnLayout
    {
        anchors.fill: parent

        anchors.margins: appWindow.uiver === 1 ? 14 : appWindow.theme_v2.mainContentMargins*appWindow.zoom

        anchors.leftMargin: appWindow.uiver === 1 ?
                                20 :
                                appWindow.theme_v2.mainContentMargins*appWindow.zoom

        anchors.rightMargin: appWindow.uiver === 1 ?
                                 20 :
                                 appWindow.theme_v2.mainContentMargins*appWindow.zoom

        spacing: appWindow.uiver === 1 ? 10 : 16*appWindow.zoom

        ColumnLayout
        {
            spacing: 2
            Layout.fillWidth: true

            BasePageLabel
            {
                text: qsTr("Save to") + App.loc.emptyString
                font: uicore.buildFont({}, uicore.fontSizeV1(16*appWindow.fontZoom))
            }

            RowLayout
            {
                Layout.fillWidth: true

                BaseComboBox
                {
                    id: saveTo
                    Layout.fillWidth: true
                    font: uicore.buildFont({}, uicore.fontSizeV1(13)*appWindow.fontZoom)
                    onAccepted: accept()
                    onCurrentTextChanged: queryBytesAvailable()
                    delegate: Rectangle {
                        height: 30
                        width: saveTo.width
                        color: appWindow.theme.background
                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 6
                            anchors.rightMargin: 6
                            BaseLabel {
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignVCenter
                                text: modelData.text
                                font: saveTo.font
                                horizontalAlignment: Text.AlignLeft
                                elide: Text.ElideRight
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        saveTo.currentIndex = index;
                                        saveTo.popup.close();
                                    }
                                }
                            }
                            Image {
                                visible: saveTo.model.length > 1
                                Layout.alignment: Qt.AlignVCenter
                                source: Qt.resolvedUrl("../images/desktop/clean.svg")
                                layer {
                                    effect: MultiEffect {
                                        colorization: 1.0
                                        colorizationColor: appWindow.theme.foreground
                                    }
                                    enabled: true
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        let etext = saveTo.editText;
                                        let p = modelData.path;
                                        let newIndex = index < saveTo.model.length - 1 ? index : 0;
                                        let m = saveTo.model;
                                        let __saveTo = saveTo;
                                        m.splice(index, 1);
                                        __saveTo.currentIndex = newIndex;
                                        __saveTo.model = m;
                                        App.recentFolders.removeFolder(p);
                                    }
                                }
                            }
                        }
                    }
                    Connections {
                        target: filePicker
                        onFolderSelected: {
                            onFolderSelected: updateCurrentFolder(folderName)
                        }
                    }
                }

                DialogFlatButton
                {
                    visible: !App.rc.client.active
                    iconSource: Qt.resolvedUrl(appWindow.uiver === 1 ?
                                                   "../images/download-item/folder.svg" :
                                                   "V2/open_folder.svg")
                    onClicked: {
                        stackView.waPush(filePicker.filePickerPageComponent, {folder: saveTo.model[saveTo.currentIndex].path, initiator: "addDownload", downloadId: -1});
                    }
                }
            }
        }

        ColumnLayout
        {
            visible: downloadTools.filesCount === 1 || downloadTools.batchDownload
            Layout.fillWidth: true
            spacing : 2
            BasePageLabel
            {
                text: qsTr("File name") + App.loc.emptyString
                font: uicore.buildFont({}, uicore.fontSizeV1(16*appWindow.fontZoom))
            }

            BaseTextField {
                id: fileName
                visible: downloadTools.filesCount === 1 || downloadTools.batchDownload
                width: parent.width
                Layout.fillWidth: true
                selectByMouse: true
                inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
                text: downloadTools.fileName
                horizontalAlignment: Text.AlignLeft
                onAccepted: accept()
            }
        }

        BaseLabel {
            visible: appWindow.uiver !== 1 && showFileStatus
            color: fileStatusColor
            text: fileStatusText
        }

        BaseCheckBox {
            visible: !App.rc.client.active &&
                    !downloadTools.batchDownload &&
                    App.downloads.creator.downloadInfo(downloadTools.requestId, 0).hasLargeEnoughPreviewableMediaFile(40*1024*1024)

            text: qsTr("Play file while it is still downloading") + App.loc.emptyString

            Layout.fillWidth: true
            wrapMode: Text.WordWrap

            onClicked: {
                let info = App.downloads.creator.downloadInfo(downloadTools.requestId, 0);

                if (info)
                {
                    info.flags = checked ?
                                info.flags | AbstractDownloadsUi.EnableMediaDownloadToPlayAsap :
                                info.flags & ~AbstractDownloadsUi.EnableMediaDownloadToPlayAsap;
                }
            }
        }

        SchedulerButton {
            highlighted: schedulerTools.schedulerCheckboxEnabled
            onClicked: {
                schedulerDlg.initialization();
                schedulerDlg.open();
            }
        }

        Rectangle
        {
            visible: filesTree.item.downloadInfo && filesTree.item.downloadInfo.filesCount > 1

            color: 'transparent'
            border.color: appWindow.uiver === 1 ? appWindow.theme.border : "transparent"

            implicitHeight: filesTree.item.implicitHeight

            Layout.fillHeight: true
            Layout.fillWidth: true

            Component
            {
                id: tree_v1
                FilesTree
                {
                    downloadInfo: App.downloads.creator.downloadInfo(requestId, 0)
                    createDownloadDialog: true
                    property var selectedSize: downloadInfo ? downloadInfo.selectedSize : -1
                    onSelectedSizeChanged: { downloadTools.fileSizeValueChanged(selectedSize) }
                    Rectangle
                    {
                        height: 1
                        width: parent.width
                        anchors.top: parent.top
                        color: appWindow.theme.border
                    }
                }
            }

            Component
            {
                id: tree_v2
                FilesTree_V2
                {
                    property var downloadInfo: App.downloads.creator.downloadInfo(requestId, 0)
                    info: downloadInfo
                    createDownloadDialog: true
                    property var selectedSize: downloadInfo ? downloadInfo.selectedSize : -1
                    onSelectedSizeChanged: { downloadTools.fileSizeValueChanged(selectedSize) }
                }
            }

            Loader {
                id: filesTree
                sourceComponent: appWindow.uiver === 1 ? tree_v1 : tree_v2
                anchors.fill: parent
            }
        }

        DialogFlatButton_V2
        {
            visible: appWindow.uiver !== 1
            text: qsTr("Download") + App.loc.emptyString
            enabled: saveTo.currentText.length > 0 && downloadTools.hasWriteAccess
            primary: true
            onClicked: accept()
            Layout.fillWidth: true
            Layout.minimumHeight: 40*appWindow.zoom
        }

        Item {Layout.fillHeight: true}

        //file status
        BaseLabel {
            visible: appWindow.uiver === 1 && showFileStatus
            Layout.alignment: Qt.AlignHCenter
            color: fileStatusColor
            text: fileStatusText
            font: uicore.buildFont({}, 14*appWindow.fontZoom)
        }
    }

    BuildDownloadTools {
        id: downloadTools
        requestId: root.requestId
        onCreateDownloadFromDialog: {
            stackView.pop();
            appWindow.newDownloadAdded();
        }
        onReject: {
            stackView.pop();
        }
        onFilePathChanged: updateCurrentFolder(filePath)
    }

    SchedulerDialog {
        id: schedulerDlg
    }

    SchedulerTools {
        id: schedulerTools
        tuneAndDownloadDialog: true
    }

    onRequestIdChanged: {
        schedulerTools.buildScheduler([requestId]);
    }

    Component.onCompleted: {
        defineStorages();
        downloadTools.initSubtitlesDefaults();
        downloadTools.getNameAndPath();
        defineFolderList();
//        if (forceDownload) {
//            downloadTools.addDownloadFromDialog();
//        }
    }

    function defineStorages() {
        for (var i = 0; i < App.storages.storagesCount(); ++i) {
            storages[i] = App.storages.storageInfo(i);
        }
    }

    function shortUrl(path) {
        var storage = storages.filter(function (s) { return path.startsWith(s.unrestrictedPath) });
        path = storage.length > 0 ? path.replace(storage[0].unrestrictedPath, storage[0].label) : path;
        path = path.replace(/\/$/, '');//remove last slash
        return App.toNativeSeparators(path);
    }

    function defineFolderList() {
        var folderList = App.recentFolders.list;
        let m = [];
        for (var i = 0; i < folderList.length; i++)
            m.push({'text': shortUrl(folderList[i]), 'path': folderList[i]});
        saveTo.model = m;
        updateCurrentFolder(downloadTools.filePath);
    }

    function updateCurrentFolder(folderName) {
        var index = saveTo.model.findIndex(item => App.toNativeSeparators(item.path) === App.toNativeSeparators(folderName));

        if (index >= 0) {
            saveTo.currentIndex = index;
         } else {
            index = saveTo.model.length;
            let m = saveTo.model;
            m.push({'text': shortUrl(folderName), 'path': folderName});
            saveTo.model = m;
            saveTo.currentIndex = index;
        }
    }

    function accept() {
        downloadTools.onFileNameTextChanged(fileName.displayText);
        downloadTools.onFilePathTextChanged(saveTo.model[saveTo.currentIndex].path);
        downloadTools.addDownloadFromDialog();
        schedulerTools.doOK();
    }

    function queryBytesAvailable() {
        if (saveTo.currentIndex >= 0 && saveTo.currentIndex < saveTo.model.length) {
            App.storages.queryBytesAvailable(saveTo.model[saveTo.currentIndex].path)
            App.storages.queryIfHasWriteAccess(saveTo.model[saveTo.currentIndex].path);
        }
    }

    Connections {
        target: App.storages
        onBytesAvailableResult: (path, available) => {
            if (path == saveTo.model[saveTo.currentIndex].path) {
                downloadTools.freeDiskSpace = available;
            }
        }
        onHasWriteAccessResult: (path, result) => {
            if (path == saveTo.model[saveTo.currentIndex].path) {
                downloadTools.hasWriteAccess = result;
            }
        }
    }

    onVisibleChanged: queryBytesAvailable()

    Connections {
        target: Qt.application
        onActiveChanged: queryBytesAvailable()
    }
}
