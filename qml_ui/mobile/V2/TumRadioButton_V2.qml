import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.appsettings
import org.freedownloadmanager.fdm.dmcoresettings
import org.freedownloadmanager.fdm.tum
import "../BaseElements"
import "../BaseElements/V2"
import "../../common/Core"

Item
{
    id: root

    signal clicked()

    required property var mode

    TumButtonHelper {id: helper}

    implicitWidth: ct.implicitWidth
    implicitHeight: ct.implicitHeight

    component MyLabel : BaseLabel
    {
        color: appWindow.theme_v2.drawerMenuItemTextColor
    }

    component MyTumImg : Item
    {
        property alias source: myTumImg.source
        implicitWidth: 14
        implicitHeight: implicitWidth
        SvgImage_V2
        {
            id: myTumImg
            imageColor: appWindow.theme_v2.drawerMenuItemTextColor
            anchors.centerIn: parent
        }
    }

    component TumSpeed : RowLayout
    {
        MyLabel
        {
            visible: mode === TrafficUsageMode.High
            text: qsTr("No speed limit") + App.loc.emptyString
        }

        RowLayout
        {
            visible: mode !== TrafficUsageMode.High

            spacing: 0

            MyTumImg
            {
                id: img1
                source: Qt.resolvedUrl("tum_download.svg")
            }

            Item {implicitWidth: 2; implicitHeight: 1}

            MyLabel
            {
                text: App.speedAsText(App.settings.tum.value(mode, DmCoreSettings.MaxDownloadSpeed)) + App.loc.emptyString
            }

            Item {implicitWidth: 6; implicitHeight: 1}

            Rectangle
            {
                implicitWidth: 1
                implicitHeight: img1.implicitHeight
                color: appWindow.theme_v2.drawerMenuItemTextColor
            }

            Item {implicitWidth: 6; implicitHeight: 1}

            MyTumImg
            {
                source: Qt.resolvedUrl("tum_upload.svg")
            }

            Item {implicitWidth: 2; implicitHeight: 1}

            MyLabel
            {
                text: App.speedAsText(App.settings.tum.value(mode, DmCoreSettings.MaxUploadSpeed)) + App.loc.emptyString
            }
        }
    }

    RowLayout
    {
        id: ct

        anchors.fill: parent

        spacing: 8*appWindow.zoom

        BaseRadioButton
        {
            checked: mode === App.settings.tum.currentMode
            Layout.alignment: Qt.AlignTop
            onClicked: {
                checked = Qt.binding(() => App.settings.tum.currentMode);
                root.onClicked();
            }
        }

        ColumnLayout
        {
            Layout.fillWidth: true
            spacing: 0

            RowLayout
            {
                Layout.fillWidth: true

                TumSpeed
                {
                    Layout.alignment: Qt.AlignTop
                }

                Item {Layout.fillWidth: true}

                TumButtonRect_V2
                {
                    mode: root.mode
                    adjustWidth: true
                }
            }

            RowLayout
            {
                Layout.fillWidth: true

                BaseLabel
                {
                    Layout.fillWidth: true
                    Layout.maximumWidth: Math.ceil(implicitWidth)
                    Layout.preferredWidth: Math.ceil(implicitWidth)
                    text: qsTr("Maximum parallel downloads") + App.loc.emptyString
                    font: uicore.buildFont({}, (appWindow.theme_v2.fontSize-1)*appWindow.fontZoom)
                    elide: Text.ElideRight
                }

                BaseLabel
                {
                    text: App.settings.tum.value(mode, DmCoreSettings.MaxDownloads)
                    color: helper.tumDisplayColor(mode)
                    font: uicore.buildFont({weight: Font.Medium}, 
                                           (appWindow.theme_v2.fontSize-1)*appWindow.fontZoom)
                }

                Item {Layout.fillWidth: true}
            }
        }
    }

    TapHandler
    {
        gesturePolicy: TapHandler.WithinBounds
        onTapped: onClicked()
    }

    function onClicked()
    {
        App.settings.tum.currentMode = mode;
        root.clicked();
    }
}
