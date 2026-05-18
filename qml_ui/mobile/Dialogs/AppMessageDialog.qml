import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import "../BaseElements"

CenteredDialog
{
    id: root

    parent: Overlay.overlay

    modal: true

    property string text
    property bool hasCancelButton: false

    signal okClicked()
    signal cancelClicked()

    BaseLabel
    {
        visible: text
        text: root.text
        wrapMode: Text.WordWrap
        Layout.maximumWidth: Math.min(ctMaxWidth, 500*appWindow.zoom)
        font: uicore.buildFont({}, uicore.fontSizeV1(16*appWindow.fontZoom))
    }

    BaseDialogButtonsLayout
    {
        BaseDialogButton
        {
            text: qsTr("OK") + App.loc.emptyString
            primary: true
            onClicked: {
                root.okClicked();
                root.close();
            }
        }

        BaseDialogButton
        {
            visible: hasCancelButton
            text: qsTr("Cancel") + App.loc.emptyString
            onClicked: {
                root.cancelClicked();
                root.close();
            }
        }
    }
}
