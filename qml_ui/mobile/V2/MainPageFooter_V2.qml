import QtQuick
import QtQuick.Shapes
import QtQuick.Effects
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import "../BaseElements/V2"

Item
{
    id: root

    readonly property int myHeight: 40

    implicitHeight: myHeight

    Shape
    {
        id: bgShape

        ShapePath
        {
            id: bgShapePath

            strokeWidth: 0
            strokeColor: "transparent"
            fillColor: appWindow.theme_v2.bgColor

            startX: root.width/2 + 35
            startY: 0

            PathCubic {
                relativeX: -12.6; relativeY: 8.58;
                relativeControl1X: -5.56; relativeControl1Y: 0;
                relativeControl2X: -10.61; relativeControl2Y: 3.38
            }

            PathCubic {
                relativeX: -22.42; relativeY: 15.42;
                relativeControl1X: -3.45; relativeControl1Y: 9.02;
                relativeControl2X: -12.19; relativeControl2Y: 15.42;
            }

            PathCubic {
                relativeX: -22.42; relativeY: -15.42;
                relativeControl1X: -10.23; relativeControl1Y: 0;
                relativeControl2X: -18.97; relativeControl2Y: -6.4;
            }

            PathCubic {
                relativeX: -12.6; relativeY: -8.58
                relativeControl1X: -1.99; relativeControl1Y: -5.2;
                relativeControl2X: -7.03; relativeControl2Y: -8.58;
            }

            PathLine {x: 0; y: bgShapePath.startY}
            PathLine {relativeX: 0; relativeY: root.height - bgShapePath.startY}
            PathLine {relativeX: root.width; relativeY: 0}
            PathLine {relativeX: 0; relativeY: -root.height + bgShapePath.startY}
            PathLine {x: bgShapePath.startX; y: bgShapePath.startY}
        }
    }

    MultiEffect
    {
        source: bgShape
        anchors.fill: bgShape
        anchors.topMargin: -2*appWindow.zoom
        shadowEnabled: true
        shadowBlur: 0.5
        shadowColor: appWindow.theme_v2.bottomBarShadowColor
    }

    // add a new download ("+") button
    Rectangle
    {
        x: (root.width - width)/2
        y: 0 - height/2
        width: 40
        height: width
        radius: 20
        color: appWindow.theme_v2.primary

        Item
        {
            anchors.centerIn: parent
            width: 12
            height: width

            Rectangle
            {
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width
                height: 2
                color: appWindow.theme_v2.bg100
                radius: 2
            }

            Rectangle
            {
                anchors.horizontalCenter: parent.horizontalCenter
                height: parent.height
                width: 2
                color: appWindow.theme_v2.bg100
                radius: 2
            }
        }

        TapHandler
        {
            gesturePolicy: TapHandler.WithinBounds
            onTapped: appWindow.createDownloadDialog()
        }
    }

    component MyButton : Item
    {
        signal clicked()
        property alias imgSource: myButtonImg.source
        property bool primary: false

        implicitWidth: root.myHeight // avoid "pixel hunting"
        implicitHeight: implicitWidth

        SvgImage_V2
        {
            id: myButtonImg
            imageColor: primary ? appWindow.theme_v2.primary : supposedImageColor
            anchors.centerIn: parent
            opacity: enabled ? 1.0 : appWindow.theme_v2.opacityDisabled
        }

        TapHandler
        {
            gesturePolicy: TapHandler.WithinBounds
            onTapped: parent.clicked()
        }
    }

    RowLayout
    {
        anchors.horizontalCenter: parent.horizontalCenter

        spacing: 29

        MyButton
        {
            primary: appWindow.isDownloadsPageActive &&
                     !appWindow.isDownloadsPageSearchModeActive
            imgSource: Qt.resolvedUrl("list.svg")
            onClicked: appWindow.openDownloadsPage()
        }

        MyButton
        {
            enabled: !App.downloads.infos.empty
            primary: appWindow.isDownloadsPageSearchModeActive
            imgSource: Qt.resolvedUrl("search.svg")
            onClicked: appWindow.openDownloadsPageSearchMode()
        }

        MyButton {enabled: false} // just an empty space filler

        MyButton
        {
            primary: appWindow.isSettingsPageActive
            imgSource: Qt.resolvedUrl("gear.svg")
            onClicked: appWindow.openSettings()
        }

        MyButton
        {
            imgSource: Qt.resolvedUrl("menu_open.svg")
            onClicked: mainMenuDrawer.item.open()
        }
    }
}
