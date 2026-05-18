import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import "../../common"
import "../BaseElements"
import "../Dialogs"

AppMessageDialog
{
    id: root

    parent: Overlay.overlay

    modal: true

    title: qsTr("Are you sure you want to quit?") + App.loc.emptyString

    hasCancelButton: true

    onOkClicked: App.reportQuitConfirmationResult(true);
    onCancelClicked: App.reportQuitConfirmationResult(false);
}
