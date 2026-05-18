import QtQuick
import QtQuick.Layouts
import "../BaseElements"

Column {
    property int filter: tabIndex

    height: 108
    width: root.width

    Toolbar {}

    ToolBarShadow {}

    ExtraToolBar {
        RowLayout {
            visible: currentTabsModel.length > 1

            anchors.fill: parent
            anchors.leftMargin: 8*appWindow.zoom
            anchors.rightMargin: 8*appWindow.zoom

            spacing: tabs.count > 3 ? 10 : 30

            Repeater {
                id: tabs
                model: currentTabsModel

                BaseFilterButton {
                    text: modelData.name
                    value: modelData.id
                    selected: filter == value
                    onClicked: filter = value
                    Layout.fillWidth: !selected
                    Layout.maximumWidth: Math.ceil(implicitWidth)
                }
            }

            Item {Layout.fillWidth: true}
        }
    }
}
