import Quickshell
import Quickshell.Wayland
import QtQuick
import "../.."


// One bar instance per monitor.
// Spawned by shell.qml via Variants over Quickshell.screens.
PanelWindow {
    id: barWindow

    // Required: the screen this bar belongs to (set by parent Variants).
    required property var modelData

    screen: modelData

    // ── Layer shell positioning ──────────────────────────────────────────
    anchors {
        top: true
        left: true
        right: true
    }
    WlrLayerShell.layer:      WlrLayer.Top
    WlrLayerShell.exclusiveZone: height   // reserve 36px from top

    height: 36
    color:  "transparent"                  // we draw our own background

    // ── Background + border ─────────────────────────────────────────────
    // Blur is handled by Hyprland layerrule (see install.sh).
    // This rectangle provides color; real blur depth comes from the compositor.
    Rectangle {
        id: bg
        anchors.fill: parent
        color:   Qt.rgba(
            Theme.surface.r, Theme.surface.g, Theme.surface.b, 0.88)
        radius:  0  // full-width bar has no rounded corners

        // 1px bottom border using Theme.border color.
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left:   parent.left
            anchors.right:  parent.right
            height: Theme.borderWidth
            color:  Theme.border
        }
    }

    // ── Fade-in on shell start ───────────────────────────────────────────
    opacity: 0
    transform: Translate { id: barSlide; y: -4 }

    Component.onCompleted: startAnim.start()

    SequentialAnimation {
        id: startAnim
        // Brief pause so Hyprland has finished mapping the surface.
        PauseAnimation { duration: 60 }
        ParallelAnimation {
            NumberAnimation {
                target: barWindow
                property: "opacity"
                from: 0; to: 1
                duration: 180
                easing.type: Easing.OutCubic
            }
            NumberAnimation {
                target: barSlide
                property: "y"
                from: -4; to: 0
                duration: 180
                easing.type: Easing.OutCubic
            }
        }
    }

    // ── Layout: left / center / right ───────────────────────────────────
    Item {
        anchors.fill: parent

        BarLeft {
            id: leftSection
            anchors.left:           parent.left
            anchors.verticalCenter: parent.verticalCenter
            // Max width so it doesn't crowd the center.
            width: Math.min(implicitWidth, parent.width / 3)
        }

        BarCenter {
            id: centerSection
            anchors.centerIn: parent
        }

        BarRight {
            id: rightSection
            anchors.right:          parent.right
            anchors.verticalCenter: parent.verticalCenter
            width: Math.min(implicitWidth, parent.width / 3)
        }
    }
}
