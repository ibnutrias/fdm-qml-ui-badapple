import QtQuick
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.abstractdownloadsui

Item
{
    property var model: []

    readonly property string title: isMissingFilesFilterActive ?
                                        missingFilesFilterDisplayName :
                                        downloadsViewTools.downloadsTagFilter ?
                                            tagText(downloadsViewTools.downloadsTagFilter) + App.loc.emptyString :
                                            mode2name(App.downloads.model.downloadsStatesFilter) + App.loc.emptyString

    readonly property int missingFilesDownloadsCount: App.downloads.tracker.missingFilesDownloadsCount
    readonly property bool hasMissingFiles: missingFilesDownloadsCount > 0
    readonly property bool isMissingFilesFilterActive: downloadsWithMissingFilesTools.missingFilesFilter ==
                                                       AbstractDownloadsUi.MffAcceptMissingFiles
    readonly property string missingFilesFilterDisplayName: qsTr("Missing Files") + App.loc.emptyString

    readonly property int stateToken: (hasMissingFiles ? 1 : 0)
    onStateTokenChanged: build()

    onMissingFilesDownloadsCountChanged: {
        if (!missingFilesDownloadsCount && isMissingFilesFilterActive)
            downloadsViewTools.resetAllFilters();
    }

    Connections
    {
        target: App.downloads.tracker
        onNonFinishedDownloadsCountChanged: Qt.callLater(build)
    }

    Connections
    {
        target: App.downloads.model
        onDownloadsStatesFilterChanged: Qt.callLater(build)
    }

    Connections
    {
        target: App.loc
        onCurrentTranslationChanged: Qt.callLater(build)
    }

    function build()
    {
        let m = [];

        m.push(modelItem(0));

        if (hasMissingFiles)
        {
            m.push({
                       text: missingFilesFilterDisplayName,
                       active: isMissingFilesFilterActive,
                       action: () => downloadsViewTools.setMissingFilesFilter(AbstractDownloadsUi.MffAcceptMissingFiles)
                   });
        }

        m.push(modelItem(AbstractDownloadsUi.FilterRunning));
        m.push(modelItem(AbstractDownloadsUi.FilterFinished));

        if (App.downloads.tracker.nonFinishedDownloadsCount > 0)
            m.push(modelItem(AbstractDownloadsUi.FilterNonFinished));

        model = m;
    }

    function modelItem(mode)
    {
        return {
            text: mode2name(mode),
            active: !isMissingFilesFilterActive && App.downloads.model.downloadsStatesFilter == mode,
            action: () => downloadsViewTools.setDownloadsStatesFilter(mode)
        }
    }

    function mode2name(m)
    {
        switch(m)
        {
        case 0:
            return qsTr("All files");
        case AbstractDownloadsUi.FilterRunning:
            return qsTr("Active");
        case AbstractDownloadsUi.FilterFinished:
            return qsTr("Completed");
        case AbstractDownloadsUi.FilterNonFinished:
            return qsTr("Uncompleted");
        }
    }

    function tagText(tagId)
    {
        let tag = App.downloads.tags.tag(tagId);
        return tag.readOnly ? App.loc.tr(tag.name) : tag.name;
    }

    Component.onCompleted: build()
}
