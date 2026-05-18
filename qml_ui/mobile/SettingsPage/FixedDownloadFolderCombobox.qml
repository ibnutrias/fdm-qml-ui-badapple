import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.appsettings
import org.freedownloadmanager.fdm.dmcoresettings
import "../BaseElements"

Item {
    id: root

    implicitWidth: ct.implicitWidth
    implicitHeight: ct.implicitHeight

    QtObject {
        id: d
        property string checkingPath
        property bool isCurrentPathInvalid: false
    }

    function apply() {
        var currentPath = longUrl(downloadFolder.editText.trim());
        if (!currentPath)
        {
            d.isCurrentPathInvalid = true;
            return;
        }
        App.storages.isValidAbsoluteFilePath(d.checkingPath = currentPath);
    }

    Connections {
        target: App.storages
        onIsValidAbsoluteFilePathResult: function(path, result) {
            if (path === d.checkingPath)
            {
                d.checkingPath = ""
                d.isCurrentPathInvalid = !result;
                if (result) {
                    App.settings.dmcore.setValue(
                        DmCoreSettings.FixedDownloadPath, App.localEncodePath(path));
                }
            }
        }
    }

    ColumnLayout
    {
        id: ct

        anchors.fill: parent

        RowLayout
        {
            Layout.fillWidth: true

            BaseComboBox {
                id: downloadFolder
                enabled: root.enabled
                editable: true
                Layout.preferredHeight: contentItem.implicitHeight
                Layout.fillWidth: true
                font: uicore.buildFont({}, uicore.fontSizeV1(13)*appWindow.fontZoom)
                onEditTextChanged: root.apply()
                contentItem: BaseTextField {
                    text: downloadFolder.displayText
                    color: (!d.isCurrentPathInvalid || d.checkingPath) ?
                               (appWindow.uiver === 1 ? appWindow.theme.foreground : appWindow.theme_v2.textColor) :
                               (appWindow.uiver === 1 ? appWindow.theme.errorMessage : appWindow.theme_v2.danger)
                    leftPadding: qtbug.leftPadding(10, 0)
                    rightPadding: qtbug.rightPadding(10, 0)
                    font: downloadFolder.font
                    opacity: enabled ? 1 : 0.5
                    selectByMouse: true
                    wrapMode: Text.WrapAnywhere
                    inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
                    horizontalAlignment: TextField.AlignLeft
                    background_V2: Item {}
                }
                background: Rectangle {
                    color: appWindow.uiver === 1 ?
                               appWindow.theme.background :
                               appWindow.theme_v2.bgColor
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
                opacity: enabled ? 1 : (appWindow.uiver === 1 ? 0.5 : appWindow.theme_v2.opacityDisabled)
                iconSource: Qt.resolvedUrl(appWindow.uiver === 1 ?
                                               "../../images/download-item/folder.svg" :
                                               "../V2/open_folder.svg")
                onClicked: {
                    var currentPath = App.localEncodePath(longUrl(downloadFolder.editText.trim()));
                    stackView.waPush(filePicker.filePickerPageComponent, {folder: currentPath, initiator: "downloadsSettings", downloadId: -1});
                }
            }

            DialogButton {
                visible: appWindow.uiver === 1
                text: qsTr("Macros") + App.loc.emptyString
                enabled: root.enabled
                radius: 20
                Layout.preferredHeight: 40*appWindow.zoom
                opacity: enabled ? 1 : 0.5
                onClicked: macrosMenu.openFor(this)
            }
        }

        BaseLabel
        {
            visible: appWindow.uiver !== 1
            text: qsTr("Macros") + App.loc.emptyString
            color: appWindow.theme_v2.primary
            MouseArea {
                anchors.fill: parent
                onClicked: macrosMenu.openFor(parent)
            }
        }
    }

    Connections {
        target: filePicker
        onFolderSelected: {
            onFolderSelected: {
                console.log("[onFolderSelected] folderName", folderName);
                updateCurrentFolder(folderName);
            }
        }
    }

    MacrosMenu {
        id: macrosMenu
        onMacroSelected: (macro) => {
            updateCurrentFolder(downloadFolder.editText + macro)
        }
        function openFor(item) {
            let pt = item.mapToItem(parent, 0, 0);
            x = pt.x;
            y = pt.y;
            open();
        }
    }

    Component.onCompleted: {
        defineStorages();
        defineFolderList();
    }

    function find(model, criteria) {
        for(var i = 0; i < model.count; ++i) if (criteria(model.get(i))) return i;
        return -1;
    }

    function defineStorages() {
        for (var i = 0; i < App.storages.storagesCount(); ++i) {
            storages[i] = App.storages.storageInfo(i);
            console.log(JSON.stringify(storages[i], null, 4));
        }
    }

    function defineFolderList() {
        let m = [];
        var folderList = App.recentFolders.list;
        for (var i = 0; i < folderList.length; i++) {
            m.push({'text': shortUrl(folderList[i]), 'path': folderList[i]});
        }
        downloadFolder.model = m;
        updateCurrentFolder(App.localDecodePath(App.settings.dmcore.value(DmCoreSettings.FixedDownloadPath)));
    }

    function updateCurrentFolder(folderName) {
        if (!folderName) {
            downloadFolder.currentIndex = -1;
            return;
        }
        let index = downloadFolder.model.findIndex(item => item.path == folderName);
        if (index >= 0) {
            downloadFolder.currentIndex = index;
         } else {
            let m = downloadFolder.model;
            index = m.length;
            m.push({'text': shortUrl(folderName), 'path': folderName});
            downloadFolder.model = m;
            downloadFolder.currentIndex = index;
        }
    }

    function shortUrl(path) {
        var storage = storages.filter(function (s) { return path.startsWith(s.unrestrictedPath) });
        path = storage.length > 0 ? path.replace(storage[0].unrestrictedPath, storage[0].label) : path;
        path = path.replace(/\/$/, '');//remove last slash
        return path;
    }

    function longUrl(path) {
        var storage = storages.filter(function (s) { return path.startsWith(s.label) });
        path = storage.length > 0 ? path.replace(storage[0].label, storage[0].unrestrictedPath) : path;
        path = path.replace(/\/$/, '');//remove last slash
        return path;
    }
}
