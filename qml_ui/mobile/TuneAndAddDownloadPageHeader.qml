import QtQuick
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import "BaseElements"

BaseToolBar {
    RowLayout {
        anchors.fill: parent

        ToolbarBackButton {
            onClicked: downloadTools.doReject()
        }

        ToolbarLabel {
            text: qsTr("New file") + App.loc.emptyString
            Layout.fillWidth: true
        }

        DialogButton {
            text: qsTr("Download") + App.loc.emptyString
            Layout.rightMargin: qtbug.rightMargin(0, 10)
            Layout.leftMargin: qtbug.leftMargin(0, 10)
            textColor: appWindow.theme.toolbarTextColor
            onClicked: accept()
            enabled: saveTo.currentText.length > 0 && downloadTools.hasWriteAccess
        }
    }
}
