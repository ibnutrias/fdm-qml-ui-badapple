import QtQuick

Loader
{
    id: root

    signal clicked()

    property string text
    property bool primary: false
    property color textColor: appWindow.theme.foreground // V1 only
    property int radius: height // V1 only

    source: Qt.resolvedUrl(appWindow.uiver === 1 ? "DialogButton_V1.qml" : "V2/DialogFlatButton_V2.qml")

    onItemChanged:
    {
        if (!item)
            return;

        item.clicked.connect(clicked);

        item.text = Qt.binding(() => root.text);

        if (appWindow.uiver === 1)
        {
            item.textColor = Qt.binding(() => root.textColor);
            item.radius = Qt.binding(() => root.radius);
        }
        else
        {
            item.primary = Qt.binding(() => root.primary);
        }
    }
}
