import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../BaseElements"

CenteredDialog
{
    parent: Overlay.overlay
    modal: true

    BaseLabel
    {
        text: uicore.appReview.thanksAndRateOnGp
        wrapMode: Text.WordWrap
        Layout.maximumWidth: Math.min(ctMaxWidth, 500*appWindow.zoom)
    }

    BaseDialogButtonsLayout
    {
        BaseDialogButton
        {
            text: uicore.appReview.later
            onClicked: {
                uicore.appReview.remindLater();
                close();
            }
        }

        BaseDialogButton
        {
            text: uicore.appReview.noThanks
            onClicked: {
                uicore.appReview.dontShowAgain();
                close();
            }
        }

        BaseDialogButton
        {
            text: uicore.appReview.okSure
            primary: true
            onClicked: {
                uicore.appReview.openReviewUi();
                close();
            }
        }
    }
}
