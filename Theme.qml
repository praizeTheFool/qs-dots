pragma Singleton
import Quickshell
import QtQuick

// Central design token singleton.
// Every component imports this; no hardcoded values anywhere.
QtObject {
    id: root

    // ── Palette ────────────────────────────────────────────────────────────
    readonly property color bg:          "#0d0d14"   // near-black indigo base
    readonly property color surface:     "#13131f"   // panel background
    readonly property color surfaceHigh: "#1c1c2e"   // raised surface
    readonly property color border:      "#ffffff18" // subtle 1px separator
    readonly property color accent:      "#7c6af7"   // indigo/violet primary
    readonly property color accentWarm:  "#f5a623"   // amber highlight
    readonly property color text:        "#e8e8f0"
    readonly property color subtext:     "#888899"

    // ── Shape ──────────────────────────────────────────────────────────────
    readonly property int  radius:      14           // default corner radius
    readonly property int  radiusLg:    22           // panels / notch
    readonly property real borderWidth: 1.2

    // ── Blur ───────────────────────────────────────────────────────────────
    // backgroundBlur is NOT a QML property; blur is applied via Hyprland
    // layerrules (see install.sh).  This value is kept here so install.sh
    // and the README can reference a single source of truth.
    readonly property int blur: 24

    // ── Motion ─────────────────────────────────────────────────────────────
    readonly property int durationFast: 120
    readonly property int durationMid:  220
    readonly property int durationSlow: 380

    // QML easing equivalent of CSS cubicBezier(0.16, 1, 0.3, 1).
    // Usage: easing.type: Easing.Bezier; easing.bezierCurve: Theme.easeOut
    readonly property var easeOut: [0.16, 1.0, 0.3, 1.0, 1.0, 1.0]
}
