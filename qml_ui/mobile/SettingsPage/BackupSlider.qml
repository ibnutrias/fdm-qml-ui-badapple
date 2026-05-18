import QtQuick

Item {
    property var model: [ {text: qsTr("5 minutes"), value: 300},
        {text: qsTr("15 minutes"), value: 900},
        {text: qsTr("1 hour"), value: 3600},
        {text: qsTr("3 hours"), value: 10800},
        {text: qsTr("1 day"), value: 86400} ]
}
