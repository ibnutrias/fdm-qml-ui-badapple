import QtQuick
import org.freedownloadmanager.fdm
import "./BaseElements"

Item {
    anchors.fill: parent

    VoteDialog {
        id: voteDialog
        labelText: uicore.appReview.enjoyAppQuestion
        noBtnText: uicore.appReview.notReally
        yesBtnText: uicore.appReview.yes
        onNoBtnPressed: voteDialogHate.open()
        onYesBtnPressed: voteDialogLike.open()
        onCloseBtnPressed: uicore.appReview.remindLater()
    }

    VoteDialog {
        id: voteDialogLike
        z: 2
        labelText: uicore.appReview.thanksAndRateOnGp
        noBtnText: uicore.appReview.noThanks
        yesBtnText: uicore.appReview.okSure
        laterBtnText: uicore.appReview.later
        onNoBtnPressed: uicore.appReview.dontShowAgain()
        onYesBtnPressed: uicore.appReview.openReviewUi()
        onLaterBtnPressed: uicore.appReview.remindLater()
        onCloseBtnPressed: uicore.appReview.remindLater()
    }

    VoteDialog {
        id: voteDialogHate
        z: 2
        labelText: uicore.appReview.giveUsFeedback
        noBtnText: uicore.appReview.noThanks
        yesBtnText: uicore.appReview.okSure
        onNoBtnPressed: uicore.appReview.dontShowAgain()
        onYesBtnPressed: uicore.appReview.openFeedbackUi()
        onCloseBtnPressed: uicore.appReview.dontShowAgain()
    }

    function start() {
        voteDialog.open();
    }

    Connections
    {
        target: uicore.appReview
        onAppReviewRequested: start()
    }
}
