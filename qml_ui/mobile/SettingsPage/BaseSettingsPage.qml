import QtQuick
import QtQuick.Controls
import "../BaseElements"
import "../V2"

BaseMainPage
{
    id: root

    property bool isRoot: false
    property var validateSettingsFn: null

    objectName: uicore.settingsPageName

    enableFooter: isRoot

    background: Rectangle
    {
        color: appWindow.uiver === 1 ?
                   (root.isRoot ? appWindow.theme.generalSettingsBackground : appWindow.theme.background) :
                   (root.isRoot ? appWindow.theme_v2.bg300_2 : appWindow.theme_v2.bgColor)
        anchors.fill: parent

        Rectangle
        {
            visible: appWindow.uiver !== 1 && isRoot
            color: appWindow.theme_v2.bgColor
            anchors.bottom: parent.bottom
            height: parent.height - header.height - 100*appWindow.zoom
            width: parent.width
        }
    }

    Component
    {
        id: header_v1
        PageHeaderWithBackArrow
        {
            pageTitle: root.title
            onPopPage: validateAndClose()
            onClickedNtimes: uiSettingsTools.settings.showTroubleshootingUi = true
        }
    }

    Component
    {
        id: header_v2
        AppWindowHeader
        {
            title: root.title
            state: root.isRoot ? showTitle : showTitleWithBackButton
            onGoBack: validateAndClose()
            onClickedNtimes: uiSettingsTools.settings.showTroubleshootingUi = true
        }
    }

    header: Loader
    {
        sourceComponent: appWindow.uiver === 1 ? header_v1 : header_v2
    }

    function validateSettings()
    {
        return !validateSettingsFn || validateSettingsFn();
    }

    function validateAndClose()
    {
        if (validateSettings())
            StackView.view.pop();
    }
}
