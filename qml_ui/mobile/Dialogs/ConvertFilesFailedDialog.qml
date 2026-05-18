import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import "../BaseElements"

CenteredDialog
{
    id: root

    property var files: []

    parent: Overlay.overlay

    modal: true

    title: qsTr("Convert failed") + App.loc.emptyString

    Flickable
    {
        clip: true

        Layout.fillWidth: true
        Layout.fillHeight: true

        implicitHeight: contentHeight
        implicitWidth: Math.min(filesLabel.implicitWidth, ctMaxWidth)

        contentHeight: filesLabel.contentHeight

        BaseLabel
        {
            id: filesLabel
            text: files.join("\n")
            elide: Text.ElideMiddle
            width: parent.width
        }

        ScrollBar.vertical: ScrollBar {}
    }

    BaseDialogButtonsLayout
    {
        BaseDialogButton
        {
            text: qsTr("OK") + App.loc.emptyString
            primary: true
            onClicked: root.close()
        }
    }

    BaseFontMetrics
    {
        id: fm
    }
}
