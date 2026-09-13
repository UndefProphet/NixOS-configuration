// System tray widget

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell // for PanelWindow
import Quickshell.Services.SystemTray
import Quickshell.Widgets

Item {
  id: root
  property int iconSize: 15
  property int spacing: 5
  property int clickAreaIncrease: 3
  property color tintColor


  implicitWidth: systemTrayRectangle.width
  implicitHeight: systemTrayRectangle.height

  Rectangle {
    id: systemTrayRectangle

    color: "transparent"
    
    anchors {
        verticalCenter: parent.verticalCenter
        horizontalCenter: parent.horizontalCenter
    }

    implicitHeight: trayRow.height
    implicitWidth: trayRow.width

    RowLayout {
      id: trayRow

      anchors.centerIn: parent
      spacing: root.spacing

      Repeater {
        model: SystemTray.items

        delegate: Rectangle {
          id: trayItemRect
          required property SystemTrayItem modelData
          readonly property SystemTrayItem trayItem : modelData
          
          color: "transparent"
          implicitHeight: trayIconImage.height + root.clickAreaIncrease
          implicitWidth: trayIconImage.width + root.clickAreaIncrease

          MouseArea {
            anchors.fill : trayItemRect
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: (mouse) => {

                switch (mouse.button) {
                    case Qt.LeftButton:
                        console.log("Left click")
                        trayItemRect.trayItem.activate()
                    break;

                    case Qt.RightButton:
                        console.log("Right click on", modelData.id, "hasMenu:", modelData.hasMenu, "menu:", modelData.menu)
                        if (trayItemRect.trayItem.hasMenu){
                          console.log("Cocaine Discovered")
                          // QsMenuEntery
                          systemTrayWindowMenu.menuOptions = trayItemRect.trayItem.menu?.children
                          console.log(systemTrayWindowMenu.menuOptions)
                          contextMenu.popup()
                        }
                    break;
                }
            }
          }

          IconImage {
            id: trayIconImage
            anchors.centerIn: parent
            source: trayItemRect.trayItem.icon
            implicitSize: root.iconSize
            visible: false
          }
          MultiEffect {
            id: alteredIconImage
            source: trayIconImage 
            implicitHeight: root.iconSize
            implicitWidth: root.iconSize
            // brightness: 0.1
            colorization: 1
            colorizationColor: root.tintColor
          }
        }
      }
    }
  }


  PanelWindow {
    visible: false
    id: systemTrayWindowMenu
    implicitHeight: contextMenu.height
    implicitWidth: contextMenu.width
    // color: "transparent"

    property var menuOptions: []

    Menu {
      id: contextMenu
      MenuItem { text: "Paste" }
    } 
  }
}
