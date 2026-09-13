import QtQuick

Item {
  id: root
  property color widgetBackround
  property color textColor: "white"
  implicitWidth: widgetRectangle.width
  implicitHeight: widgetRectangle.height

  Rectangle {
    id: widgetRectangle
    color: "transparent"
    anchors {
        verticalCenter: parent.verticalCenter
        horizontalCenter: parent.horizontalCenter
    }
    implicitHeight: languageText.height
    implicitWidth: languageText.width

    Text {
      id: languageText
      text: `[Lang:]`
    }
  }
}
