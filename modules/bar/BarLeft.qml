import Quickshell
import Quickshell.Hyprland
import QtQuick

// Left section of the bar.
// Renders one pill per workspace and the active window title.
Item {
    id: root
    implicitWidth: row.implicitWidth + 8
    implicitHeight: parent ? parent.height : 36

    Row {
        id: row
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 8
        spacing: 5

        // ── Workspace pills ─────────────────────────────────────────────
        Repeater {
            model: HyprlandService.workspaces

            delegate: Rectangle {
                id: pill

                readonly property bool isActive:
                    modelData.id === HyprlandService.activeWorkspaceId
                readonly property bool hasWindows:
                    modelData.clientCount > 0

                // Invisible if empty and not active.
                visible: isActive || hasWindows

                height: 22
                radius: Theme.radius

                // Active → accent fill; occupied → raised surface; else accent at 20%
                color: isActive
                    ? Theme.accent
                    : (hasWindows ? Theme.surfaceHigh : Qt.rgba(
                          Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.2))

                // Pill width animates smoothly on state change.
                width: isActive ? 32 : 18
                Behavior on width {
                    SmoothedAnimation {
                        duration: Theme.durationMid
                        easing.type: Easing.Bezier
                        easing.bezierCurve: Theme.easeOut
                    }
                }

                // Workspace number label — hidden when pill is narrow.
                Text {
                    anchors.centerIn: parent
                    text: modelData.id
                    font.pixelSize: 10
                    font.weight: Font.Medium
                    color: pill.isActive ? "#ffffff" : Theme.subtext
                    opacity: pill.isActive ? 1 : 0
                    Behavior on opacity {
                        NumberAnimation { duration: Theme.durationFast }
                    }
                }

                // Click → focus that workspace.
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: HyprlandService.dispatch("focusworkspace " + modelData.id)
                }
            }
        }

        // ── Window title ────────────────────────────────────────────────
        Text {
            anchors.verticalCenter: parent ? parent.verticalCenter : undefined
            // Truncate to 32 characters.
            text: HyprlandService.activeTitle.length > 32
                ? HyprlandService.activeTitle.substring(0, 32) + "…"
                : HyprlandService.activeTitle
            font.pixelSize: 12
            color: Theme.subtext
            verticalAlignment: Text.AlignVCenter
            leftPadding: 6
        }
    }
}
