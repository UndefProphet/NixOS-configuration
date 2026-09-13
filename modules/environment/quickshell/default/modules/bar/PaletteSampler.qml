import QtQuick
import QtQuick.Layouts

Item {
  id: root

  SystemPalette {
    id: sysPalette
  }
  SystemPalette {
    id: sysPaletteInactive
    colorGroup: SystemPalette.Inactive
  }
  SystemPalette {
    id: sysPaletteDisabled
    colorGroup: SystemPalette.Disabled
  }

  property int squareSizes: 10
  property int widgetWidth: 100

  implicitWidth: backgroundRect.width
  implicitHeight: backgroundRect.height

  Rectangle {
    id: backgroundRect
    implicitWidth: colorColumn.width
    implicitHeight: colorColumn.height
    ColumnLayout {
      id: colorColumn
      RowLayout {
        id: colorLayoutActive
        Rectangle { implicitWidth: root.squareSizes; height: root.squareSizes; color: sysPalette.accent }
        Rectangle { implicitWidth: root.squareSizes; height: root.squareSizes; color: sysPalette.alternateBase }
        Rectangle { implicitWidth: root.squareSizes; height: root.squareSizes; color: sysPalette.base }
        Rectangle { implicitWidth: root.squareSizes; height: root.squareSizes; color: sysPalette.button }
        Rectangle { implicitWidth: root.squareSizes; height: root.squareSizes; color: sysPalette.buttonText }
        Rectangle { implicitWidth: root.squareSizes; height: root.squareSizes; color: sysPalette.dark }
        Rectangle { implicitWidth: root.squareSizes; height: root.squareSizes; color: sysPalette.highlight }
        Rectangle { implicitWidth: root.squareSizes; height: root.squareSizes; color: sysPalette.highlightedText }
        Rectangle { implicitWidth: root.squareSizes; height: root.squareSizes; color: sysPalette.light }
        Rectangle { implicitWidth: root.squareSizes; height: root.squareSizes; color: sysPalette.mid }
        Rectangle { implicitWidth: root.squareSizes; height: root.squareSizes; color: sysPalette.midlight }
        Rectangle { implicitWidth: root.squareSizes; height: root.squareSizes; color: sysPalette.placeholderText }
        Rectangle { implicitWidth: root.squareSizes; height: root.squareSizes; color: sysPalette.shadow }
        Rectangle { implicitWidth: root.squareSizes; height: root.squareSizes; color: sysPalette.text }
        Rectangle { implicitWidth: root.squareSizes; height: root.squareSizes; color: sysPalette.window }
        Rectangle { implicitWidth: root.squareSizes; height: root.squareSizes; color: sysPalette.windowText }
      }

      RowLayout {
        id: colorLayoutInactive
        Rectangle { width: root.squareSizes; height: root.squareSizes; color: sysPaletteInactive.accent }
        Rectangle { width: root.squareSizes; height: root.squareSizes; color: sysPaletteInactive.alternateBase }
        Rectangle { width: root.squareSizes; height: root.squareSizes; color: sysPaletteInactive.base }
        Rectangle { width: root.squareSizes; height: root.squareSizes; color: sysPaletteInactive.button }
        Rectangle { width: root.squareSizes; height: root.squareSizes; color: sysPaletteInactive.buttonText }
        Rectangle { width: root.squareSizes; height: root.squareSizes; color: sysPaletteInactive.dark }
        Rectangle { width: root.squareSizes; height: root.squareSizes; color: sysPaletteInactive.highlight }
        Rectangle { width: root.squareSizes; height: root.squareSizes; color: sysPaletteInactive.highlightedText }
        Rectangle { width: root.squareSizes; height: root.squareSizes; color: sysPaletteInactive.light }
        Rectangle { width: root.squareSizes; height: root.squareSizes; color: sysPaletteInactive.mid }
        Rectangle { width: root.squareSizes; height: root.squareSizes; color: sysPaletteInactive.midlight }
        Rectangle { width: root.squareSizes; height: root.squareSizes; color: sysPaletteInactive.placeholderText }
        Rectangle { width: root.squareSizes; height: root.squareSizes; color: sysPaletteInactive.shadow }
        Rectangle { width: root.squareSizes; height: root.squareSizes; color: sysPaletteInactive.text }
        Rectangle { width: root.squareSizes; height: root.squareSizes; color: sysPaletteInactive.window }
        Rectangle { width: root.squareSizes; height: root.squareSizes; color: sysPaletteInactive.windowText }
      }

      RowLayout {
        id: colorLayoutDisabled
        Rectangle { width: root.squareSizes; height: root.squareSizes; color: sysPaletteDisabled.accent }
        Rectangle { width: root.squareSizes; height: root.squareSizes; color: sysPaletteDisabled.alternateBase }
        Rectangle { width: root.squareSizes; height: root.squareSizes; color: sysPaletteDisabled.base }
        Rectangle { width: root.squareSizes; height: root.squareSizes; color: sysPaletteDisabled.button }
        Rectangle { width: root.squareSizes; height: root.squareSizes; color: sysPaletteDisabled.buttonText }
        Rectangle { width: root.squareSizes; height: root.squareSizes; color: sysPaletteDisabled.dark }
        Rectangle { width: root.squareSizes; height: root.squareSizes; color: sysPaletteDisabled.highlight }
        Rectangle { width: root.squareSizes; height: root.squareSizes; color: sysPaletteDisabled.highlightedText }
        Rectangle { width: root.squareSizes; height: root.squareSizes; color: sysPaletteDisabled.light }
        Rectangle { width: root.squareSizes; height: root.squareSizes; color: sysPaletteDisabled.mid }
        Rectangle { width: root.squareSizes; height: root.squareSizes; color: sysPaletteDisabled.midlight }
        Rectangle { width: root.squareSizes; height: root.squareSizes; color: sysPaletteDisabled.placeholderText }
        Rectangle { width: root.squareSizes; height: root.squareSizes; color: sysPaletteDisabled.shadow }
        Rectangle { width: root.squareSizes; height: root.squareSizes; color: sysPaletteDisabled.text }
        Rectangle { width: root.squareSizes; height: root.squareSizes; color: sysPaletteDisabled.window }
        Rectangle { width: root.squareSizes; height: root.squareSizes; color: sysPaletteDisabled.windowText }
      }
    }
  } 
}
