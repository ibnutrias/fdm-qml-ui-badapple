import QtQuick
import QtQuick.Layouts
import "../BaseElements"
import "../BaseElements/V2"

Item
{
    enabled: false

    visible: enabled

    implicitWidth: ct.implicitWidth
    implicitHeight: ct.implicitHeight

    Rectangle
    {
        color: appWindow.theme_v2.bgColor
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
            color: appWindow.theme_v2.separator
        }

        RowLayout
        {
            Layout.fillWidth: true
            Layout.leftMargin: appWindow.theme_v2.mainContentMargins*appWindow.zoom
            Layout.rightMargin: Layout.leftMargin
            Layout.topMargin: 7*appWindow.zoom

            spacing: 0

            Item {Layout.fillWidth: true}

            RowGridLayout
            {
                Layout.maximumWidth: Math.ceil(implicitWidth1Row)
                Layout.preferredWidth: Math.ceil(implicitWidth1Row)
                Layout.minimumWidth: 1 // qt bug(?) workaround
                Layout.fillWidth: true

                columnSpacing: 12*appWindow.zoom

                BaseLabel
                {
                    text: uicore.appReview.enjoyAppQuestion
                    font: uicore.buildFont({weight: Font.DemiBold}, (appWindow.theme_v2.fontSize+1)*appWindow.fontZoom)
                }

                RowLayout
                {
                    spacing: 10*appWindow.zoom

                    DialogFlatButton_V2
                    {
                        text: uicore.appReview.notReally
                        onClicked: {
                            hide();
                            dontLikeDlg.open();
                        }
                    }

                    DialogFlatButton_V2
                    {
                        text: uicore.appReview.yes
                        primary: true
                        onClicked: {
                            hide();
                            likeDlg.open();
                        }
                    }
                }
            }

            Item {implicitWidth: appWindow.theme_v2.mainContentMargins*appWindow.zoom*2}

            Item
            {
                implicitWidth: childrenRect.width
                implicitHeight: childrenRect.height

                SvgImage_V2
                {
                    source: Qt.resolvedUrl("close.svg")
                    anchors.centerIn: parent
                }

                MouseArea
                {
                    anchors.fill: parent
                    anchors.margins: -10*appWindow.zoom
                    onClicked:
                    {
                        uicore.appReview.remindLater();
                        hide();
                    }
                }
            }

            Item {Layout.fillWidth: true}
        }
    }

    function show()
    {
        enabled = true;
    }

    function hide()
    {
        enabled = false;
    }

    Connections
    {
        target: uicore.appReview
        onAppReviewRequested: show()
    }

    AppReviewOnLikeDialog
    {
        id: likeDlg
    }

    AppReviewOnDontLikeDialog
    {
        id: dontLikeDlg
    }
}
