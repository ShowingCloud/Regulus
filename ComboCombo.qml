import QtQuick 2.9
import QtQuick.Controls 1.6
import QtQuick.Controls.Styles 1.4

import rdss.alert 1.0

Item {
    id: blockComboCombo
    property int posLeft : 0
    property int posTop : 0
    property int posRight : combo.x + combo.width
    property int posBottom : combo.y + combo.height
    property alias txtText : text.text
    property alias comboModel : combo.model
    property string colorValue : "black"

    signal hold()
    signal updated(int index)
    signal indexChanged(int index)
    signal submit()

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
        activeFocusOnPress: true
        currentIndex: 1

        style: ComboBoxStyle {
            textColor: colorValue
        }

        onActiveFocusChanged: {
            if (activeFocus) {
                blockComboCombo.hold()
            } else {
                blockComboCombo.updated(currentIndex)
            }
        }

        onCurrentIndexChanged: {
            blockComboCombo.indexChanged(currentIndex)
        }
    }

    onSubmit: blockComboCombo.updated(combo.currentIndex)
}
