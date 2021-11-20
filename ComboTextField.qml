import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: blockComboTextField
    property int posLeft : 0
    property int posTop : 0
    property int posRight : suffix.x + suffix.width
    property int posBottom : suffix.y + suffix.height
    property int widthWidget : defaultWidthWidget
    property int widthWidgetLabel : defaultWidthWidgetLabel
    property int widthPrefixSuffix : 0
    property alias txtText : text.text
    property alias txtValue : value.text
    property alias txtPrefix : prefix.text
    property alias txtSuffix : suffix.text
    property double upperLimit : 1000
    property double lowerLimit : 0

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

    Text {
        id: prefix
        anchors.left: text.right
        anchors.leftMargin: defaultMarginWidget
        y: posTop + defaultMarginWidget
        height: defaultHeightWidget
        width: widthPrefixSuffix
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: defaultLabelFontSize
    }

    TextField {
        id: value
        anchors.left: prefix.right
        y: posTop + defaultMarginWidget
        height: defaultHeightWidget
        width: widthWidget
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: defaultLabelFontSize
        padding: 3 // seems good but not with the default 6
        selectByMouse: true

        onActiveFocusChanged: {
            if (parseFloat(value.text) > upperLimit || parseFloat(value.text) < lowerLimit)
                color = "red"
            else
                color = "black"
        }
    }

    Text {
        id: suffix
        anchors.left: value.right
        y: posTop + defaultMarginWidget
        height: defaultHeightWidget
        width: widthPrefixSuffix
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: defaultLabelFontSize
    }
}
