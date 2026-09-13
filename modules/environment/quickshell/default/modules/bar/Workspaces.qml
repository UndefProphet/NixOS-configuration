pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import Quickshell.Hyprland
import QtQuick.Layouts
import Quickshell.Widgets
import QtQuick.Effects

Item {
  id: root

  // Move to appearence settings later
  property int widgetMargin: 0
  property int spacings: 5
  property int iconSize: 16
  property string defaultMissingIcon: "application-x-executable"

  property int workspaceSpacing: 2
  property int workspacePaddingHorizontal: 5
  property int workspacePaddingVertical: 5
  property int workspaceIconSpacing: 1
  property int roundingWorkspaceGroup: 0
  // Font
  property Font font;
  property int textSize: 12
  property bool textBold: false

  // Colors
  property color tintColor
  SystemPalette {
    id: activePalette
  }

  property color widgetBackground: "transparent"
  // Workspace colors
  property color workspaceTextColor: "#ffffff"
  property color workspaceBackgroundColor: "transparent"
  property color workspaceFocusedTextColor: '#000000'
  property color workspaceFocusedBackgroundColor: '#9affffff'
  // // Different monitor colors
  property color workspaceDifferentMonitorTextColor: '#ff0000'
  property color workspaceDifferentMonitorBackgroundColor: 'transparent'
  property color workspaceDifferentMonitorFocusedTextColor: '#000000'
  property color workspaceDifferentMonitorFocusedBackgroundColor: '#b7ff4e4e'

  required property ShellScreen shellScreen 
  property var workspaces: Hyprland.workspaces

  implicitWidth: background.width
  implicitHeight: background.height

  Rectangle {
    id: background

    // color: 'yellow' // Background color
    color: root.widgetBackground
    anchors {
      verticalCenter: parent.verticalCenter
      horizontalCenter: parent.horizontalCenter
    }
    implicitWidth: workspacesRow.width
    implicitHeight: workspacesRow.implicitHeight

    // Workspace row.
    RowLayout {
      id: workspacesRow
      anchors.centerIn: parent
      // height: parent.height
      spacing: root.workspaceSpacing

      // Each Hyprland workspace.
      Repeater {
        id: workspaceRepeater
        model: root.workspaces


        // Show only for this screen's workspaces.
        delegate: Rectangle {
          id: workspaceItem

          required property HyprlandWorkspace modelData
          readonly property HyprlandWorkspace workspace: modelData

          readonly property HyprlandWorkspace activeWorkspaceOnMonitor: workspace?.monitor?.activeWorkspace ?? null
          readonly property string currentMonitorName: root.shellScreen?.name 
          readonly property string currentHyprlandMonitorName: workspace?.monitor?.name ?? ""
          readonly property string hyprlandMonitorId : workspace?.monitor?.id ?? ""

          // readonly property color backgroundColor: activeWorkspaceOnMonitor === workspace && currentMonitorName === currentHyprlandMonitorName ? root.workspaceFocusedBackgroundColor : root.workspaceBackgroundColor;

          readonly property color backgroundColor: {
            // If different monitor
            if (workspaceItem.currentMonitorName !== workspaceItem.currentHyprlandMonitorName ) {
              // Active workspace on different monitor
              if(workspaceItem.workspace === workspaceItem.activeWorkspaceOnMonitor){
                return root.workspaceDifferentMonitorFocusedBackgroundColor
              }
              return root.workspaceDifferentMonitorBackgroundColor
            }
            // Check if workspace is active
            if (workspaceItem.activeWorkspaceOnMonitor === workspaceItem.workspace) {
              return root.workspaceFocusedBackgroundColor
            }
            return root.workspaceBackgroundColor
          }

          // In case there is no icon to increase the height.
          implicitHeight: Math.max(workspaceItemsRow.height, root.iconSize) + root.workspacePaddingVertical
          implicitWidth: workspaceItemsRow.width + root.workspacePaddingHorizontal

          radius: root.roundingWorkspaceGroup
          color: "transparent"
          border {
            color: backgroundColor
            width: 1
          }


          MouseArea {
            anchors.fill : workspaceItemsRow
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: (mouse) => {

              switch (mouse.button) {
                case Qt.LeftButton:
                console.log("Pressed left click on workspace (activate): " + workspaceItem.workspace.id)
                workspaceItem.workspace.activate()
                break;

                case Qt.RightButton:
                console.log("Pressed right click on workspace (focusworkspaceoncurrentmonitor): " + workspaceItem.workspace.id)
                Hyprland.dispatch(`focusworkspaceoncurrentmonitor ${workspaceItem.workspace.id}`)
                break;
              }
            }
          }

          RowLayout {
            id: workspaceItemsRow
            spacing: root.workspaceIconSpacing
            anchors.centerIn: parent

            Text {
              id: workspaceNumberText

              // Make workspaces belonging to another monitor the color colorWorkspaceDifferentMonitor.
              readonly property var textColor: {
                // If different monitor
                if (workspaceItem.currentMonitorName !== workspaceItem.currentHyprlandMonitorName ) {
                  // Active workspace on different monitor
                  if(workspaceItem.workspace === workspaceItem.activeWorkspaceOnMonitor){
                    return root.workspaceDifferentMonitorFocusedTextColor
                  }
                  return root.workspaceDifferentMonitorTextColor
                }
                // Check if workspace is active
                if (workspaceItem.activeWorkspaceOnMonitor === workspaceItem.workspace) {
                  return root.workspaceFocusedTextColor
                }
                return root.workspaceTextColor
              }
              readonly property string monitorId: workspaceItem.currentMonitorName !== workspaceItem.currentHyprlandMonitorName ? workspaceItem.hyprlandMonitorId : ""

              font.pointSize: root.textSize
              color: textColor
              textFormat: Text.RichText
              text: workspaceItem.workspace?.id + ("<sup>" + monitorId + "</sup>")
              font.bold: root.textBold
            }

            // For each window in the workspace.
            Repeater {
              model: workspaceItem.workspace.toplevels

              delegate: Rectangle {
                id: workspaceIcon
                color: "transparent"
                implicitHeight: applicationIconImage.height
                implicitWidth: applicationIconImage.width

                required property HyprlandToplevel modelData;
                readonly property HyprlandToplevel toplevel: modelData;

                IconImage {
                  id: applicationIconImage
                  implicitSize: root.iconSize
                  anchors.centerIn: parent
                  source: getIconForToplevel(parent.toplevel)

                  // TODO: Some applications can't be found by DesktopEntries.heuristicLookup like LSP-plugins.
                  function getIconForToplevel(toplevel) {
                    return Quickshell.iconPath(DesktopEntries.heuristicLookup(toplevel?.wayland?.appId)?.icon, root.defaultMissingIcon)
                  }
                }

                MultiEffect {
                  id: alteredIconImage
                  source: applicationIconImage 
                  implicitHeight: root.iconSize
                  implicitWidth: root.iconSize
                  saturation: -0.5
                  // brightness: 0.10
                  colorization: 1
                  colorizationColor: root.tintColor
                }
                // MultiEffect {
                //   id: alteredIconImage
                //   source: applicationIconImage 
                //   implicitHeight: root.iconSize
                //   implicitWidth: root.iconSize
                //   brightness: 0.10
                //   colorization: 0.75
                //   colorizationColor: root.tintColor
                // }
              }
            }
          }
        }
      }
    }
  }
}
