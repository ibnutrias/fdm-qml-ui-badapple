import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import "../../common/Tools"
import "../BaseElements"

CenteredDialog
{
    id: root

    property var downloadIds: []
    property int singleMode: downloadIds.length == 1

    signal downloadsRemoved()

    parent: Overlay.overlay

    modal: true

    title: (singleMode ? qsTr("Delete this file?") : qsTr("Delete selected files?")) + App.loc.emptyString

    BaseDialogButtonsLayout
    {
        BaseDialogButton
        {
            text: (singleMode ? qsTr("OK") : qsTr("Delete files")) + App.loc.emptyString
            primary: true
            onClicked: {
                App.downloads.mgr.removeDownloads(downloadIds, true, App.downloads.mgr.supportsMoveFilesToTrash());
                root.close();
                downloadsRemoved();
            }
        }

        BaseDialogButton
        {
            visible: !singleMode
            text: qsTr("Remove from list") + App.loc.emptyString
            onClicked: {
                App.downloads.mgr.removeDownloads(downloadIds, false, false);
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
}
