import QtQuick
import QtQuick.Controls

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
                color: root.showBorder ? "#00b5ff" : "transparent"
            }
            color: root.theme === "light"
                    ? button.down ? "#cdcdcd" : button.hovered ? "#d4d4d4" : "#dbdbdb"
                    : button.down ? "#565656" : button.hovered ? "#484848" : "#404040"
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
}
