import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.abstractdownloadsui 
import "../../common"
import "../BaseElements"

CenteredDialog
{
    id: root

    property double downloadId: -1
    property var info: downloadId !== -1 ? App.downloads.infos.info(downloadId) : null

    parent: Overlay.overlay

    modal: true

    title: qsTr("Download Failure") + App.loc.emptyString

    RowLayout
    {
        WaSvgImage
        {
            source: appWindow.theme.attentionImg
            width: 16
            height: 16
            Layout.alignment: Qt.AlignTop
        }

        BaseLabel
        {
            text: qsTr("Can't resume download. Download link likely expired. Resume attempts failed.") + "<br><br>" +
                  qsTr("Please try to update the download link to resume.") + "<br><br>" +
                  qsTr("Go to the website with the original download source and copy the renewed link") +
                  (info && App.tools.isBrowsableUrl(info.webPageUrl) ? " - <a href='" + info.webPageUrl.toString() + "'>" + qsTr("click here") + "</a>" : "") + "." +
                  App.loc.emptyString
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.maximumWidth: Math.min(ctMaxWidth, 500*appWindow.zoom)
            wrapMode: Label.WordWrap
            textFormat: Text.StyledText
            onLinkActivated: {
                root.close();
                App.openDownloadUrl(link);
            }
        }
    }

    BaseDialogButtonsLayout
    {
        BaseDialogButton
        {
            visible: info && (info.flags & AbstractDownloadsUi.AllowChangeSourceUrl)
            text: qsTr("Update download") + App.loc.emptyString
            primary: true
            onClicked: {
                root.close();
                stackView.waPush(Qt.resolvedUrl("../ChangeUrlPage.qml"), {downloadModel:root.info})
            }
        }

        BaseDialogButton
        {
            text: qsTr("Close") + App.loc.emptyString
            onClicked: root.close()
        }
    }
}
