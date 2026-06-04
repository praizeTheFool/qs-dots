import QtQuick
import "../.."

// Center section of the bar.
// Shows HH:mm clock and ddd dd MMM date.
// Phase 2 will replace this with the dynamic notch PanelWindow;
// this component stays in the bar layout as a fallback/spacer.
Item {
    id: root
    implicitWidth: column.implicitWidth + 16
    implicitHeight: parent ? parent.height : 36

    // Live clock — updates every 10 seconds (1s is wasteful for HH:mm display).
    Timer {
        id: clockTimer
        interval: 10000
        repeat: true
        running: true
        onTriggered: {
            var now = new Date()
            timeLabel.text  = Qt.formatTime(now, "HH:mm")
            dateLabel.text  = Qt.formatDate(now, "ddd dd MMM")
        }
    }

    Column {
        id: column
        anchors.centerIn: parent
        spacing: 1

        Text {
            id: timeLabel
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 14
            font.weight: Font.SemiBold
            color: Theme.text
        }

        Text {
            id: dateLabel
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 10
            color: Theme.subtext
        }
    }
}
