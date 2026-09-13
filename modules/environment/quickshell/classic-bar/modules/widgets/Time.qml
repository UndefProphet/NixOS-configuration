import Quickshell
import QtQuick

Text {
  id: root
  SystemPalette { id: palette }

  property string timeFormat: "dddd, MMMM dd hh:mm"

  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }

  text: `${Qt.formatDateTime(clock.date, timeFormat)}`
  color: palette.text
}
