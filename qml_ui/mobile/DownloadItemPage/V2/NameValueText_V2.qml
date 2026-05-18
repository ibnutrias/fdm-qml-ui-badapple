import QtQuick
import QtQuick.Layouts
import "../../BaseElements"

RowLayout
{
    signal linkActivated(var url)

    property alias name: nameLabel.text
    property alias value: valueLabel.text
    property alias valueElide: valueLabel.elide
    property alias valueWrapMode: valueLabel.wrapMode

    spacing: 4

    BaseLabel
    {
        id: nameLabel
        color: appWindow.theme_v2.bg700
        Layout.alignment: Qt.AlignTop
    }

    BaseLabel
    {
        id: valueLabel
        linkColor: appWindow.theme_v2.primary
        onLinkActivated: url => parent.linkActivated(url)
        Layout.fillWidth: true
        elide: Text.ElideMiddle
    }
}
