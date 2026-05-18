import QtQuick
import "../../V2"

AppWindowHeader
{
    state: showTitleWithBackButton
    title: downloadsItemTools.title

    onGoBack: stackView.pop()
}
