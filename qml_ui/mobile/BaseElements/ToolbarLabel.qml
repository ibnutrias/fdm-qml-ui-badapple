import QtQuick
import QtQuick.Controls

BaseLabel {
    clip: true
    elide: lineCount === 1 ? Label.ElideMiddle : Label.ElideRight
    wrapMode: Text.WordWrap
    maximumLineCount: 3
    horizontalAlignment: Qt.AlignHCenter
    verticalAlignment: Qt.AlignVCenter
    font: uicore.buildFont({weight: Font.DemiBold}, 20*appWindow.fontZoom)
    color: appWindow.theme.toolbarTextColor
}
