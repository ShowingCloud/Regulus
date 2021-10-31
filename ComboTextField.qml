import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: blockComboTextField
    property int posLeft : 0
    property int posTop : 0
    property int posRight : rect.x + rect.width
    property int posBottom : rect.y + rect.height
    property int widthWidget : defaultWidthWidget
    property int widthWidgetLabel : defaultWidthWidgetLabel
    property int widthPrefixSuffix : 0
    property alias txtText : text.text
    property alias txtValue : value.text
    property alias txtPrefix : prefix.text
    property alias txtSuffix : suffix.text

    Text {
        id: text
        x: posLeft + defaultMarginWidget
        y: posTop + defaultMarginWidget
        height: defaultHeightWidget
        width: widthWidgetLabel
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
        width: widthWidget

        Text {
            id: prefix
            x: 0
            y: 0
            height: rect.height
            width: widthPrefixSuffix
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: defaultLabelFontSize
        }

        TextField {
            id: value
            x: 0
            anchors.left: prefix.right
            height: rect.height
            width: rect.width
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: defaultLabelFontSize
            padding: 3 // seems good but not with the default 6
        }

        Text {
            id: suffix
            x: 0
            anchors.left: value.right
            height: rect.height
            width: widthPrefixSuffix
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: defaultLabelFontSize
        }
    }
}
