import QtQuick
import "../BaseElements/V2"
import "../../common/Core"
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.abstractdownloadsui 

ToolbarFlatButton_V2
{
    property alias shouldBeChecked: helper.shouldBeChecked

    hasCheckBox: true
    checked: helper.shouldBeChecked

    AllDownloadsCheckBoxButtonMenuHelper{id: helper}

    dropDownMenu: BaseMenu_V2
    {
        Repeater {
            model: helper.model

            BaseMenuItem_V2
            {
                text: modelData.text
                onClicked: modelData.action()
            }
        }
    }

    onCheckBoxClicked: helper.onCheckBoxClicked(checked)

    Connections {
        target: App.downloads.model
        onAllCheckStateChanged: checked = helper.shouldBeChecked
    }
}
