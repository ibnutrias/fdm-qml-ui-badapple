import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import "BaseElements"

BasePage
{
    id: root

    readonly property bool isOkToSend: !App.bugReporter.sending &&
                                       reportTitle.text.trim() && description.text.trim() && isEmailOk(email.text.trim())

    title: qsTr("Submit a bug report") + App.loc.emptyString

    component DataBlock : ColumnLayout {
        spacing: 8*appWindow.zoom
    }

    component RequiredFieldMark : BaseLabel {
        text: "*"
        color: appWindow.uiver === 1 ? "red" : appWindow.theme_v2.danger
        font: uicore.buildFont({bold: true}, (appWindow.theme_v2.fontSize+1)*appWindow.fontZoom)
        Layout.alignment: Qt.AlignTop
    }

    Flickable
    {
        id: f

        Layout.fillWidth: true
        Layout.fillHeight: true

        flickableDirection: Flickable.VerticalFlick
        ScrollIndicator.vertical: ScrollIndicator { }
        boundsBehavior: Flickable.StopAtBounds

        implicitHeight: all.implicitHeight
        contentHeight: all.height

        ColumnLayout
        {
            id: all

            spacing: contentItemSpacing

            width: f.width
            height: Math.max(implicitHeight, f.height)

            DataBlock {
                RowLayout {
                    BasePageLabel {
                        text: qsTr("Title") + App.loc.emptyString
                    }
                    RequiredFieldMark {}
                }

                BaseTextField {
                    id: reportTitle
                    focus: true
                    Layout.fillWidth: true
                }
            }

            DataBlock {
                RowLayout {
                    BasePageLabel {
                        text: qsTr("Description") + App.loc.emptyString
                    }
                    RequiredFieldMark{}
                }

                ScrollView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.minimumHeight: 80*appWindow.fontZoom

                    BaseTextArea {
                        id: description
                        wrapMode: TextArea.WordWrap
                    }
                }
            }

            DataBlock {
                BasePageLabel {
                    text: qsTr("Name") + App.loc.emptyString
                }

                BaseTextField {
                    id: name
                    Layout.fillWidth: true
                }
            }

            DataBlock {
                RowLayout {
                    BasePageLabel {
                        text: qsTr("E-mail") + App.loc.emptyString
                    }
                    RequiredFieldMark{}
                }

                BaseTextField {
                    id: email
                    Layout.fillWidth: true
                    color: isEmailOk(text) ?
                               (appWindow.uiver === 1 ? appWindow.theme.foreground : appWindow.theme_v2.textColor) :
                               (appWindow.uiver === 1 ? appWindow.theme.errorMessage : appWindow.theme_v2.danger)
                }
            }

            BaseCheckBox {
                id: sendLogs
                text: qsTr("Attach %1 log files (recommended)").arg(App.shortDisplayName) + App.loc.emptyString
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                checked: true
            }

            BaseLabel {
                text: App.bugReporter.error
                visible: text
                color: appWindow.uiver === 1 ?
                           appWindow.theme.errorMessage :
                           appWindow.theme_v2.danger
                Layout.fillWidth: true
            }

            RowLayout {
                opacity: 0.5
                RequiredFieldMark{}
                BaseLabel {
                    text: qsTr("Required fields") + App.loc.emptyString
                    Layout.fillWidth: true
                }
            }

            BaseDialogButton {
                enabled: root.isOkToSend
                primary: true
                text: (App.bugReporter.sending ? qsTr("Submitting") : qsTr("Submit")) + App.loc.emptyString
                onClicked: root.send()
                Layout.fillWidth: true
            }
        }
    }

    Component.onCompleted: {
        App.bugReporter.clearError()
        reportTitle.forceActiveFocus()
    }

    function send()
    {
        if (!root.isOkToSend)
            return;

        App.bugReporter.send(reportTitle.text.trim(), description.text.trim(), name.text.trim(), email.text.trim(), sendLogs.checked)
    }

    function isEmailOk(str)
    {
        return /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/.test(str);
    }

    Connections {
        target: App.bugReporter
        onSendingChanged: {
            if (!App.bugReporter.sending && !App.bugReporter.error && root.StackView.view.currentItem === root)
                root.StackView.view.pop()
        }
    }
}
