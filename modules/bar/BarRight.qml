import Quickshell
import QtQuick

// Right section of the bar.
// Shows network state, volume level, battery %, and a notification bell.
// All values are polled via Process; Phase 7 will migrate to socket listeners.
Item {
    id: root
    implicitWidth: tray.implicitWidth + 12
    implicitHeight: parent ? parent.height : 36

    // ── State ────────────────────────────────────────────────────────────
    property string networkIcon:   ""  // Material Symbols: wifi
    property string volumeIcon:    ""  // Material Symbols: volume_up
    property int    volumeLevel:   100
    property int    batteryLevel:  -1        // -1 = no battery / desktop
    property bool   charging:      false
    property bool   dndActive:     false     // toggled by Phase 5

    // ── Polling timers ──────────────────────────────────────────────────

    /*
    // Network state via nmcli — every 10s is plenty.
    Process {
        id: netProc
        command: ["nmcli", "-t", "-f", "STATE", "general"]
        running: false
        onExited: {
            var out = stdout.trim()
            if (out === "connected")
                root.networkIcon = ""      // wifi connected
            else if (out.startsWith("connecting"))
                root.networkIcon = ""      // wifi_find
            else
                root.networkIcon = "︎" // wifi_off fallback — use subtext color
        }
        stdout: ""
    }

    // Volume via wpctl — every 3s.
    Process {
        id: volProc
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        running: false
        onExited: {
            var line = stdout.trim()
            var muted = line.indexOf("[MUTED]") !== -1
            var match = line.match(/[\d.]+/)
            if (match) {
                root.volumeLevel = Math.round(parseFloat(match[0]) * 100)
            }
            if (muted) {
                root.volumeIcon   = ""  // volume_off
                root.volumeLevel  = 0
            } else if (root.volumeLevel < 30) {
                root.volumeIcon = ""    // volume_down
            } else {
                root.volumeIcon = ""    // volume_up
            }
        }
        stdout: ""
    }

    // Battery via upower — every 30s.
    Process {
        id: batProc
        command: ["sh", "-c",
            "upower -i $(upower -e | grep BAT | head -1) 2>/dev/null " +
            "| grep -E 'percentage|state' | awk '{print $2}'"]
        running: false
        onExited: {
            var lines = stdout.trim().split("\n")
            if (lines.length >= 2) {
                root.batteryLevel = parseInt(lines[1])
                root.charging     = (lines[0] === "charging")
            }
        }
        stdout: ""
    }
    */

    Timer {
        interval: 3000; repeat: true; running: true; triggeredOnStart: true
        onTriggered: {
            // netProc.running = true; volProc.running = true
        }
    }
    Timer {
        interval: 30000; repeat: true; running: true; triggeredOnStart: true
        onTriggered: {
            // batProc.running = true
        }
    }

    // ── Tray row ─────────────────────────────────────────────────────────
    Row {
        id: tray
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 8
        spacing: 10

        // Network icon
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.networkIcon
            font.pixelSize: 16
            font.family: "Material Symbols Rounded"
            color: Theme.subtext
        }

        // Volume icon + level
        Row {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 3
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: root.volumeIcon
                font.pixelSize: 16
                font.family: "Material Symbols Rounded"
                color: Theme.subtext
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: root.volumeLevel + "%"
                font.pixelSize: 11
                color: Theme.subtext
                visible: root.volumeLevel >= 0
            }
        }

        // Battery (hidden on desktops without a battery)
        Row {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 3
            visible: root.batteryLevel >= 0

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: root.charging ? ""                       // battery_charging_full
                    : root.batteryLevel > 80 ? ""              // battery_full
                    : root.batteryLevel > 50 ? ""              // battery_3_bar
                    : root.batteryLevel > 20 ? ""              // battery_2_bar
                    : ""                                        // battery_alert
                font.pixelSize: 16
                font.family: "Material Symbols Rounded"
                color: root.batteryLevel <= 20 && !root.charging
                    ? Theme.accentWarm
                    : Theme.subtext
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: root.batteryLevel + "%"
                font.pixelSize: 11
                color: Theme.subtext
            }
        }

        // Notification bell — Phase 5 will wire this to sidebar toggle.
        Text {
            id: bellIcon
            anchors.verticalCenter: parent.verticalCenter
            text: root.dndActive ? "" : ""  // notifications_off / notifications
            font.pixelSize: 16
            font.family: "Material Symbols Rounded"
            color: root.dndActive ? Theme.accentWarm : Theme.subtext

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {}
            }
        }
    }
}
