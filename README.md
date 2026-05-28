

# fdm-qml-ui-badapple

![Bad Apple Preview](https://github.com/ibnutrias/fdm-qml-ui-badapple/blob/master/badapple_preview.png?raw=true)

This is a fork of FDM QML UI for show Bad Apple in FDM Progress Bar

FDM6 supports loading of custom interfaces and uses the special command line argument for this.

1. Clone this repository.

2. Make your changes.

3. Existing Bad Apple Video in this folder repo (badapple.mp4)

4. Run ffmpeg for converting video frames to images in frames/badapple_%d.png

`ffmpeg -i badapple.mp4 -vf "fps=30,scale=120:-1:flags=neighbor,format=rgba,geq=r=30:g=30:b=30:a='255-r(X\,Y)'" frames/badapple_%d.png`

4. Test your changes by launching FDM6 using the following parameters:

    fdm --qurl file:///PATH_TO_MAIN_QML_INSIDE_OF_LOCAL_REPOSITORY

    E.g. for Windows OS, this could be:
    fdm.exe --qurl file:///C:/fdm-qml-ui/qml_ui/desktop/main.qml

5. Share your changes with all FDM6 users on our forum or by creating pull requests to our main repository.