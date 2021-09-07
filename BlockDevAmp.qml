import QtQuick 2.9
import QtQuick.Extras 1.4

import rdss.device 1.0

Item {
    id: blockDevAmp
    property int posLeft : 0
    property int posTop : 0
    property int posRight : devMaster.x + devMaster.width
    property int posBottom: devSlave.y + devSlave.height

    DevAmp {
        id: devAmpMaster
    }
    DevAmp {
        id: devAmpSlave
    }
    property alias masterId : devAmpMaster.dId
    property alias slaveId : devAmpSlave.dId

    Text {
        id: txtId
        anchors.top: devMaster.top
        anchors.right: devMaster.left
        width: defaultMarginAndTextWidthHeight
        height: 2 * rackAmpBoxHeight
        text: devAmpMaster.name
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        wrapMode: Text.WrapAnywhere
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: defaultLabelFontSize

        MouseArea {
            id: mouseId
            anchors.fill: parent
            onClicked: {
                objWinAmp.setVisible(true);
            }
        }
    }

    Rectangle {
        id: devMaster
        x: posLeft + 2 * defaultMarginAndTextWidthHeight
        y: posTop + defaultMarginAndTextWidthHeight
        width: rackAmpBoxWidth
        height: rackAmpBoxHeight
        StatusIndicator {
            id: indMaster
            x: marginIndicators
            y: marginIndicators
        }
        border.width: defaultBorderWidth

        MouseArea {
            id: mouseMaster
            anchors.fill: parent
            onClicked: {
                objWinAmp.setVisible(true);
            }
        }
    }

    Rectangle {
        id: devSlave
        anchors.left: devMaster.left
        anchors.top: devMaster.bottom
        anchors.topMargin: -defaultBorderWidth
        width: rackAmpBoxWidth
        height: rackAmpBoxHeight
        StatusIndicator {
            id: indSlave
            x: marginIndicators
            y: marginIndicators
        }
        border.width: defaultBorderWidth

        MouseArea {
            id: mouseSlave
            anchors.fill: parent
            onClicked: {
                objWinAmp.setVisible(true);
            }
        }
    }

    Text {
        id: txtMasterStr
        anchors.top: devMaster.top
        anchors.left: devMaster.left
        height: defaultMarginAndTextWidthHeight
        width: 2 * rackAmpBoxWidth
        text: devAmpMaster.str
    }

    Text {
        id: txtSlaveStr
        anchors.top: devSlave.top
        anchors.left: devSlave.left
        height: defaultMarginAndTextWidthHeight
        width: 2 * rackAmpBoxWidth
        text: devAmpSlave.str
    }
}
