import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.abstractdownloadsui
import "../BaseElements"
import "../BaseElements/V2"
import "../../common/Core"

ToolbarFlatButton_V2
{
    hasCheckBox: true
    checked: helper.shouldBeChecked

    AllDownloadsCheckBoxButtonMenuHelper{id: helper}

    dropDownMenu: BottomEdgeDrawer_V2
    {
        contentItem: BottomEdgeDrawerContentItem_V2
        {
            title: qsTr("Select") + App.loc.emptyString

            ListView
            {
                Layout.fillWidth: true
                implicitHeight: 40*model.length

                model: helper.model

                clip: true

                spacing: 0

                delegate: ItemDelegate
                {
                    height: 40
                    width: parent.width

                    onClicked: {
                        modelData.action();
                        dropDownMenu.close();
                    }

                    contentItem: BaseLabel
                    {
                        text: modelData.text
                        color: appWindow.theme_v2.drawerMenuItemTextColor
                        anchors.fill: parent
                        verticalAlignment: Qt.AlignVCenter
                        padding: 8*appWindow.zoom
                    }
                }
            }
        }
    }

    onCheckBoxClicked: helper.onCheckBoxClicked(checked)
}
