import QtQuick
import QtQuick.Window

import scrumdown.utils

Window {
    id: window

    width: 300
    minimumWidth: 150
    height: 200
    minimumHeight: 100

    visible: true

    title: qsTr("Timer")

    color: theme === "light" ? ensemble.theme.light_background : ensemble.theme.dark_background

    readonly property real scaleFactor: Math.min(width/300, height/200)

    property string theme: "light"

    Item {
        id: mainBox

        anchors {
            horizontalCenter: window.horizontalCenter
            verticalCenter: window.verticalCenter
        }

        width: window.width
        height: window.height

        Item {
            id: otherButtons

            anchors {
                bottom: timerPanel.top
                horizontalCenter: mainBox.horizontalCenter
            }

            height: 50 * window.scaleFactor

            ControlButton {
                id: pin

                anchors {
                    right: otherButtons.horizontalCenter
                    rightMargin: 5 * window.scaleFactor
                    verticalCenter: otherButtons.verticalCenter
                }

                baseSize: 40
                scaleFactor: window.scaleFactor

                iconSource: "qrc:/icons/" + window.theme + "/pin.png"
                iconMarginsRatio: 3

                theme: window.theme

                onPressed: logic.togglePinMode()
            }

            ControlButton {
                id: settings

                anchors {
                    left: otherButtons.horizontalCenter
                    rightMargin: 5 * window.scaleFactor
                    verticalCenter: otherButtons.verticalCenter
                }

                baseSize: 40
                scaleFactor: window.scaleFactor

                iconSource: "qrc:/icons/" + window.theme + "/settings.png"
                iconMarginsRatio: 3

                theme: window.theme

                onPressed: logic.toggleSettings()
            }
        }

        TimerPanel {
            id: timerPanel

            anchors {
                horizontalCenter: mainBox.horizontalCenter
                verticalCenter: mainBox.verticalCenter
            }

            baseWidth: 300
            baseHeight: 100
            scaleFactor: window.scaleFactor

            theme: window.theme
        }

        Item {
            id: timerButtons

            anchors {
                top: timerPanel.bottom
                horizontalCenter: mainBox.horizontalCenter
            }

            height: 50 * window.scaleFactor

            ControlButton {
                id: reset

                anchors {
                    right: play.left
                    rightMargin: 5 * window.scaleFactor
                    verticalCenter: timerButtons.verticalCenter
                }

                baseSize: 40
                scaleFactor: window.scaleFactor

                iconSource: "qrc:/icons/" + window.theme + "/reset.png"
                iconMarginsRatio: 4

                theme: window.theme

                onPressed: timerPanel.resetTimer()
            }

            ControlButton {
                id: play

                anchors {
                    horizontalCenter: timerButtons.horizontalCenter
                    verticalCenter: timerButtons.verticalCenter
                }

                baseSize: 45
                scaleFactor: window.scaleFactor

                iconSource: "qrc:/icons/" + window.theme + "/play.png"
                iconMarginsRatio: 4

                theme: window.theme

                onPressed: timerPanel.startTimer()
            }

            ControlButton {
                id: stop

                anchors {
                    left: play.right
                    leftMargin: 5 * window.scaleFactor
                    verticalCenter: timerButtons.verticalCenter
                }

                baseSize: 40
                scaleFactor: window.scaleFactor

                iconSource: "qrc:/icons/" + window.theme + "/stop.png"
                iconMarginsRatio: 4

                theme: window.theme

                onPressed: timerPanel.stopTimer()
            }
        }
    }

    Item {
        id: settingsBox

        visible: false

        anchors {
            horizontalCenter: window.horizontalCenter
            verticalCenter: window.verticalCenter
        }

        width: window.width
        height: window.height

        SettingsPanel {
            id: settingsPanel

            anchors {
                horizontalCenter: settingsBox.horizontalCenter
                verticalCenter: settingsBox.verticalCenter
            }

            width: settingsBox.width
            height: settingsBox.height

            scaleFactor: window.scaleFactor

            theme: window.theme

            onThemeSelected: (newTheme) => window.theme = newTheme
            onTimeUpdated: (newTime) => timerPanel.setTime(newTime)
        }

        ControlButton {
            id: back

            anchors {
                left: settingsBox.left
                bottom: settingsBox.bottom
                margins: 5 * window.scaleFactor
            }

            baseSize: 40
            scaleFactor: window.scaleFactor

            iconSource: "qrc:/icons/" + window.theme + "/back.png"
            iconMarginsRatio: 4

            theme: window.theme

            onPressed: logic.toggleSettings()
        }
    }

    QtObject {
        id: logic

        property int real_x: 0
        property int real_y: 0
        property int real_width: 300
        property int real_height: 200

        function updateValues() {
            if (window.visibility === Qt.WindowMaximized) {
                logic.real_x = window.x
                logic.real_y = window.y
                logic.real_width = window.width
                logic.real_height = window.height
            }
        }

        function togglePinMode() {
            window.flags ^= Qt.WindowStaysOnTopHint
            pin.showBorder ^= true
        }

        function toggleSettings() {
            mainBox.visible ^= true
            settingsBox.visible ^= true
        }
    }

    Connections {
        target: window

        function onXChanged() {
            geometryTimer.restart()
        }
        function onYChanged() {
            geometryTimer.restart()
        }
        function onWidthChanged() {
            geometryTimer.restart()
        }
        function onHeightChanged() {
            geometryTimer.restart()
        }
    }

    Timer { // trick to properly handle geometry events on all systems (:coff: ... Windows ... :coff:)
        id: geometryTimer
        interval: 1000
        onTriggered: logic.updateValues()
    }

    Ensemble {
        id: ensemble
    }

    ConfigsManager {
        id: configsManager
    }

    Component.onCompleted: {
        if (configsManager.readConfigs()) {
            const geometry = configsManager.getGeometry()
            window.x = geometry.x
            window.y = geometry.y
            window.width = geometry.width
            window.height = geometry.height
            if (configsManager.getMaximization()) {
                window.visibility = Qt.WindowFullScreen
            }
            window.theme = configsManager.getTheme()
            timerPanel.setTime(configsManager.getTime())
        }
        logic.updateValues() // needed to properly initialize values on all systems (:coff: ... Windows ... :coff:)
        timerPanel.resetTimer()
        const time = timerPanel.getTime()
        const mins = Math.floor(time / 60)
        const secs = Math.floor(time - (mins * 60))
        settingsPanel.setMinutes(mins)
        settingsPanel.setSeconds(secs)
    }

    onClosing: (handler) => {
        configsManager.setMaximization(window.visibility === Qt.WindowFullScreen)
        configsManager.setGeometry(logic.real_x, logic.real_y, logic.real_width, logic.real_height)
        configsManager.setTheme(window.theme)
        configsManager.setTime(timerPanel.getTime())
        configsManager.setPinMode(pin.showBorder)
        configsManager.writeConfigs()
    }
}
