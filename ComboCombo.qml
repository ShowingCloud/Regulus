import QtQuick 2.11
import QtQuick.Controls 2.4
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
    property alias index : combo.currentIndex

    signal hold()
    signal updated(int index)
    signal changedIndex(int index)
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
        font.pixelSize: defaultLabelFontSize
        currentIndex: 1

        contentItem: Text {
            text: combo.displayText
            font: combo.font
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight
            color: colorValue
        }

        delegate: ItemDelegate {
            width: combo.width
            contentItem: Text {
                text: modelData
                font: combo.font
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
                color: colorValue
            }
            highlighted: combo.highlightedIndex === index
        }

        onActiveFocusChanged: {
            if (activeFocus) {
                blockComboCombo.hold()
            } else {
                blockComboCombo.updated(currentIndex)
            }
        }

        onCurrentIndexChanged: {
            blockComboCombo.changedIndex(currentIndex)
        }
    }

    onSubmit: blockComboCombo.updated(combo.currentIndex)
}
