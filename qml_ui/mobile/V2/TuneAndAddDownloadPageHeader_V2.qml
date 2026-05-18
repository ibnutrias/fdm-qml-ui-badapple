import QtQuick
import org.freedownloadmanager.fdm

AppWindowHeader
{
    state: showTitleWithBackButton
    title: qsTr("New file") + App.loc.emptyString
    onGoBack: downloadTools.doReject()
}
