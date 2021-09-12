import QtQuick 2.9
import QtQuick.Controls 1.6

Item {
    id: blockComboCombo
    property int posLeft : 0
    property int posTop : 0
    property int posRight : combo.x + combo.width
    property int posBottom : combo.y + combo.height
    property string txtText

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

    ComboBox {
        id: combo
        anchors.left: text.right
        anchors.leftMargin: marginWidget
        y: posTop + marginWidget
        height: heightWidget
        width: widthWidget
        currentIndex: 1
    }
}
