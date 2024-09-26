import QtQuick
import QtQuick.Controls

import scrumdown.utils

Item {
    id: root

    width: baseSize * scaleFactor
    height: baseSize * scaleFactor

    property int baseSize

    property real scaleFactor

    property string iconSource

    property int iconMarginsRatio

    property string theme

    property bool showBorder: false

    signal pressed()

    Component.onCompleted: icon.width = root.width

    Button {
        id: button

        anchors.fill: root

        background: Rectangle {
            radius: root.width / 2
            border {
                width: Math.max(1, Math.min(10, root.width / 30 * root.scaleFactor))
                color: root.showBorder ? ensemble.theme.pin_border : "transparent"
            }
            color: root.theme === "light"
                    ? button.down ? ensemble.theme.light_button_down
                                  : button.hovered ? ensemble.theme.light_button_hovered
                                                   : ensemble.theme.light_button_static
                    : button.down ? ensemble.theme.dark_button_down
                                  : button.hovered ? ensemble.theme.dark_button_hovered
                                                   : ensemble.theme.dark_button_static
        }

        onPressed: root.pressed()
    }

    Image {
        id: icon

        anchors {
            fill: root
            margins: root.width / root.iconMarginsRatio
        }

        fillMode: Image.PreserveAspectFit

        source: root.iconSource
    }

    Ensemble {
        id: ensemble
    }
}
