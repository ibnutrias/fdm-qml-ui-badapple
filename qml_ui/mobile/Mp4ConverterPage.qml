import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material
import org.freedownloadmanager.fdm
import "BaseElements"
import "BaseElements/V2"
import "../common/Tools"

BasePage {
    property var downloadsIds: []
    property var filesIndices: []
    property bool wrongFilePathWarning: false
    property bool constantBitrateChecked

    title: qsTr("Convert to mp4") + App.loc.emptyString

    v1_okButtonVisible: true
    v1_okButtonEnabled: !d.accepting && destinationDir.displayText
    onV1_okButtonClicked: doOK()
    goBackHandler: () => {
                       d.accepting = false;
                       stackView.pop();
                   }

    QtObject {
        id: d
        property bool accepting: false
    }

    ColumnLayout
    {
        spacing: 5*appWindow.zoom
        Layout.fillWidth: true

        BasePageLabel
        {
            text: qsTr("Save to") + App.loc.emptyString
        }

        RowLayout
        {
            Layout.fillWidth: true

            BaseTextField
            {
                id: destinationDir
                enabled: !d.accepting
                Layout.fillWidth: true
                selectByMouse: true
                inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
                wrapMode: TextInput.WrapAnywhere
                horizontalAlignment: Text.AlignLeft
                onAccepted: doOK()
            }

            DialogFlatButton
            {
                visible: !App.rc.client.active
                enabled: !d.accepting
                iconSource: Qt.resolvedUrl(appWindow.uiver === 1 ?
                                               "../images/download-item/folder.svg" :
                                               "V2/open_folder.svg")
                onClicked: {
                    stackView.waPush(filePicker.filePickerPageComponent, {initiator: "convertPage", downloadId: -1});
                }
            }

            Connections {
                target: filePicker
                onFolderSelected: {
                    onFolderSelected: { destinationDir.text = folderName }
                }
            }
        }

        BaseLabel
        {
            visible: wrongFilePathWarning
            text: qsTr("The path contains invalid characters") + App.loc.emptyString
            wrapMode: Text.WordWrap
            color: appWindow.uiver === 1 ?
                       appWindow.theme.errorMessage :
                       appWindow.theme_v2.danger
        }
    }

    DialogFlatButton_V2
    {
        visible: appWindow.uiver !== 1
        text: qsTr("OK") + App.loc.emptyString
        enabled: v1_okButtonEnabled
        primary: true
        onClicked: doOK()
        Layout.fillWidth: true
        Layout.minimumHeight: 40*appWindow.zoom
    }

    Item {Layout.fillHeight: true}

    function firstDownloadPath()
    {
        return downloadsIds.length ?
                    App.downloads.infos.info(downloadsIds[0]).destinationPath :
                    "";
    }

    function initialPath()
    {
        return App.toNativeSeparators(uiSettingsTools.settings.mp4ConverterDestinationDir !== "" ?
                    uiSettingsTools.settings.mp4ConverterDestinationDir :
                    firstDownloadPath());
    }

    function isUserChangedPath()
    {
        return destinationDir.text !== initialPath();
    }

    Component.onCompleted: {
        destinationDir.text = initialPath();
        wrongFilePathWarning = false;
    }

    function doOK() {
        d.accepting = true;
        App.storages.isValidAbsoluteFilePath(App.fromNativeSeparators(destinationDir.text));
    }

    Connections
    {
        target: App.storages
        onIsValidAbsoluteFilePathResult: function(path, result) {
            if (d.accepting &&
                    path === App.fromNativeSeparators(destinationDir.text))
            {
                d.accepting = false;
                wrongFilePathWarning = !result;
                if (result)
                {
                    App.downloads.mgr.convertFilesToMp4(downloadsIds, filesIndices, destinationDir.text);
                    if (isUserChangedPath())
                        uiSettingsTools.settings.mp4ConverterDestinationDir = destinationDir.text;
                    stackView.pop();
                }
            }
        }
    }
}
