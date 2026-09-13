import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import qs.modules.services

        PanelWindow {
            required property var monitorScreen
            screen: monitorScreen

            // Anchor to the left edge, centered vertically
            anchors {
                left: true
                // top: true
                // bottom: true
            }

            implicitWidth: 24
implicitHeight: childRect.height

            exclusiveZone: 10

            color: "transparent"

            WlrLayershell.layer: WlrLayer.Top
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

            // Vertically centered column of workspace dots
            Column {
                anchors.centerIn: parent
                spacing: 8

                Repeater {
                    model: NiriService.workspaces

                    // Filter to only show workspaces on this screen
                    // (niri exposes workspaces for all outputs; match by output name)
                    delegate: Item {
                        // Hide workspaces that belong to a different output
                        visible: model.output === screen.name || NiriService.workspaces.count === 1
                        width: visible ? 24 : 0
                        height: visible ? 24 : 0

                        Rectangle {
                            id: dot
                            anchors.centerIn: parent

                            // Active/focused workspace gets a larger, bright pill
                            width: model.isFocused ? 10 : model.isActive ? 8 : 6
                            height: width
                            radius: width / 2

                            color: model.isFocused  ? "transparent" : // focused
                                   model.isActive   ? "#000" : // active
                                   model.isUrgent   ? "#e07060" : // urgent
                                                      "#000"   // inactive

                            // Smooth size / colour transitions
                            Behavior on width  { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }
                            Behavior on height { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }
                            Behavior on color  { ColorAnimation  { duration: 120 } }

                            // Subtle glow behind the focused dot
                            Rectangle {
                                anchors.centerIn: parent
                                width: parent.width + 0
                                height: width
                                radius: width / 2

                                border.color: model.isFocused  ? "#000" : // focused
                                      model.isActive   ? "transparent" : // active
                                      model.isUrgent   ? "#000" : // urgent
                                                          "transparent"   // inactive

                                border.width: 3
                                
                                color: model.isFocused  ? "transparent" : // focused
                                      model.isActive   ? "#4a7fa8" : // active
                                      model.isUrgent   ? "#e07060" : // urgent
                                                          "transparent"   // inactive
                                // visible: model.isFocused
                                z: -1
                            }
                        }
                    }
                }
            }
        }
