import Quickshell
import QtQuick

// Root shell entry point.
// Run with: quickshell -c shell/shell.qml
//
// Singletons loaded implicitly by QML engine when pragma Singleton is present
// and the file is listed in qmldir (or co-located): Theme, HyprlandService.
ShellRoot {
    id: root

    // Spawn one Bar per connected monitor.
    // Quickshell.screens updates automatically on monitor hot-plug (Phase 7).
    Variants {
        model: Quickshell.screens

        // Each variant receives the screen via the required property in Bar.qml.
        Bar {}
    }
}
