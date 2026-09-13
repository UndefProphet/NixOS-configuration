//@ pragma UseQApplication
import QtQuick
import Quickshell
import qs.modules.bar
// import qs.modules.scrollindicator

ShellRoot {
  id: root

  Variants {
    // TODO: implement side and top bar for different resolutions.
    // model: { return Quickshell.screens; }
    model: Quickshell.screens
    Bar {
      required property var modelData
      monitorScreen: modelData
    }
  }


  // Variants {
  //   model: Quickshell.screens
  //  ScrollIndicator {
  //     monitorScreen: modelData
  //   }
  // }
}
