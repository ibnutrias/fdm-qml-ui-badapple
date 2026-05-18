import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import "../BaseElements"

CenteredDialog {
    id: root

    property string currentPath
    property int currentTaskId: -1
    property var taskQueue: []

    parent: Overlay.overlay

    closePolicy: Popup.NoAutoClose

    modal: true

    title: qsTr("Extraneous files are detected") + App.loc.emptyString

    BaseLabel
    {
        text: qsTr("The following folder contains extraneous files. Do you still want to delete it?") +
              App.loc.emptyString
        Layout.fillWidth: true
        Layout.maximumWidth: ctMaxWidth
        wrapMode: Text.WordWrap
    }

    BaseLabel
    {
        text: currentPath
        Layout.fillWidth: true
        Layout.maximumWidth: ctMaxWidth
        elide: Text.ElideMiddle
    }

    BaseDialogButtonsLayout
    {
        BaseDialogButton
        {
            text: qsTr("Delete anyway") + App.loc.emptyString
            primary: true
            onClicked: continueClicked()
        }

        BaseDialogButton
        {
            text: qsTr("Cancel") + App.loc.emptyString
            onClicked: abortClicked()
        }
    }

    onOpened: forceActiveFocus()
    onClosed: checkTaskQueue()

    function checkTaskQueue() {
        if (taskQueue.length > 0) {
            let currentTask = taskQueue.shift();
            currentTaskId = currentTask.taskId;
            currentPath = currentTask.path;
            root.open();
        }
        else {
            currentTaskId = -1;
        }
    }

    function continueClicked() {
        App.filesOps.continueRemoveFiles(currentTaskId, false, false);
        root.close();
    }

    function abortClicked() {
        App.filesOps.abortRemoveFiles(currentTaskId);
        root.close();
    }

    Connections {
        target: App.filesOps
        onExtraneousFilesDetected: (taskId, path) => {
                   if (currentTaskId !== -1) {
                        taskQueue.push({'taskId': taskId, 'path': path});
                   } else {
                        currentTaskId = taskId;
                        currentPath = path;
                        root.open();
                   }
        }
    }
}
