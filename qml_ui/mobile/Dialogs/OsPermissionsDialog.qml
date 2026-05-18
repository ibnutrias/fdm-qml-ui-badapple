import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import "../../common"
import "../BaseElements"

CenteredDialog
{
    id: root

    property var requiredPermissions: []
    property var optionalPermissions: []

    readonly property bool missingRequiredPermissions: requiredPermissions.length > 0
    readonly property bool missingOptionalPermissions: optionalPermissions.length > 0

    modal: true
    closePolicy: Popup.NoAutoClose | Popup.CloseOnEscape

    parent: Overlay.overlay

    title: qsTr("%1 is missing permissions").arg(App.shortDisplayName)

    ColumnLayout
    {
        Repeater
        {
            model: root.requiredPermissions.concat(optionalPermissions)

            ColumnLayout
            {
                RowLayout
                {
                    spacing: 10*appWindow.zoom

                    BaseLabel
                    {
                        text: App.osPermissionsMgr.permissionDisplayName(modelData) + App.loc.emptyString
                        font: uicore.buildFont({bold: true}, uicore.fontSizeV1(16*appWindow.fontZoom))
                    }

                    BaseLabel
                    {
                        visible: index < root.requiredPermissions.length
                        text: qsTr("(required)") + App.loc.emptyString
                        color: appWindow.uiver === 1 ?
                                   appWindow.theme.errorMessage :
                                   appWindow.theme_v2.danger
                        font: uicore.buildFont({italic: true}, uicore.fontSizeV1(16*appWindow.fontZoom))
                    }
                }

                BaseLabel
                {
                    text: App.osPermissionsMgr.permissionRationaleText(modelData) + App.loc.emptyString
                    wrapMode: Label.Wrap
                    Layout.fillWidth: true
                    Layout.maximumWidth: ctMaxWidth
                    font: uicore.buildFont({}, uicore.fontSizeV1(16*appWindow.fontZoom))
                }
            }
        }
    }

    BaseLabel
    {
        text: qsTr("You can grant these permissions using the Application details screen within your system's settings.") + App.loc.emptyString
        wrapMode: Label.WordWrap
        Layout.fillWidth: true
        Layout.maximumWidth: ctMaxWidth
        font: uicore.buildFont({}, uicore.fontSizeV1(16*appWindow.fontZoom))
    }

    BaseCheckBox
    {
        visible: !root.missingRequiredPermissions
        text: qsTr("Don't show again") + App.loc.emptyString
        onClicked: uiSettingsTools.settings.dontShowOsPermissionsDialog = checked
    }

    BaseDialogButtonsLayout
    {
        BaseDialogButton
        {
            text: qsTr("Grant permissions") + App.loc.emptyString
            primary: true
            onClicked: {
                App.openAppOsPermissionsSettings();
                root.close();
            }
        }

        BaseDialogButton
        {
            text: (root.missingRequiredPermissions ? qsTr("Quit") : qsTr("Close")) + App.loc.emptyString
            onClicked: root.close()
        }
    }

    onClosed: {
        if (root.missingRequiredPermissions)
            App.quit();
    }
}
