import QtQuick
import QtQuick.Layouts

GridLayout
{
    property double implicitWidth1Row: 0 // for read-only purposes
    property double elementMinimumWidth: 0
    property bool elementFillsWidth: false

    rowSpacing: 10*appWindow.zoom
    columnSpacing: 10*appWindow.zoom

    onImplicitHeightChanged: Qt.callLater(apply)
    onImplicitWidthChanged: Qt.callLater(apply)
    onWidthChanged: Qt.callLater(apply)
    onHeightChanged: Qt.callLater(apply)
    onColumnSpacingChanged: Qt.callLater(apply)
    onVisibleChanged: Qt.callLater(apply)
    Component.onCompleted: Qt.callLater(apply)

    function apply()
    {
        columns = calculateColCount();
        rows = -1;

        if (elementMinimumWidth || elementFillsWidth)
        {
            for (let i = 0; i < visibleChildren.length; ++i)
            {
                if (elementFillsWidth)
                    visibleChildren[i].Layout.fillWidth = true;

                if (elementMinimumWidth)
                    visibleChildren[i].Layout.minimumWidth = elementMinimumWidth;
            }
        }
    }

    function calculateColCount()
    {
        // does they all fit in 1 row?

        let w = 0;

        for (let i = 0; i < visibleChildren.length; ++i)
            w += Math.max(visibleChildren[i].implicitWidth, elementMinimumWidth) + columnSpacing;

        if (!w)
            return 0;

        implicitWidth1Row = w - columnSpacing;

        if (w - columnSpacing <= width)
            return visibleChildren.length;

        // can't fit 1 row;
        // find such a columns count value so we have the same number of elements on the each row

        for (let cols = Math.floor(visibleChildren.length / 2); cols > 1; --cols)
        {
            if (visibleChildren.length % cols)
                continue;

            let ok = true;

            let maxWidthArr = []; // to apply grid layout properly
            {
                for (let i = 0; i < cols; ++i)
                    maxWidthArr.push(0);
            }

            for (let i = 0; ok && i < visibleChildren.length; i += cols)
            {
                let w = 0;

                for (let j = i; j < i + cols; ++j)
                {
                    let c = j - i;
                    let ww = Math.max(visibleChildren[j].implicitWidth, elementMinimumWidth);
                    if (ww > maxWidthArr[c])
                        maxWidthArr[c] = ww;
                    else
                        ww = maxWidthArr[c];
                    w += ww + columnSpacing;
                }

                if (w - columnSpacing > width)
                    ok = false;
            }

            if (ok)
                return cols;
        }

        // the worst case - 1 element per 1 row
        return 1;
    }
}
