import QtQuick 2.11
import QtQuick.Extras 1.4

import rdss.device 1.0
import rdss.alert 1.0

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
            onClicked: mouseClick()
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
            onClicked: mouseClick()
        }

        RectDevAmp {
            id: rectMaster
            devAmp: devAmpMaster
            devIsMaster: true
        }

        Timer {
            property string colorValue: Alert.MAP_COLOR["OTHERS"]

            id: masterTimer
            interval: Alert.timeout * 1000
            running: true
            repeat: true

            Component.onCompleted: devAmpMaster.gotData.connect(function() {
                if (!devAmpMaster.timedout()) colorValue = Alert.MAP_COLOR["NORMAL"]
                if (objWinAmp.devAmpMaster === devAmpMaster)
                    objWinAmp.masterCommunicationColorValue = colorValue
                restart()
            });
            onTriggered: {
                colorValue = devAmpMaster.timedout() ? Alert.MAP_COLOR["ABNORMAL"] : Alert.MAP_COLOR["NORMAL"]
                if (objWinAmp.devAmpMaster === devAmpMaster)
                    objWinAmp.masterCommunicationColorValue = colorValue
                if (rectMaster.ind.active)
                    rectMaster.ind.color = colorValue
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
            onClicked: mouseClick()
        }

        RectDevAmp {
            id: rectSlave
            devAmp: devAmpSlave
            devIsMaster: false
        }

        Timer {
            property string colorValue: Alert.MAP_COLOR["OTHERS"]

            id: slaveTimer
            interval: Alert.timeout * 1000
            running: true
            repeat: true

            Component.onCompleted: devAmpSlave.gotData.connect(function() {
                if (!devAmpSlave.timedout()) colorValue = Alert.MAP_COLOR["NORMAL"]
                if (objWinAmp.devAmpSlave === devAmpSlave)
                    objWinAmp.slaveCommunicationColorValue = colorValue
                restart()
            });
            onTriggered: {
                colorValue = devAmpSlave.timedout() ? Alert.MAP_COLOR["ABNORMAL"] : Alert.MAP_COLOR["NORMAL"]
                if (objWinAmp.devAmpSlave === devAmpSlave)
                    objWinAmp.slaveCommunicationColorValue = colorValue
                if (rectSlave.ind.active)
                    rectSlave.ind.color = colorValue
            }
        }
    }

    function mouseClick() {
        objWinAmp.setVisible(true);
        objWinAmp.opened(devAmpMaster, devAmpSlave)
        objWinAmp.masterCommunicationColorValue = masterTimer.colorValue
        objWinAmp.slaveCommunicationColorValue = slaveTimer.colorValue
    }
}
