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
            text: qsTr("Add download") + App.loc.emptyString
            Layout.fillWidth: true
        }

        DialogButton {
            text: (downloadTools.buildingDownload || downloadTools.buildingDownloadFinished ? qsTr("Download") : qsTr("OK")) + App.loc.emptyString
            Layout.rightMargin: qtbug.rightMargin(0, 10)
            Layout.leftMargin: qtbug.leftMargin(0, 10)
            textColor: appWindow.theme.toolbarTextColor
            enabled: url.text.length > 0 && (!downloadTools.failed() || downloadTools.canIgnoreError())
            onClicked: url.accepted()
        }
    }
}
