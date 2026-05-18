import QtQuick
import "../BaseElements/V2"
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.appfeatures

Item
{
    property bool showCheckmark: false

    enabled: !downloadsItemTools.locked && !downloadsItemTools.stopping
    opacity: enabled ? 1 : appWindow.theme_v2.opacityDisabled

    implicitWidth: 40
    implicitHeight: 40

    Rectangle
    {
        visible: downloadsItemTools.buttonType === downloadsItemTools.buttonTypes.start ||
                 downloadsItemTools.buttonType === downloadsItemTools.buttonTypes.restart ||
                 downloadsItemTools.buttonType === downloadsItemTools.buttonTypes.pause ||
                 downloadsItemTools.buttonType === downloadsItemTools.buttonTypes.scheduler

        radius: 8
        color: appWindow.theme_v2.bg300_2
        anchors.fill: parent

        SvgImage_V2
        {
            anchors.centerIn: parent

            source: Qt.resolvedUrl(
                        downloadsItemTools.buttonType === downloadsItemTools.buttonTypes.scheduler ? "scheduled.svg" :
                        downloadsItemTools.buttonType === downloadsItemTools.buttonTypes.pause ? "pause.svg" :
                        "play.svg")
        }
    }

    SvgImage_V2
    {
        visible: downloadsItemTools.buttonType === downloadsItemTools.buttonTypes.showInFolder

        source: Qt.resolvedUrl("folder.svg")

        imageColor: appWindow.theme_v2.primary

        anchors.horizontalCenter: parent.horizontalCenter
    }

    Rectangle
    {
        visible: showCheckmark

        x: 28
        y: 28

        width: 20
        height: 20

        radius: 5

        color: appWindow.theme_v2.secondary

        border.color: appWindow.theme_v2.bg100
        border.width: 2

        SvgImage_V2
        {
            source: Qt.resolvedUrl("checkmark.svg")
            anchors.centerIn: parent
            imageColor: appWindow.theme_v2.bg100
        }
    }

    TapHandler
    {
        gesturePolicy: TapHandler.WithinBounds

        onTapped:
        {
            if (!downloadsItemTools.locked)
            {
                if (downloadsItemTools.buttonType === downloadsItemTools.buttonTypes.showInFolder &&
                    !App.features.hasFeature(AppFeatures.OpenFolder))
                {
                    fileManagerSupportDlg.open();
                }
                else
                {
                    downloadsItemTools.doAction();
                }
            }
        }
    }
}
