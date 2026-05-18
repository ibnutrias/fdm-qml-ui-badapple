import QtQuick
import QtQuick.Layouts
import Qt.labs.folderlistmodel
import org.freedownloadmanager.fdm
import "../../BaseElements/V2"
import "../../V2"

BottomEdgeDrawer_V2
{
    id: root

    contentItem: BottomEdgeDrawerContentItem_V2
    {
        title: qsTr("Sort") + App.loc.emptyString

        ColumnLayout
        {
            spacing: 0

            Repeater {
                model: buildModel()

                BottomEdgeDrawerMenuRadioButton_V2
                {
                    text: modelData.text
                    checked: modelData.value === uiSettingsTools.settings.filePickerSortField &&
                             modelData.ascending === !uiSettingsTools.settings.filePickerSortReversed
                    onClicked: {
                        uiSettingsTools.settings.filePickerSortField = modelData.value;
                        uiSettingsTools.settings.filePickerSortReversed = !modelData.ascending;
                        root.close()
                    }
                }
            }
        }
    }

    function buildModel()
    {
        return [
                    {text: qsTr("Old"), value: FolderListModel.Time, ascending: true},
                    {text: qsTr("Newest"), value: FolderListModel.Time, ascending: false},
                    {text: qsTr("A-Z"), value: FolderListModel.Name, ascending: true},
                    {text: qsTr("Z-A"), value: FolderListModel.Name, ascending: false},
                    {text: qsTr("By size: small"), value: FolderListModel.Size, ascending: true},
                    {text: qsTr("By size: large"), value: FolderListModel.Size, ascending: false}
                ];
    }
}
