import QtQuick
import QtQuick.Controls
import "../BaseElements"

ListView
{
    orientation: ListView.Horizontal

    clip: true

    spacing: 10*appWindow.zoom

    BaseRadioButton {id: rb; visible: false}
    FontMetrics {id: fm; font: rb.font}

    implicitHeight: Math.max(rb.implicitHeight, fm.height)

    implicitWidth: {
        let w = 0;

        for (let i = 0; i < model.count; ++i)
            w += rb.implicitWidth + rb.spacing + fm.advanceWidth(model.get(i).label) + spacing;

        return w ? w - spacing + fm.font.pixelSize*fm.font.pointSize*0 : 0;
    }

    delegate: BaseRadioButton
    {
        text: model.label
        checked: index === currentIndex
        v1_white: true
        height: parent.height
        textColor: appWindow.uiver === 1 ?
                       "white" :
                       appWindow.theme_v2.textColor2
        onClicked: {
            currentIndex = index;
            positionViewAtIndex(index, ListView.Center);
        }
    }
}
