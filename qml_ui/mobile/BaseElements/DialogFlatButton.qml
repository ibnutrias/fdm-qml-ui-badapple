import QtQuick
import QtQuick.Controls.Material

Loader
{
    id: root

    signal clicked()

    property string text
    property string iconSource
    property int iconWidth: 18
    property int iconHeight: iconWidth
    property bool primary: false

    source: Qt.resolvedUrl(appWindow.uiver === 1 ? "BaseRoundButton.qml" : "V2/DialogFlatButton_V2.qml")

    onItemChanged:
    {
        if (!item)
            return;

        item.clicked.connect(clicked);

        item.text = Qt.binding(() => root.text);

        if (appWindow.uiver === 1)
        {
            item.icon.source = Qt.binding(() => root.iconSource);
            item.icon.width = Qt.binding(() => root.iconWidth);
            item.icon.height = Qt.binding(() => root.iconHeight);
            item.icon.color = Qt.binding(() => root.primary ? appWindow.theme.toolbarTextColor : appWindow.theme.foreground);
            item.Material.foreground = Qt.binding(() => root.primary ? appWindow.theme.toolbarTextColor : appWindow.theme.foreground);
            item.Material.background = Qt.binding(() => root.primary ? appWindow.theme.selectModeBarAndPlusBtn : appWindow.theme.background);
        }
        else
        {
            item.imageSource = Qt.binding(() => root.iconSource);
            item.primary = Qt.binding(() => root.primary);
        }
    }
}
