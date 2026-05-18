import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.abstractdownloadsui
import "../../BaseElements"
import "../../BaseElements/V2"
import "../../../common/V2"

Item
{
    required property var info
    property bool createDownloadDialog: false

    readonly property var myModel: info && info.filesCount > 1 ?
                                       info.filesTreeListModel() :
                                       null

    implicitWidth: ct.implicitWidth
    implicitHeight: ct.implicitHeight

    FontMetrics
    {
        id: fm12
        font: uicore.buildFont({}, (appWindow.theme_v2.fontSize-1)*appWindow.fontZoom)
    }

    ColumnLayout
    {
        id: ct

        anchors.fill: parent

        spacing: 0

        Item {implicitWidth: 8*appWindow.zoom}

        RowLayout
        {
            id: header

            Layout.fillWidth: true

            spacing: 16*appWindow.zoom

            FilesTabTablesHeaderItem_V2
            {
                id: nameItem
                text: qsTr("Name") + App.loc.emptyString
                sortBy: AbstractDownloadsUi.SortByName
                Layout.fillWidth: true
                Layout.minimumWidth: 100*appWindow.zoom
            }

            FilesTabTablesHeaderItem_V2
            {
                id: priorityItem
                text: qsTr("Priority") + App.loc.emptyString
                sortBy: AbstractDownloadsUi.SortByPriority
                Layout.minimumWidth: Math.max(
                                         fm12.advanceWidth(uicore.priorityText(AbstractDownloadsUi.DownloadPriorityHigh)),
                                         fm12.advanceWidth(uicore.priorityText(AbstractDownloadsUi.DownloadPriorityNormal)),
                                         fm12.advanceWidth(uicore.priorityText(AbstractDownloadsUi.DownloadPriorityLow) + App.loc.emptyString)) +
                                     2*8*appWindow.zoom
            }
        }

        Item {implicitHeight: 8*appWindow.zoom}

        ListViewItemSeparator_V2
        {
            Layout.fillWidth: true
        }

        ListView
        {
            id: lv

            model: myModel

            Layout.fillWidth: true
            Layout.fillHeight: true

            ScrollBar.vertical: ScrollBar{}

            flickableDirection: Flickable.AutoFlickIfNeeded
            boundsBehavior: Flickable.StopAtBounds

            clip: true

            delegate: Item
            {
                width: lv.width
                implicitHeight: lvItemCt.implicitHeight

                ColumnLayout
                {
                    id: lvItemCt

                    anchors.fill: parent
                    spacing: 0

                    Item {implicitHeight: 8*appWindow.zoom}

                    RowLayout
                    {
                        Layout.fillWidth: true

                        spacing: header.spacing

                        RowLayout
                        {
                            Layout.preferredWidth: nameItem.width
                            spacing: 0

                            Item
                            {
                                //left padding by levels
                                implicitWidth: (model.level + (model.folder ? 0 : 1)) * 16*appWindow.zoom
                            }

                            Item
                            {
                                Layout.alignment: Qt.AlignTop
                                Layout.preferredHeight: 16*appWindow.zoom
                                Layout.preferredWidth: 8*appWindow.zoom

                                SvgImage_V2
                                {
                                    visible: model.folder
                                    source: Qt.resolvedUrl(model.isOpened ? "arrow_drop_down.svg" : "arrow_drop_right.svg")
                                    anchors.centerIn: parent
                                }
                            }

                            Item {implicitWidth: 8*appWindow.zoom}

                            BaseCheckBox
                            {
                                Layout.alignment: Qt.AlignTop
                                checked: model.priority !== AbstractDownloadsUi.DownloadPriorityDontDownload
                                onClicked: {
                                    model.priority = checked ?
                                                AbstractDownloadsUi.DownloadPriorityNormal :
                                                AbstractDownloadsUi.DownloadPriorityDontDownload;
                                }
                            }

                            Item {implicitWidth: 8*appWindow.zoom}

                            ColumnLayout
                            {
                                Layout.fillWidth: true

                                BaseLabel
                                {
                                    text: model.name
                                    wrapMode: Text.Wrap
                                    font: fm12.font
                                    Layout.fillWidth: true
                                }

                                RowLayout
                                {
                                    spacing: 8*appWindow.zoom
                                    Layout.fillWidth: true

                                    BaseLabel
                                    {
                                        text: App.bytesAsText(model.selectedSize) + App.loc.emptyString
                                        font: uicore.buildFont({}, (appWindow.theme_v2.fontSize-2)*appWindow.fontZoom)
                                    }

                                    SlimProgressBar_V2
                                    {
                                        visible: !createDownloadDialog
                                        Layout.fillWidth: true
                                        radius: 2
                                        value: model.progress
                                        indeterminate: false
                                        running: !createDownloadDialog && downloadsItemTools.indicatorInProgress
                                        bgColor: running ? appWindow.theme_v2.bg500 : appWindow.theme_v2.bg400
                                        progressColor: running ? appWindow.theme_v2.primary : appWindow.theme_v2.bg500
                                        progressGradient: (uicore.snailTools.isSnail && running) ? appWindow.theme_v2.snailOnGradient : null
                                    }

                                    BaseLabel
                                    {
                                        visible: !createDownloadDialog
                                        text: model.progress + '%'
                                        font: uicore.buildFont({}, (appWindow.theme_v2.fontSize-2)*appWindow.fontZoom)
                                    }
                                }
                            }

                            Item {Layout.fillWidth: true}
                        }

                        Item
                        {
                            Layout.preferredWidth: priorityItem.width
                            Layout.alignment: Qt.AlignTop

                            implicitHeight: priorityBtn.implicitHeight

                            FilesTreeItemPriorityButton_V2
                            {
                                id: priorityBtn

                                visible: model.priority !== AbstractDownloadsUi.DownloadPriorityDontDownload &&
                                         model.priority !== AbstractDownloadsUi.DownloadPriorityUnknown

                                anchors.fill: parent
                            }

                        }
                    }

                    Item {implicitHeight: 8*appWindow.zoom}

                    ListViewItemSeparator_V2
                    {
                        Layout.fillWidth: true
                    }
                }

                TapHandler
                {
                    gesturePolicy: TapHandler.WithinBounds
                    onTapped:
                    {
                        if (model.folder)
                            model.isOpened = !model.isOpened;
                    }
                    onLongPressed:
                    {
                        var component = Qt.createComponent("../FilesTreeContextMenu.qml");
                        var menu = component.createObject(parent, {
                                                              "model": model,
                                                              "downloadItemId" : info.id,
                                                              "downloadModel" : info,
                                                              "finished": (info.id && !model.folder) ? info.fileInfo(model.fileIndex).finished : false,
                                                              "locked": info.lockReason !== ""
                                                          });
                        menu.x = point.position.x;
                        menu.y = point.position.y;
                        menu.currentIndex = -1; // bug under Android workaround
                        menu.open();
                        menu.aboutToHide.connect(function(){
                            menu.destroy();
                        });
                    }
                }
            }
        }
    }
}
