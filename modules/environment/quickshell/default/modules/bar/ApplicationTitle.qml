pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import Quickshell.Hyprland

// import Quickshell.Wayland

Item {
    id: root

    required property var shellScreen

    implicitHeight: parent.height


    Text {
      id: titleText
      
      anchors.centerIn: parent
      color: 'white'
      text: shellScreen.title
      // text: "test"
      Component.onCompleted:{

        var monitor = Hyprland.monitors.values.find(monitor => monitor.name === shellScreen.name)
        console.log(monitor.activeWorkspace)

      }
    }
}