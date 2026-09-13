import QtQuick
import Quickshell
// import "../widgets"
// import "../widgets/Workspaces"
import qs.modules.widgets
import qs.modules.widgets.workspaces
import qs.modules.widgets.systray

PanelWindow {
  id: root
  required property ShellScreen monitorScreen

  // Colors
  SystemPalette { id: palette }
  SystemPalette { id: paletteInactive; colorGroup: SystemPalette.Inactive }
  SystemPalette { id: paletteDisabled; colorGroup: SystemPalette.Disabled }

  //colors
  property real opacity: 0 //0.75
  property color barColor: Qt.rgba( palette.base.r, palette.base.g, palette.base.b, opacity)

  // Dimensions
  property int barHeight: 30

  anchors {
    top: true
    left: true
    right: true
  }
  margins {
    top: 5
    bottom: 0
  }

  screen: monitorScreen
  implicitHeight: barHeight
  color: "transparent"

  WidgetFields {
    implicitHeight: root.barHeight

    rightSide: [
      WidgetBackground {
        Battery {}
        SystemTrayWidget {}
      }
    ]

    leftSide: [

      WidgetBackground {
        Workspaces { screen: monitorScreen }
      }
    ]

    middle: [
      WidgetBackground {
        Time {}
      }
    ]

  }
}
