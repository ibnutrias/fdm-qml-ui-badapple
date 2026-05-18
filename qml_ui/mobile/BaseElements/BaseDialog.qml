import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../common"

Dialog
{
    readonly property int dlgMaxWidth: parent.width - leftPadding - rightPadding
    readonly property int ctMaxWidth: dlgMaxWidth - leftPadding - rightPadding
    property int titleNClicks: -1

    signal titleClickedNTimes

    //////////////////////////////////////////////////////////////////////
    // QTBUG-139695 workaround
    topMargin: appWindow.SafeArea.margins.top
    leftMargin: appWindow.SafeArea.margins.left
    bottomMargin: appWindow.SafeArea.margins.bottom
    rightMargin: appWindow.SafeArea.margins.right
    //////////////////////////////////////////////////////////////////////

    padding: (appWindow.uiver === 1 ? 20 : 16)*appWindow.zoom
    leftPadding: padding
    rightPadding: padding
    topPadding: title ? 0 : padding
    bottomPadding: padding

    background: Rectangle
    {
        color: appWindow.uiver === 1 ?
                   appWindow.theme.background :
                   appWindow.theme_v2.bgColor

        radius: appWindow.uiver === 1 ? 28 : 16*appWindow.zoom
    }

    header: Item
    {
        implicitWidth: title ?
                           Math.min(headerLabel.implicitWidth + headerLabel.anchors.leftMargin + headerLabel.anchors.rightMargin,
                                    dlgMaxWidth) :
                           0

        implicitHeight: title ?
                            headerLabel.implicitHeight + headerLabel.anchors.topMargin + headerLabel.anchors.bottomMargin :
                            0

        BaseLabel
        {
            id: headerLabel

            text: title

            anchors.fill: parent
            anchors.leftMargin: parent.parent.padding
            anchors.rightMargin: anchors.leftMargin
            anchors.topMargin: anchors.leftMargin
            anchors.bottomMargin: anchors.leftMargin/2

            font: uicore.buildFont({weight: Font.DemiBold},
                                   (appWindow.uiver === 1 ? 16 : (appWindow.theme_v2.fontSize+3))*appWindow.fontZoom)

            wrapMode: Text.WordWrap

            NClicksTrigger
            {
                enabled: titleNClicks != -1
                n: titleNClicks != -1 ? titleNClicks : 10
                anchors.fill: parent
                onTriggered: titleClickedNTimes()
            }
        }
    }

    contentItem: ColumnLayout
    {
        spacing: 10*appWindow.zoom
    }
}
