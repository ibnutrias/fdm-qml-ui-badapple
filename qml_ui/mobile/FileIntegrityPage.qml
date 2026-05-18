import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.abstractdownloadsui 

import "BaseElements"
import "../common/Tools/"
import "../common/V2"

BasePage {
    id: root
    property var downloadModel
    property int fileIndex

    property bool verificationEnabled: currentHash.displayText != "" && userHash.displayText != ""
    property bool verificationOK: verificationEnabled && currentHash.displayText.toLowerCase() == userHash.displayText.toLowerCase().trim()

    title: qsTr("Check file integrity") + App.loc.emptyString

    goBackHandler: () => {
                       fileIntegrityTools.abortHashCalculating();
                       stackView.pop();
                   }

    BaseLabel {
        text: fileIntegrityTools.title + " (" + App.bytesAsText(fileIntegrityTools.size) + ")" + App.loc.emptyString
        Layout.fillWidth: true
        elide: Text.ElideMiddle
    }

    RowLayout
    {
        spacing: 5*appWindow.zoom

        BaseComboBox {
            id: hashCombo
            flat: true
            antialiasing: true
            font: uicore.buildFont({}, uicore.fontSizeV1(13)*appWindow.fontZoom)

            model: [
                {text: qsTr("MD5") + App.loc.emptyString, algorithm: AbstractDownloadsUi.Md5, hash: ""},
                {text: qsTr("SHA-1") + App.loc.emptyString, algorithm: AbstractDownloadsUi.Sha1, hash: ""},
                {text: qsTr("SHA-256") + App.loc.emptyString, algorithm: AbstractDownloadsUi.Sha256, hash: ""},
                {text: qsTr("SHA-512") + App.loc.emptyString, algorithm: AbstractDownloadsUi.Sha512, hash: ""}]

            onActivated: fileIntegrityTools.calculateHash(model[index].algorithm, model[index].hash)
            Component.onCompleted: fileIntegrityTools.calculateHash(model[currentIndex].algorithm, "")
        }

        BaseLabel
        {
            id: errorLabel
            color: appWindow.uiver === 1 ?
                       appWindow.theme.errorMessage :
                       appWindow.theme_v2.danger
            elide: Text.ElideRight
        }
    }

    ColumnLayout
    {
        spacing: 5*appWindow.zoom
        Layout.fillWidth: true

        BasePageLabel
        {
            text: qsTr("Hash") + App.loc.emptyString
        }

        BasePageLabel {
            id: perscentText
            visible: fileIntegrityTools.calculatingInProgress
            text: qsTr("Calculating %1\%").arg(Math.round(fileIntegrityTools.calculatingProgress)) + App.loc.emptyString
        }

        ProgressBar {
            id: progressbar_download
            visible: appWindow.uiver === 1 && fileIntegrityTools.calculatingInProgress
            from: 0
            to: 100
            value: fileIntegrityTools.calculatingProgress
            Layout.fillWidth: true
            Layout.preferredHeight: 4 //currentHash.height - perscentText.implicitHeight - 4
            LayoutMirroring.enabled: false

            background: Rectangle {
                anchors.fill: parent
                color: "#d9d9d9"
                radius: 0
            }

            contentItem: Item {
                anchors.fill: parent

                Rectangle {
                    width: progressbar_download.visualPosition * parent.width
                    height: parent.height
                    color: theme.accent
                }
            }
        }

        SlimProgressBar_V2
        {
            visible: appWindow.uiver !== 1 && fileIntegrityTools.calculatingInProgress
            from: 0
            to: 100
            value: fileIntegrityTools.calculatingProgress
            Layout.fillWidth: true
            Layout.preferredHeight: 4*appWindow.zoom
            radius: 2*appWindow.zoom
            running: visible
            bgColor: running ? appWindow.theme_v2.bg500 : appWindow.theme_v2.bg400
            progressColor: running ? appWindow.theme_v2.primary : appWindow.theme_v2.bg500
        }

        BaseTextField
        {
            id: currentHash
            visible: !fileIntegrityTools.calculatingInProgress
            Layout.fillWidth: true
            selectByMouse: true
            readOnly: true
            horizontalAlignment: Text.AlignLeft
        }
    }

    ColumnLayout
    {
        spacing: 5*appWindow.zoom
        Layout.fillWidth: true

        BasePageLabel
        {
            text: qsTr("Compare with") + App.loc.emptyString
        }

        BaseTextField
        {
            id: userHash
            Layout.fillWidth: true
            selectByMouse: true
            focus: true
            inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
            horizontalAlignment: Text.AlignLeft
        }
    }

    BaseLabel
    {
        visible: verificationEnabled
        color: appWindow.uiver === 1 ?
                   (verificationOK ? "#299100" : "#bc3737") :
                   (verificationOK ? appWindow.theme_v2.secondary : appWindow.theme_v2.danger)
        text: (verificationOK ? qsTr("Verification OK") : qsTr("Verification failed")) + App.loc.emptyString
    }

    Item {Layout.fillHeight: true}

    FileIntegrityTools {
        id: fileIntegrityTools
        downloadModel: root.downloadModel
        fileIndex: root.fileIndex
    }
}
