import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import "../../common/Tools"
import "../BaseElements"

CenteredDialog {
    id: root

    property var downloadIds: []
    property int singleMode: downloadIds.length == 1

    signal downloadsRemoved()

    parent: Overlay.overlay

    modal: true

    BaseFontMetrics
    {
        id: fm
    }

    title: (singleMode ? qsTr("This download can't be resumed after pausing") : qsTr("The download(s) below can't be resumed after pausing")) + App.loc.emptyString

    ListView
    {
        id: listView
        clip: true
        implicitWidth: {
            let r = 0;
            for (let i = 0; i < root.downloadIds.length; ++i) {
                r = Math.max(r, fm.advanceWidth(displayPath(root.downloadIds[i])));
            }
            return r + fm.font.pixelSize*fm.font.pointSize*0;
        }
        Layout.fillWidth: true
        Layout.maximumWidth: root.ctMaxWidth
        Layout.preferredHeight: Math.min(contentHeight, 150)
        ScrollBar.vertical: ScrollBar {
            active: parent.contentHeight > 150
        }
        model: root.downloadIds
        delegate: BaseLabel {
            width: parent.width
            elide: Text.ElideMiddle
            color: appWindow.uiver === 1 ?
                       "#737373" :
                       appWindow.theme_v2.textColor2
            text: displayPath(root.downloadIds[index])
        }
    }

    BaseDialogButtonsLayout
    {
        BaseDialogButton
        {
            text: qsTr("Pause") + App.loc.emptyString
            primary: true
            onClicked: {
                selectedDownloadsTools.stopByIds(downloadIds);
                root.close();
                downloadsRemoved();
            }
        }

        BaseDialogButton
        {
            text: qsTr("Cancel") + App.loc.emptyString
            onClicked: root.close()
        }
    }

    function show(ids)
    {
        console.log("show(ids)", ids);
        root.downloadIds = ids;
        root.open();
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
