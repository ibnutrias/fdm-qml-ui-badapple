import QtQuick
import "../BaseElements/V2"
import "../../common/Core"
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.abstractdownloadsui 

ToolbarFlatButton_V2
{
    AllDownloadsSortModeButtonMenuHelper {id: helper}

    title: helper.title

    iconSource: Qt.resolvedUrl("sort_icon.svg")

    dropDownMenu: BaseMenu_V2
    {
        Repeater
        {
            model: helper.model

            BaseMenuItem_V2 {
                text: modelData.text
                onClicked: modelData.action()
            }
        }
    }
}
