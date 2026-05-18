import QtQuick
import QtQuick.Controls

Switch
{
    id: control

    padding: 0

    indicator: Rectangle
    {
        implicitWidth: appWindow.uiver === 1 ? 38 : 40
        implicitHeight: appWindow.uiver === 1 ? 14 : 20

        x: LayoutMirroring.enabled ?
               parent.width - width - qtbug.getLeftPadding(control) :
               qtbug.getLeftPadding(control)

        y: (parent.height - height) / 2

        radius: appWindow.uiver === 1 ? 7 : 40

        color: appWindow.uiver === 1 ?
                   (control.checked ? appWindow.theme.switchBackgroundOn : appWindow.theme.switchBackgroundOff) :
                   (control.checked ?
                        appWindow.theme_v2.primary :
                        (appWindow.theme_v2.isLightTheme ? appWindow.theme_v2.light700 : appWindow.theme_v2.dark500))

        opacity: enabled ? 1 : (appWindow.uiver === 1 ? 0.5 : appWindow.theme_v2.opacityDisabled)

        Rectangle
        {
            x: LayoutMirroring.enabled ?
                   (control.checked ? 2 : parent.width - width - 2) :
                   (control.checked ? parent.width - width - 2 : 2)

            y: (parent.height - height) / 2

            width: appWindow.uiver === 1 ? 20 : 16
            height: appWindow.uiver === 1 ? 20 : 16
            radius: appWindow.uiver === 1 ? 10 : 16

            color: appWindow.uiver === 1 ?
                       (control.checked ? appWindow.theme.switchTumblerOn : appWindow.theme.switchTumblerOff) :
                       appWindow.theme_v2.light1000
        }
    }

    contentItem: BaseLabel
    {
        anchors.left: parent.left
        anchors.verticalCenter: control.verticalCenter
        leftPadding: qtbug.leftPadding(control.leftPadding + control.indicator.width + (text ? control.spacing : 0), control.rightPadding)
        rightPadding: qtbug.rightPadding(control.leftPadding + control.indicator.width + (text ? control.spacing : 0), control.rightPadding)
        text: control.text
    }
}
