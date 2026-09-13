// Time.qml
import Quickshell
import QtQuick

Item {
  id: root
  property string time
  property color textColor: "white"
  property bool textBold: false
  property color widgetBackground: "transparent"
  // property int widgetBackgroundSideMargin: 4

  // FontConfig {
  //   id: fontConfig
  // }

  implicitWidth: timeText.width
  implicitHeight: timeText.height

  Rectangle {
    // id: widgetBackground
    // color: root.widgetBackground
    anchors {
        verticalCenter: parent.verticalCenter
        horizontalCenter: parent.horizontalCenter
    }
    implicitHeight: parent.height
    implicitWidth: timeText.width 

    color: "transparent"
    radius: 4

    Text {
      id: timeText
      text: `${Qt.formatDateTime(clock.date, "dddd, MMMM dd hh:mm")}`
      color: root.textColor
      font.bold: root.textBold
    }
  }


  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }
}
