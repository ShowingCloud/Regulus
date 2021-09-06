import QtQuick 2.9
import QtQuick.Extras 1.4

import rdss.device 1.0

Item {
    id: blockDevDist
    property int posLeft : 0
    property int posTop : 0
    property int posRight : dev.x + dev.width
    property int posBottom: dev.y + dev.height

    DevDist {
        id: devDist
    }
    property alias deviceId : devDist.dId

    Text {
        id: txtId
        anchors.top: dev.top
        anchors.topMargin: -10
        anchors.right: dev.left
        width: defaultMarginAndTextWidthHeight
        height: 2 * rackFreqBoxHeight + 20
        text: devDist.name
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        wrapMode: Text.WrapAnywhere
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: defaultLabelFontSize

        MouseArea {
            id: mouseId
            anchors.fill: parent
            onClicked: {
                objWinDist.setVisible(true);
            }
        }
    }

    Rectangle {
        id: dev
        x: posLeft + 2 * defaultMarginAndTextWidthHeight
        y: posTop + defaultMarginAndTextWidthHeight
        width: rackFreqBoxWidth
        height: 2 * rackFreqBoxHeight
        StatusIndicator {
            id: ind
            x: marginIndicators
            y: marginIndicators
        }
        border.width: defaultBorderWidth

        MouseArea {
            id: mouseDev
            anchors.fill: parent
            onClicked: {
                objWinDist.setVisible(true);
            }
        }
    }
}