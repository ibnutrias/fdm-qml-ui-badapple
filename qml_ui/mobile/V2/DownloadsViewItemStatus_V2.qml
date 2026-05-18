import QtQuick
import QtQuick.Layouts
import "../BaseElements"
import "../BaseElements/V2"

BaseDownloadStatus_V2
{
    RowLayout
    {
        visible: showMiscStatus

        Layout.fillWidth: true

        spacing: 8*appWindow.zoom

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
                Layout.leftMargin: 6*appWindow.zoom
            }

            Item {implicitWidth: 6}

            Rectangle
            {
                visible: downloadsItemTools.performingLo &&
                         downloadsItemTools.loAbortable

                implicitWidth: 20*appWindow.zoom
                implicitHeight: 20*appWindow.zoom
                radius: 4*appWindow.zoom
                color: appWindow.theme_v2.bg300_2

                SvgImage_V2
                {
                    source: Qt.resolvedUrl("abort_lo.svg")
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

        RowLayout
        {
            visible: showFinishedStatus

            spacing: 0
            Layout.fillWidth: true

            BaseLabel
            {
                text: downloadsItemTools.finishedStatusText
                color: appWindow.theme_v2.primary
                font: uicore.buildFont({weight: Font.Medium}, 
                                       (appWindow.theme_v2.fontSize-2)*appWindow.fontZoom)
            }

            Item
            {
                implicitHeight: 12*appWindow.zoom
                implicitWidth: (6*2+1)*appWindow.zoom
                Rectangle
                {
                    width: 1*appWindow.zoom
                    height: parent.height
                    color: appWindow.theme_v2.bg500
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            BaseLabel
            {
                text: downloadsItemTools.sizeText
                font: uicore.buildFont({}, (appWindow.theme_v2.fontSize-2)*appWindow.fontZoom)
            }

            Item {Layout.fillWidth: true}
        }

        BaseLabel
        {
            visible: (downloadsItemTools.showError ||
                     downloadsItemTools.finishedStatusText) &&
                     !downloadsItemTools.runningStatusText

            text: downloadsItemTools.dateAddedText

            font: uicore.buildFont({}, (appWindow.theme_v2.fontSize-2)*appWindow.fontZoom)

            Layout.fillWidth: true
            Layout.maximumWidth: Math.ceil(implicitWidth)
            elide: Text.ElideRight
        }
    }

    DownloadsViewItemStatusDownloadProgress_V2
    {
        visible: showDownloadProgress
        Layout.fillWidth: true
        Layout.fillHeight: true
    }
}
