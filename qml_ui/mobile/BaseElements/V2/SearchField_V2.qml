import QtQuick
import ".."

BaseTextField
{
    signal clearClicked()

    selectByMouse: true
    inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhSensitiveData

    setupPaddings: false
    leftPadding: searchImg.width + searchImg.anchors.leftMargin*2
    rightPadding: closeImgRect.width
    topPadding: 8*appWindow.zoom
    bottomPadding: 8*appWindow.zoom

    SvgImage_V2
    {
        id: searchImg
        anchors.left: parent.left
        anchors.leftMargin: 8*appWindow.zoom
        anchors.verticalCenter: parent.verticalCenter
        source: Qt.resolvedUrl("../../V2/search.svg")
        imageColor: appWindow.theme_v2.bg500
    }

    Item
    {
        id: closeImgRect

        visible: text
        anchors.right: parent.right

        width: closeImg.width + 8*appWindow.zoom*2
        height: parent.height

        SvgImage_V2
        {
            id: closeImg
            anchors.centerIn: parent
            source: Qt.resolvedUrl("../../V2/close.svg")
            imageColor: appWindow.theme_v2.bg500
        }

        MouseArea
        {
            anchors.fill: parent
            onClicked: clearClicked()
        }
    }
}
