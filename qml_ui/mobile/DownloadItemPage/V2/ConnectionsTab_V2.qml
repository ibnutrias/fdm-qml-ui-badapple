import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.appfeatures
import "../../BaseElements"

Item
{
    BaseLabel
    {
        visible: !connectionsList.visible
        text: qsTr("There are no connections") + App.loc.emptyString
        color: appWindow.theme_v2.textColor2
        anchors.centerIn: parent
        font: uicore.buildFont({}, (appWindow.theme_v2.fontSize+5)*appWindow.fontZoom)
    }

    ColumnLayout
    {
        id: connectionsList

        visible: downloadsItemTools.running && connectionsListView.count

        property int hostColWidth: 0
        property int portColWidth: 0
        property int countColWidth: 0

        anchors.fill: parent
        spacing: 0

        ColumnLayout
        {
            Layout.fillWidth: true

            spacing: 0

            RowLayout
            {
                Layout.fillWidth: true
                Layout.preferredHeight: 32

                spacing: 16

                BaseLabel
                {
                    text: qsTr("Host") + App.loc.emptyString
                    font: uicore.buildFont({}, (appWindow.theme_v2.fontSize-1)*appWindow.fontZoom)
                    Layout.fillWidth: true
                    onWidthChanged: connectionsList.hostColWidth = width
                }

                BaseLabel
                {
                    text: qsTr("Port") + App.loc.emptyString
                    font: uicore.buildFont({}, (appWindow.theme_v2.fontSize-1)*appWindow.fontZoom)
                    Layout.preferredWidth: 60
                    onWidthChanged: connectionsList.portColWidth = width
                }

                BaseLabel
                {
                    text: qsTr("Connection count") + App.loc.emptyString
                    font: uicore.buildFont({}, (appWindow.theme_v2.fontSize-1)*appWindow.fontZoom)
                    wrapMode: Text.WordWrap
                    Layout.preferredWidth: 85
                    onWidthChanged: connectionsList.countColWidth = width
                }
            }

            Item {implicitHeight: 4}

            Rectangle
            {
                implicitHeight: 1*appWindow.zoom
                Layout.fillWidth: true
                color: appWindow.theme_v2.separator
            }

            Item {implicitHeight: 4}
        }

        ListView
        {
            id: connectionsListView

            ScrollBar.vertical: ScrollBar{}
            flickableDirection: Flickable.AutoFlickIfNeeded
            boundsBehavior: Flickable.StopAtBounds
            headerPositioning: ListView.OverlayHeader
            clip: true
            Layout.fillWidth: true
            Layout.fillHeight: true
            reuseItems: true

            model: downloadsItemTools.connectionsModel

            delegate: ColumnLayout
            {
                spacing: 0
                width: connectionsListView.width

                Item {implicitHeight: 8}

                RowLayout
                {
                    spacing: 16

                    BaseLabel
                    {
                        text: model.host
                        font: uicore.buildFont({}, (appWindow.theme_v2.fontSize-1)*appWindow.fontZoom)
                        Layout.preferredWidth: connectionsList.hostColWidth
                    }

                    BaseLabel
                    {
                        text: model.port
                        font: uicore.buildFont({}, (appWindow.theme_v2.fontSize-1)*appWindow.fontZoom)
                        Layout.preferredWidth: connectionsList.portColWidth
                    }

                    BaseLabel
                    {
                        text: model.connectionCount
                        font: uicore.buildFont({}, (appWindow.theme_v2.fontSize-1)*appWindow.fontZoom)
                        Layout.preferredWidth: connectionsList.countColWidth
                    }
                }
            }
        }
    }
}
