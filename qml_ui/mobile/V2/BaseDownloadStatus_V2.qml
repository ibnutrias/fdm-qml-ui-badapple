import QtQuick
import QtQuick.Layouts

ColumnLayout // it's just to define implicit size, not to do an actual layout
{
    readonly property bool showRunningStatus: downloadsItemTools.runningStatusText
    readonly property bool showError: !showRunningStatus && downloadsItemTools.showError
    readonly property bool showFinishedStatus: !showRunningStatus &&
                                               !showError &&
                                               downloadsItemTools.finishedStatusText

    readonly property bool showMiscStatus: showError ||
                                           showRunningStatus ||
                                           showFinishedStatus

    readonly property bool showDownloadProgress: !downloadsItemTools.finished &&
                                                 (downloadsItemTools.running || !showMiscStatus)


    spacing: 0
}
