import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import "../BaseElements"
import "../../common/Tools"

CenteredDialog {
    id: root

    parent: Overlay.overlay

    modal: true

    title: qsTr("Remote resource changed") + App.loc.emptyString

    signal remoteResourceChanged(int id)
    onRemoteResourceChanged: (id) => downloadsListModel.append({'id': id});

    BaseFontMetrics
    {
        id: fm
    }

    ListView {
        id: downloadsList
        clip: true
        Layout.fillWidth: true
        Layout.maximumWidth: root.ctMaxWidth
        Layout.preferredHeight: Math.min(contentHeight, 150)
        ScrollBar.vertical: ScrollBar {
            active: parent.contentHeight > 150
        }
        model: ListModel {
            id: downloadsListModel
        }

        implicitWidth: {
            let r = 0;
            for (let i = 0; i < downloadsListModel.count; ++i) {
                r = Math.max(r, fm.advanceWidth(displayPath(downloadsListModel.get(i).id)));
            }
            return r + fm.font.pixelSize*fm.font.pointSize*0;
        }

        delegate: BaseLabel {
            width: parent.width
            elide: Text.ElideMiddle
            color: appWindow.uiver === 1 ?
                       "#737373" :
                       appWindow.theme_v2.textColor2
            text: index < downloadsListModel.count ?
                      displayPath(downloadsListModel.get(index).id) :
                      ""
        }
    }

    BaseCheckBox {
        id: rememberField
        text: qsTr("Always re-download") + App.loc.emptyString
    }

    BaseDialogButtonsLayout 
    {
        BaseDialogButton
        {
            text: qsTr("Re-download") + App.loc.emptyString
            primary: true
            onClicked: redownloadClicked()
        }

        BaseDialogButton
        {
            text: qsTr("Cancel") + App.loc.emptyString
            onClicked: cancelClicked()
        }
    }

    onOpened: forceActiveFocus()
    onClosed: {
        downloadsListModel.clear();
    }

    function redownloadClicked() {
        if (rememberField.checked) {
            App.settings.dmcore.setValue(DmCoreSettings.AutoRestartFinishedDownloadIfRemoteResourceChanged,
                                         App.settings.fromBool(true));
        }

        for (let i = 0; i < downloadsListModel.count; ++i) {
            App.downloads.mgr.restartDownload(downloadsListModel.get(i).id);
        }
        root.close();
    }

    function cancelClicked() {
        root.close();
    }

    function displayPath(id) {
        let info = App.downloads.infos.info(id);
        if (!info)
            return "";
        return info.hasChildDownloads ?
                    info.destinationPath :
                    info.destinationPath + '/' + info.title;
    }
}
