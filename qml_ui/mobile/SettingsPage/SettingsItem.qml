import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import "../BaseElements"

ToolButton {
    id: root

    property string description
    property int textMargin: (appWindow.uiver === 1 ? 20 : appWindow.theme_v2.mainContentMargins)*appWindow.zoom
    property int textHeighIncrement: 30
    property int textPointSize: (appWindow.uiver === 1 ? 16 : appWindow.theme_v2.fontSize)*appWindow.fontZoom
    property int textWeight: Font.Normal

    anchors.left: parent.left
    anchors.right: parent.right

    height: switch1Rect.height

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

        height: labelText.height + textHeighIncrement

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
            anchors.right: parent.left
            anchors.leftMargin: textMargin
            anchors.rightMargin: textMargin
            anchors.verticalCenter: parent.verticalCenter
            text: root.description
            font: uicore.buildFont({weight: textWeight}, textPointSize)
        }

        Image {
            visible: appWindow.uiver === 1
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            source: Qt.resolvedUrl("../../images/arr.svg")
            anchors.rightMargin: 30
            height: 16
            fillMode: Image.PreserveAspectFit
            mirror: LayoutMirroring.enabled
        }
    }
}
