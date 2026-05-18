import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import QtQuick.Controls.Material
import "../../common"
import "../BaseElements"

CenteredDialog
{
    id: root

    modal: true

    BaseLabel
    {
        text: qsTr("You're about to open a built-in web browser.\n\nIt helps you to add downloads into %1.\n\nSome of them (e.g. Google Drive downloads) can be added using this browser only, because they require additional information that your Android system's browser does not provide to %1 (or there is no universal way for all browsers to do this).").arg(App.shortDisplayName) + App.loc.emptyString
        Layout.fillWidth: true
        Layout.maximumWidth: Math.min(ctMaxWidth, 500*appWindow.zoom)
        wrapMode: Label.WordWrap
        font: uicore.buildFont({}, uicore.fontSizeV1(16*appWindow.fontZoom))
    }

    BaseDialogButtonsLayout
    {
        BaseDialogButton
        {
            text: qsTr("Continue") + App.loc.emptyString
            primary: true
            onClicked: root.close()
        }
    }

    onClosed: appWindow.openBrowser()
}
