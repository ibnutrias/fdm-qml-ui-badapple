import QtQuick
import QtQuick.Layouts

RowGridLayout
{
    elementMinimumWidth: appWindow.uiver === 1 ? 0 : 90*appWindow.zoom
    elementFillsWidth: appWindow.uiver !== 1

    Layout.fillWidth: appWindow.uiver !== 1
    Layout.alignment: Qt.AlignHCenter
    Layout.preferredWidth: Math.ceil(implicitWidth1Row)
    Layout.maximumWidth: ctMaxWidth
}
