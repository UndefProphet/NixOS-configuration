import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland

IconImage {
  id: applicationIconImage
  required property HyprlandToplevel toplevel
  source: getIconForToplevel(toplevel)

  // TODO: Some applications can't be found by DesktopEntries.heuristicLookup like LSP-plugins.
  property string defaultMissingIcon: "application-x-executable"
  function getIconForToplevel(toplevel) {
    return Quickshell.iconPath(DesktopEntries.heuristicLookup(toplevel?.wayland?.appId)?.icon, defaultMissingIcon)
  }

  // MultiEffect {
  //   id: alteredIconImage
  //   source: applicationIconImage 
  //   implicitHeight:applicationIconImage.height
  //   implicitWidth: applicationIconImage.width
  //   saturation: -0.5
  //   // brightness: 0.10
  //   colorization: 1
  //   colorizationColor: "orange"
  // }
}
