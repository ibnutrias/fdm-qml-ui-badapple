import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.dmcoresettings
import org.freedownloadmanager.fdm.appsettings
import org.freedownloadmanager.fdm.appfeatures
import "../BaseElements"
import "../../common"

Column {
    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        height: mainContent.height + 12*appWindow.zoom
        radius: (appWindow.uiver === 1 ? 26 : 16)*appWindow.zoom
        color: appWindow.uiver === 1 ?
                   appWindow.theme.background :
                   appWindow.theme_v2.bgColor
        Rectangle {
            width: parent.width
            height: parent.height / 2
            color: parent.color
        }

        GridLayout
        {
            id: mainContent

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: (appWindow.uiver === 1 ? 20 : appWindow.theme_v2.mainContentMargins)*appWindow.zoom
            anchors.rightMargin: anchors.leftMargin
            columns: 2
            rowSpacing: 0

            Item {implicitHeight: 10; implicitWidth: 1}
            Item {implicitHeight: 10; implicitWidth: 1}

            BasePageLabel {
                text: qsTr("Language") + App.loc.emptyString
                font: uicore.buildFont({}, (appWindow.uiver === 1 ? 16 : appWindow.theme_v2.fontSize)*appWindow.fontZoom)
                Layout.fillWidth: true
                MouseArea {
                    anchors.fill: parent
                    onClicked: langDialog.open()
                }
            }

            Item {
                implicitWidth: currentLngRow.implicitWidth
                implicitHeight: currentLngRow.implicitHeight

                RowLayout
                {
                    id: currentLngRow

                    Item {
                        implicitWidth: flagImg.preferredWidth
                        implicitHeight: flagImg.preferredHeight
                        WaSvgImage {
                            id: flagImg
                            visible: appWindow.uiver === 1
                            source: Qt.resolvedUrl("../../images/flags/" + App.loc.currentTranslation + ".svg")
                            zoom: appWindow.zoom
                        }
                        RoundedImageEffect {
                            enabled: appWindow.uiver !== 1
                            source: flagImg
                            radius: 2*appWindow.zoom
                        }
                    }

                    BaseLabel {
                        text: App.loc.translationLanguageString(App.loc.currentTranslation) + " (" + App.loc.translationCountryString(App.loc.currentTranslation) + ")"
                        font: uicore.buildFont({capitalization: Font.Capitalize},
                                               (appWindow.uiver === 1 ? 16 : appWindow.theme_v2.fontSize)*appWindow.fontZoom)
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: langDialog.open()
                }
            }

            Item {visible: App.loc.needRestart; implicitHeight: 10; implicitWidth: 1}
            RestartRequiredLabel {visible: App.loc.needRestart; Layout.topMargin: 5*appWindow.zoom}
        }
    }

    LanguageDialog {
        id: langDialog
    }
}
