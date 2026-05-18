import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import "../../BaseElements"
import "../../BaseElements/V2"

BottomEdgeDrawer_V2
{
    id: root

    MainMenuHelper
    {
        id: helper
    }

    contentItem: BottomEdgeDrawerContentItem_V2
    {
        title: qsTr("Menu") + App.loc.emptyString

        ListView
        {
            Layout.fillWidth: true
            implicitHeight: 48*model.count

            model: helper.model

            clip: true

            spacing: 0

            delegate: ItemDelegate
            {
                enabled: model.enabled

                leftPadding: 0
                rightPadding: 0
                bottomPadding: 0
                topPadding: 0

                height: Math.max(48*appWindow.zoom, contentItem.implicitHeight)
                width: parent.width

                onClicked: {
                    root.close()
                    helper.model.actions[model.actionLabel]();
                }

                contentItem: ColumnLayout
                {
                    spacing: 0

                    RowLayout
                    {
                        spacing: 8*appWindow.zoom
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Item
                        {
                            implicitWidth: 24*appWindow.zoom
                            implicitHeight: implicitWidth

                            SvgImage_V2
                            {
                                source: model.icon
                                imageColor: enabled ? appWindow.theme_v2.bg600 : appWindow.theme_v2.bg500
                                anchors.centerIn: parent
                            }
                        }

                        BaseLabel
                        {
                            text: model.text
                            color: appWindow.theme_v2.drawerMenuItemTextColor
                            Layout.fillWidth: true
                            Layout.maximumWidth: Math.ceil(implicitWidth)
                            wrapMode: Text.WordWrap
                        }

                        SvgImage_V2
                        {
                            visible: model.externalLink
                            source: Qt.resolvedUrl("external_link.svg")
                            imageColor: enabled ? appWindow.theme_v2.bg600 : appWindow.theme_v2.bg500
                        }
                    }

                    Rectangle
                    {
                        visible: index !== helper.model.count - 1
                        implicitHeight: 2*appWindow.zoom
                        Layout.fillWidth: true
                        color: appWindow.theme_v2.separator
                    }
                }
            }
        }
    }
}
