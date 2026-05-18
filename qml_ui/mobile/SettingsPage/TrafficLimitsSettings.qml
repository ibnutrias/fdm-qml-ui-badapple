import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.dmcoresettings
import org.freedownloadmanager.fdm.appsettings
import org.freedownloadmanager.fdm.tum
import "../BaseElements"
import "../BaseElements/V2"

BaseSettingsPage {
    id: root

    property bool smallScreen: width < 500

    title: qsTr("Traffic limits") + App.loc.emptyString

    validateSettingsFn: () => {
        invalidSettingsMessageDialog.lastInvalidSettingsMessage = root.invalidSettingsMessage();
        if (invalidSettingsMessageDialog.lastInvalidSettingsMessage !== "")
        {
            invalidSettingsMessageDialog.open();
            return false;
        }
        return true;
    }

    InvalidSettingsMessageDialog {
        id: invalidSettingsMessageDialog
        lastInvalidSettingsMessage: ""
        onPopPage: root.StackView.view.pop()
    }

    Flickable
    {
        anchors.fill: parent
        flickableDirection: Flickable.VerticalFlick
        ScrollIndicator.vertical: ScrollIndicator { }
        boundsBehavior: Flickable.StopAtBounds

        contentHeight: contentColumn.height + 20

        clip: true

        ColumnLayout {
            id: contentColumn
            anchors.left: parent.left
            anchors.right: parent.right

            spacing: 0

            property var currentSection: null

            component SectionHeader: Item {
                id: sh

                property string name

                readonly property bool isCurrent: contentColumn.currentSection === this
                readonly property int spacing: 10*appWindow.zoom

                implicitWidth: shL.implicitWidth + spacing + shI.implicitWidth
                implicitHeight: shL.implicitHeight

                Layout.fillWidth: true
                Layout.maximumWidth: Math.min(parent.width, Math.ceil(implicitWidth))

                SettingsGroupHeader {
                    id: shL
                    name: sh.name
                    width: parent.width - (spacing + shI.implicitWidth)
                    anchors.left: parent.left
                }

                SvgImage_V2 {
                    id: shI
                    source: Qt.resolvedUrl("../BaseElements/V2/expand_more.svg")
                    imageColor: shL.color
                    rotation: isCurrent ? 180 : 0
                    anchors.left: parent.left
                    anchors.leftMargin: shL.contentWidth + spacing
                    anchors.verticalCenter: parent.verticalCenter
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: contentColumn.currentSection = isCurrent ? null : parent
                }
            }

            component MyLayout: RowGridLayout {
                Layout.fillWidth: true
                Layout.maximumWidth: Math.min(parent.width - Layout.leftMargin - Layout.rightMargin, Math.ceil(implicitWidth1Row))

                Layout.leftMargin: (appWindow.uiver === 1 ? 20 : appWindow.theme_v2.mainContentMargins)*appWindow.zoom
                Layout.rightMargin: Layout.leftMargin
            }

            component Separator: SettingsSeparator {
                required property bool sectionOpened
                Layout.fillWidth: true
                Layout.leftMargin: appWindow.uiver === 1 ? 0 : appWindow.theme_v2.mainContentMargins*appWindow.zoom
                Layout.rightMargin: Layout.leftMargin
                Layout.topMargin: (sectionOpened ? 14 : 0)*appWindow.zoom
            }

            SectionHeader {
                id: downloadSpeedSection
                name: qsTr("Download speed") + App.loc.emptyString
                Layout.fillWidth: true
            }

            MyLayout {
                visible: downloadSpeedSection.isCurrent
                SpeedComboBoxWrapper {
                    comboBoxText: qsTr("Low") + App.loc.emptyString
                    speedLimitMode: TrafficUsageMode.Low
                    speedLimitSetting: DmCoreSettings.MaxDownloadSpeed
                }

                SpeedComboBoxWrapper {
                    comboBoxText: qsTr("Medium") + App.loc.emptyString
                    speedLimitMode: TrafficUsageMode.Medium
                    speedLimitSetting: DmCoreSettings.MaxDownloadSpeed
                }

                SpeedComboBoxWrapper {
                    comboBoxText: qsTr("High") + App.loc.emptyString
                    speedLimitMode: TrafficUsageMode.High
                    speedLimitSetting: DmCoreSettings.MaxDownloadSpeed
                }
            }

            Separator {sectionOpened: downloadSpeedSection.isCurrent}

            SectionHeader {
                id: uploadSpeedSection
                name: qsTr("Upload speed") + App.loc.emptyString
                Layout.fillWidth: true
            }

            MyLayout {
                visible: uploadSpeedSection.isCurrent

                SpeedComboBoxWrapper {
                    comboBoxText: qsTr("Low") + App.loc.emptyString
                    speedLimitMode: TrafficUsageMode.Low
                    speedLimitSetting: DmCoreSettings.MaxUploadSpeed
                }

                SpeedComboBoxWrapper {
                    comboBoxText: qsTr("Medium") + App.loc.emptyString
                    speedLimitMode: TrafficUsageMode.Medium
                    speedLimitSetting: DmCoreSettings.MaxUploadSpeed
                }

                SpeedComboBoxWrapper {
                    comboBoxText: qsTr("High") + App.loc.emptyString
                    speedLimitMode: TrafficUsageMode.High
                    speedLimitSetting: DmCoreSettings.MaxUploadSpeed
                }
            }

            Separator {sectionOpened: uploadSpeedSection.isCurrent}

            SectionHeader
            {
                id: maxConnSection
                name: qsTr("Maximum number of connections") + App.loc.emptyString
                Layout.fillWidth: true
            }

            MyLayout
            {
                visible: maxConnSection.isCurrent

                MaxConnectionsWrapper {
                    id: maxConn1
                    labelText: qsTr("Low") + App.loc.emptyString
                    trafficUsageMode: TrafficUsageMode.Low
                    maxDownloadSpeedSetting: DmCoreSettings.MaxConnections
                }

                MaxConnectionsWrapper {
                    id: maxConn2
                    labelText: qsTr("Medium") + App.loc.emptyString
                    trafficUsageMode: TrafficUsageMode.Medium
                    maxDownloadSpeedSetting: DmCoreSettings.MaxConnections
                }

                MaxConnectionsWrapper {
                    id: maxConn3
                    labelText: qsTr("High") + App.loc.emptyString
                    trafficUsageMode: TrafficUsageMode.High
                    maxDownloadSpeedSetting: DmCoreSettings.MaxConnections
                }
            }

            Separator {sectionOpened: maxConnSection.isCurrent}

            SectionHeader
            {
                id: maxDownloadsSection
                name: qsTr("Maximum number of simultaneous downloads") + App.loc.emptyString
                Layout.fillWidth: true
            }

            MyLayout {
                visible: maxDownloadsSection.isCurrent

                MaxConnectionsWrapper {
                    id: maxConn7
                    labelText: qsTr("Low") + App.loc.emptyString
                    trafficUsageMode: TrafficUsageMode.Low
                    maxDownloadSpeedSetting: DmCoreSettings.MaxDownloads
                }

                MaxConnectionsWrapper {
                    id: maxConn8
                    labelText: qsTr("Medium") + App.loc.emptyString
                    trafficUsageMode: TrafficUsageMode.Medium
                    maxDownloadSpeedSetting: DmCoreSettings.MaxDownloads
                }

                MaxConnectionsWrapper {
                    id: maxConn9
                    labelText: qsTr("High") + App.loc.emptyString
                    trafficUsageMode: TrafficUsageMode.High
                    maxDownloadSpeedSetting: DmCoreSettings.MaxDownloads
                }
            }

            Separator {sectionOpened: maxDownloadsSection.isCurrent}

            SectionHeader {
                id: maxURatioSection
                visible: name
                name: btS ? btS.stopSAtRatio : ""
                Layout.fillWidth: true
            }

            MyLayout {
                visible: maxURatioSection.visible && maxURatioSection.isCurrent

                MaxURatioComboBoxWrapper {
                    comboBoxText: qsTr("Low") + App.loc.emptyString
                    speedLimitMode: TrafficUsageMode.Low
                    speedLimitSetting: maxURatioSection.visible ? DmCoreSettings.MaxURatio : -1
                }

                MaxURatioComboBoxWrapper {
                    comboBoxText: qsTr("Medium") + App.loc.emptyString
                    speedLimitMode: TrafficUsageMode.Medium
                    speedLimitSetting: maxURatioSection.visible ? DmCoreSettings.MaxURatio : -1
                }

                MaxURatioComboBoxWrapper {
                    comboBoxText: qsTr("High") + App.loc.emptyString
                    speedLimitMode: TrafficUsageMode.High
                    speedLimitSetting: maxURatioSection.visible ? DmCoreSettings.MaxURatio : -1
                }
            }

            Separator {visible: maxURatioSection.visible; sectionOpened: maxURatioSection.isCurrent}

            Item {
                Layout.fillWidth: true
                implicitWidth: childrenRect.width
                implicitHeight: childrenRect.height

                SwitchSetting {
                    description: qsTr("Enable additional downloads to optimize speed") + App.loc.emptyString
                    switchChecked: parseInt(App.settings.dmcore.value(DmCoreSettings.MaxAdditionalSmallDownloads)) > 0 ||
                                   parseInt(App.settings.dmcore.value(DmCoreSettings.MaxAdditionalDownloadsIfTotalSpeedIsTooSlow)) > 0
                    onClicked: {
                        switchChecked = !switchChecked;
                        App.settings.dmcore.setValue(
                                    DmCoreSettings.MaxAdditionalSmallDownloads,
                                    switchChecked ? "1" : "0");
                        App.settings.dmcore.setValue(
                                    DmCoreSettings.MaxAdditionalDownloadsIfTotalSpeedIsTooSlow,
                                    switchChecked ? "1" : "0");
                    }
                }
            }

            //-- contentColumn content - END ---------------------------------------------------------------------
        }
    }

    function invalidSettingsMessage()
    {
        if (!maxConn1.isValidTumSetting() ||
            !maxConn2.isValidTumSetting() ||
            !maxConn3.isValidTumSetting() ||
            !maxConn7.isValidTumSetting() ||
            !maxConn8.isValidTumSetting() ||
            !maxConn9.isValidTumSetting())
        {
            return qsTr("Invalid traffic limits settings") + App.loc.emptyString;
        }
        return "";
    }
}



