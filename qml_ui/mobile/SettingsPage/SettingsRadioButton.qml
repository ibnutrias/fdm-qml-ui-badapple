import QtQuick
import QtQuick.Controls
import "../BaseElements"

BaseRadioButton
{
    textColor: appWindow.uiver === 1 ?
               appWindow.theme.foreground :
               appWindow.theme_v2.textColor2
}
