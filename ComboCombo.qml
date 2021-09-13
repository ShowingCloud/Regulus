import QtQuick 2.9
import QtQuick.Controls 1.6

import rdss.alert 1.0

Item {
    id: blockComboCombo
    property int posLeft : 0
    property int posTop : 0
    property int posRight : combo.x + combo.width
    property int posBottom : combo.y + combo.height
    property alias txtText : text.text
    property alias comboModel : combo.model

    signal updated(int index)

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

        onCurrentIndexChanged: blockComboCombo.updated(currentIndex)
    }
}