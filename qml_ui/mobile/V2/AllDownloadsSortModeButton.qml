import QtQuick
import QtQuick.Layouts
import "../BaseElements/V2"
import "../../common/Core"
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.abstractdownloadsui

ToolbarFlatButton_V2
{
    title: helper.title
    iconSource: Qt.resolvedUrl("sort.svg")

    AllDownloadsSortModeButtonMenuHelper {id: helper}

    dropDownMenu: BottomEdgeDrawer_V2
    {
        contentItem: BottomEdgeDrawerContentItem_V2
        {
            title: qsTr("Sort") + App.loc.emptyString

            ColumnLayout
            {
                spacing: 0

                Repeater {
                    model: helper.model

                    BottomEdgeDrawerMenuRadioButton_V2
                    {
                        text: modelData.text
                        checked: modelData.sortBy == sortTools.sortBy && modelData.acsending == sortTools.sortAscendingOrder
                        onClicked: {
                            modelData.action();
                            dropDownMenu.close()
                        }
                    }
                }
            }
        }
    }
}
