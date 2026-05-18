import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import org.freedownloadmanager.fdm
import "V2"

Rectangle {
    id: root
    color: 'transparent'
    Layout.topMargin: 5
    Layout.preferredHeight: 20
    Layout.fillWidth: true

    property bool highlighted
    signal clicked

    readonly property color myColor: appWindow.uiver === 1 ?
                                         (root.highlighted ? appWindow.theme.schedulerLabelText : appWindow.theme.schedulerLabelSelectedText) :
                                         (root.highlighted ? appWindow.theme_v2.primary : appWindow.theme_v2.textColor)

    Item {
        anchors.left: parent.left

        width: content.width
        height: content.height

        Row {
            id: content
            spacing: 5

            SvgImage_V2 {
                id: img
                sourceSize: appWindow.uiver === 1 ?
                                Qt.size(16,16) :
                                Qt.size(width, height)
                source: Qt.resolvedUrl(appWindow.uiver === 1 ?
                                           "../../images/mobile/scheduler.svg" :
                                           "V2/scheduler.svg")
                Layout.alignment: Qt.AlignVCenter
                imageColor: myColor
            }

            BaseLabel {
                text: qsTr("Scheduler") + App.loc.emptyString
                color: myColor
                font: uicore.buildFont({}, uicore.fontSizeV1(16*appWindow.fontZoom))
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: root.clicked()
        }
    }
}
