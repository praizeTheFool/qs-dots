pragma Singleton
import Quickshell
import Quickshell.Hyprland
import QtQuick

// Thin wrapper around QuickShell's Hyprland IPC.
// Exposes the workspace list and active window title as clean properties
// so bar components never touch raw IPC directly.
QtObject {
    id: root

    // ── Active window title (truncated in BarLeft) ──────────────────────
    readonly property string activeTitle: Hyprland.focusedClient
        ? Hyprland.focusedClient.title
        : ""

    // ── Workspace list ──────────────────────────────────────────────────
    // HyprlandWorkspace objects exposed by QuickShell's Hyprland singleton.
    readonly property var workspaces: Hyprland.workspaces

    // ID of the currently focused workspace.
    readonly property int activeWorkspaceId: Hyprland.focusedMonitor
        ? Hyprland.focusedMonitor.activeWorkspace.id
        : 1

    // ── Helpers ─────────────────────────────────────────────────────────

    // Dispatch an arbitrary hyprctl command (e.g. "focusworkspace 3").
    function dispatch(cmd) {
        Hyprland.dispatch(cmd)
    }
}
