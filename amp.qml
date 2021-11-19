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

    SetAmp {
        id: setAmp
        devAmpMaster: devAmpMaster
        devAmpSlave: devAmpSlave
        dialogName: name.text + " " + qsTr("Setting")
    }
    Button {
        id: setting
        x: defaultMarginRect + rectMaster.width - defaultWidthWidget - defaultMarginWidget
        anchors.top: name.top
        width: defaultWidthWidget
        height: defaultHeightWidget
        text: qsTr("Setting")
        font.pixelSize: defaultLabelFontSize

        onClicked: {
            setAmp.devAmpMaster = devAmpMaster
            setAmp.devAmpSlave = devAmpSlave
            if (devAmpMaster.getValue("masterslave") === Alert.P_NOR_NORMAL)
                setAmp.valueChannel = Alert.P_MS_MASTER
            else
                setAmp.valueChannel = Alert.P_MS_SLAVE
            setAmp.valueMasterAttenMode = comboMasterAttenMode.index
            setAmp.valueMasterAtten = comboMasterAtten.txtValue
            setAmp.valueMasterPower = comboMasterPower.txtValue
            setAmp.valueMasterGain = comboMasterGain.txtValue
            setAmp.valueSlaveAttenMode = comboSlaveAttenMode.index
            setAmp.valueSlaveAtten = comboSlaveAtten.txtValue
            setAmp.valueSlavePower = comboSlavePower.txtValue
            setAmp.valueSlaveGain = comboSlaveGain.txtValue
            setAmp.open()
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

        ComboCombo {
            id: comboMasterAttenMode
            posTop: 0
            posLeft: 0
            txtText: devAmpMaster ? devAmpMaster.varName("atten_mode") : qsTr("Attenuation Mode")
            visible: false

            Component.onCompleted: {
                comboModel = Alert.addEnum("P_ATTEN")
            }
        }

        ComboText {
            id: comboMasterAtten
            posTop: 0
            posLeft: 0
            txtText: devAmpMaster ? devAmpMaster.varName("atten") : qsTr("Attenuation")
            txtSuffix: " dB"

            Component.onCompleted: {
                masterRefreshData.connect(function() {
                    txtValue = devAmpMaster.showDisplay("atten")
                    colorValue = devAmpMaster.showColor("atten")
                })
            }
        }

        ComboText {
            id: comboMasterPower
            posTop: 0
            posLeft: (rectMaster.width - defaultMarginWidget) / 4
            txtText: devAmpMaster ? devAmpMaster.varName("output_power") : qsTr("Output Power")
            txtSuffix: " dBm"

            Component.onCompleted: {
                masterRefreshData.connect(function() {
                    txtValue = devAmpMaster.showDisplay("output_power")
                    colorValue = devAmpMaster.showColor("output_power")
                })
            }
        }

        ComboText {
            id: comboMasterGain
            posTop: 0
            posLeft: (rectMaster.width - defaultMarginWidget) / 2
            txtText: devAmpMaster ? devAmpMaster.varName("gain") : qsTr("Gain")
            txtSuffix: " dBm"

            Component.onCompleted: {
                masterRefreshData.connect(function() {
                    txtValue = devAmpMaster.showDisplay("gain")
                    colorValue = devAmpMaster.showColor("gain")
                })
            }
        }

        ComboText {
            id: comboMasterChannel
            posLeft: (rectMaster.width - defaultMarginWidget) * 3 / 4
            posTop: 0
            txtText: devAmpMaster ? devAmpMaster.varName("masterslave") : qsTr("Current State")

            Component.onCompleted: {
                masterRefreshData.connect(function() {
                    txtValue = devAmpMaster.showDisplay("masterslave")
                    colorValue = devAmpMaster.showColor("masterslave")
                })
            }
        }

        ComboText {
            id: comboMasterLoss
            posTop: comboMasterAtten.posBottom
            posLeft: 0
            txtText: devAmpMaster ? devAmpMaster.varName("input_power") : qsTr("Input Power")
            txtSuffix: " dBm"

            Component.onCompleted: {
                masterRefreshData.connect(function() {
                    txtValue = devAmpMaster.showDisplay("input_power")
                    colorValue = devAmpMaster.showColor("input_power")
                })
            }
        }

        ComboText {
            id: comboMasterAmpTemp
            posTop: comboMasterAtten.posBottom
            posLeft: (rectMaster.width - defaultMarginWidget) / 4
            txtText: devAmpMaster ? devAmpMaster.varName("amp_temp") : qsTr("Amplifier Temperature")
            txtSuffix: " C"

            Component.onCompleted: {
                masterRefreshData.connect(function() {
                    txtValue = devAmpMaster.showDisplay("amp_temp")
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
            txtSuffix: " C"

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

        ComboCombo {
            id: comboSlaveAttenMode
            posTop: 0
            posLeft: 0
            txtText: devAmpSlave ? devAmpSlave.varName("atten_mode") : qsTr("Attenuation Mode")
            visible: false

            Component.onCompleted: {
                comboModel = Alert.addEnum("P_ATTEN")
            }
        }

        ComboText {
            id: comboSlaveAtten
            posTop: 0
            posLeft: 0
            txtText: devAmpSlave ? devAmpSlave.varName("atten") : qsTr("Attenuation")
            txtSuffix: " dB"

            Component.onCompleted: {
                slaveRefreshData.connect(function() {
                    txtValue = devAmpSlave.showDisplay("atten")
                    colorValue = devAmpSlave.showColor("atten")
                })
            }
        }

        ComboText {
            id: comboSlavePower
            posTop: 0
            posLeft: (rectSlave.width - defaultMarginWidget) / 4
            txtText: devAmpSlave ? devAmpSlave.varName("output_power") : qsTr("Output Power")
            txtSuffix: " mW"

            Component.onCompleted: {
                slaveRefreshData.connect(function() {
                    txtValue = devAmpSlave.showDisplay("output_power")
                    colorValue = devAmpSlave.showColor("output_power")
                })
            }
        }

        ComboText {
            id: comboSlaveGain
            posTop: 0
            posLeft: (rectSlave.width - defaultMarginWidget) / 2
            txtText: devAmpSlave ? devAmpSlave.varName("gain") : qsTr("Gain")
            txtSuffix: " dB"

            Component.onCompleted: {
                slaveRefreshData.connect(function() {
                    txtValue = devAmpSlave.showDisplay("gain")
                    colorValue = devAmpSlave.showColor("gain")
                })
            }
        }

        ComboText {
            id: comboSlaveChannel
            posLeft: (rectSlave.width - defaultMarginWidget) * 3 / 4
            posTop: 0
            txtText: devAmpSlave ? devAmpSlave.varName("masterslave") : qsTr("Current State")

            Component.onCompleted: {
                slaveRefreshData.connect(function() {
                    txtValue = devAmpSlave.showDisplay("masterslave")
                    colorValue = devAmpSlave.showColor("masterslave")
                })
            }
        }

        ComboText {
            id: comboSlaveLoss
            posTop: comboSlaveAtten.posBottom
            posLeft: 0
            txtText: devAmpSlave ? devAmpSlave.varName("input_power") : qsTr("Input Power")
            txtSuffix: " dBm"

            Component.onCompleted: {
                slaveRefreshData.connect(function() {
                    txtValue = devAmpSlave.showDisplay("input_power")
                    colorValue = devAmpSlave.showColor("input_power")
                })
            }
        }

        ComboText {
            id: comboSlaveAmpTemp
            posTop: comboSlaveAtten.posBottom
            posLeft: (rectSlave.width - defaultMarginWidget) / 4
            txtText: devAmpSlave ? devAmpSlave.varName("amp_temp") : qsTr("Amplifier Temperature")
            txtSuffix: " C"

            Component.onCompleted: {
                slaveRefreshData.connect(function() {
                    txtValue = devAmpSlave.showDisplay("amp_temp")
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
            txtSuffix: " C"

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
