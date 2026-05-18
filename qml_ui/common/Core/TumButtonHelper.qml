import QtQuick
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.appsettings
import org.freedownloadmanager.fdm.dmcoresettings
import org.freedownloadmanager.fdm.tum

QtObject
{
    readonly property color tumColor: tumDisplayColor(App.settings.tum.currentMode)

    function tumDisplayText(tum) {
        switch (tum) {
        case TrafficUsageMode.Low: return qsTr("Low");
        case TrafficUsageMode.Medium: return qsTr("Medium");
        case TrafficUsageMode.High: return qsTr("High");
        case TrafficUsageMode.Snail: return qsTr("Snail");
        default: return "";
        }
    }

    function tumDisplayColor(tum) {
        switch (tum) {
        case TrafficUsageMode.Low: return appWindow.theme_v2.danger;
        case TrafficUsageMode.Medium: return appWindow.theme_v2.amber;
        case TrafficUsageMode.High: return appWindow.theme_v2.secondary;
        default: return "transparent";
        }
    }
}
