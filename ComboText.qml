import QtQuick 2.15

Item {
    id: blockComboText
    property int posLeft : 0
    property int posTop : 0
    property int posRight : rect.x + rect.width
    property int posBottom : rect.y + rect.height
    property alias txtText : text.text
    property alias txtValue : value.text
    property alias colorValue : value.color
    property int fontSize : defaultLabelFontSize

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

        Text {
            id: value
            x: 0
            y: 0
            height: rect.height
            width: rect.width
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: fontSize
        }
    }
}
