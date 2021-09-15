import QtQuick 2.11

Item {
    id: blockComboText
    property int posLeft : 0
    property int posTop : 0
    property int posRight : rect.x + rect.width
    property int posBottom : rect.y + rect.height
    property alias txtText : text.text
    property alias txtValue : value.text
    property alias colorValue : value.color

    Text {
        id: text
        x: posLeft + marginWidget
        y: posTop + marginWidget
        height: heightWidget
        width: widthWidgetLabel
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: defaultLabelFontSize
    }

    Rectangle {
        id: rect
        anchors.left: text.right
        anchors.leftMargin: marginWidget
        y: posTop + marginWidget
        height: heightWidget
        width: widthWidget
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
            font.pixelSize: defaultLabelFontSize
        }
    }
}
