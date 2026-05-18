import QtQuick
import QtQuick.Layouts
import "../../BaseElements"
import "../../BaseElements/V2"
import "../../V2"
import "../../../common/V2"

BaseDownloadStatus_V2
{
    RowLayout
    {
        visible: showMiscStatus

        spacing: 0

        BaseErrorLabel
        {
            visible: showError
            error: downloadsItemTools.error
            Layout.fillWidth: true
        }

        RowLayout
        {
            visible: showRunningStatus

            spacing: 0
            Layout.fillWidth: true

            BaseLabel
            {
                text: downloadsItemTools.runningStatusText
                color: appWindow.theme_v2.primary
                font: uicore.buildFont({weight: Font.Medium}, 
                      (appWindow.theme_v2.fontSize-2)*appWindow.fontZoom)
            }

            BaseLabel
            {
                visible: !downloadsItemTools.infinityIndicator
                text: downloadsItemTools.progress + "%";
                font: uicore.buildFont({}, (appWindow.theme_v2.fontSize-2)*appWindow.fontZoom)
                Layout.leftMargin: 6
            }

            Item {implicitWidth: 6}

            Rectangle
            {
                visible: downloadsItemTools.performingLo &&
                         downloadsItemTools.loAbortable

                implicitWidth: 20
                implicitHeight: 20
                radius: 4
                color: appWindow.theme_v2.bg300_2

                SvgImage_V2
                {
                    source: Qt.resolvedUrl("../../V2/abort_lo.svg")
                    anchors.centerIn: parent
                }

                TapHandler
                {
                    gesturePolicy: TapHandler.WithinBounds
                    onTapped: downloadsItemTools.abortLo()
                }
            }

            Item {Layout.fillWidth: true}
        }
    }

    RowLayout
    {
        visible: showDownloadProgress

        Layout.fillWidth: true
        spacing: 4

        SlimProgressBar_V2
        {
            Layout.fillWidth: true
            Layout.preferredHeight: 8
            radius: 2
            value: downloadsItemTools.progress
            indeterminate: downloadsItemTools.infinityIndicator
            running: downloadsItemTools.indicatorInProgress
            bgColor: running ? appWindow.theme_v2.bg500 : appWindow.theme_v2.bg400
            progressColor: running ? appWindow.theme_v2.primary : appWindow.theme_v2.bg500
            progressGradient: (uicore.snailTools.isSnail && running) ? appWindow.theme_v2.snailOnGradient : null
        }

        BaseLabel
        {
            text: downloadsItemTools.progress + "%"
        }
    }
}
