import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.abstractdownloadsui 
import "../BaseElements"

CenteredDialog
{
    id: root

    closePolicy: Popup.NoAutoClose

    property int taskId
    property var files: []

    parent: Overlay.overlay

    modal: true

    title: qsTr("Destination files already exists") + App.loc.emptyString

    Flickable
    {
        clip: true

        Layout.fillWidth: true
        Layout.maximumWidth: ctMaxWidth
        Layout.fillHeight: true

        contentHeight: filesLabel.contentHeight

        implicitHeight: filesLabel.implicitHeight
        implicitWidth: filesLabel.implicitWidth

        BaseLabel
        {
            id: filesLabel
            text: files.join("\n")
            width: parent.width
            elide: Text.ElideMiddle
        }

        ScrollBar.vertical: ScrollBar {}
    }

    BaseDialogButtonsLayout
    {
        BaseDialogButton
        {
            text: qsTr("Overwrite All") + App.loc.emptyString
            onClicked: doRespond(Array(files.length).fill(AbstractDownloadsUi.ExistingFileOverwrite))
        }

        BaseDialogButton
        {
            text: qsTr("Rename All") + App.loc.emptyString
            onClicked: doRespond(Array(files.length).fill(AbstractDownloadsUi.ExistingFileRename))
        }

        BaseDialogButton
        {
            text: qsTr("Skip All") + App.loc.emptyString
            onClicked: doRespond(Array(files.length).fill(AbstractDownloadsUi.ExistingFileSkip))
        }

        BaseDialogButton
        {
            text: qsTr("Abort") + App.loc.emptyString
            onClicked: {
                App.downloads.mgr.sumbitConvertFilesExistsReaction(taskId, [], true);
                root.close();
            }
        }
    }

    function doRespond(of)
    {
        App.downloads.mgr.sumbitConvertFilesExistsReaction(taskId, of, false);
        root.close();
    }
}
