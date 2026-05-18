import QtQuick
import QtQuick.Controls

Page
{
    property bool enableFooter: true

    footer: Loader {
        visible: source.toString()
        source: (appWindow.uiver === 1 || !enableFooter) ? "" : Qt.resolvedUrl("../V2/MainPageFooter_V2.qml")
    }
}
