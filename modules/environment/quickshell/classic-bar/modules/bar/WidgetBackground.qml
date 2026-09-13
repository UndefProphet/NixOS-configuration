import QtQuick.Controls
import Quickshell
import QtQuick
import QtQuick.Layouts


Rectangle {
  id: root
  SystemPalette { id: palette }
  QtObject {
    id: _padding;
    property int vertical: 5;
    property int horizontal: vertical * 3;
  }

  default property alias content: container.data
  property alias padding: _padding
  color: palette.base.alpha(0.75)

  radius: 0 //Global.rounding

  implicitWidth: container.width + (content.length ? padding.horizontal : 0)
  implicitHeight: container.height + (content.length ? padding.vertical : 0)

  RowLayout {
    id: container
    anchors.centerIn: parent
  }
}
