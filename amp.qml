import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.3
import QtQuick.Window 2.15

import rdss.alert 1.0

Window {
    property alias masterCommunicationColorValue: comboMasterCommunication.colorValue
    property alias slaveCommunicationColorValue: comboSlaveCommunication.colorValue

    id: winAmp
    visible: false
    modality: Qt.ApplicationModal
    width: rectMaster.width + 2 * defaultMarginRect
    height: 2 * rectMaster.height + defaultHeightWidget + 3 * defaultMarginRect + defaultMarginWidget
    title: qsTr("Amplification Device")

    property QtObject devAmpMaster: null
    property QtObject devAmpSlave: null
    signal opened(QtObject devMaster, QtObject devSlave)
    signal masterRefreshData()
    signal slaveRefreshData()

    Component.onCompleted: {
        winAmp.opened.connect(function(devMaster, devSlave) {
            devAmpMaster = devMaster
            devAmpSlave = devSlave
            name.text = devAmpMaster.name
            devMaster.gotData.connect(masterRefreshData)
            devSlave.gotData.connect(slaveRefreshData)
            masterRefreshData()
            slaveRefreshData()
        })
    }

    onClosing: {
        close.accepted = false
        this.hide()
        devAmpMaster.gotData.disconnect(masterRefreshData)
        devAmpSlave.gotData.disconnect(slaveRefreshData)
        name.text = ""
        devAmpMaster = null
        devAmpSlave = null
    }

    Text {
        id: name
        x: defaultMarginRect + defaultMarginWidget
        y: defaultMarginRect
        height: defaultHeightWidget
        width: 2 * defaultWidthWidget
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: defaultLabelFontSize
    }

    ComboText {
        id: comboChannel
        posLeft: defaultMarginRect + rectMaster.width - defaultWidthWidget - defaultWidthWidgetLabel - 3 * defaultMarginWidget
        posTop: defaultMarginRect - defaultMarginWidget
        txtText: devAmpMaster ? devAmpMaster.varName("masterslave") : qsTr("Current State")

        Component.onCompleted: {
            //comboModel = Alert.addEnum("P_MS")
            /*
            masterRefreshData.connect(function() {
                index = devAmpMaster.getValue("masterslave")
                colorValue = devAmpMaster.showColor("masterslave")
            })
            */
        }
    }

    Rectangle {
        id: rectMaster
        x: defaultMarginRect
        anchors.top: name.bottom
        anchors.topMargin: defaultMarginWidget
        width: 4 * defaultWidthWidget + 4 * defaultWidthWidgetLabel + 9 * defaultMarginWidget
        height: 4 * defaultHeightWidget + 5 * defaultMarginWidget
        border.width: defaultBorderWidth

        ComboText {
            id: comboMasterAtten
            posTop: 0
            posLeft: 0
            txtText: devAmpMaster ? devAmpMaster.varName("atten") : qsTr("Attenuation")

            Component.onCompleted: {
                masterRefreshData.connect(function() {
                    txtValue = devAmpMaster.showDisplay("atten") + " dB"
                    colorValue = devAmpMaster.showColor("atten")
                })
            }
        }

        ComboText {
            id: comboMasterPower
            posTop: 0
            posLeft: (rectMaster.width - defaultMarginWidget) / 4
            txtText: devAmpMaster ? devAmpMaster.varName("power") : qsTr("Power")

            Component.onCompleted: {
                masterRefreshData.connect(function() {
                    txtValue = devAmpMaster.showDisplay("power") + " mW"
                    colorValue = devAmpMaster.showColor("power")
                })
            }
        }

        ComboText {
            id: comboMasterGain
            posTop: 0
            posLeft: (rectMaster.width - defaultMarginWidget) / 2
            txtText: devAmpMaster ? devAmpMaster.varName("gain") : qsTr("Gain")

            Component.onCompleted: {
                masterRefreshData.connect(function() {
                    txtValue = devAmpMaster.showDisplay("gain") + " dB"
                    colorValue = devAmpMaster.showColor("gain")
                })
            }
        }

        ComboText {
            id: comboMasterLoss
            posTop: comboMasterAtten.posBottom
            posLeft: 0
            txtText: devAmpMaster ? devAmpMaster.varName("loss") : qsTr("Return Loss")

            Component.onCompleted: {
                masterRefreshData.connect(function() {
                    txtValue = "-" + devAmpMaster.showDisplay("loss") + " dB"
                    colorValue = devAmpMaster.showColor("loss")
                })
            }
        }

        ComboText {
            id: comboMasterAmpTemp
            posTop: comboMasterAtten.posBottom
            posLeft: (rectMaster.width - defaultMarginWidget) / 4
            txtText: devAmpMaster ? devAmpMaster.varName("amp_temp") : qsTr("Amplifier Temperature")

            Component.onCompleted: {
                masterRefreshData.connect(function() {
                    txtValue = devAmpMaster.showDisplay("amp_temp") + " C"
                    colorValue = devAmpMaster.showColor("amp_temp")
                })
            }
        }

        ComboText {
            id: comboMasterStateStandWave
            posTop: comboMasterAtten.posBottom
            posLeft: (rectMaster.width - defaultMarginWidget) / 2
            txtText: devAmpMaster ? devAmpMaster.varName("s_stand_wave") : qsTr("Stand Wave")

            Component.onCompleted: {
                masterRefreshData.connect(function() {
                    txtValue = devAmpMaster.showDisplay("s_stand_wave")
                    colorValue = devAmpMaster.showColor("s_stand_wave")
                })
            }
        }

        ComboText {
            id: comboMasterStateTemp
            posTop: comboMasterAtten.posBottom
            posLeft: (rectMaster.width - defaultMarginWidget) * 3 / 4
            txtText: devAmpMaster ? devAmpMaster.varName("s_temp") : qsTr("Temperature")

            Component.onCompleted: {
                masterRefreshData.connect(function() {
                    txtValue = devAmpMaster.showDisplay("s_temp")
                    colorValue = devAmpMaster.showColor("s_temp")
                })
            }
        }

        ComboText {
            id: comboMasterStateCurrent
            posTop: comboMasterLoss.posBottom
            posLeft: 0
            txtText: devAmpMaster ? devAmpMaster.varName("s_current") : qsTr("Current")

            Component.onCompleted: {
                masterRefreshData.connect(function() {
                    txtValue = devAmpMaster.showDisplay("s_current")
                    colorValue = devAmpMaster.showColor("s_current")
                })
            }
        }

        ComboText {
            id: comboMasterStateVoltage
            posTop: comboMasterLoss.posBottom
            posLeft: (rectMaster.width - defaultMarginWidget) / 4
            txtText: devAmpMaster ? devAmpMaster.varName("s_voltage") : qsTr("Voltage")

            Component.onCompleted: {
                masterRefreshData.connect(function() {
                    txtValue = devAmpMaster.showDisplay("s_voltage")
                    colorValue = devAmpMaster.showColor("s_voltage")
                })
            }
        }

        ComboText {
            id: comboMasterStateOutputPower
            posTop: comboMasterLoss.posBottom
            posLeft: (rectMaster.width - defaultMarginWidget) / 2
            txtText: devAmpMaster ? devAmpMaster.varName("s_power") : qsTr("Output Power")

            Component.onCompleted: {
                masterRefreshData.connect(function() {
                    txtValue = devAmpMaster.showDisplay("s_power")
                    colorValue = devAmpMaster.showColor("s_power")
                })
            }
        }

        ComboText {
            id: comboMasterLoadTemp
            posTop: comboMasterLoss.posBottom
            posLeft: (rectMaster.width - defaultMarginWidget) * 3 / 4
            txtText: devAmpMaster ? devAmpMaster.varName("load_temp") : qsTr("Load Temperature")

            Component.onCompleted: {
                masterRefreshData.connect(function() {
                    txtValue = devAmpMaster.showDisplay("load_temp")
                    colorValue = devAmpMaster.showColor("load_temp")
                })
            }
        }

        ComboText {
            id: comboMasterCommunication
            posTop: comboMasterStateCurrent.posBottom
            posLeft: 0
            txtText: qsTr("Network Communication")
            fontSize: timerStringFontSize
            txtValue: devAmpMaster ? devAmpMaster.timerStr : qsTr("No data")
        }

        ComboText {
            id: comboMasterSignal
            posTop: comboMasterStateCurrent.posBottom
            posLeft: (rectMaster.width - defaultMarginWidget) / 2
            txtText: devAmpMaster ? devAmpMaster.varName("handshake") : qsTr("Handshake Signal")

            Component.onCompleted: {
                masterRefreshData.connect(function() {
                    txtValue = devAmpMaster.showDisplay("handshake")
                    colorValue = devAmpMaster.showColor("handshake")
                })
            }
        }
    }

    Rectangle {
        id: rectSlave
        anchors.left: rectMaster.left
        anchors.top: rectMaster.bottom
        anchors.topMargin: defaultMarginRect
        width: rectMaster.width
        height: rectMaster.height
        border.width: defaultBorderWidth

        ComboText {
            id: comboSlaveAtten
            posTop: 0
            posLeft: 0
            txtText: devAmpSlave ? devAmpSlave.varName("atten") : qsTr("Attenuation")

            Component.onCompleted: {
                slaveRefreshData.connect(function() {
                    txtValue = devAmpSlave.showDisplay("atten") + " dB"
                    colorValue = devAmpSlave.showColor("atten")
                })
            }
        }

        ComboText {
            id: comboSlavePower
            posTop: 0
            posLeft: (rectSlave.width - defaultMarginWidget) / 4
            txtText: devAmpSlave ? devAmpSlave.varName("power") : qsTr("Power")

            Component.onCompleted: {
                slaveRefreshData.connect(function() {
                    txtValue = devAmpSlave.showDisplay("power") + " mW"
                    colorValue = devAmpSlave.showColor("power")
                })
            }
        }

        ComboText {
            id: comboSlaveGain
            posTop: 0
            posLeft: (rectSlave.width - defaultMarginWidget) / 2
            txtText: devAmpSlave ? devAmpSlave.varName("gain") : qsTr("Gain")

            Component.onCompleted: {
                slaveRefreshData.connect(function() {
                    txtValue = devAmpSlave.showDisplay("gain") + " dB"
                    colorValue = devAmpSlave.showColor("gain")
                })
            }
        }

        ComboText {
            id: comboSlaveLoss
            posTop: comboSlaveAtten.posBottom
            posLeft: 0
            txtText: devAmpSlave ? devAmpSlave.varName("loss") : qsTr("Return Loss")

            Component.onCompleted: {
                slaveRefreshData.connect(function() {
                    txtValue = "-" + devAmpSlave.showDisplay("loss") + " dB"
                    colorValue = devAmpSlave.showColor("loss")
                })
            }
        }

        ComboText {
            id: comboSlaveAmpTemp
            posTop: comboSlaveAtten.posBottom
            posLeft: (rectSlave.width - defaultMarginWidget) / 4
            txtText: devAmpSlave ? devAmpSlave.varName("amp_temp") : qsTr("Amplifier Temperature")

            Component.onCompleted: {
                slaveRefreshData.connect(function() {
                    txtValue = devAmpSlave.showDisplay("amp_temp") + " C"
                    colorValue = devAmpSlave.showColor("amp_temp")
                })
            }
        }

        ComboText {
            id: comboSlaveStateStandWave
            posTop: comboSlaveAtten.posBottom
            posLeft: (rectSlave.width - defaultMarginWidget) / 2
            txtText: devAmpSlave ? devAmpSlave.varName("s_stand_wave") : qsTr("Stand Wave")

            Component.onCompleted: {
                slaveRefreshData.connect(function() {
                    txtValue = devAmpSlave.showDisplay("s_stand_wave")
                    colorValue = devAmpSlave.showColor("s_stand_wave")
                })
            }
        }

        ComboText {
            id: comboSlaveStateTemp
            posTop: comboSlaveAtten.posBottom
            posLeft: (rectSlave.width - defaultMarginWidget) * 3 / 4
            txtText: devAmpSlave ? devAmpSlave.varName("s_temp") : qsTr("Temperature")

            Component.onCompleted: {
                slaveRefreshData.connect(function() {
                    txtValue = devAmpSlave.showDisplay("s_temp")
                    colorValue = devAmpSlave.showColor("s_temp")
                })
            }
        }

        ComboText {
            id: comboSlaveStateCurrent
            posTop: comboSlaveLoss.posBottom
            posLeft: 0
            txtText: devAmpSlave ? devAmpSlave.varName("s_current") : qsTr("Current")

            Component.onCompleted: {
                slaveRefreshData.connect(function() {
                    txtValue = devAmpSlave.showDisplay("s_current")
                    colorValue = devAmpSlave.showColor("s_current")
                })
            }
        }

        ComboText {
            id: comboSlaveStateVoltage
            posTop: comboSlaveLoss.posBottom
            posLeft: (rectSlave.width - defaultMarginWidget) / 4
            txtText: devAmpSlave ? devAmpSlave.varName("s_voltage") : qsTr("Voltage")

            Component.onCompleted: {
                slaveRefreshData.connect(function() {
                    txtValue = devAmpSlave.showDisplay("s_voltage")
                    colorValue = devAmpSlave.showColor("s_voltage")
                })
            }
        }

        ComboText {
            id: comboSlaveStateOutputPower
            posTop: comboSlaveLoss.posBottom
            posLeft: (rectSlave.width - defaultMarginWidget) / 2
            txtText: devAmpSlave ? devAmpSlave.varName("s_power") : qsTr("Output Power")

            Component.onCompleted: {
                slaveRefreshData.connect(function() {
                    txtValue = devAmpSlave.showDisplay("s_power")
                    colorValue = devAmpSlave.showColor("s_power")
                })
            }
        }

        ComboText {
            id: comboSlaveLoadTemp
            posTop: comboSlaveLoss.posBottom
            posLeft: (rectSlave.width - defaultMarginWidget) * 3 / 4
            txtText: devAmpSlave ? devAmpSlave.varName("load_temp") : qsTr("Load Temperature")

            Component.onCompleted: {
                slaveRefreshData.connect(function() {
                    txtValue = devAmpSlave.showDisplay("load_temp")
                    colorValue = devAmpSlave.showColor("load_temp")
                })
            }
        }

        ComboText {
            id: comboSlaveCommunication
            posTop: comboSlaveStateCurrent.posBottom
            posLeft: 0
            txtText: qsTr("Network Communication")
            fontSize: timerStringFontSize
            txtValue: devAmpSlave ? devAmpSlave.timerStr : qsTr("No data")
        }

        ComboText {
            id: comboSlaveSignal
            posTop: comboSlaveStateCurrent.posBottom
            posLeft: (rectSlave.width - defaultMarginWidget) / 2
            txtText: devAmpSlave ? devAmpSlave.varName("handshake") : qsTr("Handshake Signal")

            Component.onCompleted: {
                slaveRefreshData.connect(function() {
                    txtValue = devAmpSlave.showDisplay("handshake")
                    colorValue = devAmpSlave.showColor("handshake")
                })
            }
        }
    }
}
