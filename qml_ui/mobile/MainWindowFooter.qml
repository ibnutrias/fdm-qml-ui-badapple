import QtQuick

Item
{
    readonly property var activeItem:
        (appReviewV2.item && appReviewV2.item.enabled) ? appReviewV2 :
        (donate.item && donate.item.enabled) ? donate :
        null

    visible: activeItem

    //////////////////////////////////////////////////////////////////
    // Qt bug workaround
    readonly property int buggyLeft: SafeArea.margins.left
    readonly property int buggyRight: SafeArea.margins.right
    readonly property int buggyBottom: SafeArea.margins.bottom
    //////////////////////////////////////////////////////////////////

    implicitWidth: activeItem ?
                       activeItem.implicitWidth +
                       appWindow.theme_v2.mainContentMargins*appWindow.zoom*2 +
                       buggyLeft + buggyRight
                     : 0
    implicitHeight: activeItem ?
                        activeItem.implicitHeight + 10*appWindow.zoom + buggyBottom
                      : 0

    component Part : Loader
    {
        visible: activeItem === this
        anchors.fill: parent
        anchors.leftMargin: buggyLeft
        anchors.rightMargin: buggyRight
        anchors.bottomMargin: buggyBottom
    }

    Part
    {
        id: appReviewV2
        active: appWindow.uiver !== 1
        source: appWindow.uiver !== 1 ? Qt.resolvedUrl("V2/AppReview_V2.qml") : ""
    }

    Part
    {
        id: donate
        source: Qt.resolvedUrl("DonateBannerStrip.qml")
    }
}
