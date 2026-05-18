import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import "../../common"
import "../../common/Tools"
import "../BaseElements"

CenteredDialog
{
    id: root

    modal: true

    title: App.displayName +
           (appWindow.hasDownloadMgr ? "" : (" (" + qsTr("remote control") + App.loc.emptyString + ")"))
    titleNClicks: 10
    onTitleClickedNTimes: App.testVersion = true

    BaseLabel
    {
        text: qsTr("Version %1 (%2)").arg(App.version).arg(App.versionHash) + App.loc.emptyString
        Layout.fillWidth: true
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font: uicore.buildFont({}, uicore.fontSizeV1(16*appWindow.fontZoom))
    }

    BaseLabel
    {
        visible: App.testVersion
        text: "Test mode is active <a href='#'>turn off</a>"
        onLinkActivated: {App.testVersion = false;}
        font: uicore.buildFont({}, uicore.fontSizeV1(16*appWindow.fontZoom))
    }

    Repeater
    {
        model: App.thirdPartyLibsInfos.size()

        BaseLabel {
            text: "<a href='%1'>%2</a>".arg(App.thirdPartyLibsInfos.url(index)).arg(App.thirdPartyLibsInfos.displayName(index))
                      + ' ' + qsTr("version %1").arg(App.thirdPartyLibsInfos.displayVersion(index))
                      + App.loc.emptyString
            onLinkActivated: Qt.openUrlExternally(link)
            font: uicore.buildFont({}, uicore.fontSizeV1(16*appWindow.fontZoom))
        }
    }

    BaseLabel
    {
        //: © FreeDownloadManager.org, 2004-2023
        text: qsTr("© %1, %2-%3").arg("<a href='https://www.freedownloadmanager.org'>FreeDownloadManager.org</a>")
                .arg(App.copytightFirstYear()).arg(App.copytightLastYear()) + App.loc.emptyString
        onLinkActivated: Qt.openUrlExternally(link)
        font: uicore.buildFont({}, uicore.fontSizeV1(16*appWindow.fontZoom))
    }
}
