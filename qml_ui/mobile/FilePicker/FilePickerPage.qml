import QtQuick
import QtQuick.Controls
import Qt.labs.folderlistmodel
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls.Material
import org.freedownloadmanager.fdm
import ".."
import "../BaseElements"
import "../BaseElements/V2"
import "../Dialogs"
import "../V2"
import "V2"

BasePage
{
    id: picker

    signal fileSelected(string fileName)

    property bool showDirsFirst: true
    property string folder
    property string nameFilters: !onlyFolders && initiator === 'addDownload' && App.cfg.cdOpenFileDlgNameFilters ? App.cfg.cdOpenFileDlgNameFilters : "*.*"
    property int downloadId: -1
    property string initiator
    property bool onlyFolders: true
    property int currentStorageIndex: -1

    readonly property string currentStorageName:
        currentStorageIndex != -1 ?
            App.storages.storageInfo(currentStorageIndex).label :
            ""

    readonly property string currentStorageRootFolder:
        currentStorageIndex != -1 ?
            absolutePath(App.storages.storageInfo(currentStorageIndex).unrestrictedPath) :
            ""

    Component.onCompleted: {
        defineStorageList();
        updateFoldersBar();
    }
    onFolderChanged: updateFoldersBar()

    title: (onlyFolders ? qsTr("Select folder") : qsTr("Select file")) + App.loc.emptyString

    contentItemSpacing: 0

    ListModel {id: storageListModel}

    header_v1: Component
    {
        Column
        {
            height: 108

            PageHeaderWithBackArrow
            {
                pageTitle: title
                okButtonVisible: onlyFolders
                onOkButtonClicked: doOK()
                onPopPage: stackView.pop()
            }

            ToolBarShadow {}

            ExtraToolBar
            {
                StorageListView
                {
                    anchors.left: parent.left
                    anchors.leftMargin: picker.padding
                    anchors.right: sortMenuBtn.left
                    anchors.verticalCenter: parent.verticalCenter
                    height: parent.height
                    model: storageListModel
                    currentIndex: currentStorageIndex
                    onCurrentIndexChanged: resetFolder(absolutePath(model.get(currentStorageIndex=currentIndex).unrestrictedPath));
                }

                ToolbarButton
                {
                    id: sortMenuBtn
                    anchors.right: parent.right
                    anchors.rightMargin: -6
                    anchors.verticalCenter: parent.verticalCenter
                    icon.source: Qt.resolvedUrl("../../images/mobile/sort_menu.svg")
                    onClicked: filePickerSortDialog.open()
                    width: visible ? width : 16
                }
            }
        }
    }

    FolderListModel {
        id: folderListModel
        showDirsFirst: picker.showDirsFirst
        folder: picker.folder
        nameFilters: picker.nameFilters
        showFiles: !onlyFolders
        sortField: uiSettingsTools.settings.filePickerSortField
        sortReversed: uiSettingsTools.settings.filePickerSortReversed
        rootFolder: picker.currentStorageRootFolder
        showOnlyReadable: true
        onStatusChanged: {
            if (folderListModel.status == FolderListModel.Ready && folderListModel.folder.toString() !== picker.folder.toString()) {
                resetFolder(picker.folder.length > 0 ? absolutePath(picker.folder) : rootFolder);
            }
        }
    }

    Loader
    {
        visible: active
        active: appWindow.uiver !== 1 && storageListModel.count
        sourceComponent: Component
        {
            StorageListView
            {
                model: storageListModel
                currentIndex: currentStorageIndex
                onCurrentIndexChanged: resetFolder(absolutePath(model.get(currentStorageIndex=currentIndex).unrestrictedPath));
            }
        }
        Layout.fillWidth: true
        Layout.preferredHeight: item ? item.implicitHeight + supposedContentItemSpacing : 0
    }

    ListViewItemSeparator_V2
    {
        visible: appWindow.uiver !== 1
        Layout.fillWidth: true
    }

    RowLayout
    {
        Flickable
        {
            id: foldersBar

            property var folders: []

            Layout.fillWidth: true

            implicitHeight: foldersBarRow.implicitHeight
            implicitWidth: foldersBarRow.implicitWidth

            contentWidth: foldersBarRow.width
            onContentWidthChanged: contentX = Math.max(0, contentWidth - width)

            clip: true

            Row
            {
                id: foldersBarRow

                spacing: 8*appWindow.zoom

                Repeater
                {
                    model: foldersBar.folders.length

                    Item
                    {
                        implicitWidth: children[0].implicitWidth
                        implicitHeight: children[0].implicitHeight

                        RowLayout
                        {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: foldersBarRow.spacing

                            SvgImage_V2
                            {
                                id: toolbarArrow
                                source: Qt.resolvedUrl("../../images/mobile/arrow_right.svg")
                                sourceSize: Qt.size(7, 8)
                                mirror: LayoutMirroring.enabled
                                imageColor: appWindow.theme.foreground
                            }

                            BaseLabel
                            {
                                id: folderText
                                readonly property bool isCurrent: picker.folder === foldersBar.folders[index].fullPath
                                text: foldersBar.folders[index].folderName
                                font: uicore.buildFont({weight: isCurrent ?
                                                               (appWindow.uiver === 1 ? Font.Bold : Font.Medium) :
                                                               Font.Normal
                                                       })
                                color: appWindow.uiver === 1 ?
                                           appWindow.theme.foreground :
                                           (isCurrent ? appWindow.theme_v2.textColor : appWindow.theme_v2.textColor2)
                                Layout.preferredHeight: implicitHeight + supposedContentItemSpacing
                                verticalAlignment: Text.AlignVCenter
                            }
                        }

                        MouseArea
                        {
                            anchors.fill: parent
                            onClicked: {
                                picker.resetFolder(foldersBar.folders[index].fullPath)
                            }
                        }
                    }
                }
            }
        }

        SvgImage_V2
        {
            visible: appWindow.uiver !== 1
            source: Qt.resolvedUrl("../V2/sort.svg")

            MouseArea {
                anchors.fill: parent
                anchors.margins: -20*appWindow.zoom // avoid pixel hunting
                onClicked: v2_sortMenu.open()
            }

            FilePickerSortModeDrawer_V2 {
                id: v2_sortMenu
            }
        }
    }

    ListViewItemSeparator_V2
    {
        visible: appWindow.uiver !== 1
        Layout.fillWidth: true
    }

    ListView
    {
        id: foldersList

        enabled: folderListModel.status !== FolderListModel.Loading

        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.leftMargin: picker.padding // offset relative to foldersBar

        model: folderListModel

        clip: true

        boundsBehavior: Flickable.StopAtBounds

        delegate: Item
        {
            width: foldersList.width
            height: children[0].height + supposedContentItemSpacing

            RowLayout
            {
                width: parent.width
                anchors.centerIn: parent

                spacing: 8*appWindow.zoom

                SvgImage_V2
                {
                    visible: folderListModel.isFolder(index)
                    source: Qt.resolvedUrl("../../images/mobile/folder.svg")
                    sourceSize: Qt.size(20, 20)
                    fillMode: Image.PreserveAspectFit
                    imageColor: appWindow.uiver === 1 ?
                                    appWindow.theme.foreground :
                                    appWindow.theme_v2.primary
                }

                Rectangle
                {
                    id: fileMarker
                    visible: !folderListModel.isFolder(index)
                    implicitWidth: 8
                    implicitHeight: 8
                    radius: 4
                    color: appWindow.uiver === 1 ?
                               appWindow.theme.foreground :
                               appWindow.theme_v2.textColor
                }

                BasePageLabel
                {
                    text: fileName
                    elide: Label.ElideMiddle
                    Layout.fillWidth: true
                }

                SvgImage_V2
                {
                    visible: appWindow.uiver === 1 &&
                             folderListModel.isFolder(index)
                    source: Qt.resolvedUrl("../../images/mobile/arrow_right.svg")
                    sourceSize: Qt.size(7, 8)
                    mirror: LayoutMirroring.enabled
                    imageColor: appWindow.theme.foreground
                }
            }

            MouseArea
            {
                anchors.fill: parent
                onClicked: onItemClick(fileName)
            }
        }

        RoundButton
        {
            visible: onlyFolders && !foldersList.flicking && !foldersList.dragging
            onClicked: createFolderDialog.openDialog(App.tools.url(folderListModel.folder).toLocalFile())

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
            Material.background: appWindow.uiver === 1 ?
                                     appWindow.theme.selectModeBarAndPlusBtn :
                                     appWindow.theme_v2.primary
            display: AbstractButton.IconOnly

            icon.source: Qt.resolvedUrl("../../images/mobile/add_folder.svg")
            icon.width: 24
            icon.height: 24
            icon.color: "#fff"
        }

        BasePageLabel {
            visible: folderListModel.status == FolderListModel.Ready && folderListModel.count == 0
            text: qsTr("Empty folder") + App.loc.emptyString
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 150
        }
    }

    BaseDialogButton
    {
        visible: appWindow.uiver !== 1 &&
                 onlyFolders
        Layout.topMargin: supposedContentItemSpacing
        text: qsTr("OK") + App.loc.emptyString
        primary: true
        Layout.fillWidth: true
        onClicked: doOK()
    }

    FilePickerSortDialog {
        id: filePickerSortDialog
    }

    CreateFolderDialog {
        id: createFolderDialog
    }

    Connections {
        target: filePicker
        onResetFolder: {
            picker.folder = folderName;
        }
    }

    function absolutePath(url) {
        return url.length > 0 ? (url[0] === "/" ? "file://" : "") + url : "file:///";
    }

    function updateFoldersBar() {
        foldersBar.folders = picker.getFoldersList();
    }

    function isFolder(fileName) {
        return folderListModel.isFolder(folderListModel.indexOf(folderListModel.folder + "/" + fileName));
    }
    function canMoveUp() {
        return folderListModel.folder.toString() !== currentStorageRootFolder;
    }

    function resetFolder(folderName)
    {
        folder = folderName;
    }

    function onItemClick(fileName) {
        if (isFolder(fileName)) {
            //folder
            if (fileName === ".." && canMoveUp()) {
                folder = folderListModel.parentFolder;
            } else if (fileName !== ".") {
                folder = concatFolders(folderListModel.folder.toString(), fileName);
            }
        } else if (!onlyFolders) {
            //file
            fileName = concatFolders(folderListModel.folder.toString(), fileName);
            filePicker.fileSelected(fileName);
            stackView.pop();
        }
    }

    function doOK()
    {
        filePicker.folderSelected(App.tools.url(folderListModel.folder).toLocalFile(), downloadId, initiator);
        stackView.pop()
    }

    function getFoldersList()
    {
        setCurrentStorage();

        var folders_str = folder.toString();
        folders_str = folders_str.replace(currentStorageRootFolder, '');
        var models = [];
        models.push({folderName: currentStorageName, fullPath: currentStorageRootFolder});
        if (folders_str !== '') {
            var folders_arr = folders_str.split("/");
            var last_path = currentStorageRootFolder;
            for (var i = 0; i < folders_arr.length; i++) {
                if (folders_arr[i] !== '') {
                    last_path = concatFolders(last_path, folders_arr[i]);
                    models.push({folderName: folders_arr[i], fullPath: last_path});
                }
            }
        }
        return models;
    }

    function concatFolders(f, n) {
        return (f[f.length-1] === "/" ? (f + n) : (f + '/' + n));
    }

    function setCurrentStorage() {
        var storage, path;
        var folder_str = absolutePath(folder);

        for (var i = 0; i < App.storages.storagesCount(); ++i) {
            storage = App.storages.storageInfo(i);
            path = absolutePath(storage.unrestrictedPath);

            if (storage.isPrimary || folder_str.startsWith(path)) {
                currentStorageIndex = i;

                if (folder_str.startsWith(path)) {
                    break;
                }
            }
        }
    }

    function defineStorageList()
    {
        storageListModel.clear();

        for (var i = 0; i < App.storages.storagesCount(); i++)
        {
            let storage = App.storages.storageInfo(i);

            storageListModel.insert(i, {'label': storage.label, 'unrestrictedPath': storage.unrestrictedPath,
                                    'isUnrestrictedPathAppSpecific': storage.isUnrestrictedPathAppSpecific,
                                    'isPrimary': storage.isPrimary, 'isRemovable': storage.isRemovable
                                });
        }
    }
}
