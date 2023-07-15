import QtQuick
import QtMultimedia
import QtQuick.Window
import QtQuick.Dialogs

Window {
    id: window
    width: 800
    height: 600
    visible: true
    title: "Simple Video Player"

    Rectangle {
        width: parent.width
        height: parent.height
        color: "white"
        anchors.centerIn: parent

        Video {
            id: video
            width: parent.width
            height: parent.height
            source: fileDialog.currentFile
            volume: 0.5

            Text {
                id: videoPlayBtn
                text: video.state === MediaPlayer.PlayingState ? "Pause" : "Play"
                font.pointSize: 24
                color: "black"
                anchors.centerIn: parent
            }
        }

        Text {
            id: videoTitle
            wrapMode: Text.Wrap
            text: ""
            font.family: "Arial"
            font.pointSize: 14
            color: "black"
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.topMargin: 25
        }

        Rectangle {
            id: browseBtn
            width: 150
            height: 40
            color: "white"
            visible: true
            anchors.centerIn: parent

            HoverHandler {
                acceptedDevices: PointerDevice.Mouse
            }

            Text {
                text: "Select your File"
                font.pointSize: 12
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    fileDialog.open()
                }
            }
        }

        Rectangle {
            id: playbtn
            width: 20
            height: 20
            color: "transparent"
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            anchors.topMargin: 10
            anchors.bottomMargin: 20

            Text {
                text: "▶"
                color: "black"
                font.pointSize: 24
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (video.state === MediaPlayer.PlayingState) {
                        video.pause()
                        videoPlayBtn.text = "Play"
                    } else {
                        video.play()
                        videoPlayBtn.text = "Pause"
                    }
                }
            }
        }

        Rectangle {
            id: pausebtn
            width: 20
            height: 20
            color: "transparent"
            anchors.bottom: parent.bottom
            anchors.left: playbtn.right
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            anchors.topMargin: 10
            anchors.bottomMargin: 20

            Text {
                text: "||"
                color: "black"
                font.pointSize: 18
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    video.pause()
                    videoPlayBtn.text = "Play"
                }
            }
        }

        Rectangle {
            id: seekLine
            height: 5
            color: "white"
            radius: 16
            anchors.bottom: playbtn.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            anchors.bottomMargin: 20

            Rectangle {
                height: parent.height
                color: "deepskyblue"
                radius: 16
                anchors.left: seekLine.left
                anchors.right: seekHandle.right
            }

            MouseArea {
                width: parent.width - seekHandle.width
                height: parent.height + 10
                anchors.centerIn: parent

                onPressed: {
                    video.position = mouseX / (seekLine.width - seekHandle.width) * video.duration
                }
            }

            Rectangle {
                id: seekHandle
                width: 20
                height: 20
                color: "white"
                radius: 32
                anchors.verticalCenter: parent.verticalCenter
                x: ((video.position / video.duration) * (seekLine.width - seekHandle.width))

                MouseArea {
                    width: parent.width + 5
                    height: parent.height + 5
                    anchors.centerIn: parent
                    drag.target: seekHandle
                    drag.axis: Drag.XAxis
                    drag.minimumX: 0.1
                    drag.maximumX: seekLine.width - seekHandle.width

                    onPressed: {
                        video.pause()
                    }

                    onReleased: {
                        video.position = seekHandle.x / (seekLine.width - seekHandle.width) * video.duration
                        video.play()
                    }
                }
            }
        }

        FileDialog {
            id: fileDialog
            title: "Please choose a file"
            nameFilters: ["Video Files (*.mp4 *.mov *.wmv *mkv)"]

            onAccepted: {
                browseBtn.visible = false
                video.play()
                videoTitle.text = fileDialog.currentFile
                console.log("Loaded File: " + fileDialog.currentFile)
            }

            onRejected: {
                console.log("Canceled")
            }
        }
    }
}
