import QtQuick
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import "../BaseElements"
import "../BaseElements/V2"

Item
{
    implicitHeight: 48*appWindow.zoom

    Rectangle
    {
        anchors.fill: parent
        gradient: appWindow.theme_v2.donateBannerGradient
    }

    RowLayout
    {
        anchors.fill: parent
        anchors.leftMargin: 12*appWindow.zoom
        anchors.rightMargin: 12*appWindow.zoom
        anchors.topMargin: 8*appWindow.zoom
        anchors.bottomMargin: 8*appWindow.zoom

        spacing: 12*appWindow.zoom

        BaseLabel
        {
            text: uicore.thankYouForUsingApp
            font.family: appWindow.theme_v2.fontFamily
            font.pixelSize: 13*appWindow.fontZoom
            font.weight: appWindow.uiver === 1 ? 500 : 700
        }

        BaseLabel
        {
            text: qsTr("You help us grow and progress") + App.loc.emptyString
            font.family: appWindow.theme_v2.fontFamily
            font.pixelSize: 13*appWindow.fontZoom
            font.weight: 400
        }

        Rectangle
        {
            implicitWidth: ctBtn.implicitWidth + ctBtn.anchors.leftMargin*2
            implicitHeight: ctBtn.implicitHeight + ctBtn.anchors.topMargin*2

            color: appWindow.uiver === 1 ?
                       (appWindow.theme.isLightTheme ? appWindow.theme_v2.light1000 : appWindow.theme_v2.dark1000) :
                       appWindow.theme_v2.primary

            border.color: appWindow.uiver === 1 ?
                              (appWindow.theme.isLightTheme ? "#B8B8B8" : "#D4D4D4") :
                              "transparent"
            border.width: appWindow.uiver === 1 ? 1*appWindow.zoom : 0

            radius: appWindow.uiver === 1 ? 1*appWindow.zoom : 8*appWindow.zoom

            RowLayout
            {
                id: ctBtn

                anchors.fill: parent
                anchors.leftMargin: 12*appWindow.zoom
                anchors.rightMargin: 12*appWindow.zoom
                anchors.topMargin: 8*appWindow.zoom
                anchors.bottomMargin: 8*appWindow.zoom

                spacing: 8*appWindow.zoom

                BaseLabel
                {
                    text: uicore.supportTheProjectText
                    font.family: appWindow.theme_v2.fontFamily
                    font.pixelSize: 13*appWindow.fontZoom
                    font.weight: 500
                    color: appWindow.uiver === 1 ?
                               (appWindow.theme.isLightTheme ? "#292929" : "#141415") :
                               appWindow.theme_v2.bgColor
                }

                SvgImage_V2
                {
                    source: Qt.resolvedUrl("hyper_link_arrow.svg")
                    imageColor: appWindow.uiver === 1 ?
                                    (appWindow.theme.isLightTheme ? "#292929" : "#141415") :
                                    appWindow.theme_v2.bgColor
                }
            }

            MouseAreaWithHand_V2 {
                anchors.fill: parent
                onClicked: App.donate.onDonateDialogAccepted()
            }
        }

        Item {Layout.fillWidth: true}

        SvgImage_V2
        {
            source: Qt.resolvedUrl("../V2/BottomPanel/close.svg")
            MouseAreaWithHand_V2 {
                anchors.fill: parent
                onClicked: App.donate.onDonateDialogDeclined()
            }
        }
    }
}
