pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import Quickshell.Hyprland
import QtQuick.Layouts
import Quickshell.Widgets
import QtQuick.Effects
import Quickshell.Io

Item {
  id: root
  required property string sourceImage
  required property color fillColor
  property int size: 28

  implicitWidth: img.width
  implicitHeight: img.height

  SystemPalette {
    id: activePalette
    // colorGroup: SystemPalette.Active
  }

  IconImage{
    id: iconImage
    source: root.sourceImage
    implicitSize: root.size
    visible: false
  }

  MultiEffect {
    id: img
    source: iconImage
    implicitHeight: root.size
    implicitWidth: root.size
    // brightness: 1
    colorization: 0.75
    colorizationColor: root.fillColor 
  }

  MouseArea {
    anchors.fill : iconImage
    acceptedButtons: Qt.LeftButton  
    onClicked: (mouse) => {
      switch (mouse.button) {
        case Qt.LeftButton:
        console.log("Left clicked logo")
        // Process.exec(["rofi", "-show", "drun"])
        break;

        case Qt.RightButton:
        console.log("Right clicked logo")
        // DesktopAction.execString("")
        break;
      }
    }
  }
}
