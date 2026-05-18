import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.appsettings
import org.freedownloadmanager.fdm.dmcoresettings
import org.freedownloadmanager.fdm.tum
import "../../common/Core"
import "../BaseElements"
import "../BaseElements/V2"

TumButtonRect_V2
{
    TumButtonHelper {id: helper}

    mode: App.settings.tum.currentMode

    TapHandler
    {
        gesturePolicy: TapHandler.WithinBounds
        onTapped: menu.open()
    }

    BottomEdgeDrawer_V2
    {
        id: menu

        contentItem: BottomEdgeDrawerContentItem_V2
        {
            title: qsTr("Traffic usage mode") + App.loc.emptyString

            Item
            {
                implicitWidth: ctMain.implicitWidth
                implicitHeight: ctMain.implicitHeight

                Layout.fillWidth: true

                ColumnLayout
                {
                    id: ctMain
                    spacing: 0

                    height: Math.min(parent.height, implicitHeight)
                    width: Math.min(parent.width, Math.max(implicitWidth, 500*appWindow.zoom))

                    ColumnLayout
                    {
                        spacing: 16*appWindow.zoom

                        Repeater
                        {
                            model: [TrafficUsageMode.High, TrafficUsageMode.Medium, TrafficUsageMode.Low]

                            TumRadioButton_V2
                            {
                                required property int modelData
                                mode: modelData
                                Layout.fillWidth: true
                            }
                        }
                    }

                    Item {implicitHeight: 18*appWindow.zoom}

                    Rectangle
                    {
                        Layout.fillWidth: true
                        implicitHeight: 1*appWindow.zoom
                        color: appWindow.theme_v2.separator
                    }

                    Item {implicitHeight: 18*appWindow.zoom}

                    RowLayout
                    {
                        Layout.fillWidth: true

                        BaseLabel
                        {
                            text: qsTr("Snail mode") + App.loc.emptyString
                            font: uicore.buildFont({weight: Font.Medium}, 
                                                   (appWindow.theme_v2.fontSize+3)*appWindow.fontZoom)
                            Layout.fillWidth: true
                        }

                        BaseSwitch
                        {
                            checked: uicore.snailTools.isSnail
                            onClicked: uicore.snailTools.toggleSnailMode()
                        }
                    }

                    Item {implicitHeight: 8*appWindow.zoom}

                    BaseLabel
                    {
                        text: qsTr("Frees up as much Internet bandwidth as possible without stopping downloads") + App.loc.emptyString
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                    }

                    Item {implicitHeight: 16*appWindow.zoom}

                    BaseLabel
                    {
                        text: "<a href='#'>" + qsTr("Change traffic limits") + App.loc.emptyString + "</a>"
                        onLinkActivated: {
                            menu.close();
                            stackView.waPush(Qt.resolvedUrl("../SettingsPage/TrafficLimitsSettings.qml"));
                        }
                    }
                }
            }
        }

        Connections
        {
            target: App.settings.tum
            onCurrentModeChanged: menu.close()
        }
    }
}
