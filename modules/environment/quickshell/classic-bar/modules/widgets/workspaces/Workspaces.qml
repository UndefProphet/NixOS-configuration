import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Hyprland
import QtQml.Models

import qs.modules.widgets.workspaces

Item {
  id: root
  SystemPalette { id: palette }

  required property ShellScreen screen

  implicitWidth: childrenRect.width
  implicitHeight: childrenRect.height

  property var workspaces: Hyprland.workspaces


  RowLayout {

    Repeater {
      model: root.workspaces
      delegate: RowLayout {
        required property HyprlandWorkspace modelData
        readonly property HyprlandWorkspace workspace: modelData

        Text {
          property var workspaceId: workspace.id
          color: "yellow"
          text: `[${workspaceId}:`
        }

        Repeater {
          model: workspace.toplevels
          Icon {
            required property HyprlandToplevel modelData
            implicitSize: parent.height
            toplevel: modelData
          }
        }

        Text {
          property var workspaceId: workspace.id
          color: "yellow"
          text: `]`
        }
      }
    }
  }


//     Repeater {
//       model: .workspaces
//
// RowLayout {
//         id: workspace
//         visible: model.output == screen.name
//         property var workspaceId: model.id
//
//         Text {
//           color: "yellow"
//           text: `[${model.index}${model.name}]`
//         }
//
//         Repeater {
//           // model: NiriService.windows
//           //
//           RowLayout {
//             visible: model.workspaceId == workspace.workspaceId
//
//             Rectangle {
//               color: model.isFocused ? "lightblue" : "transparent"
//               implicitWidth: childrenRect.width + 10
//               implicitHeight: childrenRect.height
//
//               RowLayout {
//               anchors.centerIn: parent
//                 IconImage {
//                   implicitSize: apptext.height
//                   source: `file://${model.iconPath}`
//                 }
//                 Text {
//                   id: apptext
//                   color: model.isFocused ?  "black" : palette.text
//                   text: model.appId
//                 }
//               }
//             }
//           }
//         }
//       }
//     }
//   }
}
