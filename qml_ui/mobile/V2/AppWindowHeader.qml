import QtQuick
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import "../BaseElements"
import "../BaseElements/V2"
import "../../common"

Item
{
    id: root

    signal goBack()
    signal abortSelection()
    signal clickedNtimes()

    readonly property string showTitle: ""
    readonly property string showSelectedItemCount: "2"
    readonly property string showTitleWithBackButton: "3"
    readonly property string showTitleAsError: "4"

    // showSelectedItemCount state
    property int selectedItemCount: 0

    // showTitleWithBackButton state
    property string title: App.displayName

    state: showTitle

    readonly property var stateBlock:
        state === showTitleWithBackButton ? titleWithBackButtonBlock :
        state === showSelectedItemCount ? selectedItemCountBlock :
        state === showTitleAsError ? titleAsErrorBlock :
        appTitleBlock

    implicitHeight: Math.max(40, stateBlock.implicitHeight + 8*2*appWindow.zoom)
    implicitWidth: stateBlock.implicitWidth

    Rectangle
    {
        anchors.fill: parent
        color: uicore.snailTools.isSnail ?
                   appWindow.theme_v2.appTitleBgColorInSnailMode :
                   appWindow.theme_v2.appTitleBgColor
    }

    BaseLabel
    {
        id: appTitleBlock
        visible: stateBlock === this
        text: title
        color: appWindow.theme_v2.light1000
        anchors.fill: parent
        anchors.leftMargin: appWindow.theme_v2.mainContentMargins*appWindow.zoom
        anchors.rightMargin: anchors.leftMargin
        maximumLineCount: 4
        elide: Text.ElideRight
        wrapMode: Text.WordWrap
        horizontalAlignment: lineCount === 1 ? Text.AlignHCenter : Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        font: uicore.buildFont({weight: 600}, (appWindow.theme_v2.fontSize+3)*appWindow.fontZoom)

        NClicksTrigger {
            anchors.fill: parent
            onTriggered: root.clickedNtimes()
        }
    }

    Rectangle
    {
        id: titleAsErrorBlock

        readonly property int paddingH: 12*appWindow.zoom
        readonly property int paddingV:  4*appWindow.zoom

        visible: stateBlock === this

        anchors.centerIn: parent

        color: appWindow.theme_v2.danger
        radius: 12*appWindow.zoom

        implicitWidth: titleAsErrorLabelMetrics.implicitWidth + 2*paddingH
        implicitHeight: titleAsErrorLabelMetrics.implicitHeight + 2*paddingV

        width: titleAsErrorLabelMetrics.contentWidth + 2*paddingH
        height: titleAsErrorLabelMetrics.height + 2*paddingV

        BaseLabel
        {
            id: titleAsErrorLabel

            text: title
            color: appWindow.theme_v2.bgColor
            font: uicore.buildFont({capitalization: Font.AllUppercase}, 14*appWindow.fontZoom)
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap

            anchors.fill: parent
            anchors.leftMargin: parent.paddingH
            anchors.rightMargin: parent.paddingH
            anchors.topMargin: parent.paddingV
            anchors.bottomMargin: parent.paddingV

            BaseLabel {
                id: titleAsErrorLabelMetrics
                visible: false
                width: root.width - appWindow.theme_v2.mainContentMargins*appWindow.zoom*2 - titleAsErrorBlock.paddingH*2
                text: parent.text
                font: parent.font
                wrapMode: parent.wrapMode
                horizontalAlignment: parent.horizontalAlignment
            }
        }
    }

    RowLayout
    {
        id: titleWithBackButtonBlock

        visible: stateBlock === this

        anchors.fill: parent

        spacing: 0

        Item
        {
            implicitWidth: backBtn.implicitWidth + appWindow.theme_v2.mainContentMargins*appWindow.zoom*2
            implicitHeight: backBtn.implicitHeight

            Layout.fillHeight: true

            SvgImage_V2
            {
                id: backBtn
                source: Qt.resolvedUrl("back.svg")
                imageColor: appWindow.theme_v2.light1000
                anchors.centerIn: parent
            }

            TapHandler
            {
                gesturePolicy: TapHandler.WithinBounds
                onTapped: root.goBack()
            }
        }

        BaseLabel
        {
            text: root.title
            color: appWindow.theme_v2.light1000
            font: uicore.buildFont({}, (appWindow.theme_v2.fontSize-1)*appWindow.fontZoom)
            Layout.fillWidth: true
            elide: Text.ElideRight
            wrapMode: Text.WordWrap
            maximumLineCount: 4

            NClicksTrigger {
                anchors.fill: parent
                onTriggered: root.clickedNtimes()
            }
        }

        Item
        {
            implicitWidth: appWindow.theme_v2.mainContentMargins*appWindow.zoom
            implicitHeight: 1
        }
    }

    RowLayout
    {
        id: selectedItemCountBlock

        visible: stateBlock === this

        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 12

        spacing: 16

        Item
        {
            implicitWidth: closeBtn.implicitWidth
            implicitHeight: closeBtn.implicitHeight

            Layout.fillHeight: true

            SvgImage_V2
            {
                id: closeBtn
                source: Qt.resolvedUrl("close.svg")
                imageColor: appWindow.theme_v2.light1000
                anchors.centerIn: parent
            }

            TapHandler
            {
                gesturePolicy: TapHandler.WithinBounds
                onTapped: root.abortSelection()
            }
        }

        BaseLabel
        {
            text: qsTr("Selected: %1").arg(root.selectedItemCount)
            color: appWindow.theme_v2.light1000
            Layout.fillWidth: true
        }
    }
}
