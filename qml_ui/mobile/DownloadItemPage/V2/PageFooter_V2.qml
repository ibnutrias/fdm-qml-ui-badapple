import QtQuick
import QtQuick.Layouts
import "../../BaseElements"

Rectangle
{
    property int filter: tabIndex

    implicitHeight: 48

    color: appWindow.theme_v2.bg300_2

    component MyButton : Rectangle
    {
        signal clicked()
        required property bool active
        property alias title: myButtonLabel.text

        implicitHeight: 32
        implicitWidth: Math.ceil(myButtonLabel.implicitWidth) + 8*2

        radius: 4
        color: active ? appWindow.theme_v2.primary : "transparent"

        BaseLabel
        {
            id: myButtonLabel
            color: active ? appWindow.theme_v2.bg100 : appWindow.theme_v2.bg1000
            font: uicore.buildFont({capitalization: Font.AllUppercase, weight: 600},
                                   (appWindow.theme_v2.fontSize-2)*appWindow.fontZoom)
            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            elide: Text.ElideRight
        }

        TapHandler
        {
            gesturePolicy: TapHandler.WithinBounds
            onTapped: clicked()
        }
    }

    RowLayout
    {
        anchors.fill: parent
        anchors.leftMargin: 8*appWindow.zoom
        anchors.rightMargin: 8*appWindow.zoom

        Repeater
        {
            model: currentTabsModel

            MyButton
            {
                required property var modelData
                title: modelData.name
                active: filter === modelData.id
                onClicked: filter = modelData.id
                Layout.fillWidth: !active
                Layout.maximumWidth: Math.ceil(implicitWidth)
            }
        }

        Item {Layout.fillWidth: true}
    }
}
