pragma ComponentBehavior: Bound
import Quickshell // for PanelWindow
import QtQuick // for Text
import QtQuick.Layouts // for RowLayout

import "systray"

Scope {
    id: root

    property int widgetGroupSideMargins: 25
    property int widgetSpacings: 10
    property int barHeight: 30
    property int widgetBackgroundSpacing: 2
    
    SystemPalette {
      id: sysPalette
    }

    SystemPalette {
      id: sysPaletteInactive
      colorGroup: SystemPalette.Inactive
    }
    SystemPalette {
      id: sysPaletteDisabled
      colorGroup: SystemPalette.Disabled
    }

    // For each screen, create a panel
    Variants {
        model: {
            // TODO: implement side and top bar for different resolutions.
            return Quickshell.screens;
        }

        PanelWindow {
            required property var modelData
            screen: modelData
            color: sysPalette.base

            anchors {
                // bottom: true
                top: true
                left: true
                right: true
            }

            // Size
            implicitHeight: root.barHeight

            // Middle widgets.
            Rectangle {
                color: 'transparent'
                
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
                }
                implicitHeight: parent.height
                implicitWidth: middleRow.width // + root.widgetGroupSideMargins

                RowLayout {
                    id: middleRow
                    anchors.centerIn: parent
                    implicitHeight: parent.height

                    spacing: root.widgetSpacings
                  
                    // PaletteSampler {}
                    Time {
                      textColor: sysPalette.windowText
                      widgetBackground: sysPalette.light
                      // widgetBackgroundSideMargin: root.widgetBackgroundSpacing
                    }
                }
            }

            // Right side widgets.
            Rectangle {
                // color: '#2815b6' // Background color
                color: 'transparent'
                anchors {
                    right: parent.right
                    top: parent.top
                    bottom: parent.bottom
                }
                implicitHeight: parent.height
                implicitWidth: rightRow.width + root.widgetGroupSideMargins

                RowLayout {
                    id: rightRow
                    implicitHeight: parent.height
                    anchors.centerIn: parent
                    spacing: root.widgetSpacings
                    
                    Battery {
                      textColor: sysPalette.windowText
                      reverseOrder: true
                    }
                    SystemTrayWidget {
                      tintColor: sysPalette.windowText
                    }
                }
            }

            // Left side widgets.
            Rectangle {
                // color: '#6fb41b' // background color
                color: 'transparent'
                anchors { }
                implicitHeight: parent.height
                implicitWidth: leftRow.implicitWidth + root.widgetGroupSideMargins

                RowLayout {
                    id: leftRow
                    anchors.centerIn: parent

                    spacing: root.widgetSpacings
                    OSIcon {
                      sourceImage: "file://" + Quickshell.shellPath("assets") + "/nixos.svg"
                      fillColor: sysPalette.windowText 
                    }
                    Workspaces {
                        shellScreen: modelData

                        tintColor: sysPalette.windowText
                        // widgetBackground: sysPalette.alternateBase
                        // Workspace colors
                        workspaceTextColor: sysPalette.text
                        workspaceBackgroundColor: "transparent"
                        // workspaceFocusedTextColor: sysPalette.highlightedText
                        workspaceFocusedTextColor: sysPalette.text
                        workspaceFocusedBackgroundColor: sysPaletteInactive.accent
                        // Different monitor colors
                        workspaceDifferentMonitorTextColor: sysPalette.highlight
                        workspaceDifferentMonitorBackgroundColor: 'transparent'
                        // workspaceDifferentMonitorFocusedTextColor: sysPalette.highlightedText
                        workspaceDifferentMonitorFocusedTextColor: sysPalette.highlight
                        workspaceDifferentMonitorFocusedBackgroundColor: sysPalette.highlight
                    }
                }
            }


        }
    }
}
