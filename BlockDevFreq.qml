import QtQuick 2.11
import QtQuick.Extras 1.4

import rdss.device 1.0
import rdss.alert 1.0

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
            onClicked: mouseClick()
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
            onClicked: mouseClick()
        }

        RectDevFreq {
            devFreq: devFreqMaster
            devIsMaster: true
        }

        Timer {
            property string colorValue: Alert.MAP_COLOR["OTHERS"]

            id: masterTimer
            interval: Alert.timeout * 1000
            running: true
            repeat: true

            Component.onCompleted: devFreqMaster.gotData.connect(function() {
                if (!devFreqMaster.timedout()) colorValue = Alert.MAP_COLOR["NORMAL"]
                if (objWinFreq.devFreqMaster === devFreqMaster)
                    objWinFreq.masterCommunicationColorValue = colorValue
                restart()
            });
            onTriggered: {
                colorValue = devFreqMaster.timedout() ? Alert.MAP_COLOR["ABNORMAL"] : Alert.MAP_COLOR["NORMAL"]
                if (objWinFreq.devFreqMaster === devFreqMaster)
                    objWinFreq.masterCommunicationColorValue = colorValue
            }
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
            onClicked: mouseClick()
        }

        RectDevFreq {
            devFreq: devFreqSlave
            devIsMaster: false
        }

        Timer {
            property string colorValue: Alert.MAP_COLOR["OTHERS"]

            id: slaveTimer
            interval: Alert.timeout * 1000
            running: true
            repeat: true

            Component.onCompleted: devFreqSlave.gotData.connect(function() {
                if (!devFreqSlave.timedout()) colorValue = Alert.MAP_COLOR["NORMAL"]
                if (objWinFreq.devFreqSlave === devFreqSlave)
                    objWinFreq.slaveCommunicationColorValue = colorValue
                restart()
            });
            onTriggered: {
                colorValue = devFreqSlave.timedout() ? Alert.MAP_COLOR["ABNORMAL"] : Alert.MAP_COLOR["NORMAL"]
                if (objWinFreq.devFreqSlave === devFreqSlave)
                    objWinFreq.slaveCommunicationColorValue = colorValue
            }
        }
    }

    function mouseClick() {
        objWinFreq.setVisible(true)
        objWinFreq.opened(devFreqMaster, devFreqSlave, devFreqUp)
        objWinFreq.masterCommunicationColorValue = masterTimer.colorValue
        objWinFreq.slaveCommunicationColorValue = slaveTimer.colorValue
    }
}
