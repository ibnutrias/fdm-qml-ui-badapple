import QtQuick
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.appfeatures
import "BaseElements"
import "BaseElements/V2"

Item
{
    enabled: App.features.hasFeature(AppFeatures.Donate) &&
             (App.donate.showDonate || appWindow.forceShowDonateUi)

    visible: enabled

    implicitWidth: ct.implicitWidth
    implicitHeight: ct.implicitHeight

    Rectangle
    {
        color: appWindow.uiver === 1 ?
                   appWindow.theme.background :
                   appWindow.theme_v2.bgColor
        anchors.fill: parent
    }

    ColumnLayout
    {
        id: ct

        anchors.fill: parent

        spacing: 0

        Rectangle
        {
            implicitHeight: 1*appWindow.zoom
            Layout.fillWidth: true
            color: appWindow.uiver === 1 ?
                       appWindow.theme.border :
                       appWindow.theme_v2.separator
        }

        RowLayout
        {
            Layout.fillWidth: true
            Layout.leftMargin: appWindow.theme_v2.mainContentMargins*appWindow.zoom
            Layout.rightMargin: Layout.leftMargin
            Layout.topMargin: 4*appWindow.zoom
            Layout.bottomMargin: 4*appWindow.zoom

            spacing: 0

            Item {Layout.fillWidth: true}

            RowGridLayout
            {
                id: mainCt

                Layout.fillWidth: true
                Layout.maximumWidth: Math.ceil(implicitWidth1Row)

                BaseLabel
                {
                    text: qsTr("Help shape %1").arg(App.shortDisplayName) + App.loc.emptyString
                    font: uicore.buildFont({weight: Font.Medium},
                                           uicore.fontSizeV1(16)*appWindow.fontZoom)
                    Layout.fillWidth: true
                    Layout.maximumWidth: Math.ceil(implicitWidth)
                    wrapMode: Text.WordWrap
                }

                DialogFlatButton_V2
                {
                    text: qsTr("Suggest & Support") + App.loc.emptyString
                    imageSource: Qt.resolvedUrl("V2/MainMenu/external_link.svg")
                    layoutDirection: Qt.RightToLeft
                    primary: appWindow.uiver !== 1
                    onClicked: {
                        App.donate.onDonateDialogAccepted();
                        appWindow.forceShowDonateUi = false;
                    }
                }
            }

            Item {implicitWidth: 12*appWindow.zoom}

            Item
            {
                implicitWidth: childrenRect.width
                implicitHeight: childrenRect.height

                Layout.alignment: mainCt.width < mainCt.implicitWidth1Row ?
                                      Qt.AlignTop :
                                      0

                SvgImage_V2
                {
                    source: Qt.resolvedUrl("V2/close.svg")
                    anchors.centerIn: parent
                }

                MouseArea
                {
                    anchors.fill: parent
                    anchors.margins: -10*appWindow.zoom
                    onClicked: {
                        App.donate.onDonateDialogDeclined();
                        appWindow.forceShowDonateUi = false;
                    }
                }
            }

            Item {Layout.fillWidth: true}
        }
    }
}
