import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Dialogs 1.3
import QtQuick.Window 2.11

import rdss.alert 1.0

Window {
    readonly property int heightWidget: 30
    readonly property int marginWidget: 15
    readonly property int widthWidgetLabel: 150
    readonly property int widthWidget: 150
    readonly property int marginRect: 30
    property alias masterCommunicationColorValue: comboMasterCommunication.colorValue
    property alias slaveCommunicationColorValue: comboSlaveCommunication.colorValue

    id: winAmp
    visible: false
    modality: Qt.ApplicationModal
    width: rectMaster.width + 2 * marginRect
    height: 2 * rectMaster.height + heightWidget + 4 * marginRect + marginWidget + defaultHistoryAreaHeight
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
            buttonReset.clicked()
        })
    }

    onClosing: {
        close.accepted = false
        this.hide()
        devAmpMaster.gotData.disconnect(masterRefreshData)
        devAmpSlave.gotData.disconnect(slaveRefreshData)
        buttonReset.clicked()
        name.text = ""
        devAmpMaster = null
        devAmpSlave = null
    }

    Text {
        id: name
        x: marginRect + marginWidget
        y: marginRect
        height: heightWidget
        width: 2 * widthWidget
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: defaultLabelFontSize
    }

    ComboCombo {
        id: comboChannel
        posLeft: marginRect + rectMaster.width - widthWidget - widthWidgetLabel - 3 * marginWidget
        posTop: marginRect - marginWidget
        txtText: qsTr("Current State")

        Component.onCompleted: {
            comboModel = Alert.addEnum("P_MS")
            /*
            masterRefreshData.connect(function() {
                index = devAmpMaster.getValue("masterslave")
                colorValue = devAmpMaster.showColor("masterslave")
            })
            */
            clicked.connect(function(index) {
                // TODO
                if (index === Alert.P_MS_MASTER)
                    devAmpMaster.createCntlMsg()
                else if (index === Alert.P_MS_SLAVE)
                    devAmpSlave.createCntlMsg()

                buttonReset.clicked()
            })
        }
    }

    Button {
        id: buttonReset
        x: comboChannel.posLeft - marginWidget - widthWidget
        anchors.top: name.top
        width: widthWidget
        height: heightWidget
        text: qsTr("Reset")
        font.pixelSize: defaultLabelFontSize

        onClicked: {
            forceActiveFocus()
            devAmpMaster.releaseHold("atten_mode")
            comboMasterAttenMode.colorValue = devAmpMaster.showColor("atten_mode")
            comboMasterAttenMode.index = devAmpMaster.getValue("atten_mode")
            devAmpMaster.releaseHold("atten")
            comboMasterAtten.colorValue = devAmpMaster.showColor("atten")
            comboMasterAtten.txtValue = devAmpMaster.showDisplay("atten") + " dB"
            devAmpMaster.releaseHold("power")
            comboMasterPower.colorValue = devAmpMaster.showColor("power")
            comboMasterPower.txtValue = devAmpMaster.showDisplay("power") + " mW"
            devAmpMaster.releaseHold("gain")
            comboMasterGain.colorValue = devAmpMaster.showColor("gain")
            comboMasterGain.txtValue = devAmpMaster.showDisplay("gain") + " dB"
            devAmpSlave.releaseHold("atten_mode")
            comboSlaveAttenMode.colorValue = devAmpSlave.showColor("atten_mode")
            comboSlaveAttenMode.index = devAmpSlave.getValue("atten_mode")
            devAmpSlave.releaseHold("atten")
            comboSlaveAtten.colorValue = devAmpSlave.showColor("atten")
            comboSlaveAtten.txtValue = devAmpSlave.showDisplay("atten") + " dB"
            devAmpSlave.releaseHold("power")
            comboSlavePower.colorValue = devAmpSlave.showColor("power")
            comboSlavePower.txtValue = devAmpSlave.showDisplay("power") + " mW"
            devAmpSlave.releaseHold("gain")
            comboSlaveGain.colorValue = devAmpSlave.showColor("gain")
            comboSlaveGain.txtValue = devAmpSlave.showDisplay("gain") + " dB"
        }
    }

    Rectangle {
        id: rectMaster
        x: marginRect
        anchors.top: name.bottom
        anchors.topMargin: marginWidget
        width: 4 * widthWidget + 4 * widthWidgetLabel + 9 * marginWidget
        height: 4 * heightWidget + 5 * marginWidget
        border.width: defaultBorderWidth

        ComboCombo {
            id: comboMasterAttenMode
            posTop: 0
            posLeft: 0
            txtText: qsTr("Attenuation Mode")

            Component.onCompleted: {
                comboModel = Alert.addEnum("P_ATTEN")
                updated.connect(function (index) {
                    devAmpMaster.holdValue("atten_mode", index)
                })
                hold.connect(function() {
                    devAmpMaster.setHold("atten_mode")
                    colorValue = devAmpMaster.showColor("atten_mode")
                })
            }
        }

        ComboTextField {
            id: comboMasterAtten
            posTop: 0
            posLeft: (rectMaster.width - marginWidget) / 4
            txtText: qsTr("Attenuation")

            Component.onCompleted: {
                masterRefreshData.connect(function() {
                    if ((colorValue = devAmpMaster.showColor("atten")) !== Alert.MAP_COLOR["HOLDING"])
                        txtValue = devAmpMaster.showDisplay("atten") + " dB"
                })
                updated.connect(function (value) {
                    if (value !== "" && !isNaN(value))
                        devAmpMaster.holdValue("atten", value)
                })
                hold.connect(function() {
                    devAmpMaster.setHold("atten")
                    colorValue = devAmpMaster.showColor("atten")
                    txtValue = ""
                })
            }
        }

        ComboTextField {
            id: comboMasterPower
            posTop: 0
            posLeft: (rectMaster.width - marginWidget) / 2
            txtText: qsTr("Power")

            Component.onCompleted: {
                masterRefreshData.connect(function() {
                    if ((colorValue = devAmpMaster.showColor("power")) !== Alert.MAP_COLOR["HOLDING"])
                        txtValue = devAmpMaster.showDisplay("power") + " mW"
                })
                updated.connect(function (value) {
                    if (value !== "" && !isNaN(value))
                        devAmpMaster.holdValue("power", value)
                })
                hold.connect(function() {
                    devAmpMaster.setHold("power")
                    colorValue = devAmpMaster.showColor("power")
                    txtValue = ""
                })
            }
        }

        ComboTextField {
            id: comboMasterGain
            posTop: 0
            posLeft: (rectMaster.width - marginWidget) * 3 / 4
            txtText: qsTr("Gain")

            Component.onCompleted: {
                masterRefreshData.connect(function() {
                    if ((colorValue = devAmpMaster.showColor("gain")) !== Alert.MAP_COLOR["HOLDING"])
                        txtValue = devAmpMaster.showDisplay("gain") + " dB"
                })
                updated.connect(function (value) {
                    if (value !== "" && !isNaN(value))
                        devAmpMaster.holdValue("gain", value)
                })
                hold.connect(function() {
                    devAmpMaster.setHold("gain")
                    colorValue = devAmpMaster.showColor("gain")
                    txtValue = ""
                })
            }
        }

        ComboText {
            id: comboMasterLoss
            posTop: comboMasterAttenMode.posBottom
            posLeft: 0
            txtText: qsTr("Return Loss")

            Component.onCompleted: {
                masterRefreshData.connect(function() {
                    txtValue = "-" + devAmpMaster.showDisplay("loss") + " dB"
                    colorValue = devAmpMaster.showColor("loss")
                })
            }
        }

        ComboText {
            id: comboMasterAmpTemp
            posTop: comboMasterAttenMode.posBottom
            posLeft: (rectMaster.width - marginWidget) / 4
            txtText: qsTr("Amplifier Temperature")

            Component.onCompleted: {
                masterRefreshData.connect(function() {
                    txtValue = devAmpMaster.showDisplay("amp_temp") + " C"
                    colorValue = devAmpMaster.showColor("amp_temp")
                })
            }
        }

        ComboText {
            id: comboMasterStateStandWave
            posTop: comboMasterAttenMode.posBottom
            posLeft: (rectMaster.width - marginWidget) / 2
            txtText: qsTr("Stand Wave")

            Component.onCompleted: {
                masterRefreshData.connect(function() {
                    txtValue = devAmpMaster.showDisplay("s_stand_wave")
                    colorValue = devAmpMaster.showColor("s_stand_wave")
                })
            }
        }

        ComboText {
            id: comboMasterStateTemp
            posTop: comboMasterAttenMode.posBottom
            posLeft: (rectMaster.width - marginWidget) * 3 / 4
            txtText: qsTr("Temperature")

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
            txtText: qsTr("Current")

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
            posLeft: (rectMaster.width - marginWidget) / 4
            txtText: qsTr("Voltage")

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
            posLeft: (rectMaster.width - marginWidget) / 2
            txtText: qsTr("Output Power")

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
            posLeft: (rectMaster.width - marginWidget) * 3 / 4
            txtText: qsTr("Load Temperature")

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

            Component.onCompleted: {
                masterRefreshData.connect(function() {
                    txtValue = devAmpMaster.timerStr
                })
            }
        }

        ComboText {
            id: comboMasterSignal
            posTop: comboMasterStateCurrent.posBottom
            posLeft: (rectMaster.width - marginWidget) / 2
            txtText: qsTr("Handshake Signal")

            Component.onCompleted: {
                masterRefreshData.connect(function() {
                    txtValue = devAmpMaster.showDisplay("handshake")
                    colorValue = devAmpMaster.showColor("handshake")
                })
            }
        }

        Button {
            id: buttonMasterSubmit
            x: rectMaster.width - marginWidget - widthWidget
            y: comboMasterStateCurrent.posBottom + marginWidget
            width: widthWidget
            height: heightWidget
            text: qsTr("Submit")
            font.pixelSize: defaultLabelFontSize

            onClicked: {
                comboMasterAttenMode.submit()
                comboMasterAtten.submit()
                comboMasterPower.submit()
                comboMasterGain.submit()
                devAmpMaster.createCntlMsg()
                buttonReset.clicked()
            }
        }
    }

    Rectangle {
        id: rectSlave
        anchors.left: rectMaster.left
        anchors.top: rectMaster.bottom
        anchors.topMargin: marginRect
        width: rectMaster.width
        height: rectMaster.height
        border.width: defaultBorderWidth

        ComboCombo {
            id: comboSlaveAttenMode
            posTop: 0
            posLeft: 0
            txtText: qsTr("Attenuation Mode")

            Component.onCompleted: {
                comboModel = Alert.addEnum("P_ATTEN")
                updated.connect(function (index) {
                    devAmpSlave.holdValue("atten_mode", index)
                })
                hold.connect(function() {
                    devAmpSlave.setHold("atten_mode")
                    colorValue = devAmpSlave.showColor("atten_mode")
                })
            }
        }

        ComboTextField {
            id: comboSlaveAtten
            posTop: 0
            posLeft: (rectSlave.width - marginWidget) / 4
            txtText: qsTr("Attenuation")

            Component.onCompleted: {
                slaveRefreshData.connect(function() {
                    if ((colorValue = devAmpSlave.showColor("atten")) !== Alert.MAP_COLOR["HOLDING"])
                        txtValue = devAmpSlave.showDisplay("atten") + " dB"
                })
                updated.connect(function (value) {
                    if (value !== "" && !isNaN(value))
                        devAmpSlave.holdValue("atten", value)
                })
                hold.connect(function() {
                    devAmpSlave.setHold("atten")
                    colorValue = devAmpSlave.showColor("atten")
                    txtValue = ""
                })
            }
        }

        ComboTextField {
            id: comboSlavePower
            posTop: 0
            posLeft: (rectSlave.width - marginWidget) / 2
            txtText: qsTr("Power")

            Component.onCompleted: {
                slaveRefreshData.connect(function() {
                    if ((colorValue = devAmpSlave.showColor("power")) !== Alert.MAP_COLOR["HOLDING"])
                        txtValue = devAmpSlave.showDisplay("power") + " mW"
                })
                updated.connect(function (value) {
                    if (value !== "" && !isNaN(value))
                        devAmpSlave.holdValue("power", value)
                })
                hold.connect(function() {
                    devAmpSlave.setHold("power")
                    colorValue = devAmpSlave.showColor("power")
                    txtValue = ""
                })
            }
        }

        ComboTextField {
            id: comboSlaveGain
            posTop: 0
            posLeft: (rectSlave.width - marginWidget) * 3 / 4
            txtText: qsTr("Gain")

            Component.onCompleted: {
                slaveRefreshData.connect(function() {
                    if ((colorValue = devAmpSlave.showColor("gain")) !== Alert.MAP_COLOR["HOLDING"])
                        txtValue = devAmpSlave.showDisplay("gain") + " dB"
                })
                updated.connect(function (value) {
                    if (value !== "" && !isNaN(value))
                        devAmpSlave.holdValue("gain", value)
                })
                hold.connect(function() {
                    devAmpSlave.setHold("gain")
                    colorValue = devAmpSlave.showColor("gain")
                    txtValue = ""
                })
            }
        }

        ComboText {
            id: comboSlaveLoss
            posTop: comboSlaveAttenMode.posBottom
            posLeft: 0
            txtText: qsTr("Return Loss")

            Component.onCompleted: {
                slaveRefreshData.connect(function() {
                    txtValue = "-" + devAmpSlave.showDisplay("loss") + " dB"
                    colorValue = devAmpSlave.showColor("loss")
                })
            }
        }

        ComboText {
            id: comboSlaveAmpTemp
            posTop: comboSlaveAttenMode.posBottom
            posLeft: (rectSlave.width - marginWidget) / 4
            txtText: qsTr("Amplifier Temperature")

            Component.onCompleted: {
                slaveRefreshData.connect(function() {
                    txtValue = devAmpSlave.showDisplay("amp_temp") + " C"
                    colorValue = devAmpSlave.showColor("amp_temp")
                })
            }
        }

        ComboText {
            id: comboSlaveStateStandWave
            posTop: comboSlaveAttenMode.posBottom
            posLeft: (rectSlave.width - marginWidget) / 2
            txtText: qsTr("Stand Wave")

            Component.onCompleted: {
                slaveRefreshData.connect(function() {
                    txtValue = devAmpSlave.showDisplay("s_stand_wave")
                    colorValue = devAmpSlave.showColor("s_stand_wave")
                })
            }
        }

        ComboText {
            id: comboSlaveStateTemp
            posTop: comboSlaveAttenMode.posBottom
            posLeft: (rectSlave.width - marginWidget) * 3 / 4
            txtText: qsTr("Temperature")

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
            txtText: qsTr("Current")

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
            posLeft: (rectSlave.width - marginWidget) / 4
            txtText: qsTr("Voltage")

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
            posLeft: (rectSlave.width - marginWidget) / 2
            txtText: qsTr("Output Power")

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
            posLeft: (rectSlave.width - marginWidget) * 3 / 4
            txtText: qsTr("Load Temperature")

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

            Component.onCompleted: {
                slaveRefreshData.connect(function() {
                    txtValue = devAmpSlave.timerStr
                })
            }
        }

        ComboText {
            id: comboSlaveSignal
            posTop: comboSlaveStateCurrent.posBottom
            posLeft: (rectSlave.width - marginWidget) / 2
            txtText: qsTr("Handshake Signal")

            Component.onCompleted: {
                slaveRefreshData.connect(function() {
                    txtValue = devAmpSlave.showDisplay("handshake")
                    colorValue = devAmpSlave.showColor("handshake")
                })
            }
        }

        Button {
            id: buttonSlaveSubmit
            x: rectSlave.width - marginWidget - widthWidget
            y: comboSlaveStateCurrent.posBottom + marginWidget
            width: widthWidget
            height: heightWidget
            text: qsTr("Submit")
            font.pixelSize: defaultLabelFontSize

            onClicked: {
                comboSlaveAttenMode.submit()
                comboSlaveAtten.submit()
                comboSlavePower.submit()
                comboSlaveGain.submit()
                devAmpSlave.createCntlMsg()
                buttonReset.clicked()
            }
        }
    }

    RectHistory {
        id: rectHistory
        anchors.top: rectSlave.bottom
        anchors.topMargin: marginRect
        anchors.left: rectSlave.left
        itemWidth: rectMaster.width
    }
}
