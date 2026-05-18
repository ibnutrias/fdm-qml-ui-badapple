import QtQuick

Loader
{
    readonly property var time: item ? item.time : undefined

    source: Qt.resolvedUrl(appWindow.uiver === 1 ? "TimePicker_V1.qml" : "V2/TimePicker_V2.qml")

    function setTime(newTime)
    {
        item.setTime(newTime);
    }
}
