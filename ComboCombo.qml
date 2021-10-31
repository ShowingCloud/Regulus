import QtQuick 2.15
import QtQuick.Controls 2.15
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
    property alias index : combo.currentIndex

    Text {
        id: text
        x: posLeft + defaultMarginWidget
        y: posTop + defaultMarginWidget
        height: defaultHeightWidget
        width: defaultWidthWidgetLabel
        text: txtText
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: defaultLabelFontSize
    }

    ComboBox {
        id: combo
        anchors.left: text.right
        anchors.leftMargin: defaultMarginWidget
        y: posTop + defaultMarginWidget
        height: defaultHeightWidget
        width: defaultWidthWidget
        font.pixelSize: defaultLabelFontSize
        currentIndex: 1

        contentItem: Text {
            text: combo.displayText
            font: combo.font
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight
        }

        delegate: ItemDelegate {
            width: combo.width
            contentItem: Text {
                text: modelData
                font: combo.font
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
            }
            highlighted: combo.highlightedIndex === index
        }
    }
}
