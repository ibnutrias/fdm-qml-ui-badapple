import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import "../BaseElements"

CenteredDialog {
    id: root

    property string currentPath
    property int currentTaskId: -1
    property bool ignoreAllMode: false
    property var taskQueue: []

    parent: Overlay.overlay

    closePolicy: Popup.NoAutoClose

    modal: true

    title: qsTr("Download deleting failed") + App.loc.emptyString

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
            text: qsTr("Try again") + App.loc.emptyString
            onClicked: tryAgainClicked()
        }

        BaseDialogButton
        {
            text: qsTr("Ignore") + App.loc.emptyString
            onClicked: ignoreClicked()
        }

        BaseDialogButton
        {
            text: qsTr("Ignore all") + App.loc.emptyString
            onClicked: ignoreAllClicked()
        }

        BaseDialogButton
        {
            text: qsTr("Abort") + App.loc.emptyString
            onClicked: abortClicked()
        }
    }

    onOpened: forceActiveFocus()
    onClosed: checkTaskQueue()

    Timer {
        id: ignoreAllTimer
        interval: 10000;
        running: false;
        repeat: false
        onTriggered: {
            ignoreAllMode = false;
        }
    }

    function checkTaskQueue() {
        if (taskQueue.length > 0) {
            var currentTask;
            if (ignoreAllMode) {
                while (currentTask = taskQueue.shift())
                {
                    ignoreAll(currentTask.taskId);
                }
            } else {
                currentTask = taskQueue.shift();
                currentTaskId = currentTask.taskId;
                currentPath = currentTask.path;
                root.open();
                return;
            }
        }
        currentTaskId = -1;
    }

    function tryAgainClicked() {
        ignoreAllMode = false;
        ignoreAllTimer.stop();
        App.filesOps.continueRemoveFiles(currentTaskId, false, false);
        root.close();
    }

    function ignoreClicked() {
        ignoreAllMode = false;
        ignoreAllTimer.stop();
        App.filesOps.continueRemoveFiles(currentTaskId, true, false);
        root.close();
    }

    function ignoreAllClicked() {
        ignoreAllMode = true;
        ignoreAllTimer.restart();
        ignoreAll(currentTaskId);
        root.close();
    }

    function ignoreAll(taskId) {
        App.filesOps.continueRemoveFiles(taskId, true, true);
    }

    function abortClicked() {
        console.log("abortClicked", currentTaskId);
        ignoreAllMode = false;
        ignoreAllTimer.stop();
        App.filesOps.abortRemoveFiles(currentTaskId);
        root.close();
    }

    Connections {
        target: App.filesOps
        onGotErrorRemovingFile: (taskId, path) => {
            if (ignoreAllMode) {
                ignoreAll(taskId);
            } else {
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
}
