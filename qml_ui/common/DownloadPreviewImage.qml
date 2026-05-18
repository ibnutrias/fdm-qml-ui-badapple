import QtQuick
import org.freedownloadmanager.fdm

Item
{
    required property double downloadId
    required property int supposedWidth // preview image
    required property int supposedHeight // preview image
    required property int minimumHeight
    required property string folderImageUrl
    property int folderImageHOffset: 0
    property int folderImageVOffset: 0

    readonly property var preview: App.downloads.previews.preview(downloadId)
    readonly property var previewUrl: preview && !preview.usingFileIconPreview ? preview.large : null
    readonly property bool hasPreview: previewUrl && previewUrl.toString()

    implicitWidth: hasPreview ?
                       previewHolder.recommendedWidth(supposedWidth, supposedHeight) :
                       Math.max(folderImg.implicitWidth, supposedWidth)

    implicitHeight: hasPreview ?
                        previewHolder.recommendedHeight(supposedWidth, supposedHeight) :
                        Math.max(folderImg.implicitHeight, supposedHeight)

    WaSvgImage
    {
        id: folderImg
        visible: !hasPreview
        anchors.left: parent.left
        anchors.leftMargin: folderImageHOffset
        anchors.top: parent.top
        anchors.topMargin: folderImageVOffset
        zoom: appWindow.zoom
        source: hasPreview ? "" : folderImageUrl
    }

    Item
    {
        id: previewHolder

        visible: hasPreview

        anchors.top: parent.top

        height: recommendedHeight(parent.width, parent.height)
        width: recommendedWidth(parent.width, parent.height)

        Image
        {
            id: previewImg
            readonly property real ratio: sourceSize.height ? sourceSize.width / sourceSize.height : 0
            readonly property bool isHorizontal: ratio > 1
            source: hasPreview ? previewUrl : ""
            anchors.fill: parent
            visible: false
        }

        RoundedImageEffect {source: previewImg}

        function recommendedWidth(supposedWidth, supposedHeight)
        {
            return previewImg.isHorizontal ?
                        Math.max(supposedWidth, minimumHeight * previewImg.ratio) :
                        supposedHeight * previewImg.ratio;
        }

        function recommendedHeight(supposedWidth, supposedHeight)
        {
            return previewImg.isHorizontal ?
                        Math.max(minimumHeight, supposedWidth / previewImg.ratio) :
                        supposedHeight;
        }
    }
}
