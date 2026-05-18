import QtQuick
import ".."

ListView
{
    property var time: ({hour: 0, minute: 0})

    readonly property int step: 15
    readonly property int stepsInHour: 60 / step
    readonly property int itemsPerDay: 24 * stepsInHour

    readonly property int currentItemFontSize: (appWindow.theme_v2.fontSize+7)
    readonly property int itemFontSize: (appWindow.theme_v2.fontSize+1)

    readonly property int delegateHeight: currentItemFontSize*appWindow.fontZoom + 5*appWindow.zoom

    implicitHeight: delegateHeight*3

    clip: true

    model: itemsPerDay + 1

    highlightRangeMode: ListView.StrictlyEnforceRange
    preferredHighlightBegin: (height - delegateHeight) / 2
    preferredHighlightEnd: (height + delegateHeight) / 2

    delegate: Item
    {
        readonly property int hour: index / stepsInHour
        readonly property int minute: step * (index % stepsInHour)

        height: delegateHeight
        width: parent ? parent.width : 0

        BaseLabel
        {
            text: leadingZero(parent.hour) + ":" + leadingZero(parent.minute)
            color: parent.ListView.isCurrentItem ? appWindow.theme_v2.textColor : appWindow.theme_v2.bg500
            font: uicore.buildFont({weight: 500},
                                   (parent.ListView.isCurrentItem ? currentItemFontSize : itemFontSize)*appWindow.fontZoom)
            anchors.centerIn: parent
        }
    }

    onMovementEnded:
    {
        var item = currentIndex % itemsPerDay
        var hour = Math.floor(currentIndex / stepsInHour)
        var minute = (item - (Math.floor(item / 4) * 60 / step)) * step
        time = {hour: hour, minute: minute}
    }

    function setTime(newTime)
    {
        positionViewAtIndex(newTime && newTime.hour * stepsInHour + newTime.minute / step || 0, ListView.Center)
        time = newTime
    }

    function leadingZero(number)
    {
        return ('00' + number).slice(-2)
    }
}
