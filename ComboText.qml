import QtQuick 2.9

Item {
    id: blockComboText
    property int posLeft : 0
    property int posTop : 0
    property int posRight : rect.x + rect.width
    property int posBottom : rect.y + rect.height
    property string txtText
    property string txtValue

    Text {
        id: text
        x: posLeft + marginWidget
        y: posTop + marginWidget
        height: heightWidget
        width: widthWidgetLabel
        text: txtText
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
            text: txtValue
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: defaultLabelFontSize
        }
    }
}
