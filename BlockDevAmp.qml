import QtQuick 2.15
import QtQuick.Extras 1.4

import rdss.device 1.0
import rdss.alert 1.0

Item {
    id: blockDevAmp
    property int posLeft : 0
    property int posTop : 0
    property int posRight : rectDev.x + rectDev.width
    property int posBottom: rectDev.y + rectDev.height

    DevAmp {
        id: devAmpMaster
        isSlave: false
    }
    DevAmp {
        id: devAmpSlave
        isSlave: true
    }
    property alias masterId : devAmpMaster.dId
    property alias slaveId : devAmpSlave.dId

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
                text: devAmpMaster.name
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                wrapMode: Text.WrapAnywhere
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: defaultLabelFontSize
            }
        }

        Text {
            id: txtMasterInputPower
            x: 60
            anchors.top: masterInd.top
            width: 90
            height: masterInd.height
            text: devAmpMaster.showDisplay("input_power") + "dBm"
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignLeft
            font.pixelSize: rectBigFontSize

            Component.onCompleted: {
                devAmpMaster.gotData.connect(function() {
                    text = devAmpMaster.showDisplay("input_power") + "dBm"
                    color = devAmpMaster.showColor("input_power", false)
                })
            }
        }

        Text {
            id: txtMasterOutputPower
            anchors.left: txtMasterInputPower.right
            anchors.top: masterInd.top
            width: 90
            height: masterInd.height
            text: devAmpMaster.showDisplay("output_power") + "dBm"
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignLeft
            font.pixelSize: rectBigFontSize

            Component.onCompleted: {
                devAmpMaster.gotData.connect(function() {
                    text = devAmpMaster.showDisplay("output_power") + "dBm"
                    color = devAmpMaster.showColor("output_power", false)
                })
            }
        }

        Text {
            id: txtSlaveInputPower
            x: 60
            anchors.top: slaveInd.top
            width: 90
            height: slaveInd.height
            text: devAmpSlave.showDisplay("input_power") + "dBm"
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignLeft
            font.pixelSize: rectBigFontSize

            Component.onCompleted: {
                devAmpSlave.gotData.connect(function() {
                    text = devAmpSlave.showDisplay("input_power") + "dBm"
                    color = devAmpSlave.showColor("input_power", false)
                })
            }
        }

        Text {
            id: txtSlaveOutputPower
            anchors.left: txtSlaveInputPower.right
            anchors.top: slaveInd.top
            width: 90
            height: slaveInd.height
            text: devAmpSlave.showDisplay("output_power") + "dBm"
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignLeft
            font.pixelSize: rectBigFontSize

            Component.onCompleted: {
                devAmpSlave.gotData.connect(function() {
                    text = devAmpSlave.showDisplay("output_power") + "dBm"
                    color = devAmpSlave.showColor("output_power", false)
                })
            }
        }

        StatusIndicator {
            id: masterInd
            anchors.right: rectDev.right
            anchors.rightMargin: marginIndicators
            anchors.top: rectDev.top
            anchors.topMargin: marginIndicators
            active: false

            Component.onCompleted: devAmpMaster.gotData.connect(function() {
                active = true
                color = devAmpMaster.showIndicatorColor()
            })
        }

        StatusIndicator {
            id: slaveInd
            anchors.right: rectDev.right
            anchors.rightMargin: marginIndicators
            anchors.top: masterInd.bottom
            anchors.topMargin: marginIndicators
            active: false

            Component.onCompleted: devAmpSlave.gotData.connect(function() {
                active = true
                color = devAmpSlave.showIndicatorColor()
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
                if (devAmpMaster.timedout()) {
                    devAmpMaster.alertTimeout()
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
                if (devAmpSlave.timedout()) {
                    devAmpSlave.alertTimeout()
                    if (slaveInd.active)
                        slaveInd.color = Alert.MAP_COLOR["ABNORMAL"]
                }
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
