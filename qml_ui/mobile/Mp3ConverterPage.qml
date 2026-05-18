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

    title: (appWindow.smallScreen ? qsTr("Convert to mp3") : qsTr("Convert to mp3 with adjustable bitrate")) + App.loc.emptyString

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
        Layout.fillWidth: true
        spacing: 5*appWindow.zoom

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
                horizontalAlignment: Text.AlignLeft
                wrapMode: TextInput.WrapAnywhere
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

            Connections
            {
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

    ColumnLayout
    {
        Layout.fillWidth: true
        spacing: 5*appWindow.zoom

        BasePageLabel
        {
            text: qsTr("Bitrate (quality)") + ':' + App.loc.emptyString
        }

        RowLayout
        {
            Layout.fillWidth: true
            spacing: 10*appWindow.zoom

            BaseComboBox
            {
                id: quality

                model: [
                    {text: qsTr("Constant bitrate of value") + App.loc.emptyString, value: true},
                    {text: qsTr("Variable bitrate (VBR)") + App.loc.emptyString, value: false}]

                Component.onCompleted: { currentIndex = model.findIndex(e => e.value == constantBitrateChecked); }

                onActivated: index => constantBitrateChecked = model[index].value
            }

            BaseLabel
            {
                text: "<a href='https://wikipedia.org/wiki/Variable_bitrate'>VBR?</a>"
                onLinkActivated: Qt.openUrlExternally(link)
                Material.accent: appWindow.theme.link
                horizontalAlignment: Text.AlignLeft
                font: uicore.buildFont({}, uicore.fontSizeV1(16*appWindow.fontZoom))
            }

            Item {Layout.fillWidth: true}
        }

        BitrateComboBox
        {
            id: constantBitrate
            visible: constantBitrateChecked
            constantBitrate: true
            maxComboWidth: destinationDir.width
        }

        BitrateComboBox
        {
            id: variableBitrate
            visible: !constantBitrateChecked
            constantBitrate: false
            maxComboWidth: destinationDir.width
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
        return App.toNativeSeparators(uiSettingsTools.settings.mp3ConverterDestinationDir !== "" ?
                    uiSettingsTools.settings.mp3ConverterDestinationDir :
                    firstDownloadPath());
    }

    function isUserChangedPath()
    {
        return destinationDir.text !== initialPath();
    }

    Component.onCompleted: {
        constantBitrateChecked = uiSettingsTools.settings.mp3ConverterConstantBitrateEnabled;
        constantBitrate.minBitrate = uiSettingsTools.settings.mp3ConverterConstantBitrate;
        constantBitrate.maxBitrate = uiSettingsTools.settings.mp3ConverterConstantBitrate;
        variableBitrate.minBitrate = uiSettingsTools.settings.mp3ConverterVariableMinBitrate;
        variableBitrate.maxBitrate = uiSettingsTools.settings.mp3ConverterVariableMaxBitrate;
        destinationDir.text = initialPath();
        constantBitrate.reloadCombo();
        variableBitrate.reloadCombo();
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
                    var minBitrate = constantBitrateChecked ? constantBitrate.minBitrate : variableBitrate.minBitrate;
                    var maxBitrate = constantBitrateChecked ? constantBitrate.maxBitrate : variableBitrate.maxBitrate;

                    App.downloads.mgr.convertFilesToMp3(downloadsIds, filesIndices, destinationDir.text, minBitrate, maxBitrate);

                    uiSettingsTools.settings.mp3ConverterConstantBitrateEnabled = constantBitrateChecked;
                    uiSettingsTools.settings.mp3ConverterConstantBitrate = constantBitrate.minBitrate;
                    uiSettingsTools.settings.mp3ConverterVariableMinBitrate = variableBitrate.minBitrate;
                    uiSettingsTools.settings.mp3ConverterVariableMaxBitrate = variableBitrate.maxBitrate;
                    if (isUserChangedPath())
                        uiSettingsTools.settings.mp3ConverterDestinationDir = destinationDir.text;
                    stackView.pop();
                }
            }
        }
    }
}
