import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../BaseElements"

ToolButton {
    id: root

    property bool switchChecked
    property string description

    property int textMargins: (appWindow.uiver === 1 ? 20 : appWindow.theme_v2.mainContentMargins)*appWindow.zoom
    property int textHeighIncrement: 25*appWindow.zoom
    property int textFontSize: (appWindow.uiver === 1 ? 16 : appWindow.theme_v2.fontSize)*appWindow.fontZoom

    property bool settingsPageStyle: true
    property int fontWeight: Font.Normal

    anchors.left: parent.left
    anchors.right: parent.right

    implicitHeight: switch1Rect.implicitHeight
    implicitWidth: switch1Rect.implicitWidth

    contentItem: Rectangle {
        anchors.fill: switch1Rect
        color: "transparent"

        MouseArea
        {
            anchors.fill: parent
            onClicked: {
                root.clicked();
                circleAnimation.stop();
            }
            onPressed: function (mouse) {
                colorRect.x = mouseX
                colorRect.y = mouseY
                circleAnimation.start()
            }
            onReleased: circleAnimation.stop()
            onPositionChanged: circleAnimation.stop()
        }
    }

    background: Rectangle {
        id: switch1Rect
        anchors.left: parent.left
        anchors.right: parent.right
        color: "transparent"

        implicitHeight: Math.max(labelText.implicitHeight + textHeighIncrement, switch1.height)
        implicitWidth: labelText.implicitWidth + switch1.implicitWidth + 20

        clip: true

        //For animation
        Rectangle {
            id: colorRect
            height: 0
            width: 0
            color: appWindow.theme.tapAnimation
            transform: Translate {
                x: -colorRect.width / 2
                y: -colorRect.height / 2
            }
        }

        PropertyAnimation {
            id: circleAnimation
            target: colorRect
            properties: "width,height,radius"
            from: 0
            to: switch1Rect.width*3
            duration: 300

            onStopped: {
                colorRect.width = 0
                colorRect.height = 0
            }
        }

        BaseLabel {
            id: labelText
            anchors.left: parent.left
            anchors.right: switch1.left
            anchors.leftMargin: textMargins
            anchors.rightMargin: textMargins
            anchors.verticalCenter: parent.verticalCenter
            text: root.description
            font: uicore.buildFont({weight: fontWeight}, textFontSize)
            color: appWindow.uiver === 1 ?
                       appWindow.theme.foreground :
                       (settingsPageStyle ? appWindow.theme_v2.textColor2 : appWindow.theme_v2.textColor)
            wrapMode: Text.WordWrap
        }

        BaseSwitch {
            id: switch1
            anchors.right: parent.right
            anchors.rightMargin: textMargins
            anchors.verticalCenter: parent.verticalCenter
            checked: root.switchChecked
        }
    }
}
