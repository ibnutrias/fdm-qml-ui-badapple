import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import QtQuick.Controls.Material
import org.freedownloadmanager.fdm
import "../common/Tools"
import "BaseElements"
import "BaseElements/V2"


Page {
    id: root

    property string pageName: "BuildDownloadPage"
    property var downloadRequest

    readonly property bool showReportProblem: downloadTools.lastFailedRequestId !== -1 && (downloadTools.statusWarning || downloadTools.lastError) && downloadTools.allowedToReportLastError

    header: Loader
    {
        source: Qt.resolvedUrl(appWindow.uiver === 1 ?
                                   "BuildDownloadPageHeader.qml" :
                                   "V2/BuildDownloadPageHeader_V2.qml")
    }

    ColumnLayout
    {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top

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
            Layout.fillWidth: true

            spacing: 2

            BasePageLabel
            {
                text: App.cfg.cdEnterUrlText + App.loc.emptyString
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                font: uicore.buildFont({}, uicore.fontSizeV1(16*appWindow.fontZoom))
            }

            RowLayout
            {
                Layout.fillWidth: true

                BaseTextField
                {
                    id: url
                    Layout.fillWidth: true
                    Layout.maximumHeight: 300*appWindow.fontZoom
                    selectByMouse: true
                    focus: true
                    text: downloadTools.urlText
                    onDisplayTextChanged: downloadTools.onUrlTextChanged(displayText)
                    enabled: !downloadTools.buildingDownload && !downloadTools.buildingDownloadFinished
                    onAccepted: downloadTools.doOK()
                    inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
                    wrapMode: TextInput.WrapAnywhere
                    horizontalAlignment: Label.AlignLeft
                }

                DialogFlatButton
                {
                    visible: App.cfg.cdShowOpenFileBtn
                    onClicked: openFileDlg.open()
                    iconSource: Qt.resolvedUrl(appWindow.uiver === 1 ?
                                                   "../images/download-item/folder.svg" :
                                                   "V2/open_folder.svg")
                }
            }
        }

        RowLayout
        {
            Layout.fillWidth: true
            height: 40

            BusyIndicator
            {
                visible: downloadTools.buildingDownload
                running: downloadTools.buildingDownload
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredHeight: 30*appWindow.zoom
                Layout.preferredWidth: 30*appWindow.zoom
            }

            BaseLabel
            {
                visible: !downloadTools.lastError
                text: downloadTools.statusText
                color: appWindow.uiver === 1 ?
                           (downloadTools.statusWarning ? appWindow.theme.errorMessage : appWindow.theme.successMessage) :
                           (downloadTools.statusWarning ? appWindow.theme_v2.danger : appWindow.theme_v2.secondary)
                Layout.alignment: Qt.AlignVCenter
                Layout.fillWidth: true
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                font: uicore.buildFont({}, uicore.fontSizeV1(16*appWindow.fontZoom))
            }

            BaseErrorLabel
            {
                visible: downloadTools.lastError
                error: downloadTools.lastError
                shortVersion: false
                showIcon: false
                resourceUrl: App.tools.urlFromUserInput(downloadTools.urlText)
                Layout.alignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }
        }

        DialogFlatButton
        {
            visible: showReportProblem

            text: qsTr("Report problem") + App.loc.emptyString

            primary: true

            iconSource: Qt.resolvedUrl(appWindow.uiver === 1 ?
                                           "../images/mobile/bug_report.svg" :
                                           "V2/bug_report.svg")
            iconWidth: 14
            iconHeight: iconWidth

            Layout.minimumHeight: appWindow.uiver === 1 ? 48 : 40*appWindow.zoom
            Layout.preferredWidth: appWindow.uiver === 1 ? implicitWidth + 10*2 : implicitWidth
            Layout.fillWidth: appWindow.uiver !== 1

            Layout.alignment: Qt.AlignHCenter
            onClicked: privacyDlg.open(downloadTools.lastFailedRequestId)
        }

        DialogFlatButton_V2
        {
            visible: appWindow.uiver !== 1 && (!showReportProblem || downloadTools.canIgnoreError())
            text: qsTr("Download") + App.loc.emptyString
            enabled: url.text.length > 0 && (!downloadTools.failed() || downloadTools.canIgnoreError())
            primary: true
            onClicked: url.accepted()
            Layout.fillWidth: true
            Layout.minimumHeight: 40*appWindow.zoom
        }
    }

    FileDialog
    {
        id: openFileDlg
        nameFilters: App.cfg.cdOpenFileDlgNameFilters ? App.cfg.cdOpenFileDlgNameFilters : ["*"]
        fileMode: FileDialog.OpenFile
        flags: FileDialog.ReadOnly
        onAccepted: {
            url.text = selectedFile;
            url.accepted();
        }
    }

    function resetUi()
    {
        url.text = "";
        var text = App.clipboard.text;
        if (text)
        {
            urlTools.checkIfAcceptableUrl(text, function(acceptable, modulesUids, urlDescriptions, downloadsTypes){
                if (acceptable) {
                    url.text = text;
                    url.selectAll();
                }
                url.forceActiveFocus();
            });
        }
        else
        {
            url.forceActiveFocus();
        }
    }

    Component.onCompleted: {
        if (downloadRequest) {
            downloadTools.newDownloadByRequest(downloadRequest);
        } else {
            resetUi();
        }
    }

    BuildDownloadTools {
        id: downloadTools
        onCreateDownloadBeforeRequest: {
            appWindow.newDownloadAdded();
            stackView.pop();
        }
        onCreateRequestSuccess: (id) => {
            stackView.replace('TuneAndAddDownloadPage.qml', {requestId:id});
        }
        onReject: {
            stackView.pop();
        }
    }

    AcceptableUrlTool {
        id: urlTools
    }

    Connections {
        target: appWindow
        onReportError: (failedId) => {
            if (failedId == downloadTools.lastFailedRequestId) {
                downloadTools.doReject();
            }
        }
    }
}
