import QtQuick 2.9
import QtQuick.Controls 1.6
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.9

import rdss.alert 1.0

Window {
    readonly property int heightWidget: 30
    readonly property int marginWidget: 15
    readonly property int widthWidgetLabel: 150
    readonly property int widthWidget: 150
    readonly property int marginRect: 30

    id: winFreq
    visible: false
    modality: Qt.ApplicationModal
    width: rectMaster.width + 2 * marginRect
    height: 2 * rectMaster.height + heightWidget + 4 * marginRect + marginWidget + defaultTextAreaHeight
    title: qsTr("Frequency Conversion Device")

    property QtObject devFreqMaster
    property QtObject devFreqSlave
    signal opened(QtObject devMaster, QtObject devSlave)
    signal masterGotData()
    signal slaveGotData()

    Component.onCompleted: {
        winFreq.opened.connect(function(devMaster, devSlave) {
            devFreqMaster = devMaster
            devFreqSlave = devSlave
            name.text = devFreqMaster.name
            devMaster.gotData.connect(masterGotData)
            devSlave.gotData.connect(slaveGotData)
        })
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

        Component.onCompleted: comboModel = Alert.addEnum("P_MS")
    }

    Button {
        id: buttonSubmit
        x: comboChannel.posLeft - marginWidget - widthWidget
        anchors.top: name.top
        width: widthWidget
        height: heightWidget
        text: qsTr("Submit")
    }

    Button {
        id: buttonReset
        anchors.right: buttonSubmit.left
        anchors.rightMargin: marginWidget
        anchors.top: name.top
        width: widthWidget
        height: heightWidget
        text: qsTr("Reset")
    }

    Rectangle {
        id: rectMaster
        x: marginRect
        anchors.top: name.bottom
        anchors.topMargin: marginWidget
        width: 4 * widthWidget + 4 * widthWidgetLabel + 9 * marginWidget
        height: 5 * heightWidget + 6 * marginWidget
        border.width: defaultBorderWidth

        ComboText {
            id: comboMasterAtten
            posTop: 0
            posLeft: 0
            txtText: qsTr("Attenuation")

            Component.onCompleted: {
                masterGotData.connect(function() {
                    txtValue = devFreqMaster.showDisplay("atten") + " dB"
                    colorValue = devFreqMaster.showColor("atten")
                })
            }
        }

        ComboCombo {
            id: comboMasterRefA
            posTop: 0
            posLeft: (rectMaster.width - marginWidget) / 3
            txtText: "10 Mhz " + qsTr("Ref")

            Component.onCompleted: {
                comboModel = Alert.addEnum("P_CH", qsTr("Channel") + " ")
                updated.connect(function (index) {
                    devFreqMaster.setValue("ch_a", index)
                })
            }
        }

        ComboCombo {
            id: comboMasterRefB
            posTop: 0
            posLeft: (rectMaster.width - marginWidget) / 3 * 2
            txtText: "10 Mhz " + qsTr("Ref")

            Component.onCompleted: {
                comboModel = Alert.addEnum("P_CH", qsTr("Channel") + " ")
                updated.connect(function (index) {
                    devFreqMaster.setValue("ch_b", index)
                })
            }
        }

        ComboText {
            id: comboMasterVoltage
            posTop: comboMasterAtten.posBottom
            posLeft: 0
            txtText: qsTr("Voltage")

            Component.onCompleted: {
                masterGotData.connect(function() {
                    txtValue = devFreqMaster.showDisplay("voltage") + " V"
                    colorValue = devFreqMaster.showColor("voltage")
                })
            }
        }

        ComboText {
            id: comboMasterCurrent
            posTop: comboMasterAtten.posBottom
            posLeft: (rectMaster.width - marginWidget) / 4
            txtText: qsTr("Current")

            Component.onCompleted: {
                masterGotData.connect(function() {
                    txtValue = devFreqMaster.showDisplay("current") + " mA"
                    colorValue = devFreqMaster.showColor("current")
                })
            }
        }

        ComboText {
            id: comboMasterOutputStat
            posTop: comboMasterAtten.posBottom
            posLeft: (rectMaster.width - marginWidget) / 4 * 2
            txtText: qsTr("Radio Output")

            Component.onCompleted: {
                masterGotData.connect(function() {
                    txtValue = devFreqMaster.showDisplay("output_stat")
                    colorValue = devFreqMaster.showColor("output_stat")
                })
            }
        }

        ComboText {
            id: comboMasterInputStat
            posTop: comboMasterAtten.posBottom
            posLeft: (rectMaster.width - marginWidget) / 4 * 3
            txtText: qsTr("Mid Freq Input")

            Component.onCompleted: {
                masterGotData.connect(function() {
                    txtValue = devFreqMaster.showDisplay("input_stat")
                    colorValue = devFreqMaster.showColor("input_stat")
                })
            }
        }

        ComboText {
            id: comboMasterLOA1
            posTop: comboMasterVoltage.posBottom
            posLeft: 0
            txtText: qsTr("Local Oscillator") + " A1"

            Component.onCompleted: {
                masterGotData.connect(function() {
                    txtValue = devFreqMaster.showDisplay("lock_a1")
                    colorValue = devFreqMaster.showColor("lock_a1")
                })
            }
        }

        ComboText {
            id: comboMasterLOA2
            posTop: comboMasterVoltage.posBottom
            posLeft: (rectMaster.width - marginWidget) / 4
            txtText: qsTr("Local Oscillator") + " A1"

            Component.onCompleted: {
                masterGotData.connect(function() {
                    txtValue = devFreqMaster.showDisplay("lock_a2")
                    colorValue = devFreqMaster.showColor("lock_a2")
                })
            }
        }

        ComboText {
            id: comboMasterLOB1
            posTop: comboMasterVoltage.posBottom
            posLeft: (rectMaster.width - marginWidget) / 4 * 2
            txtText: qsTr("Local Oscillator") + " B1"

            Component.onCompleted: {
                masterGotData.connect(function() {
                    txtValue = devFreqMaster.showDisplay("lock_b1")
                    colorValue = devFreqMaster.showColor("lock_b1")
                })
            }
        }

        ComboText {
            id: comboMasterLOB2
            posTop: comboMasterVoltage.posBottom
            posLeft: (rectMaster.width - marginWidget) / 4 * 3
            txtText: qsTr("Local Oscillator") + " B2"

            Component.onCompleted: {
                masterGotData.connect(function() {
                    txtValue = devFreqMaster.showDisplay("lock_b2")
                    colorValue = devFreqMaster.showColor("lock_b2")
                })
            }
        }

        ComboText {
            id: comboMaster10Ref1
            posTop: comboMasterLOA1.posBottom
            posLeft: 0
            txtText: "10 MHz 1"

            Component.onCompleted: {
                masterGotData.connect(function() {
                    txtValue = devFreqMaster.showDisplay("ref_10_1")
                    colorValue = devFreqMaster.showColor("ref_10_1")
                })
            }
        }

        ComboText {
            id: comboMaster10Ref2
            posTop: comboMasterLOA1.posBottom
            posLeft: (rectMaster.width - marginWidget) / 4
            txtText: "10 MHz 2"

            Component.onCompleted: {
                masterGotData.connect(function() {
                    txtValue = devFreqMaster.showDisplay("ref_10_2")
                    colorValue = devFreqMaster.showColor("ref_10_2")
                })
            }
        }

        ComboText {
            id: comboMaster10RefInner
            posTop: comboMasterLOA1.posBottom
            posLeft: (rectMaster.width - marginWidget) / 4 * 2
            txtText: "10 MHz " + qsTr("Inner Ref")

            Component.onCompleted: {
                masterGotData.connect(function() {
                    txtValue = devFreqMaster.showDisplay("ref_10_2")
                    colorValue = devFreqMaster.showColor("ref_10_2")
                })
            }
        }

        ComboText {
            id: comboMasterCommunication
            posTop: comboMaster10Ref1.posBottom
            posLeft: 0
            txtText: "Network Communication"
        }

        ComboText {
            id: comboMasterSignal
            posTop: comboMaster10Ref1.posBottom
            posLeft: (rectMaster.width - marginWidget) / 4 * 2
            txtText: "Control Signal"
        }
    }

    Rectangle {
        id: rectSlave
        anchors.left: rectMaster.left
        anchors.top: rectMaster.bottom
        anchors.topMargin: marginRect
        width: winFreq.width - 2 * marginRect
        height: 5 * heightWidget + 6 * marginWidget
        border.width: defaultBorderWidth

        ComboText {
            id: comboSlaveAtten
            posTop: 0
            posLeft: 0
            txtText: qsTr("Attenuation")

            Component.onCompleted: {
                slaveGotData.connect(function() {
                    txtValue = devFreqSlave.showDisplay("atten") + " dB"
                    colorValue = devFreqSlave.showColor("atten")
                })
            }
        }

        ComboCombo {
            id: comboSlaveRefA
            posTop: 0
            posLeft: (rectSlave.width - marginWidget) / 3
            txtText: "10 Mhz " + qsTr("Ref") + " A"

            Component.onCompleted: {
                comboModel = Alert.addEnum("P_CH", qsTr("Channel") + " ")
                updated.connect(function (index) {
                    devFreqSlave.setValue("ch_a", index)
                })
            }
        }

        ComboCombo {
            id: comboSlaveRefB
            posTop: 0
            posLeft: (rectSlave.width - marginWidget) / 3 * 2
            txtText: "10 Mhz " + qsTr("Ref") + " B"

            Component.onCompleted: {
                comboModel = Alert.addEnum("P_CH", qsTr("Channel") + " ")
                updated.connect(function (index) {
                    devFreqSlave.setValue("ch_b", index)
                })
            }
        }

        ComboText {
            id: comboSlaveVoltage
            posTop: comboSlaveAtten.posBottom
            posLeft: 0
            txtText: qsTr("Voltage")

            Component.onCompleted: {
                slaveGotData.connect(function() {
                    txtValue = devFreqSlave.showDisplay("voltage") + " V"
                    colorValue = devFreqSlave.showColor("voltage")
                })
            }
        }

        ComboText {
            id: comboSlaveCurrent
            posTop: comboSlaveAtten.posBottom
            posLeft: (rectSlave.width - marginWidget) / 4
            txtText: qsTr("Current")

            Component.onCompleted: {
                slaveGotData.connect(function() {
                    txtValue = devFreqSlave.showDisplay("current") + " mA"
                    colorValue = devFreqSlave.showColor("current")
                })
            }
        }

        ComboText {
            id: comboSlaveOutputStat
            posTop: comboSlaveAtten.posBottom
            posLeft: (rectSlave.width - marginWidget) / 4 * 2
            txtText: qsTr("Radio Output")

            Component.onCompleted: {
                slaveGotData.connect(function() {
                    txtValue = devFreqSlave.showDisplay("output_stat")
                    colorValue = devFreqSlave.showColor("output_stat")
                })
            }
        }

        ComboText {
            id: comboSlaveInputStat
            posTop: comboSlaveAtten.posBottom
            posLeft: (rectSlave.width - marginWidget) / 4 * 3
            txtText: qsTr("Mid Freq Input")

            Component.onCompleted: {
                slaveGotData.connect(function() {
                    txtValue = devFreqSlave.showDisplay("input_stat")
                    colorValue = devFreqSlave.showColor("input_stat")
                })
            }
        }

        ComboText {
            id: comboSlaveLOA1
            posTop: comboSlaveVoltage.posBottom
            posLeft: 0
            txtText: qsTr("Local Oscillator") + " A1"

            Component.onCompleted: {
                slaveGotData.connect(function() {
                    txtValue = devFreqSlave.showDisplay("lock_a1")
                    colorValue = devFreqSlave.showColor("lock_a1")
                })
            }
        }

        ComboText {
            id: comboSlaveLOA2
            posTop: comboSlaveVoltage.posBottom
            posLeft: (rectSlave.width - marginWidget) / 4
            txtText: qsTr("Local Oscillator") + " A1"

            Component.onCompleted: {
                slaveGotData.connect(function() {
                    txtValue = devFreqSlave.showDisplay("lock_a2")
                    colorValue = devFreqSlave.showColor("lock_a2")
                })
            }
        }

        ComboText {
            id: comboSlaveLOB1
            posTop: comboSlaveVoltage.posBottom
            posLeft: (rectSlave.width - marginWidget) / 4 * 2
            txtText: qsTr("Local Oscillator") + " B1"

            Component.onCompleted: {
                slaveGotData.connect(function() {
                    txtValue = devFreqSlave.showDisplay("lock_b1")
                    colorValue = devFreqSlave.showColor("lock_b1")
                })
            }
        }

        ComboText {
            id: comboSlaveLOB2
            posTop: comboSlaveVoltage.posBottom
            posLeft: (rectSlave.width - marginWidget) / 4 * 3
            txtText: qsTr("Local Oscillator") + " B2"

            Component.onCompleted: {
                slaveGotData.connect(function() {
                    txtValue = devFreqSlave.showDisplay("lock_b2")
                    colorValue = devFreqSlave.showColor("lock_b2")
                })
            }
        }

        ComboText {
            id: comboSlave16Ref1
            posTop: comboSlaveLOA1.posBottom
            posLeft: 0
            txtText: "16 MHz 1"

            Component.onCompleted: {
                slaveGotData.connect(function() {
                    txtValue = devFreqSlave.showDisplay("ref_3")
                    colorValue = devFreqSlave.showColor("ref_3")
                })
            }
        }

        ComboText {
            id: comboSlave16Ref2
            posTop: comboSlaveLOA1.posBottom
            posLeft: (rectSlave.width - marginWidget) / 4
            txtText: "16 MHz 2"

            Component.onCompleted: {
                slaveGotData.connect(function() {
                    txtValue = devFreqSlave.showDisplay("ref_4")
                    colorValue = devFreqSlave.showColor("ref_4")
                })
            }
        }

        ComboText {
            id: comboSlave16RefInner
            posTop: comboSlaveLOA1.posBottom
            posLeft: (rectSlave.width - marginWidget) / 4 * 2
            txtText: "16 MHz " + qsTr("Inner Ref")

            Component.onCompleted: {
                slaveGotData.connect(function() {
                    txtValue = devFreqSlave.showDisplay("ref_4")
                    colorValue = devFreqSlave.showColor("ref_4")
                })
            }
        }

        ComboText {
            id: comboSlaveCommunication
            posTop: comboSlave16Ref1.posBottom
            posLeft: 0
            txtText: "Network Communication"
        }

        ComboText {
            id: comboSlaveSignal
            posTop: comboSlave16Ref1.posBottom
            posLeft: (rectSlave.width - marginWidget) / 4 * 2
            txtText: "Control Signal"
        }
    }

    RectHistory {
        id: rectHistory
        anchors.top: rectSlave.bottom
        anchors.topMargin: marginRect
        anchors.left: rectSlave.left
        itemWidth: rectMaster.width
    }

    onClosing: {
        close.accepted = false
        this.hide()
    }
}
