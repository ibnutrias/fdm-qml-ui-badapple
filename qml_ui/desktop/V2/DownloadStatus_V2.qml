import QtQuick
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.abstractdownloadsui
import "../BaseElements"
import "../BaseElements/V2"
import "../../common/Tools"
import "../../common/V2"

Item
{
    id: root

    readonly property bool running: downloadsItemTools.indicatorInProgress
    readonly property bool unkSize: downloadsItemTools.infinityIndicator

    implicitWidth: p.visible ? p.implicitWidth : e.implicitWidth
    implicitHeight: p.visible ? p.implicitHeight : e.implicitHeight

    Error_V2
    {
        id: e
        visible: downloadsItemTools.showError
        error: downloadsItemTools.error
        anchors.fill: parent
    }

    RowLayout
    {
        id: p

        visible: !e.visible

        anchors.fill: parent

        spacing: 8*appWindow.zoom

        SlimProgressBar_V2
        {
            visible: downloadsItemTools.showProgressBar
            value: downloadsItemTools.progress
            indeterminate: unkSize
            running: root.running
            bgColor: appWindow.theme_v2.bg400
            progressColor: running ? appWindow.theme_v2.primary : appWindow.theme_v2.bg500
            progressGradient: (uicore.snailTools.isSnail && running) ? appWindow.theme_v2.snailOnGradient : null
            Layout.fillWidth: true
            Layout.maximumWidth: 524*appWindow.zoom
            Layout.preferredHeight: 16*appWindow.zoom
            radius: 4*appWindow.zoom
            zoom: appWindow.zoom
        }

        BaseLabel
        {
            visible: downloadsItemTools.showProgressBar && text
            text: unkSize ? downloadsItemTools.n_a : downloadsItemTools.progress + "%"
        }

        BaseLabel
        {
            visible: text
            text: {
                if (downloadsItemTools.runningStatusText)
                    return downloadsItemTools.runningStatusText;

                if (downloadsItemTools.queuedStatusText)
                    return downloadsItemTools.queuedStatusText;

                if (downloadsItemTools.finishedStatusText)
                    return downloadsItemTools.finishedStatusText;

                return "";
            }
        }

        BaseLabel
        {
            visible: downloadsItemTools.eta >= 0
            text: qsTr("Remaining") + ':' + App.loc.emptyString
            color: appWindow.theme_v2.bg700
        }

        BaseLabel
        {
            visible: downloadsItemTools.eta >= 0
            text: downloadsItemTools.etaText
            color: uicore.snailTools.isSnail ? appWindow.theme_v2.amber : appWindow.theme_v2.textColor
        }

        Item {Layout.fillWidth: true}
    }
}
