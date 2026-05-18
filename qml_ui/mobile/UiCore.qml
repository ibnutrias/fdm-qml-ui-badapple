import QtQuick
import "../common"
import "Core"

UiCoreBase
{
    readonly property string downloadsPageName: "downloadsPage"
    readonly property string settingsPageName: "settingsPage"

    readonly property var appReview: AppReviewUiCore {}

    function buildFont(o, fontSize)
    {
        if (appWindow.uiver !== 1 && !o.family)
            o.family = appWindow.theme_v2.fontFamily;

        if (!fontSize)
            fontSize = (appWindow.uiver === 1 ? 12 : appWindow.theme_v2.fontSize)*appWindow.fontZoom

        if (appWindow.uiver === 1)
            o.pixelSize = fontSize;
        else
            o.pointSize = fontSize;

        return o;
    }

    function adjustFont(src, adj)
    {
        let result =  {};

        for (const prop in src)
            result[prop] = src[prop];

        if (appWindow.uiver === 1)
            delete result.pointSize;
        else
            delete result.pixelSize;

        for (const prop in adj)
        {
            result[prop] = adj[prop];

            if (prop === "bold")
                delete result.weight;
        }

        return result;
    }

    function fontSizeV1(fontSize)
    {
        return appWindow.uiver === 1 ?
                    fontSize :
                    appWindow.theme_v2.fontSize;
    }

    function fontSizeV2(fontSize)
    {
        return appWindow.uiver !== 1 ?
                    fontSize :
                    12;
    }

    function fontSizeV2Rel(fontSizeRel)
    {
        return appWindow.uiver !== 1 ?
                    appWindow.theme_v2.fontSize + fontSizeRel :
                    12;
    }
}
