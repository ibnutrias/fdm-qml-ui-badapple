import QtQuick
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import "../BaseElements"
import "../BaseElements/V2"
import "../../common/Tools"
import "../../common/V2"

ColumnLayout
{
    spacing: 3*appWindow.zoom

    RowLayout
    {
        spacing: 0

        DownloadsViewItemSpeed_V2
        {
            downloadSpeed: downloadsItemTools.downloadSpeed
            uploadSpeed: downloadsItemTools.uploadSpeed
            running: model.running
            priority: model.priority
        }

        BaseLabel
        {
            visible: (!downloadsItemTools.finished && !downloadsItemTools.canBeRestarted) ||
                     downloadsItemTools.performingLo
            text: {
                if (downloadsItemTools.pausedStatusText)
                    return downloadsItemTools.pausedStatusText.toLowerCase();

                if (downloadsItemTools.queuedStatusText)
                    return downloadsItemTools.queuedStatusText.toLowerCase();

                if (downloadsItemTools.infinityIndicator)
                    return downloadsItemTools.n_a;

                let result = downloadsItemTools.progress + "%";

                if (downloadsItemTools.etaText)
                    result += " (~ " + downloadsItemTools.etaText + ")";

                return result;
            }

            font: uicore.buildFont({}, (appWindow.theme_v2.fontSize-2)*appWindow.fontZoom)
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignRight
        }
    }

    SlimProgressBar_V2
    {
        Layout.fillWidth: true
        radius: 2*appWindow.zoom
        value: downloadsItemTools.progress
        indeterminate: downloadsItemTools.infinityIndicator
        running: downloadsItemTools.indicatorInProgress
        bgColor: running ? appWindow.theme_v2.bg500 : appWindow.theme_v2.bg400
        progressColor: running ? appWindow.theme_v2.primary : appWindow.theme_v2.bg500
        progressGradient: (uicore.snailTools.isSnail && running) ? appWindow.theme_v2.snailOnGradient : null
    }
}
