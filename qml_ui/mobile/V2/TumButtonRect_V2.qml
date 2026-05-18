import QtQuick
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.tum
import "../BaseElements"
import "../BaseElements/V2"
import "../../common/Core"

Rectangle
{
    TumButtonHelper {id: helper}

    required property var mode
    property bool adjustWidth: false

    implicitWidth: (adjustWidth ?
                        Math.max(fm.advanceWidth(helper.tumDisplayText(TrafficUsageMode.High)),
                                 fm.advanceWidth(helper.tumDisplayText(TrafficUsageMode.Medium)),
                                 fm.advanceWidth(helper.tumDisplayText(TrafficUsageMode.Low)),
                                 fm.font.pointSize*fm.font.pixelSize*0) :
                        ct.implicitWidth)
                   + radius*2

    implicitHeight: ct.implicitHeight + 4*appWindow.zoom

    radius: 12

    color: mode === TrafficUsageMode.Snail ? "transparent" : helper.tumDisplayColor(mode)

    gradient: mode === TrafficUsageMode.Snail ? appWindow.theme_v2.snailOnGradient : null

    FontMetrics
    {
        id: fm
        font: l.font
    }

    RowLayout
    {
        id: ct

        anchors.centerIn: parent

        spacing: 5

        BaseLabel
        {
            id: l
            text: helper.tumDisplayText(mode)
            color: mode === TrafficUsageMode.Snail ?
                       appWindow.theme_v2.baseBgColorInSnailMode :
                       appWindow.theme_v2.bg200
            font: uicore.buildFont({capitalization: mode === TrafficUsageMode.Snail ? Font.Capitalize : Font.AllUppercase},
                                   (appWindow.theme_v2.fontSize-1)*appWindow.fontZoom)
        }

        SvgImage_V2
        {
            visible: mode === TrafficUsageMode.Snail
            source: Qt.resolvedUrl("snail.svg")
            imageColor: appWindow.theme_v2.baseBgColorInSnailMode
        }
    }
}
