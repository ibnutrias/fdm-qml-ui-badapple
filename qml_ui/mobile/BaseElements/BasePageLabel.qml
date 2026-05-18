import QtQuick

BaseLabel
{
    color: appWindow.uiver === 1 ?
               appWindow.theme.foreground :
               appWindow.theme_v2.textColor2
}
