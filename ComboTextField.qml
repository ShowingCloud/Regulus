import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: blockComboTextField
    property int posLeft : 0
    property int posTop : 0
    property int posRight : rect.x + rect.width
    property int posBottom : rect.y + rect.height
    property alias txtText : text.text
    property alias txtValue : value.text

    Text {
        id: text
        x: posLeft + defaultMarginWidget
        y: posTop + defaultMarginWidget
        height: defaultHeightWidget
        width: defaultWidthWidgetLabel
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: defaultLabelFontSize
    }

    Rectangle {
        id: rect
        anchors.left: text.right
        anchors.leftMargin: defaultMarginWidget
        y: posTop + defaultMarginWidget
        height: defaultHeightWidget
        width: defaultWidthWidget
        border.width: defaultBorderWidth

        TextField {
            id: value
            x: 0
            y: 0
            height: rect.height
            width: rect.width
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: defaultLabelFontSize
            padding: 3 // seems good but not with the default 6
        }
    }
}
