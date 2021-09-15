import QtQuick 2.9
import QtQuick.Extras 1.4

import rdss.device 1.0

Item {
    id: blockDevFreq
    property int posLeft : 0
    property int posTop : 0
    property int posRight : devMaster.x + devMaster.width
    property int posBottom : devSlave.y + devSlave.height
    property bool devFreqUp: false

    DevFreq {
        id: devFreqMaster
    }
    DevFreq {
        id: devFreqSlave
    }
    property alias masterId : devFreqMaster.dId
    property alias slaveId : devFreqSlave.dId

    Text {
        id: txtId
        anchors.top: devMaster.top
        anchors.right: devMaster.left
        width: defaultMarginAndTextWidthHeight
        height: 2 * rackFreqBoxFreqHeight
        text: devFreqMaster.name
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        wrapMode: Text.WrapAnywhere
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: defaultLabelFontSize

        MouseArea {
            id: mouseId
            anchors.fill: parent
            onClicked: {
                objWinFreq.setVisible(true)
                objWinFreq.opened(devFreqMaster, devFreqSlave, devFreqUp)
            }
        }
    }

    Rectangle {
        id: devMaster
        x: posLeft + 2 * defaultMarginAndTextWidthHeight
        y: posTop + defaultMarginAndTextWidthHeight
        width: rackFreqBoxWidth
        height: rackFreqBoxFreqHeight
        border.width: defaultBorderWidth

        MouseArea {
            id: mouseMaster
            anchors.fill: parent
            onClicked: {
                objWinFreq.setVisible(true)
                objWinFreq.opened(devFreqMaster, devFreqSlave, devFreqUp)
            }
        }

        RectDevFreq {
            devFreq: devFreqMaster
            devIsMaster: true
        }
    }

    Rectangle {
        id: devSlave
        anchors.left: devMaster.left
        anchors.top: devMaster.bottom
        anchors.topMargin: -defaultBorderWidth
        width: rackFreqBoxWidth
        height: rackFreqBoxFreqHeight
        border.width: defaultBorderWidth

        MouseArea {
            id: mouseSlave
            anchors.fill: parent
            onClicked: {
                objWinFreq.setVisible(true)
                objWinFreq.opened(devFreqMaster, devFreqSlave, devFreqUp)
            }
        }

        RectDevFreq {
            devFreq: devFreqSlave
            devIsMaster: false
        }
    }
}
