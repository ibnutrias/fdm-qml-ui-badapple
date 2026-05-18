import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.appfeatures
import "../../../common/Tools"
import "../../../common/V2"
import "../../"
import "../../BaseElements"
import "../../../common"
import "../../V2"

Flickable
{
    id: root

    flickableDirection: Flickable.VerticalFlick
    ScrollIndicator.vertical: ScrollIndicator { }
    boundsBehavior: Flickable.StopAtBounds

    contentHeight: Math.max(ct.implicitHeight, parent.height)

    ColumnLayout
    {
        id: ct

        width: parent.width
        height: Math.max(implicitHeight, parent.height)

        spacing: 0

        RowLayout
        {
            Layout.fillWidth: true
            spacing: 15*appWindow.zoom

            DownloadPreviewImage
            {
                id: previewImg
                downloadId: downloadsItemTools.itemId
                supposedWidth: 78*appWindow.zoom
                supposedHeight: 78*appWindow.zoom
                minimumHeight: supposedHeight/2
                folderImageUrl: Qt.resolvedUrl("folder.svg")
                Layout.alignment: Qt.AlignTop
            }

            ColumnLayout
            {
                Layout.fillWidth: true

                BaseLabel
                {
                    text: downloadsItemTools.title
                    Layout.fillWidth: true
                    wrapMode: Text.Wrap
                    Layout.topMargin: -5*appWindow.fontZoom
                }

                DownloadStatus_V2
                {
                    Layout.fillWidth: true
                }
            }
        }

        Item {implicitHeight: 24*appWindow.zoom}

        ColumnLayout
        {
            spacing: 16*appWindow.zoom

            NameValueText_V2
            {
                visible: downloadsItemTools.eta >= 0
                name: qsTr("Remaining") + ':' + App.loc.emptyString
                value: downloadsItemTools.etaText
                Layout.fillWidth: true
            }

            NameValueText_V2
            {
                name: qsTr("Downloaded:") + App.loc.emptyString
                value: (downloadsItemTools.finished || downloadsItemTools.unknownFileSize ?
                            App.bytesAsText(downloadsItemTools.selectedBytesDownloaded) :
                            "%1 / %2".arg(App.bytesAsText(downloadsItemTools.selectedBytesDownloaded)).arg(App.bytesAsText(downloadsItemTools.selectedSize))
                        ) + App.loc.emptyString
                Layout.fillWidth: true
            }

            NameValueText_V2
            {
                visible: downloadsItemTools.showDownloadSpeed
                name: qsTr("Download speed:") + App.loc.emptyString
                value: App.speedAsText(downloadsItemTools.downloadSpeed) + App.loc.emptyString
                Layout.fillWidth: true
            }

            NameValueText_V2
            {
                visible: downloadsItemTools.canUpload
                name: qsTr("Uploaded") + ':' + App.loc.emptyString
                value: App.bytesAsText(downloadsItemTools.bytesUploaded) +
                       " (" + qsTr("ratio") + ": " + downloadsItemTools.ratioText + ")" +
                       App.loc.emptyString
                Layout.fillWidth: true
            }

            NameValueText_V2
            {
                visible: downloadsItemTools.showUploadSpeed
                name: qsTr("Upload speed:") + App.loc.emptyString
                value: App.speedAsText(downloadsItemTools.uploadSpeed) + App.loc.emptyString
                Layout.fillWidth: true
            }

            NameValueText_V2
            {
                name: qsTr("Added at:") + App.loc.emptyString
                value: downloadsItemTools.added ?
                           App.loc.dateTimeToString_v2(downloadsItemTools.added, true, true) + App.loc.emptyString :
                           ""
                Layout.fillWidth: true
            }

            NameValueText_V2
            {
                name: qsTr("Saved in") + ':' + App.loc.emptyString
                value: downloadsItemTools.destinationPath
                valueWrapMode: Text.Wrap
                valueElide: Text.ElideNone
                Layout.fillWidth: true
            }

            NameValueText_V2
            {
                visible: downloadsItemTools.webPageUrl
                name: qsTr("Web page") + ':' + App.loc.emptyString
                value: "<a href='" + downloadsItemTools.webPageUrl + "'>" + downloadsItemTools.webPageUrl + "</a>"
                Layout.fillWidth: true
                onLinkActivated: url => App.openDownloadUrl(url)
            }

            NameValueText_V2
            {
                visible: downloadsItemTools.resourceUrl
                name: qsTr("File") + ':' + App.loc.emptyString
                value: "<a href='" + downloadsItemTools.resourceUrl + "'>" + downloadsItemTools.resourceUrl + "</a>"
                Layout.fillWidth: true
                onLinkActivated: url => App.openDownloadUrl(url)
            }
        }

        Item {implicitHeight: 20*appWindow.zoom}

        Rectangle
        {
            implicitHeight: 1*appWindow.zoom
            Layout.fillWidth: true
            color: appWindow.theme_v2.separator
        }

        Item {implicitHeight: 12*appWindow.zoom}

        NameValueText_V2
        {
            name: qsTr("Priority") + ':' + App.loc.emptyString
            value: "<a href='#'>" + uicore.priorityText(downloadsItemTools.item.priority).toLowerCase() + App.loc.emptyString + "</a>"
            onLinkActivated: priorityMenu.open()

            BaseMenu
            {
                id: priorityMenu

                Repeater
                {
                    model: uicore.allPriorities

                    BaseMenuItem
                    {
                        required property int modelData
                        text: uicore.priorityText(modelData) + App.loc.emptyString
                        checkable: true
                        checked: downloadsItemTools.item.priority === modelData
                        onClicked: downloadsItemTools.item.priority = modelData
                    }
                }
            }
        }

        Item {implicitHeight: 12*appWindow.zoom}

        Rectangle
        {
            implicitHeight: 1*appWindow.zoom
            Layout.fillWidth: true
            color: appWindow.theme_v2.separator
        }

        Item {implicitHeight: 20*appWindow.zoom}

        NameValueText_V2
        {
            name: qsTr("Progress") + ':' + App.loc.emptyString
            value: ""
        }

        Item {implicitHeight: 8*appWindow.zoom}

        ProgressMapControl
        {
            readonly property var mapObj: App.downloads.infos.info(downloadsItemTools.itemId).progressMap(columnsCount*rowsCount)
            map: mapObj.map
            zoom: appWindow.zoom
            Layout.minimumHeight: 50*appWindow.zoom
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
