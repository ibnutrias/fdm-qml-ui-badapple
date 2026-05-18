/*
  Helps to override/keep default component's property depending on circumstances.
*/

import QtQuick

Item
{
    required property string name
    required property var value
    required property bool override

    // Qt bug (?) workarounds
    property bool enableWa1: name === "background"
    property bool enableWa2: name === "popup"

    property bool initialized: false
    property var originalValue

    // must be called by the parent in its onCompleted handler
    function initialize()
    {
        if (initialized)
            return;
        console.assert(parent);
        console.assert(!originalValue, "Don't override originalValue");
        originalValue = parent[name];
        console.assert(originalValue, name + " property was not found in the parent");
        initialized = true;
        apply();
    }

    onOverrideChanged: apply()

    function apply()
    {
        if (!initialized)
            return;

        let v = override ? value : originalValue;

        if (parent[name] !== v)
        {
            parent[name] = v;

            if (enableWa1)
            {
                v.visible = true;
                v.width = Qt.binding(() => parent.width);
                v.height = Qt.binding(() => parent.height);
            }

            if (enableWa2)
            {
                v.parent = parent;
            }
        }
    }
}
