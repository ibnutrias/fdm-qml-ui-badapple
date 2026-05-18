import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import QtQuick.Controls.Material
import "../../common/Tools"
import "../../common"
import "../BaseElements"
import "../BaseElements/V2"
import "../SettingsPage"

CenteredDialog
{
    id: root

    modal: true

    parent: Overlay.overlay

    onClosed:
    {
        if (appWindow.uiver === 1)
        {
            if (schedulerTools.tuneAndDownloadDialog)
                root.complete();
        }
        else
        {
            root.complete();

            if (!schedulerTools.tuneAndDownloadDialog)
                schedulerTools.doOK();
        }
    }

    contentItem: Flickable
    {
        flickableDirection: Flickable.VerticalFlick
        ScrollBar.vertical: ScrollBar { policy: parent.interactive ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff}
        boundsBehavior: Flickable.StopAtBounds
        contentHeight: content.height
        clip: true
        interactive: root.parent.height < 550
        implicitHeight: contentHeight
        implicitWidth: content.implicitWidth

        ColumnLayout
        {
            id: content
            width: parent.width
            spacing: (appWindow.uiver === 1 ? 10 : 16)*appWindow.zoom

            SwitchSetting {
                id: enableScheduler
                textMargins: 0
                textHeighIncrement: 10
                textFontSize: (appWindow.uiver === 1 ? 18 : appWindow.theme_v2.fontSize)*appWindow.fontZoom
                settingsPageStyle: false
                description: qsTr("Scheduler") + App.loc.emptyString
                switchChecked: schedulerTools.schedulerCheckboxEnabled
                onClicked: schedulerTools.onSchedulerCheckboxChanged(!switchChecked)
                Layout.fillWidth: true
                anchors.left: undefined
                anchors.right: undefined
            }

            BaseLabel {
                id: enableSchedulerText
                text: qsTr("Start and pause downloads at specified time") + App.loc.emptyString
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                font: uicore.buildFont({}, (appWindow.uiver === 1 ? 12 : (appWindow.theme_v2.fontSize-1))*appWindow.fontZoom)
                horizontalAlignment: Text.AlignLeft
            }

            ColumnLayout
            {
                id: scheduler

                enabled: schedulerTools.schedulerCheckboxEnabled

                Layout.fillWidth: true

                spacing: parent.spacing

                BaseCheckBox
                {
                    id: wholeDayCb
                    visible: appWindow.uiver !== 1
                    text: qsTr("All the day") + App.loc.emptyString
                    checked: isWholeDay()
                    onClicked:
                    {
                        if (checked)
                        {
                            timeFrom.setTime({hour: 0, minute: 0})
                            timeTo.setTime({hour: 24, minute: 0})
                        }
                    }
                }

                Rectangle {
                    visible: appWindow.uiver === 1
                    Layout.topMargin: 10*appWindow.zoom
                    Layout.fillWidth: true
                    implicitHeight: 1
                    color: appWindow.theme.border
                }

                Rectangle
                {
                    implicitWidth: fromToTextRect.implicitWidth + 2*20*appWindow.zoom
                    implicitHeight: fromToTextRect.implicitHeight + (appWindow.uiver === 1 ? 0 : 2*8*appWindow.zoom)
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter
                    color: appWindow.uiver === 1 ? "transparent" : appWindow.theme_v2.bg200

                    //time
                    RowLayout
                    {
                        id: fromToTextRect
                        enabled: appWindow.uiver === 1 || !wholeDayCb.checked
                        anchors.centerIn: parent
                        spacing: 10

                        TimePicker {
                            id: timeFrom
                            width: 100
                        }

                        SvgImage_V2
                        {
                            source: Qt.resolvedUrl(appWindow.uiver === 1 ?
                                                       "../../images/mobile/arrow.svg" :
                                                       "../BaseElements/V2/arrow_right.svg")
                            sourceSize: appWindow.uiver === 1 ?
                                            Qt.size(20, 8) :
                                            Qt.size(width, height)
                            applyImageColor: appWindow.uiver !== 1
                            imageColor: appWindow.theme_v2.bg500
                            Layout.alignment: Qt.AlignVCenter
                            mirror: LayoutMirroring.enabled
                        }

                        TimePicker {
                            id: timeTo
                            width: 100
                        }
                    }
                }

                BaseLabel
                {
                    visible: appWindow.uiver === 1
                    text: qsTr("All the day") + App.loc.emptyString
                    font: uicore.buildFont({}, (appWindow.uiver === 1 ? 14 : (appWindow.theme_v2.fontSize+1))*appWindow.fontZoom)
                    Layout.alignment: Qt.AlignHCenter
                    color: isWholeDay() ? appWindow.theme.schedulerLabelSelectedText : appWindow.theme.schedulerLabelText
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            timeFrom.setTime({hour: 0, minute: 0})
                            timeTo.setTime({hour: 24, minute: 00})
                        }
                    }
                }

                Rectangle {
                    visible: appWindow.uiver === 1
                    Layout.fillWidth: true
                    implicitHeight: 1
                    color: appWindow.theme.border
                }

                BaseCheckBox
                {
                    id: everyDayCb
                    visible: appWindow.uiver !== 1
                    text: qsTr("Everyday") + App.loc.emptyString
                    checked: daysGroup.checkState === Qt.Checked
                    onClicked:
                    {
                        if (checked)
                            setAllDaysChecked(true)
                    }
                }

                ButtonGroup {
                    id: daysGroup
                    exclusive: false
                }

                ListView
                {
                    id: list
                    orientation: ListView.Horizontal
                    spacing: 16*appWindow.zoom
                    Layout.fillWidth: true
                    implicitWidth: contentItem.childrenRect.width
                    implicitHeight: contentItem.childrenRect.height

                    model: ListModel {}

                    delegate: BaseCheckBox {
                        text: day
                        font: uicore.buildFont({capitalization: appWindow.uiver !== 1 ? Font.AllUppercase : Font.MixedCase},
                                               (appWindow.uiver === 1 ? 14 : appWindow.theme_v2.fontSize)*appWindow.zoom)
                        vertical: true
                        checked: dayEnabled
                        onClicked: setDayChecked(i, checked, index)
                        ButtonGroup.group: daysGroup
                    }
                }

                BaseLabel
                {
                    visible: appWindow.uiver === 1
                    text: qsTr("Everyday") + App.loc.emptyString
                    font: uicore.buildFont({}, (appWindow.uiver === 1 ? 14 : (appWindow.theme_v2.fontSize+1))*appWindow.fontZoom)
                    Layout.alignment: Qt.AlignHCenter
                    color: daysGroup.checkState === Qt.Checked ? appWindow.theme.schedulerLabelSelectedText : appWindow.theme.schedulerLabelText
                    MouseArea {
                        anchors.fill: parent
                        onClicked: setAllDaysChecked(true)
                    }
                }

                Rectangle {
                    visible: appWindow.uiver === 1
                    Layout.fillWidth: true
                    implicitHeight: 1
                    color: appWindow.theme.border
                }
            }

            Button
            {
                visible: appWindow.uiver === 1
                text: (schedulerTools.tuneAndDownloadDialog ? qsTr("Close") : qsTr("Apply")) + App.loc.emptyString
                onClicked: {
                    if (schedulerTools.tuneAndDownloadDialog) {
                        root.close();
                    } else {
                        root.complete();
                        schedulerTools.doOK();
                    }
                }
                enabled: daysGroup.checkState !== Qt.Unchecked
                Layout.fillWidth: true
                font.pixelSize: 16*appWindow.fontZoom
                font.capitalization: Font.Capitalize
                Material.background: appWindow.theme.toolbarBackground
                Material.foreground: appWindow.theme.toolbarTextColor
            }
        }
    }

    function isWholeDay()
    {
        return timeFrom.time.hour === 0 && timeFrom.time.minute === 0 &&
                timeTo.time.hour === 24 && timeTo.time.minute === 0;
    }

    function setUpSchedulerAction(ids)
    {
        schedulerTools.buildScheduler(ids);
    }

    function initialization() {
        timeFrom.setTime({hour: Math.floor(schedulerTools.startTime / 60), minute: schedulerTools.startTime % 60})
        timeTo.setTime({hour: Math.floor(schedulerTools.endTime / 60), minute: schedulerTools.endTime % 60})

        list.model.clear();
        var firstDayOfWeek = Qt.locale(App.loc.currentTranslation).firstDayOfWeek;
        if (firstDayOfWeek !== 1) {
            list.model.append({ 'i': 6, 'day': qsTr("Sun"), 'dayEnabled': schedulerTools.daysEnabled & (1<<6)});
        }
        list.model.append({ 'i': 0, 'day': qsTr("Mon"), 'dayEnabled': schedulerTools.daysEnabled & (1<<0)});
        list.model.append({ 'i': 1, 'day': qsTr("Tue"), 'dayEnabled': schedulerTools.daysEnabled & (1<<1)});
        list.model.append({ 'i': 2, 'day': qsTr("Wed"), 'dayEnabled': schedulerTools.daysEnabled & (1<<2)});
        list.model.append({ 'i': 3, 'day': qsTr("Thu"), 'dayEnabled': schedulerTools.daysEnabled & (1<<3)});
        list.model.append({ 'i': 4, 'day': qsTr("Fri"), 'dayEnabled': schedulerTools.daysEnabled & (1<<4)});
        list.model.append({ 'i': 5, 'day': qsTr("Sat"), 'dayEnabled': schedulerTools.daysEnabled & (1<<5)});
        if (firstDayOfWeek === 1) {
            list.model.append({ 'i': 6, 'day': qsTr("Sun"), 'dayEnabled': schedulerTools.daysEnabled & (1<<6)});
        }
    }

    function complete() {
        schedulerTools.startTime = timeFrom.time.hour * 60 + timeFrom.time.minute;
        schedulerTools.endTime = timeTo.time.hour * 60 + timeTo.time.minute;
    }

    function setAllDaysChecked(checked) {
        for (var i = 0; i < list.count; i++) {
            setDayChecked(list.model.get(i).i, checked, i);
        }
    }

    function setDayChecked(i, checked, index) {
        schedulerTools.onDaysEnabledChanged(checked, i);
        list.model.setProperty(index, 'dayEnabled', schedulerTools.daysEnabled & (1<<i));
    }
}
