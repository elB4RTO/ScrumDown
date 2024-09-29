import QtQuick

import scrumdown.utils

Item {
    id: root

    width: baseWidth * scaleFactor
    height: baseHeight * scaleFactor

    property int baseWidth
    property int baseHeight

    property real scaleFactor

    property string theme

    function getTime() {
        return settings.time
    }

    function setTime(secs) {
        settings.time = secs
        if (logic.timerInactive) {
            logic.resetCountdown()
            logic.updateTime()
        }
    }

    function startTimer() {
        if (logic.countdown !== 0) {
            logic.resetCountdown()
            logic.updateTime()
            timer.start()
        }
    }

    function stopTimer() {
        timer.stop()
        logic.terminateCountdown()
        logic.updateTime()
    }

    function resetTimer() {
        timer.stop()
        logic.resetCountdown()
        logic.updateTime()
    }

    Item {
        id: timerBox

        anchors {
            fill: root
            horizontalCenter: root.horizontalCenter
            verticalCenter: root.verticalCenter
        }

        readonly property int textSize: 70 * root.scaleFactor

        Text {
            id: minutes

            anchors {
                left: timerBox.left
                right: colon.left
                verticalCenter: timerBox.verticalCenter
            }

            height: timerBox.height

            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter

            font.pointSize: timerBox.textSize

            text: "00"

            color: logic.timerExpired ? settings.colorExpired : settings.colorText

            SequentialAnimation on color {
                id: minStatic
                ColorAnimation {
                    to: settings.colorText
                    duration: settings.durationStaticIn
                }
            }
            SequentialAnimation on color {
                id: minBlink
                ColorAnimation {
                    from: settings.colorText
                    to: settings.colorExpiring
                    duration: settings.durationStaticOut
                }
                SequentialAnimation {
                    alwaysRunToEnd: true
                    loops: Animation.Infinite
                    ColorAnimation {
                        from: settings.colorExpiring
                        to: settings.colorBlinking
                        duration: settings.durationBlinkIn
                    }
                    ColorAnimation {
                        from: settings.colorBlinking
                        to: settings.colorExpiring
                        duration: settings.durationBlinkOut
                    }
                }
            }
            SequentialAnimation on color {
                id: minFinish
                ColorAnimation {
                    to: settings.colorExpired
                    duration: settings.durationExpiredIn
                }
            }
        }

        Text {
            id: colon

            anchors {
                horizontalCenter: timerBox.horizontalCenter
                verticalCenter: timerBox.verticalCenter
            }

            width: timerBox.width / 20
            height: timerBox.height

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            font.pointSize: timerBox.textSize

            text: ":"

            color: logic.timerExpired ? settings.colorExpired : settings.colorText

            SequentialAnimation on color {
                id: colStatic
                ColorAnimation {
                    to: settings.colorText
                    duration: settings.durationStaticIn
                }
            }
            SequentialAnimation on color {
                id: colBlink
                ColorAnimation {
                    from: settings.colorText
                    to: settings.colorExpiring
                    duration: settings.durationStaticOut
                }
                SequentialAnimation {
                    alwaysRunToEnd: true
                    loops: Animation.Infinite
                    ColorAnimation {
                        from: settings.colorExpiring
                        to: settings.colorBlinking
                        duration: settings.durationBlinkIn
                    }
                    ColorAnimation {
                        from: settings.colorBlinking
                        to: settings.colorExpiring
                        duration: settings.durationBlinkOut
                    }
                }
            }
            SequentialAnimation on color {
                id: colFinish
                ColorAnimation {
                    to: settings.colorExpired
                    duration: settings.durationExpiredIn
                }
            }
        }

        Text {
            id: seconds

            anchors {
                left: colon.right
                right: timerBox.right
                verticalCenter: timerBox.verticalCenter
            }

            height: timerBox.height

            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter

            font.pointSize: timerBox.textSize

            text: "00"

            color: logic.timerExpired ? settings.colorExpired : settings.colorText

            SequentialAnimation on color {
                id: secStatic
                ColorAnimation {
                    to: settings.colorText
                    duration: settings.durationStaticIn
                }
            }
            SequentialAnimation on color {
                id: secBlink
                ColorAnimation {
                    from: settings.colorText
                    to: settings.colorExpiring
                    duration: settings.durationStaticOut
                }
                SequentialAnimation {
                    alwaysRunToEnd: true
                    loops: Animation.Infinite
                    ColorAnimation {
                        from: settings.colorExpiring
                        to: settings.colorBlinking
                        duration: settings.durationBlinkIn
                    }
                    ColorAnimation {
                        from: settings.colorBlinking
                        to: settings.colorExpiring
                        duration: settings.durationBlinkOut
                    }
                }
            }
            SequentialAnimation on color {
                id: secFinish
                ColorAnimation {
                    to: settings.colorExpired
                    duration: settings.durationExpiredIn
                }
            }
        }
    }

    Item {
        id: stateMachine

        state: "default"

        states: [
            State {
                name: "default"
                when: !(logic.timerExpiring || logic.timerExpired)
                PropertyChanges {
                    minStatic { running: true  }
                    colStatic { running: true  }
                    secStatic { running: true  }
                    minBlink  { running: false }
                    colBlink  { running: false }
                    secBlink  { running: false }
                    minFinish { running: false }
                    colFinish { running: false }
                    secFinish { running: false }
                }
            },
            State {
                name: "expiring"
                when: logic.timerExpiring && !logic.timerExpired
                PropertyChanges {
                    minStatic { running: false }
                    colStatic { running: false }
                    secStatic { running: false }
                    minBlink  { running: true  }
                    colBlink  { running: true  }
                    secBlink  { running: true  }
                    minFinish { running: false }
                    colFinish { running: false }
                    secFinish { running: false }
                }
            },
            State {
                name: "expired"
                when: logic.timerExpired
                PropertyChanges {
                    minStatic { running: false }
                    colStatic { running: false }
                    secStatic { running: false }
                    minBlink  { running: false }
                    colBlink  { running: false }
                    secBlink  { running: false }
                    minFinish { running: true  }
                    colFinish { running: true  }
                    secFinish { running: true  }
                }
            }
        ]
    }

    Ensemble {
        id: ensemble
    }

    QtObject {
        id: settings

        property int time: 180

        readonly property color colorText: theme === "light" ? ensemble.theme.light_timer_text : ensemble.theme.dark_timer_text
        readonly property color colorExpiring: theme === "light" ? ensemble.theme.light_timer_expiring : ensemble.theme.dark_timer_expiring
        readonly property color colorBlinking: theme === "light" ? ensemble.theme.light_timer_blinking : ensemble.theme.dark_timer_blinking
        readonly property color colorExpired: theme === "light" ? ensemble.theme.light_timer_expired : ensemble.theme.dark_timer_expired

        readonly property int durationStaticIn: 400
        readonly property int durationStaticOut: 850
        readonly property int durationBlinkIn: 300
        readonly property int durationBlinkOut: 700
        readonly property int durationExpiredIn: 1750
    }

    QtObject {
        id: logic

        property int countdown: 1

        readonly property bool timerExpiring: timer.running && logic.countdown <= 10000
        readonly property bool timerExpired: !timer.running && logic.countdown === 0
        readonly property bool timerInactive: !timer.running && logic.countdown !== 0

        function resetCountdown() {
            countdown = settings.time * 1000
        }

        function terminateCountdown() {
            countdown = 0
        }

        function countdownStep() {
            countdown -= 100
            if (countdown === 0) {
                timer.stop()
            }
            updateTime()
        }

        function updateTime() {
            const mins = Math.floor(countdown / 60000)
            const secs = Math.floor((countdown - (mins * 60000)) / 1000)
            minutes.text = mins < 10 ? "0"+mins.toString() : mins
            seconds.text = secs < 10 ? "0"+secs.toString() : secs
        }
    }

    Timer {
        id: timer
        interval: 100
        repeat: true
        onTriggered: logic.countdownStep()
    }
}
