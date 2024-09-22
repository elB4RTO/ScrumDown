import QtQuick
import QtQuick.Controls

Item {
    id: root

    property real scaleFactor

    property string theme

    signal themeSelected(string newTheme)
    signal timeUpdated(int newTime)

    function setMinutes(mins) {
        minutes.text = mins < 10 ? "0"+mins : mins
    }
    function setSeconds(secs) {
        seconds.text = secs < 10 ? "0"+secs : secs
    }

    Item {
        id: themeBox

        anchors {
            top: root.top
            bottom: root.verticalCenter
            left: root.left
            right: root.right
        }

        Item {
            id: themeButtons

            anchors {
                verticalCenter: themeBox.verticalCenter
                horizontalCenter: themeBox.horizontalCenter
            }

            width: 200 * root.scaleFactor
            height: 75 * root.scaleFactor

            Button {
                id: light

                anchors {
                    left: themeButtons.left
                    right: themeButtons.horizontalCenter
                    verticalCenter: themeButtons.verticalCenter
                }

                height: themeButtons.height / 2

                background: Rectangle {
                    topLeftRadius: data.radius
                    bottomLeftRadius: data.radius
                    border {
                        width: data.borderWidth
                        color: "#373737"
                    }
                    color: "#e5e5e5"
                }

                onPressed: root.themeSelected("light")
            }

            Button {
                id: dark

                anchors {
                    left: themeButtons.horizontalCenter
                    right: themeButtons.right
                    verticalCenter: themeButtons.verticalCenter
                }

                height: themeButtons.height / 2

                background: Rectangle {
                    topRightRadius: data.radius
                    bottomRightRadius: data.radius
                    border {
                        width: data.borderWidth
                        color: "#e5e5e5"
                    }
                    color: "#373737"
                }

                onPressed: root.themeSelected("dark")
            }
        }
    }

    Item {
        id: timeBox

        anchors {
            top: root.verticalCenter
            bottom: root.bottom
            left: root.left
            right: root.right
        }

        Rectangle {
            id: timeEditsBg

            anchors {
                horizontalCenter: timeBox.horizontalCenter
                verticalCenter: timeEdits.verticalCenter
            }

            width: 170 * root.scaleFactor
            height: 60 * root.scaleFactor

            radius: 10 * root.scaleFactor

            color: data.digitsBackground
        }

        Item {
            id: timeEdits

            anchors {
                top: timeBox.top
                horizontalCenter: timeBox.horizontalCenter
            }

            width: 200 * root.scaleFactor
            height: 75 * root.scaleFactor

            TextInput {
                id: minutes

                anchors {
                    left: timeEdits.left
                    right: colon.left
                    verticalCenter: timeEdits.verticalCenter
                }

                width: timeEdits.width / 3
                height: timeEdits.height

                horizontalAlignment: TextInput.AlignRight

                rightPadding: 10 * root.scaleFactor

                inputMask: "00"
                validator: IntValidator{
                    bottom: 0
                    top: 99
                }

                font.pointSize: data.textSize

                color: data.digitsColor

                selectByMouse: false

                onEditingFinished: logic.sendTime()
            }

            Text {
                id: colon

                anchors {
                    horizontalCenter: timeEdits.horizontalCenter
                    verticalCenter: timeEdits.verticalCenter
                }

                width: 10 * root.scaleFactor
                height: timeEdits.height

                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter

                bottomPadding: 10 * root.scaleFactor

                text: ":"

                font.pointSize: data.textSize

                color: data.digitsColor
            }

            TextInput {
                id: seconds

                anchors {
                    left: colon.right
                    right: timeEdits.right
                    verticalCenter: timeEdits.verticalCenter
                }

                width: timeEdits.width / 3
                height: timeEdits.height

                horizontalAlignment: TextInput.AlignLeft

                leftPadding: 10 * root.scaleFactor

                inputMask: "00"
                validator: IntValidator{
                    bottom: 0
                    top: 59
                }

                font.pointSize: data.textSize

                color: data.digitsColor

                selectByMouse: false

                onEditingFinished: logic.sendTime()
            }
        }
    }

    QtObject {
        id: data

        readonly property color digitsColor: theme === "light" ? "#373737" : "#e5e5e5"
        readonly property color digitsBackground: theme === "light" ? "#d4d4d4" : "#484848"

        readonly property int radius: themeBox.width / 4
        readonly property int borderWidth: Math.max(1, Math.min(10, root.height / 50 * root.scaleFactor))
        readonly property int textSize: 40 * root.scaleFactor
    }

    QtObject {
        id: logic

        function sendTime() {
            const time = (parseInt(minutes.text) * 60) + parseInt(seconds.text)
            timeUpdated(time)
        }
    }
}
