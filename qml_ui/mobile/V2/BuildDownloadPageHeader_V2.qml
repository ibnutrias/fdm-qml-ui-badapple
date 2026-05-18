import QtQuick
import org.freedownloadmanager.fdm

AppWindowHeader
{
    state: showTitleWithBackButton
    title: qsTr("Add download") + App.loc.emptyString
    onGoBack: downloadTools.doReject()
}
