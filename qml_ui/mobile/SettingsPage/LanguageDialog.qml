import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material
import QtQuick.Effects
import org.freedownloadmanager.fdm
import "../../common"
import "../BaseElements"

CenteredDialog
{
    id: root

    parent: Overlay.overlay

    modal: true

    x: appWindow.uiver === 1 ?
           Math.round((parent.width - width) / 2) :
           parent.width - width

    contentItem: ColumnLayout {
        spacing: 0

        BaseLabel {
            adaptive: true
            labelSize: adaptiveTools.labelSize.highSize
            text: qsTr("Language") + App.loc.emptyString
            Layout.alignment: appWindow.uiver === 1 ? Qt.AlignHCenter : Qt.AlignLeft
            Layout.bottomMargin: root.topPadding
            font: uicore.buildFont({weight: Font.Medium},
                                   (appWindow.uiver === 1 ? 19 : (appWindow.theme_v2.fontSize+3))*appWindow.fontZoom)
        }

        Rectangle {
            visible: appWindow.uiver === 1
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: appWindow.theme.generalSettingsBorder
        }

        ListView {
            id: langList

            readonly property int delegateHeight: (appWindow.uiver === 1 ? 30 : 40)*appWindow.zoom

            Layout.fillHeight: true
            Layout.fillWidth: true

            flickableDirection: Flickable.VerticalFlick
            boundsBehavior: Flickable.StopAtBounds

            model: App.loc.installedTranslations

            implicitHeight: delegateHeight * count
            implicitWidth: 300

            clip: true

            delegate: Item
            {
                id: listItem

                readonly property bool isCurrentLang: App.loc.currentTranslation === modelData

                implicitWidth: listItemCt.implicitWidth
                implicitHeight: listItemCt.implicitHeight

                height: langList.delegateHeight
                width: langList.width

                ColumnLayout
                {
                    id: listItemCt

                    anchors.fill: parent
                    spacing: 0

                    RowLayout
                    {
                        Layout.fillHeight: true

                        spacing: 8*appWindow.zoom

                        Item {
                            visible: appWindow.uiver === 1
                            Layout.preferredWidth: 40*appWindow.zoom
                        }

                        Item
                        {
                            implicitWidth: flagImg.preferredWidth
                            implicitHeight: flagImg.preferredHeight
                            WaSvgImage {
                                id: flagImg
                                visible: appWindow.uiver === 1
                                source: Qt.resolvedUrl("../../images/flags/" + modelData + ".svg")
                                zoom: (appWindow.uiver === 1 ? 1 : 2)*appWindow.zoom
                            }
                            RoundedImageEffect {
                                enabled: appWindow.uiver !== 1
                                source: flagImg
                                radius: 2*appWindow.zoom
                            }
                        }

                        BaseLabel
                        {
                            text: App.loc.translationLanguageString(modelData) +
                                  " (" + App.loc.translationCountryString(modelData) + ")"
                            color: appWindow.uiver === 1 ?
                                       appWindow.theme.foreground :
                                       appWindow.theme_v2.textColor2
                            font: uicore.buildFont({capitalization: Font.Capitalize, weight: listItem.isCurrentLang ? Font.Bold : Font.Normal},
                                                   (appWindow.uiver === 1 ? 14 : appWindow.theme_v2.fontSize)*appWindow.fontZoom)
                            Layout.fillWidth: true
                        }
                    }

                    SettingsSeparator{}
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        let name = modelData;
                        root.close();
                        App.loc.load(name);
                    }
                }
            }
        }
    }

    onAboutToShow: {
        for (let i = 0; i < langList.model.length; ++i)
        {
            if (App.loc.currentTranslation === langList.model[i])
                langList.positionViewAtIndex(i, ListView.Contain);
        }
    }
}
