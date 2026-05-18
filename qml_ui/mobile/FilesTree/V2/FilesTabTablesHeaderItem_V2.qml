import QtQuick
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.abstractdownloadsui
import "../../BaseElements/V2"

TablesHeaderItem_V2
{
    required property int sortBy

    showSortIndicator: myModel && myModel.sortBy == sortBy
    sortAscendingOrder: myModel && myModel.sortOrder == Qt.AscendingOrder

    onClicked:
    {
        if (myModel)
        {
            if (myModel.sortBy != sortBy)
            {
                myModel.sortBy = sortBy;
                myModel.sortOrder = Qt.AscendingOrder;
            } else
            {
                myModel.sortOrder = myModel.sortOrder == Qt.AscendingOrder ?
                            Qt.DescendingOrder :
                            Qt.AscendingOrder;
            }
        }
    }
}
