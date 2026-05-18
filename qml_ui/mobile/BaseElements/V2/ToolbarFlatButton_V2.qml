import QtQuick
import QtQuick.Layouts
import ".."

Item
{
    id: root

    signal clicked()
    signal checkBoxClicked()

    property bool hasCheckBox: false
    property url iconSource
    property string title
    property var dropDownMenu: null
    property int thAddLeft: 0
    property int thAddRight: 0
    property int thAddTop: 0
    property int thAddBottom: 0

    property alias checked: cb.checked

    implicitHeight: ct.implicitHeight
    implicitWidth: ct.implicitWidth

    Item {
        anchors.fill: parent
        anchors.leftMargin: -thAddLeft
        anchors.rightMargin: -thAddRight
        anchors.topMargin: -thAddTop
        anchors.bottomMargin: -thAddBottom
        TapHandler {
            gesturePolicy: TapHandler.WithinBounds
            onTapped: {
                if (root.dropDownMenu)
                    root.dropDownMenu.open();
                else
                    root.clicked();
            }
        }
    }

    RowLayout
    {
        id: ct

        width: parent.width

        spacing: 4

        BaseCheckBox
        {
            id: cb
            visible: hasCheckBox
            onClicked: root.checkBoxClicked()
        }

        Item
        {
            visible: root.iconSource.toString()

            implicitWidth: 16
            implicitHeight: 16

            SvgImage_V2
            {
                source: root.iconSource
                anchors.centerIn: parent
            }
        }

        BaseLabel
        {
            visible: text
            text: root.title
            font: uicore.buildFont({}, (appWindow.theme_v2.fontSize-1)*appWindow.fontZoom)
            Layout.fillWidth: true
            elide: Text.ElideRight
        }

        Item
        {
            implicitWidth: 16
            implicitHeight: 16

            SvgImage_V2
            {
                source: Qt.resolvedUrl("expand_more.svg")
                anchors.centerIn: parent
            }
        }
    }
}
