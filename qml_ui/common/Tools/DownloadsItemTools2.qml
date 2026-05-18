import QtQuick
import org.freedownloadmanager.fdm

DownloadsItemTools
{
    readonly property string runningStatusText:
        (performingLo ? loUiText :
        inCheckingFiles ? qsTr('Checking files') :
        inMergingFiles ? qsTr('Merging media streams') :
        inWaitingForMetadata ? qsTr("Requesting info") : "") + App.loc.emptyString

    readonly property string queuedStatusText: downloadsItemTools.inQueue ?
                                                   qsTr("Queued") + App.loc.emptyString :
                                                   ""

    readonly property string pausedStatusText: downloadsItemTools.inPause ?
                                                   qsTr("Stopped") + App.loc.emptyString :
                                                   ""

    readonly property string finishedStatusText: downloadsItemTools.finished ?
                                                     qsTr("Completed") + App.loc.emptyString :
                                                     ""

    readonly property bool showError: downloadsItemTools.inError &&
                                      !downloadsItemTools.runningStatusText

    readonly property bool showProgressBar: !finished || runningStatusText

    readonly property string n_a: qsTr("n/a") + App.loc.emptyString

    readonly property string etaText: eta >= 0 ?
                                          JsTools.timeUtils.remainingTime(eta) + App.loc.emptyString :
                                          ""

    readonly property string dateAddedText: added ?
                                                (App.loc.dateTimeToString_v2(added, false, false) + App.loc.emptyString + (uicore.minuteUpdate ? "" : "")) :
                                                ""

    readonly property string sizeText: (selectedSize != -1 ?
                                            App.bytesAsText(selectedSize) :
                                            bytesDownloaded > 0 ? App.bytesAsText(bytesDownloaded) + " +" :
                                                                  n_a) + App.loc.emptyString

}
