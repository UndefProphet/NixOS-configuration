// System battery
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower
import Quickshell.Widgets

Item {
  id: root

  property int maxWidth: 48
  property int fontSize: 16
  property bool reverseOrder: false
  property color textColor: "white"
  property bool textBold: false
  property int iconSize: 15

  implicitWidth: batteryRectangle.width
  implicitHeight: batteryRectangle.height

  Rectangle {
    id: batteryRectangle
    color: "transparent"
    anchors {
        verticalCenter: parent.verticalCenter
        horizontalCenter: parent.horizontalCenter
    }
    implicitHeight: batteriesRow.height
    implicitWidth: batteriesRow.width

    RowLayout {
      id: batteriesRow
      anchors.centerIn: parent
      spacing: 5

      Repeater {
        model: UPower.devices.values.filter(device => {
          return device.type !== 1 
        }).sort((a, b) => root.reverseOrder? b.type - a.type : a.type - b.type) 

        delegate : Text {
          id: textItem
          required property UPowerDevice modelData
          readonly property UPowerDevice device: modelData
          readonly property bool charging: device.changeRate > 0

          // font.pixelSize: root.fontSize
          font.bold: root.textBold

          function getPrecentage(upowerPrecentage) {
            return `${Math.round((upowerPrecentage + Number.EPSILON) * 100)}%`
          }

          color: root.textColor
          text: {
            switch (device.type) {
              case 2: return `Battery:${getPrecentage(device.percentage)}`
              default: return `${device.model}:${getPrecentage(device.percentage)}`
            }
          }


       }
      }
    }
  }
}
