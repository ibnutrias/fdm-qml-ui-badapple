import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.dmcoresettings
import org.freedownloadmanager.fdm.appsettings
import "../../common"
import "../BaseElements"

CenteredDialog
{
    id: root

    modal: true

    title: qsTr("Mobile data usage") + App.loc.emptyString

    BaseLabel
    {
        text: qsTr("Waiting for Wi-Fi to start download.") + App.loc.emptyString
        Layout.fillWidth: true
        Layout.maximumWidth: root.ctMaxWidth
        wrapMode: Label.WordWrap
        horizontalAlignment: Text.AlignLeft
        font: uicore.buildFont({}, uicore.fontSizeV1(16*appWindow.fontZoom))
    }

    BaseLabel
    {
        text: qsTr("Would you like to enable usage of mobile data? *") + App.loc.emptyString
        Layout.fillWidth: true
        Layout.maximumWidth: root.ctMaxWidth
        wrapMode: Label.WordWrap
        horizontalAlignment: Text.AlignLeft
        font: uicore.buildFont({}, uicore.fontSizeV1(16*appWindow.fontZoom))
    }

    BaseCheckBox {
        id: dontAsk
        text: qsTr("Don't ask again") + App.loc.emptyString
    }

    BaseDialogButtonsLayout 
    {
        BaseDialogButton {
            text: qsTr("Yes") + App.loc.emptyString
            primary: true
            onClicked: root.setMobileDataUsage(true)
        }

        BaseDialogButton {
            text: qsTr("No") + App.loc.emptyString
            onClicked: root.setMobileDataUsage(false)
        }
    }

    BaseLabel
    {
        text: qsTr("* additional charges may apply") + App.loc.emptyString
        Layout.fillWidth: true
        Layout.maximumWidth: root.ctMaxWidth
        wrapMode: Label.WordWrap
    }

    function setMobileDataUsage(value) {
        uiSettingsTools.settings.dontAskMobileDataUsage = dontAsk.checkState === Qt.Checked;
        App.settings.dmcore.setValue(
            DmCoreSettings.AllowToUseMobileNetworks,
            App.settings.fromBool(value));
        root.close();
    }

    Connections {
        target: appWindow
        onStartDownload: {
            if (false == uiSettingsTools.settings.dontAskMobileDataUsage
                    && false == root.opened
                    && false == App.settings.toBool(App.settings.dmcore.value(DmCoreSettings.AllowToUseMobileNetworks))
                    && !envTools.hasAllowedInternetConnection) {
                root.open();
            }
        }
    }
}
