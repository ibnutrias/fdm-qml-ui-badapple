import QtQuick
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.appfeatures
import "../../common/Tools"
import "../BaseElements"
import "../BaseElements/V2"

Item
{
    implicitWidth: ct.implicitWidth + ct.anchors.leftMargin + ct.anchors.rightMargin
    implicitHeight: ct.implicitHeight + ct.anchors.topMargin + ct.anchors.bottomMargin

    DownloadsItemTools2
    {
        id: downloadsItemTools
        itemId: model.id
        property bool locked: downloadsItemTools.lockReason != ""
        property double itemOpacity: downloadsItemTools.locked ? 0.4 : 1
    }

    Rectangle
    {
        visible: tapHandler.pressed

        anchors.fill: parent

        gradient: Gradient
        {
            orientation: Gradient.Horizontal
            GradientStop
            {
                position: 0.0
                color: appWindow.theme_v2.isLightTheme ?
                           appWindow.theme_v2.light800 :
                           appWindow.theme_v2.dark400
            }
            GradientStop
            {
                position: 1.0
                color: appWindow.theme_v2.bg100
            }
        }
    }

    RowLayout
    {
        id: ct

        anchors.fill: parent
        anchors.leftMargin: 15*appWindow.zoom
        anchors.rightMargin: 15*appWindow.zoom
        anchors.topMargin: 16*appWindow.zoom
        anchors.bottomMargin: 16*appWindow.zoom

        spacing: 0

        DownloadsViewItemActionButton_V2
        {
            showCheckmark: model.checked||false
        }

        Item {implicitWidth: 15*appWindow.zoom}

        ColumnLayout
        {
            Layout.fillWidth: true

            spacing: 3*appWindow.zoom

            BaseLabel
            {
                text: downloadsItemTools.titleSingleLine
                Layout.fillWidth: true
                elide: Text.ElideRight
                font: uicore.buildFont({weight: 500})
            }

            DownloadsViewItemSpeed_V2
            {
                visible: !statusItem.showDownloadProgress &&
                         downloadsItemTools.running &&
                         (downloadsItemTools.downloadSpeed > 0 || downloadsItemTools.uploadSpeed > 0)
                downloadSpeed: downloadsItemTools.downloadSpeed
                uploadSpeed: downloadsItemTools.uploadSpeed
                running: true
                priority: model.priority
            }

            DownloadsViewItemStatus_V2
            {
                id: statusItem
                Layout.fillWidth: true
            }
        }

        Item {implicitWidth: 8*appWindow.zoom}

        Item
        {
            implicitWidth: 20*appWindow.zoom
            implicitHeight: 20*appWindow.zoom
            Layout.fillHeight: true

            SvgImage_V2
            {
                source: Qt.resolvedUrl("menu_dots.svg")
                anchors.centerIn: parent
            }

            Item
            {
                anchors.fill: parent
                anchors.leftMargin: -8*appWindow.zoom
                anchors.rightMargin: -ct.anchors.rightMargin
                anchors.topMargin: -ct.anchors.topMargin
                anchors.bottomMargin: -ct.anchors.bottomMargin

                TapHandler
                {
                    gesturePolicy: TapHandler.WithinBounds

                    onTapped:
                    {
                        selectedDownloadsTools.currentDownloadId = model.id;
                        var component = Qt.createComponent(Qt.resolvedUrl("../DownloadsViewItemContextMenu.qml"));
                        var menu = component.createObject(parent, {
                                                              "modelIds": [model.id]
                                                          });
                            menu.open();
                            menu.aboutToHide.connect(function(){
                            menu.destroy();
                        });
                    }
                }
            }
        }
    }

    Rectangle
    {
        height: 1*appWindow.zoom
        width: parent.width
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: ct.anchors.leftMargin
        anchors.rightMargin: ct.anchors.rightMargin
        color: appWindow.theme_v2.separator
    }

    TapHandler
    {
        id: tapHandler

        gesturePolicy: TapHandler.WithinBounds

        onTapped:
        {
            if (model.checked)
            {
                model.checked = false;
            }
            else if (App.downloads.model.allCheckState == Qt.Checked ||
                     App.downloads.model.allCheckState == Qt.PartiallyChecked)
            {
                model.checked = !model.checked;
            }
            else
            {
                if (!App.rc.client.active && model.finished && !downloadsItemTools.isFolder) {
                    App.downloads.mgr.openDownload(downloadsItemTools.itemId, -1)
                } else if (!App.rc.client.active && model.finished && App.features.hasFeature(AppFeatures.OpenFolder) && downloadsItemTools.isFolder) {
                    App.downloads.mgr.openDownloadFolder(downloadsItemTools.itemId, -1);
                } else {
                    stackView.waPush(Qt.resolvedUrl("../DownloadItemPage/Page.qml"), {downloadItemId:downloadsItemTools.itemId});
                }
            }
        }

        onLongPressed:
        {
            if (!model.checked)
                model.checked = true;
        }
    }
}
