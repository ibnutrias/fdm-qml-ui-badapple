import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import "V2"

ComboBox
{
    id: combo

    property int comboMinimumWidth: 0

    font: uicore.buildFont({}, uicore.fontSizeV1(16)*appWindow.fontZoom)

    FontMetrics {
        id: fm
        font: combo.font
    }

    model: []
    textRole: "text"

    implicitHeight: Math.max(fm.height, img.implicitHeight) +
                    Math.max(topPadding + bottomPadding, 2*8*appWindow.zoom)

    implicitWidth: {
        const binding = (fm.font ? 1 : 0) + (fm.font.family ? 1 : 0) + fm.font.pixelSize + fm.font.pointSize;
        let w = 0;
        for (let i = 0; i < model.length; ++i)
            w = Math.max(w, Math.ceil(fm.advanceWidth(model[i][textRole])));
        w = contentItem.leftPadding + w + contentItem.rightPadding +
                spacing +
                indicator.implicitWidth;
        return Math.max(comboMinimumWidth, w);
    }

    property var background_V2: Rectangle
    {
        border.color: (parent && parent.activeFocus ? appWindow.theme_v2.primary : appWindow.theme_v2.editTextBorderColor)
        border.width: 1*appWindow.zoom
        color: appWindow.theme_v2.bgColor
        radius: 8*appWindow.zoom
    }

    PropertyOverride
    {
        id: bgOverride
        name: "background"
        value: background_V2
        override: appWindow.uiver !== 1
    }

    indicator: Item
    {
        implicitWidth: 24*appWindow.zoom
        implicitHeight: implicitWidth
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right

        SvgImage_V2
        {
            id: img
            opacity: enabled ? 1 : (appWindow.uiver === 1 ? 0.5 : appWindow.theme_v2.opacityDisabled)
            source: Qt.resolvedUrl(appWindow.uiver === 1 ? "../../images/arrow_drop_down.svg" : "V2/expand_more.svg")
            sourceSize: appWindow.uiver === 1 ?
                            Qt.size(24, 24) :
                            Qt.size(width, height)
            imageColor: appWindow.uiver === 1 ? appWindow.theme.foreground : supposedImageColor
            anchors.centerIn: parent
        }
    }

    contentItem: BaseLabel {
        text: combo.displayText
        leftPadding: qtbug.leftPadding(10*appWindow.zoom, 0)
        rightPadding: qtbug.rightPadding(10*appWindow.zoom, 0)
        font: combo.font
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
        opacity: enabled ? 1 : (appWindow.uiver === 1 ? 0.5 : appWindow.theme_v2.opacityDisabled)
    }

    delegate: BaseLabel {
        required property var model
        required property int index
        width: combo.width
        height: Math.max(implicitHeight, 34*appWindow.zoom)
        leftPadding: qtbug.leftPadding(10*appWindow.zoom, 0)
        rightPadding: qtbug.rightPadding(10*appWindow.zoom, 0)
        topPadding: 3*appWindow.zoom
        bottomPadding: topPadding
        text: model.text
        font: uicore.adjustFont(combo.font, {weight: index === currentIndex ? Font.DemiBold : Font.Normal})
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter

        MouseArea {
            anchors.fill: parent
            onClicked: {
                combo.currentIndex = index;
                combo.popup.close();
                combo.activated(index);
            }
        }
    }

    property var popup_V2: Popup
    {
        x: -1
        width: combo.width+2
        height: combo.count ?
                    Math.min(contentItem.implicitHeight + topPadding + bottomPadding, combo.Window.height - topMargin - bottomMargin) :
                    0
        padding: (appWindow.uiver === 1 ? 1 : 2)*appWindow.zoom

        contentItem : ListView
        {
            clip: true
            implicitHeight: contentHeight
            model: combo.popup.visible ? combo.model : null
            currentIndex: combo.highlightedIndex
            delegate: combo.delegate

            ScrollIndicator.vertical: ScrollIndicator { }
        }

        background: Rectangle
        {
            border.color: appWindow.theme_v2.editTextBorderColor
            border.width: 1*appWindow.zoom
            color: appWindow.theme_v2.bgColor
            radius: 8*appWindow.zoom
        }
    }

    PropertyOverride
    {
        id: popupOverride
        name: "popup"
        value: popup_V2
        override: appWindow.uiver !== 1
    }

    Component.onCompleted:
    {
        bgOverride.initialize();
        popupOverride.initialize();

        //////////////////////////////////////////////////////////////////////
        // QTBUG-139694 workaround
        popup.topMargin = Qt.binding(() => appWindow.SafeArea.margins.top);
        popup.leftMargin = Qt.binding(() => appWindow.SafeArea.margins.left);
        popup.bottomMargin = Qt.binding(() => appWindow.SafeArea.margins.bottom);
        popup.rightMargin = Qt.binding(() => appWindow.SafeArea.margins.right);
        //////////////////////////////////////////////////////////////////////
    }
}
