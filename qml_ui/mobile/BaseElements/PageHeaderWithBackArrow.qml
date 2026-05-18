import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import "../../common"

BaseToolBar {
    id: root

    property string pageTitle
    property bool okButtonVisible: false
    property bool okButtonEnabled: true
    property bool backButtonVisible: true

    signal popPage()
    signal clickedNtimes()
    signal okButtonClicked()

    focusPolicy: Qt.NoFocus
    focus: false

    ToolbarLabel {
        readonly property bool enoughSpace: (parent.width -
                                             (backBtn.visible ? backBtn.width - 8*appWindow.zoom : 10*appWindow.zoom) -
                                             (okBtn.visible ? okBtn.width + 8*appWindow.zoom + okBtn.anchors.rightMargin : 10*appWindow.zoom)) >= implicitWidth
        anchors.fill: parent
        text: pageTitle
        leftPadding: enoughSpace ? 10*appWindow.zoom : (backBtn.visible ? backBtn.width + 8*appWindow.zoom : 10*appWindow.zoom)
        rightPadding: enoughSpace ? 10*appWindow.zoom : (okBtn.visible ? okBtn.width + 8*appWindow.zoom : 10*appWindow.zoom)
        horizontalAlignment: enoughSpace ? Qt.AlignHCenter : Qt.AlignLeft

        NClicksTrigger {
            anchors.fill: parent
            onTriggered: root.clickedNtimes()
        }
    }

    ToolbarBackButton {
        id: backBtn
        visible: backButtonVisible
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        focus: false
        onClicked: popPage()
    }

    DialogButton {
        id: okBtn
        visible: okButtonVisible
        text: qsTr("OK") + App.loc.emptyString
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: 10*appWindow.zoom
        textColor: appWindow.theme.toolbarTextColor
        enabled: okButtonEnabled
        onClicked: okButtonClicked()
    }
}
