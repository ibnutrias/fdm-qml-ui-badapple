import QtQuick
import "BaseElements"

Column {
    height: 108
    width: root.width

    MainToolbar {
        id: upperBarLoader
    }

    SearchToolbar {
        id: searchBar

        onSwitchMainView: { root.state = "mainView"; }
    }

    ToolBarShadow {}

    Connections {
        id: connectionsWithUpperBar
        target: upperBarLoader

        onHamburgerClicked: mainMenuDrawer.item.open()
        onSwitchMainViewSelectMode: { root.state = "mainViewSelectMode"; }
        onSwitchSearchView: { root.state = "searchView"; }
    }

    MainFiltersBar {
        id: mainFiltersBar
        visible: appWindow.hasDownloadMgr
    }

    SelectModeTopBar {
        id: selectModeTopBar
        onSwitchSelectModeOff: root.switchSelectModeOff()
    }

    state: "mainView"

    states: [
        State {
            name: "mainView"
            PropertyChanges {
                target: upperBarLoader;
                enabled: true
                visible: true;
            }
            PropertyChanges {
                target: searchBar;
                enabled: true
                visible: false;
            }
            PropertyChanges {
                target: mainFiltersBar;
                visible: appWindow.hasDownloadMgr;
            }
            PropertyChanges {
                target: selectModeTopBar;
                visible: false;
            }
        },
        State {
            name: "mainViewSelectMode"
            PropertyChanges {
                target: upperBarLoader;
                enabled: false
                visible: true;
            }
            PropertyChanges {
                target: searchBar;
                enabled: false
                visible: false;
            }
            PropertyChanges {
                target: mainFiltersBar;
                visible: false;
            }
            PropertyChanges {
                target: selectModeTopBar;
                visible: true;
            }
        },
        State {
            name: "searchView"
            PropertyChanges {
                target: upperBarLoader;
                enabled: true
                visible: false;
            }
            PropertyChanges {
                target: searchBar;
                enabled: true
                visible: true;
            }
            PropertyChanges {
                target: mainFiltersBar;
                visible: appWindow.hasDownloadMgr;
            }
            PropertyChanges {
                target: selectModeTopBar;
                visible: false;
            }
        },
        State {
            name: "searchViewSelectMode"
            PropertyChanges {
                target: upperBarLoader;
                enabled: false
                visible: false;
            }
            PropertyChanges {
                target: searchBar;
                enabled: false
                visible: true;
            }
            PropertyChanges {
                target: mainFiltersBar;
                visible: false;
            }
            PropertyChanges {
                target: selectModeTopBar;
                visible: true;
            }
        }
    ]

    onStateChanged: {
        if (state === "searchView") {
            searchBar.switchSearchView();
        }
    }
}
