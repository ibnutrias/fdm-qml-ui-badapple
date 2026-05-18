import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../Dialogs"
import org.freedownloadmanager.fdm
import "../BaseElements"

Item
{
    id: root

    property double currentValue: 0

    readonly property string sUnlimited: qsTr("Unlimited") + App.loc.emptyString
    readonly property string sCustom: qsTr("Custom...") + App.loc.emptyString

    implicitHeight: combo.implicitHeight
    implicitWidth: combo.implicitWidth

    BaseComboBox
    {
        id: combo
        anchors.fill: parent
        model: [
            {text: "1", value: 1},
            {text: "2", value: 2},
            {text: "3", value: 3},
            {text: "4", value: 4},
            {text: sUnlimited, value: 0},
            {text: sCustom, value: -1}
        ]

        font: uicore.buildFont({}, uicore.fontSizeV1(14)*appWindow.fontZoom)

        onActivated: index => {
                         if (model[index].value === -1)
                         {
                             custom.open();
                             value.forceActiveFocus()
                         }
                         else
                         {
                            root.currentValue =  model[index].value;
                         }
                     }
    }

    CenteredDialog {
        id: custom
        parent: Overlay.overlay

        modal: true

        title: qsTr("Custom value") + App.loc.emptyString

        BaseTextField
        {
            id: value
            Layout.fillWidth: true
            Layout.maximumWidth: custom.ctMaxWidth
            inputMethodHints: Qt.ImhDigitsOnly | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
            onAccepted: custom.tryAcceptValue()
            font: uicore.buildFont({}, (appWindow.uiver === 1 ? 13 : appWindow.theme_v2.fontSize)*appWindow.fontZoom)
            Layout.minimumWidth: 30*appWindow.fontZoom
            maximumLength: 6
            horizontalAlignment: Text.AlignLeft
        }

        BaseDialogButtonsLayout
        {
            BaseDialogButton
            {
                id: okbtn
                text: qsTr("OK") + App.loc.emptyString
                primary: true
                onClicked: custom.tryAcceptValue()
            }

            BaseDialogButton
            {
                text: qsTr("CANCEL") + App.loc.emptyString
                onClicked: custom.reject()
            }
        }

        onAboutToHide: custom.reject()

        function tryAcceptValue()
        {
            if (!/^[\d\.,]+$/.test(value.text) ||
                    parseFloat(value.text) === 0)
            {
                invalidValueDlg.open();
                return;
            }
            currentValue = +parseFloat(value.text).toFixed(2);
            closeCustom();
        }

        function closeCustom()
        {
            applyCurrentValueToCombo();
            custom.close();
            value.text = "";
        }

        function reject()
        {
            closeCustom();
        }
    }

    AppMessageDialog
    {
        id: invalidValueDlg
        title: qsTr("Invalid value") + App.loc.emptyString
        text: qsTr("Must be a number greater than 0.") + App.loc.emptyString
    }

    function applyCurrentValueToCombo()
    {
        for (var i = 0; i < combo.model.length; i++)
        {
            if (combo.model[i].value === currentValue)
            {
                combo.currentIndex = i;
                return;
            }
        }

        let m = combo.model;
        m.unshift({text: String(currentValue), value: currentValue});
        combo.model = m;
    }

    Component.onCompleted:
    {
        applyCurrentValueToCombo();
    }
}
