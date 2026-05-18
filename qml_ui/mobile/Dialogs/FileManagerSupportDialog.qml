import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import org.freedownloadmanager.fdm
import "../../common"
import "../BaseElements"

AppMessageDialog
{
    id: root

    title: qsTr("No supported file managers found.") + App.loc.emptyString
}
