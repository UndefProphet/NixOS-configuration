import Quickshell // for PanelWindow
import QtQuick // for Text
import QtQuick.Layouts // for RowLayout

Rectangle {
  id: root
  property alias leftSide: leftContainer.data
  property alias middle: middleContainer.data
  property alias rightSide: rightContainer.data

  property alias padding: _padding
  QtObject {
    id: _padding;
    property int right: 10;
    property int left: 10;
  }

  color: "transparent"
  anchors.fill: parent

  RowLayout {
    id: middleContainer
    anchors.centerIn: parent
  }

  RowLayout {
    id: rightContainer
    anchors {
      right: parent.right
      verticalCenter: parent.verticalCenter
      rightMargin: root.padding.right
    }
  }

  RowLayout {
    id: leftContainer
    anchors {
      left: parent.left
      verticalCenter: parent.verticalCenter
      leftMargin: root.padding.left
    }
  }

}

