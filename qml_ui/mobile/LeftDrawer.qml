import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Effects
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.appfeatures
import "BaseElements"

Drawer {
    id: root
    width: listview.implicitWidth
    height: parent.height
    interactive: stackView.depth === 1

    Material.background: appWindow.theme.drawerBackground

    edge: appWindow.LayoutMirroring.enabled ? Qt.RightEdge : Qt.LeftEdge

    ListView {
        id: listview
        focus: true
        currentIndex: -1
        width: parent.width
        height: parent.height - addNewDownloadBlock.height
        headerPositioning: ListView.OverlayHeader

        MainMenuHelper {
            id: helper
        }

        Label {
            id: l
            visible: false
            font.pixelSize: 16*appWindow.fontZoom
        }
        FontMetrics {
            id: fm
            font: l.font
        }

        implicitWidth: {
            // icon + text
            let h = 64 + fm.advanceWidth(App.displayName);
            for (let i = 0; i < helper.model.count; ++i)
                h = Math.max(h, 24 + fm.advanceWidth(helper.model.get(i).text));
            // left padding + spacing between icon and text + h + right padding
            return 20 + 10 + h + 20;
        }

        header: Rectangle {
            id: header
            z: 2
            width: parent.width
            height: 108
            color: appWindow.theme.primary

            Image {
                id: logo
                sourceSize.width: 64
                sourceSize.height: 64
                source: Qt.resolvedUrl("../images/mobile/fdmlogo.svg")
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 20
            }

            Column {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: logo.right
                anchors.leftMargin: 10

                Label {
                    text: App.displayName
                    color: appWindow.theme.toolbarTextColor
                    font.pixelSize: 16*appWindow.fontZoom
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Label {
                    visible: !appWindow.hasDownloadMgr
                    text: qsTr("remote control") + App.loc.emptyString
                    color: appWindow.theme.toolbarTextColor
                    font.pixelSize: 16*appWindow.fontZoom
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }

        delegate: ItemDelegate {
            opacity: model.enabled ? 1 : 0.3

            width: listview.width
            highlighted: ListView.isCurrentItem
            leftPadding: qtbug.leftPadding(20, 0)
            rightPadding: qtbug.rightPadding(20, 0)

            onClicked: {
                if (model.enabled)
                {
                    root.close()
                    helper.model.actions[model.actionLabel]();
                }
            }

            contentItem: Row {
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width
                spacing: 15
                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    source: model.icon
                    sourceSize.width: 24
                    sourceSize.height: 24

                    layer {
                        effect: MultiEffect {
                            colorization: 1.0
                            colorizationColor: appWindow.theme.drawerIcon
                        }
                        enabled: true
                    }
                }
                Label {
                    text: model.text
                    font.pixelSize: 15*appWindow.fontZoom
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignLeft
                    width: parent.width - 24 - parent.spacing
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        model: helper.model
    }

    Rectangle {
        id: addNewDownloadBlock

        visible: appWindow.hasDownloadMgr

        width: parent.width
        height: 38
        anchors.bottom: parent.bottom
        color: appWindow.theme.primary

        Image {
            id: plus
            source: Qt.resolvedUrl("../images/mobile/plus.svg")
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 20
            sourceSize.width: 24
            sourceSize.height: 24
        }

        Label {
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Add new download") + App.loc.emptyString
            color: appWindow.theme.toolbarTextColor
            font.pixelSize: 14*appWindow.fontZoom
            font.weight: Font.Medium
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                root.close();
                appWindow.createDownloadDialog();
            }
        }
    }

    Connections {
        target: stackView
        onCurrentItemChanged: if (root.opened) root.close()
    }
}
