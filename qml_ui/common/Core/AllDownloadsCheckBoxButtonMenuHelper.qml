import QtQuick
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.abstractdownloadsui

Item
{
    property var model: []

    readonly property bool shouldBeChecked: App.downloads.model.allCheckState == Qt.Checked ||
                                            App.downloads.model.allCheckState == Qt.PartiallyChecked

    function build()
    {
        model = [
                    {
                        text: qsTr("All") + App.loc.emptyString,
                        action: () => App.downloads.model.checkAll(true)
                    },

                    {
                        text: qsTr("Downloads only") + App.loc.emptyString,
                        action: () => App.downloads.model.checkSome(AbstractDownloadsUi.FilterDownloading, true, true)
                    },

                    {
                        text: qsTr("Uploads only") + App.loc.emptyString,
                        action: () => App.downloads.model.checkSome(AbstractDownloadsUi.FilterUploading, true, true)
                    },

                    {
                        text: qsTr("Completed") + App.loc.emptyString,
                        action: () => App.downloads.model.checkSome(AbstractDownloadsUi.FilterFinished, true, true)
                    },

                    {
                        text: qsTr("Stopped") + App.loc.emptyString,
                        action: () => App.downloads.model.checkSome(AbstractDownloadsUi.FilterStopped, true, true)
                    }
                ];
    }

    function onCheckBoxClicked(checked)
    {
        App.downloads.model.checkAll(checked)
    }

    Component.onCompleted: build()

    Connections
    {
        target: App.loc
        onCurrentTranslationChanged: build()
    }
}
