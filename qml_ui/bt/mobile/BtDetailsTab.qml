import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../mobile/BaseElements"
import "../../mobile/BaseElements/V2"
import "../../mobile/DownloadItemPage/V2"
import org.freedownloadmanager.fdm

ColumnLayout
{
    id: root

    readonly property var details: App.downloads.infos.info(downloadsItemTools.itemId).details
    readonly property bool finished: downloadsItemTools.finished

    readonly property string btLastSeenComplete : details && details.btLastSeenComplete && App.tools.isDateTimeValid(details.btLastSeenComplete) ?
                                                      App.loc.dateTimeToString(details.btLastSeenComplete, false) + App.loc.emptyString :
                                                      qsTr("N/A") + App.loc.emptyString
    readonly property double btAvailability: details ? details.btAvailability.toPrecision(3) : 0.0
    readonly property int btSeedCount: details ? details.btSeedCount : 0
    readonly property int btConnectedSeedCount: details ? details.btConnectedSeedCount : 0
    readonly property int btPeerCount: details ? details.btPeerCount : 0
    readonly property int btConnectedPeerCount: details ? details.btConnectedPeerCount : 0

    readonly property string pair1Text: App.my_BT_qsTranslate("BtDetailsTab", "Peers:") + App.loc.emptyString
    readonly property string pair1Value: btPeerCount + ' ' + qsTr("(connected: %1)").arg(btConnectedPeerCount) + App.loc.emptyString
    readonly property string pair2Text: App.my_BT_qsTranslate("BtDetailsTab", "Seeds:") + App.loc.emptyString
    readonly property string pair2Value: btSeedCount + ' ' + qsTr("(connected: %1)").arg(btConnectedSeedCount) + App.loc.emptyString
    readonly property bool pair3Visible: !finished
    readonly property string pair3Text: App.my_BT_qsTranslate("BtDetailsTab", "Availability:") + App.loc.emptyString
    readonly property string pair3Value: btAvailability
    readonly property bool pair4Visible: !finished
    readonly property string pair4Text: App.my_BT_qsTranslate("BtDetailsTab", "Last seen complete:") + App.loc.emptyString
    readonly property string pair4Value: btLastSeenComplete

    spacing: 10

    GridLayout
    {
        visible: appWindow.uiver === 1

        columns: 2

        BaseLabel
        {
            text: pair1Text
        }
        RowLayout
        {
            BaseLabel
            {
                text: pair1Value
            }
            Item {implicitWidth: 30; implicitHeight: 1} // horizontal spacing
        }

        BaseLabel
        {
            text: pair2Text
        }
        BaseLabel
        {
            text: pair2Value
        }

        BaseLabel
        {
            visible: pair3Visible
            text: pair3Text
        }
        BaseLabel
        {
            visible: pair3Visible
            text: pair3Value
        }

        BaseLabel
        {
            visible: pair4Visible
            text: pair4Text
        }
        BaseLabel
        {
            visible: pair4Visible
            text: pair4Value
        }
    }

    ColumnLayout
    {
        visible: appWindow.uiver !== 1

        spacing: 8*appWindow.zoom
        Layout.fillWidth: true

        NameValueText_V2
        {
            name: pair1Text
            value: pair1Value
            Layout.fillWidth: true
        }

        NameValueText_V2
        {
            name: pair2Text
            value: pair2Value
            Layout.fillWidth: true
        }

        NameValueText_V2
        {
            visible: pair3Visible
            name: pair3Text
            value: pair3Value
            Layout.fillWidth: true
        }

        NameValueText_V2
        {
            visible: pair4Visible
            name: pair4Text
            value: pair4Value
            Layout.fillWidth: true
        }
    }

    ListView
    {
        id: trackers

        Layout.fillHeight: true
        Layout.fillWidth: true

        ScrollBar.vertical: ScrollBar{}
        flickableDirection: Flickable.AutoFlickIfNeeded
        boundsBehavior: Flickable.StopAtBounds
        clip: true
        headerPositioning: ListView.OverlayHeader

        model: ListModel {}

        spacing: appWindow.uiver === 1 ? 0 : 8*appWindow.zoom

        property int trackerUrlItemWidth: 0

        Rectangle {
            visible: appWindow.uiver === 1
            anchors.fill: parent
            color: "transparent"
            border.color: appWindow.theme.border
            border.width: 1
        }

        header: Item
        {
            width: parent.width
            height: headerCt.implicitHeight

            z: 2

            Rectangle
            {
                visible: appWindow.uiver !== 1
                anchors.fill: parent
                color: appWindow.theme_v2.bgColor
            }

            ColumnLayout
            {
                id: headerCt

                anchors.fill: parent

                spacing: 0

                ListViewItemSeparator_V2
                {
                    visible: appWindow.uiver !== 1
                    Layout.fillWidth: true
                }

                RowLayout
                {
                    Layout.fillWidth: true

                    spacing: appWindow.uiver === 1 ? 0 : 16*appWindow.zoom

                    BaseLabel
                    {
                        visible: appWindow.uiver !== 1
                        text: App.my_BT_qsTranslate("BtDetailsTab", "Tracker URL") + App.loc.emptyString
                        Layout.preferredWidth: trackers.width * 4/9
                        color: appWindow.theme_v2.bg700
                        onWidthChanged: trackers.trackerUrlItemWidth = width
                    }

                    BaseLabel
                    {
                        visible: appWindow.uiver !== 1
                        text: qsTr("Status") + App.loc.emptyString
                        Layout.fillWidth: true
                        color: appWindow.theme_v2.bg700
                    }

                    TablesHeaderItem {
                        visible: appWindow.uiver === 1
                        text: App.my_BT_qsTranslate("BtDetailsTab", "Tracker URL") + App.loc.emptyString
                        Layout.preferredWidth: trackers.width * 4/9
                        Layout.fillHeight: true
                        color: appWindow.theme.background
                        onWidthChanged: trackers.trackerUrlItemWidth = width
                    }

                    TablesHeaderItem {
                        visible: appWindow.uiver === 1
                        text: qsTr("Status") + App.loc.emptyString
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: appWindow.theme.background
                    }
                }

                ListViewItemSeparator_V2
                {
                    visible: appWindow.uiver !== 1
                    Layout.fillWidth: true
                }

                Item
                {
                    visible: appWindow.uiver !== 1
                    implicitHeight: 8
                }
            }
        }

        delegate: RowLayout
        {
            width: trackers.width

            spacing: appWindow.uiver === 1 ? 0 : 16*appWindow.zoom

            BaseLabel
            {
                text: model.url
                Layout.preferredWidth: trackers.trackerUrlItemWidth
                Layout.minimumWidth: Layout.preferredWidth
                Layout.fillHeight: true
                leftPadding: appWindow.uiver === 1 ? qtbug.leftPadding(6, 0) : 0
                rightPadding: appWindow.uiver === 1 ? qtbug.rightPadding(6, 0) : 0
                elide: Text.ElideRight
                wrapMode: Text.WrapAnywhere
            }

            BaseLabel
            {
                text: model.status
                color: model.statusColor
                Layout.fillWidth: true
                Layout.fillHeight: true
                leftPadding: appWindow.uiver === 1 ? qtbug.leftPadding(6, 0) : 0
                rightPadding: appWindow.uiver === 1 ? qtbug.rightPadding(6, 0) : 0
                elide: Text.ElideRight
                wrapMode: Text.WordWrap
            }
        }
    }

    onDetailsChanged: updateTrackersModel()

    function updateTrackersModel()
    {
        if (!details)
        {
            trackers.model.clear();
            return;
        }

        for (let i = 0; i < details.btTrackers.length; ++i)
        {
            let t = details.btTrackers[i];

            let status = "";
            let statusColor = "";

            if (t.waitingResponse)
            {
                status = qsTr("Updating...") + App.loc.emptyString;
                statusColor = appWindow.uiver === 1 ?
                            appWindow.theme.foreground :
                            appWindow.theme_v2.textColor;
            }
            else if (t.error)
            {
                status = App.tools.errorToString(t.error, false);
                statusColor = appWindow.uiver === 1 ?
                            appWindow.theme.errorMessage :
                            appWindow.theme_v2.danger;
            }
            else if (t.warning)
            {
                status = t.warning;
                statusColor = appWindow.uiver === 1 ?
                            appWindow.theme.warningMessage :
                            appWindow.theme_v2.amber;
            }
            else
            {
                if (t.isOk)
                    status = "OK";
                statusColor = appWindow.uiver === 1 ?
                            appWindow.theme.successMessage :
                            appWindow.theme_v2.secondary;
            }

            let o = {"url": t.url, "status": status, "statusColor": statusColor};

            if (trackers.model.count > i)
                trackers.model.set(i, o);
            else
                trackers.model.append(o);
        }

        if (trackers.model.count > details.btTrackers.length)
            trackers.model.remove(details.btTrackers.length, trackers.model.count - details.btTrackers.length);
    }

    Connections {
        target: App.loc
        onCurrentTranslationChanged: updateTrackersModel()
    }

    Connections {
        target: appWindow
        onThemeChanged: updateTrackersModel()
        onUiverChanged: updateTrackersModel()
    }
}
