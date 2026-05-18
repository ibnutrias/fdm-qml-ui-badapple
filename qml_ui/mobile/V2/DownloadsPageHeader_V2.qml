import QtQuick
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import "../BaseElements"
import "../BaseElements/V2"

ColumnLayout
{
    readonly property bool isSearchMode: state === "searchView"

    spacing: 0

    AppWindowHeader
    {
        Layout.fillWidth: true

        title: isSearchMode ? qsTr("Search") + App.loc.emptyString :
               envTools.downloadsAutoStartPreventReasonUiText ? envTools.downloadsAutoStartPreventReasonUiText :
               App.displayName

        state: (App.downloads.model.allCheckState == Qt.Checked || App.downloads.model.allCheckState == Qt.PartiallyChecked) ? showSelectedItemCount :
               isSearchMode ? showTitleWithBackButton :
               envTools.downloadsAutoStartPreventReasonUiText ? showTitleAsError :
               showTitle

        selectedItemCount: selectedDownloadsTools.checkedDownloadsCount

        onAbortSelection: App.downloads.model.checkAll(false)

        onGoBack: closeSearchMode()
    }

    Item
    {
        id: toolbar

        implicitHeight: Math.max(topPanelLayout.implicitHeight, playBtn.implicitHeight) + 4*2*appWindow.zoom
        Layout.fillWidth: true

        HalfRoundRect_V2
        {
            where: HalfRoundRect_V2.Where.Bottom
            color: uicore.snailTools.isSnail ?
                       appWindow.theme_v2.downloadsListToolbarBgColorInSnailMode :
                       appWindow.theme_v2.bgColor
            radius: 16*appWindow.zoom
            anchors.fill: parent
        }

        RowLayout
        {
            id: topPanelLayout
            x: appWindow.theme_v2.mainContentMargins*appWindow.zoom
            width: parent.width - x*2
            anchors.verticalCenter: parent.verticalCenter
            spacing: 8*appWindow.zoom

            AllDownloadsCheckBoxButton
            {
                id: allCb
                thAddRight: parent.spacing
                thAddTop: 8*appWindow.zoom
                thAddBottom: thAddTop
            }

            AllDownloadsSortModeButton
            {
                visible: !allCb.checked

                thAddTop: 8*appWindow.zoom
                thAddBottom: thAddTop

                Layout.fillWidth: true
                Layout.maximumWidth: Math.ceil(implicitWidth)
            }

            AllDownloadsFilterModeButton
            {
                visible: !allCb.checked

                thAddTop: 8*appWindow.zoom
                thAddBottom: thAddTop

                Layout.fillWidth: true
                Layout.maximumWidth: Math.ceil(implicitWidth)
            }

            ImageButton_V2
            {
                id: playBtn

                visible: allCb.checked

                enabled: selectedDownloadsTools.checkedDownloadsToStartExist

                source: Qt.resolvedUrl("play_circle.svg")
                onClicked: selectedDownloadsTools.startCheckedDownloads()
            }

            ImageButton_V2
            {
                visible: allCb.checked

                enabled: selectedDownloadsTools.checkedDownloadsToStopExist

                source: Qt.resolvedUrl("pause_circle.svg")
                onClicked: selectedDownloadsTools.stopCheckedDownloads()
            }

            ImageButton_V2
            {
                visible: allCb.checked

                enabled: !selectedDownloadsTools.selectedDownloadsIsLocked() &&
                         selectedDownloadsTools.checkedDownloadsCount > 0

                source: Qt.resolvedUrl("delete.svg")

                onClicked: {
                    deleteDownloadsDialog.downloadIds = App.downloads.model.checkedIds;
                    deleteDownloadsDialog.open();
                }
            }

            ImageButton_V2
            {
                visible: allCb.checked &&
                         !App.rc.client.active

                enabled: !selectedDownloadsTools.selectedDownloadsIsLocked() &&
                         selectedDownloadsTools.checkMoveAllowed()

                source: Qt.resolvedUrl("file_move.svg")

                onClicked: stackView.waPush(filePicker.filePickerPageComponent,
                                            {initiator: "fileMoving",
                                                downloadId: App.downloads.model.checkedIds[0]});
            }

            ImageButton_V2
            {
                visible: allCb.checked

                enabled: selectedDownloadsTools.checkedDownloadsCount > 1

                source: Qt.resolvedUrl("menu_dots.svg")

                onClicked: {
                    let component = Qt.createComponent(Qt.resolvedUrl("../DownloadsViewItemContextMenu.qml"));
                    let menu = component.createObject(this, {
                                                          "modelIds": selectedDownloadsTools.getCurrentDownloadIds()
                                                      });
                    menu.open();
                    menu.aboutToHide.connect(function(){
                        menu.destroy();
                    });
                }
            }

            Item {Layout.fillWidth: true}

            TumButton_V2 {}
        }
    }
}
