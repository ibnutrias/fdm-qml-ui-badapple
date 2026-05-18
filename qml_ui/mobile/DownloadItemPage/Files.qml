import QtQuick
import org.freedownloadmanager.fdm
import "../FilesTree"

Item {
    id: root

    Rectangle {
        anchors.fill: parent
        color: "transparent"

        border.color: appWindow.theme.border
        FilesTree {
            downloadItemId: downloadsItemTools.itemId
            downloadInfo: downloadsItemTools.item
        }
    }
}
