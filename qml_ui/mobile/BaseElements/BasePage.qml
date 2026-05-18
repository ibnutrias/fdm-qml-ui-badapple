import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../V2"

Page
{
    id: root

    property bool backButtonVisible: true
    property var goBackHandler: () => {root.StackView.view.pop()}
    property bool v1_okButtonVisible: false
    property bool v1_okButtonEnabled: true
    readonly property int supposedContentItemSpacing: 16*appWindow.zoom
    property int contentItemSpacing: supposedContentItemSpacing
    signal v1_okButtonClicked()

    padding: (appWindow.uiver === 1 ? 14 : appWindow.theme_v2.mainContentMargins)*appWindow.zoom
    leftPadding: padding
    rightPadding: padding
    topPadding: padding
    bottomPadding: padding

    focus: StackView.view && StackView.view.currentItem === this

    property var header_v1: Component
    {
        PageHeaderWithBackArrow
        {
            pageTitle: root.title
            backButtonVisible: root.backButtonVisible
            okButtonVisible: v1_okButtonVisible
            okButtonEnabled: v1_okButtonEnabled
            onPopPage: root.goBackHandler()
            onOkButtonClicked: v1_okButtonClicked()
        }
    }

    property var header_v2: Component
    {
        AppWindowHeader
        {
            state: backButtonVisible?
                       showTitleWithBackButton :
                       showTitle
            title: root.title
            onGoBack: root.goBackHandler()
        }
    }

    header: Loader
    {
        sourceComponent: appWindow.uiver === 1 ?
                             header_v1 :
                             header_v2
    }

    contentItem: ColumnLayout
    {
        spacing: contentItemSpacing
    }
}
