import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.dmcoresettings
import org.freedownloadmanager.fdm.appsettings
import "../BaseElements/"

BaseSettingsPage {
    id: root

    title: qsTr("Proxy settings") + App.loc.emptyString

    validateSettingsFn: () => {
        invalidSettingsMessageDialog.lastInvalidSettingsMessage = proxysettings.invalidSettingsMessage();
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

        //contentWidth: contentColumn.width
        contentHeight: contentColumn.height

        clip: true

        Item {
            id: contentColumn

            readonly property int myPadding: (appWindow.uiver === 1 ? 20 : appWindow.theme_v2.mainContentMargins)*appWindow.zoom

            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                leftMargin: myPadding
                rightMargin: myPadding
                topMargin: myPadding
            }

            implicitWidth: proxysettings.implicitWidth
            implicitHeight: proxysettings.implicitHeight + 2*myPadding

            //-- contentColumn content - BEGIN -------------------------------------------------------------------
            Column
            {
                id: proxysettings
                property int proxyMode: parseInt(App.settings.app.value(AppSettings.NetworkProxyMode)) || 0

                anchors.left: parent.left

                width: parent.width

                spacing: 10*appWindow.zoom

                SettingsRadioButton
                {
                    id: systemProxy
                    anchors.left: parent.left
                    width: parent.width
                    text: qsTr("System proxy") + App.loc.emptyString
                    checked: proxysettings.proxyMode === AppSettings.SystemProxy
                    onClicked: proxysettings.tryApplyProxySettings()
                }

                SettingsRadioButton
                {
                    id: noProxy
                    anchors.left: parent.left
                    width: parent.width
                    text: qsTr("No proxy") + App.loc.emptyString
                    checked: proxysettings.proxyMode === AppSettings.NoProxy
                    onClicked: proxysettings.tryApplyProxySettings()
                }

                SettingsRadioButton
                {
                    id: manualProxy
                    anchors.left: parent.left
                    width: parent.width
                    text: qsTr("Configure manually:") + App.loc.emptyString
                    checked: proxysettings.proxyMode === AppSettings.ManualProxy
                    onClicked: proxysettings.tryApplyProxySettings()
                }

                Column
                {
                    enabled: manualProxy.checked

                    opacity: manualProxy.checked ? 1 : 0.5

                    anchors.left: parent.left
                    anchors.leftMargin: 15*appWindow.zoom

                    spacing: parent.spacing

                    component ProtocolLabel : BasePageLabel
                    {
                        font: uicore.buildFont({weight: appWindow.uiver === 1 ? Font.Bold : Font.Medium},
                                               (appWindow.uiver === 1 ? 13 : appWindow.theme_v2.fontSize)*appWindow.fontZoom)
                    }

                    component MyTextField : BaseTextField
                    {
                        width: 200
                        inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
                    }

                    ProtocolLabel
                    {
                        anchors.left: parent.left
                        text: qsTr("HTTP") + App.loc.emptyString
                    }

                    MyTextField
                    {
                        id: httpHost
                        text: App.settings.app.value(AppSettings.Http_ProxyHost)
                        onDisplayTextChanged: tryApplyProxySettingsTimer.restart()
                        placeholderText: (activeFocus || text) ? "" : qsTr("Address") + App.loc.emptyString
                        anchors.left: parent.left
                    }
                    MyTextField
                    {
                        id: httpPort
                        text: App.settings.app.value(AppSettings.Http_ProxyPort)
                        inputMethodHints: Qt.ImhDigitsOnly | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
                        onDisplayTextChanged: tryApplyProxySettingsTimer.restart()
                        placeholderText: (activeFocus || text) ? "" : qsTr("Port") + App.loc.emptyString
                        anchors.left: parent.left
                    }

                    ProtocolLabel
                    {
                        text: qsTr("HTTPS") + App.loc.emptyString
                        anchors.left: parent.left
                    }

                    MyTextField
                    {
                        id: httpsHost
                        text: App.settings.app.value(AppSettings.Https_ProxyHost)
                        onDisplayTextChanged: tryApplyProxySettingsTimer.restart()
                        placeholderText: (activeFocus || text) ? "" : qsTr("Address") + App.loc.emptyString
                        anchors.left: parent.left
                    }
                    MyTextField
                    {
                        id: httpsPort
                        text: App.settings.app.value(AppSettings.Https_ProxyPort)
                        onDisplayTextChanged: tryApplyProxySettingsTimer.restart()
                        placeholderText: (activeFocus || text) ? "" : qsTr("Port") + App.loc.emptyString
                        anchors.left: parent.left
                    }

                    ProtocolLabel
                    {
                        text: qsTr("FTP") + App.loc.emptyString
                        anchors.left: parent.left
                    }

                    MyTextField
                    {
                        id: ftpHost
                        text: App.settings.app.value(AppSettings.Ftp_ProxyHost)
                        onDisplayTextChanged: tryApplyProxySettingsTimer.restart()
                        placeholderText: (activeFocus || text) ? "" : qsTr("Address") + App.loc.emptyString
                        anchors.left: parent.left
                    }
                    MyTextField
                    {
                        id: ftpPort
                        text: App.settings.app.value(AppSettings.Ftp_ProxyPort)
                        onDisplayTextChanged: tryApplyProxySettingsTimer.restart()
                        placeholderText: (activeFocus || text) ? "" : qsTr("Port") + App.loc.emptyString
                        anchors.left: parent.left
                    }

                    ProtocolLabel
                    {
                        text: qsTr("SOCKS5") + App.loc.emptyString
                        anchors.left: parent.left
                    }

                    MyTextField
                    {
                        id: socks5Host
                        text: App.settings.app.value(AppSettings.Socks5_ProxyHost)
                        onDisplayTextChanged: tryApplyProxySettingsTimer.restart()
                        placeholderText: (activeFocus || text) ? "" : qsTr("Address") + App.loc.emptyString
                        anchors.left: parent.left
                    }
                    MyTextField
                    {
                        id: socks5Port
                        text: App.settings.app.value(AppSettings.Socks5_ProxyPort)
                        onDisplayTextChanged: tryApplyProxySettingsTimer.restart()
                        placeholderText: (activeFocus || text) ? "" : qsTr("Port") + App.loc.emptyString
                        anchors.left: parent.left
                    }
                }

                Timer
                {
                    id: tryApplyProxySettingsTimer
                    interval: 500
                    repeat: false
                    onTriggered: proxysettings.tryApplyProxySettings()
                }

                function protocolProxySettingsValid(
                    host, port)
                {
                    return host.text === "" ||
                            (/^\d+$/.test(port.text) &&
                             parseInt(port.text) > 0 && parseInt(port.text) <= 65535);
                }

                function proxySettingsValid()
                {
                    return systemProxy.checked ||
                            noProxy.checked ||
                            (manualProxy.checked &&
                             protocolProxySettingsValid(httpHost, httpPort) &&
                             protocolProxySettingsValid(httpsHost, httpsPort) &&
                             protocolProxySettingsValid(ftpHost, ftpPort) &&
                             protocolProxySettingsValid(socks5Host, socks5Port) &&
                             (httpHost.text !== "" || httpsHost.text !== "" || ftpHost.text !== "" || socks5Host.text !== ""));
                }

                function invalidSettingsMessage()
                {
                    if (!proxySettingsValid())
                        return qsTr("Invalid proxy settings") + App.loc.emptyString;
                    return "";
                }

                function tryApplyProxySettings()
                {
                    if (!proxySettingsValid())
                        return;

                    if (systemProxy.checked)
                    {
                        App.settings.app.setValue(AppSettings.NetworkProxyMode,
                                                  AppSettings.SystemProxy);

                    }
                    else if (noProxy.checked)
                    {
                        App.settings.app.setValue(AppSettings.NetworkProxyMode,
                                                  AppSettings.NoProxy);
                    }
                    else if (manualProxy.checked)
                    {
                        App.settings.app.setManualProxy(
                                    httpHost.text, httpHost.text ? httpPort.text : "", "", "",
                                    httpsHost.text, httpsHost.text ? httpsPort.text : "", "", "",
                                    ftpHost.text, ftpHost.text ? ftpPort.text : "", "", "",
                                    socks5Host.text, socks5Host.text ? socks5Port.text : "", "", "");
                    }
                }
            }
            //-- contentColumn content - END ---------------------------------------------------------------------
        }
    }
}

