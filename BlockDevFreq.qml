import QtQuick 2.15
import QtQuick.Extras 1.4

import rdss.device 1.0
import rdss.alert 1.0

Item {
    id: blockDevFreq
    property int posLeft : 0
    property int posTop : 0
    property int posRight : rectDev.x + rectDev.width
    property int posBottom : rectDev.y + rectDev.height
    property bool devFreqUp: false

    DevFreq {
        id: devFreqMaster
        isSlave: false
    }
    DevFreq {
        id: devFreqSlave
        isSlave: true
    }
    property alias masterId : devFreqMaster.dId
    property alias slaveId : devFreqSlave.dId

    Rectangle {
        id: rectDev
        x: posLeft
        y: posTop
        width: singleBoxWidth
        height: doubleBoxHeight
        border.width: defaultBorderWidth

        Rectangle {
            x: 0
            y: 0
            width: 50
            height: doubleBoxHeight
            border.width: defaultBorderWidth
            Text {
                id: txtId
                anchors.fill: parent
                anchors.margins: 2
                text: devFreqMaster.name
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                wrapMode: Text.WrapAnywhere
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: defaultLabelFontSize
            }
        }

        StatusIndicator {
            id: masterInd
            anchors.right: rectDev.right
            anchors.rightMargin: marginIndicators
            anchors.top: rectDev.top
            anchors.topMargin: marginIndicators
            active: false

            Component.onCompleted: devFreqMaster.gotData.connect(function() {
                active = true
                color = devFreqMaster.showIndicatorColor()
            })
        }

        StatusIndicator {
            id: slaveInd
            anchors.right: rectDev.right
            anchors.rightMargin: marginIndicators
            anchors.top: masterInd.bottom
            anchors.topMargin: marginIndicators
            active: false

            Component.onCompleted: devFreqSlave.gotData.connect(function() {
                active = true
                color = devFreqSlave.showIndicatorColor()
            })
        }

        MouseArea {
            id: mouse
            anchors.fill: parent
            onClicked: mouseClick()
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
                if (devFreqMaster.timedout()) {
                    devFreqMaster.alertTimeout()
                    if (masterInd.active)
                        masterInd.color = Alert.MAP_COLOR["ABNORMAL"]
                }
            }
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
                if (devFreqSlave.timedout()) {
                    devFreqSlave.alertTimeout()
                    if (slaveInd.active)
                        slaveInd.color = Alert.MAP_COLOR["ABNORMAL"]
                }
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
