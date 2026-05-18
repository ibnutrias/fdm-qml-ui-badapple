import QtQuick
import org.freedownloadmanager.fdm

QtObject
{
    signal appReviewRequested()

    readonly property string enjoyAppQuestion: qsTranslate("VoteBlock", "Enjoy %1?").arg(App.shortDisplayName) + App.loc.emptyString
    readonly property string notReally: qsTranslate("VoteBlock", "Not, really") + App.loc.emptyString
    readonly property string yes: qsTranslate("VoteBlock", "Yes!") + App.loc.emptyString
    readonly property string thanksAndRateOnGp: qsTranslate("VoteBlock", "Thanks a lot! Please rate on Google Play.") + App.loc.emptyString
    readonly property string noThanks: qsTranslate("VoteBlock", "No, thanks") + App.loc.emptyString
    readonly property string okSure: qsTranslate("VoteBlock", "OK, sure!") + App.loc.emptyString
    readonly property string later: qsTranslate("VoteBlock", "Later") + App.loc.emptyString
    readonly property string giveUsFeedback: qsTranslate("VoteBlock", "Let's make it better together! Give us your feedback.") + App.loc.emptyString

    function remindLater()
    {
        App.appReview.reviewResult(true, true);
    }

    function dontShowAgain()
    {
        App.appReview.reviewResult(true, false);
    }

    function openFeedbackUi()
    {
        Qt.openUrlExternally(
                    "https://www.freedownloadmanager.org/support.htm?origin=form_wyl&" +
                    App.serverCommonGetParameters);

        dontShowAgain();
    }

    function openReviewUi()
    {
        App.appReview.reviewResult(false, false);
    }

    Component.onCompleted: App.appReview.requestReview.connect(appReviewRequested)
}
