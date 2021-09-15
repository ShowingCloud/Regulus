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
    property bool devFreqUp: false

    id: winFreq
    visible: false
    modality: Qt.ApplicationModal
    width: rectMaster.width + 2 * marginRect
    height: 2 * rectMaster.height + heightWidget + 4 * marginRect + marginWidget + defaultTextAreaHeight
    title: qsTr("Frequency Conversion Device")

    property QtObject devFreqMaster
    property QtObject devFreqSlave
    signal opened(QtObject devMaster, QtObject devSlave, bool devUp)
    signal masterGotData()
    signal slaveGotData()

    Component.onCompleted: {
        winFreq.opened.connect(function(devMaster, devSlave, devUp) {
            devFreqMaster = devMaster
            devFreqSlave = devSlave
            devFreqUp = devUp
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

        Component.onCompleted: {
            comboModel = Alert.addEnum("P_MS")
            indexChanged.connect(function(index) {
                comboMasterAtten.submit()
                comboMasterRef.submit()
                comboSlaveAtten.submit()
                comboSlaveRef.submit()

                if (index === Alert.P_MS_MASTER)
                    devFreqMaster.createCntlMsg()
                else if (index === Alert.P_MS_SLAVE)
                    devFreqSlave.createCntlMsg()

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

        onClicked: {
            forceActiveFocus()
            devFreqMaster.releaseHold("atten")
            comboMasterAtten.colorValue = devFreqMaster.showColor("atten")
            comboMasterAtten.txtValue = devFreqMaster.showDisplay("atten") + " dB"
            devFreqSlave.releaseHold("atten")
            comboSlaveAtten.colorValue = devFreqSlave.showColor("atten")
            comboSlaveAtten.txtValue = devFreqSlave.showDisplay("atten") + " dB"
            devFreqMaster.releaseHold("ch_a")
            comboMasterRef.colorValue = devFreqMaster.showColor("ch_a")
            devFreqSlave.releaseHold("ch_b")
            comboSlaveRef.colorValue = devFreqSlave.showColor("ch_b")
        }
    }

    Rectangle {
        id: rectMaster
        x: marginRect
        anchors.top: name.bottom
        anchors.topMargin: marginWidget
        width: 4 * widthWidget + 4 * widthWidgetLabel + 9 * marginWidget
        height: 5 * heightWidget + 6 * marginWidget
        border.width: defaultBorderWidth

        ComboTextField {
            id: comboMasterAtten
            posTop: 0
            posLeft: 0
            txtText: qsTr("Attenuation")

            Component.onCompleted: {
                masterGotData.connect(function() {
                    if ((colorValue = devFreqMaster.showColor("atten")) !== Alert.MAP_COLOR["HOLDING"])
                        txtValue = devFreqMaster.showDisplay("atten") + " dB"
                })
                updated.connect(function (value) {
                    if (value !== "" && !isNaN(value))
                        devFreqMaster.holdValue("atten", value)
                })
                hold.connect(function() {
                    devFreqMaster.setHold("atten")
                    colorValue = devFreqMaster.showColor("atten")
                    txtValue = ""
                })
            }
        }

        ComboCombo {
            id: comboMasterRef
            posTop: 0
            posLeft: (rectMaster.width - marginWidget) / 2
            txtText: "10 Mhz " + qsTr("Ref")

            Component.onCompleted: {
                comboModel = Alert.addEnum("P_CH", qsTr("Channel") + " ")
                updated.connect(function (index) {
                    devFreqMaster.holdValue("ch_a", index)
                    devFreqSlave.holdValue("ch_a", index)
                })
                hold.connect(function() {
                    devFreqMaster.setHold("ch_a")
                    colorValue = devFreqMaster.showColor("ch_a")
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
            id: comboMasterRadioStat
            posTop: comboMasterAtten.posBottom
            posLeft: (rectMaster.width - marginWidget) / 4 * 2
            txtText: qsTr("Radio") + (devFreqUp ? qsTr("Output") : qsTr("Input"))

            Component.onCompleted: {
                masterGotData.connect(function() {
                    txtValue = devFreqMaster.showDisplay("radio_stat")
                    colorValue = devFreqMaster.showColor("radio_stat")
                })
            }
        }

        ComboText {
            id: comboMasterMidStat
            posTop: comboMasterAtten.posBottom
            posLeft: (rectMaster.width - marginWidget) / 4 * 3
            txtText: qsTr("Mid Freq") + (devFreqUp ? qsTr("Input") : qsTr("Output"))

            Component.onCompleted: {
                masterGotData.connect(function() {
                    txtValue = devFreqMaster.showDisplay("mid_stat")
                    colorValue = devFreqMaster.showColor("mid_stat")
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

        /*
        ComboText {
            id: comboMasterLOA2
            posTop: comboMasterVoltage.posBottom
            posLeft: (rectMaster.width - marginWidget) / 2
            txtText: qsTr("Local Oscillator") + " A2"

            Component.onCompleted: {
                masterGotData.connect(function() {
                    txtValue = devFreqMaster.showDisplay("lock_a2")
                    colorValue = devFreqMaster.showColor("lock_a2")
                })
            }
        }
        */

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

        Button {
            id: buttonMasterSubmit
            x: rectMaster.width - marginWidget - widthWidget
            y: comboMaster10Ref1.posBottom + marginWidget
            width: widthWidget
            height: heightWidget
            text: qsTr("Submit")

            onClicked: {
                comboMasterAtten.submit()
                comboMasterRef.submit()
                comboSlaveAtten.submit()
                comboSlaveRef.submit()
                devFreqMaster.createCntlMsg()
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

        ComboTextField {
            id: comboSlaveAtten
            posTop: 0
            posLeft: 0
            txtText: qsTr("Attenuation")

            Component.onCompleted: {
                slaveGotData.connect(function() {
                    if ((colorValue = devFreqSlave.showColor("atten")) !== Alert.MAP_COLOR["HOLDING"])
                        txtValue = devFreqSlave.showDisplay("atten") + " dB"
                })
                updated.connect(function (value) {
                    if (value !== "" && !isNaN(value))
                        devFreqSlave.holdValue("atten", value)
                })
                hold.connect(function() {
                    devFreqSlave.setHold("atten")
                    colorValue = devFreqSlave.showColor("atten")
                    txtValue = ""
                })
            }
        }

        ComboCombo {
            id: comboSlaveRef
            posTop: 0
            posLeft: (rectSlave.width - marginWidget) / 2
            txtText: "10 Mhz " + qsTr("Ref")

            Component.onCompleted: {
                comboModel = Alert.addEnum("P_CH", qsTr("Channel") + " ")
                updated.connect(function (index) {
                    devFreqMaster.holdValue("ch_b", index)
                    devFreqSlave.holdValue("ch_b", index)
                })
                hold.connect(function() {
                    devFreqSlave.setHold("ch_b")
                    colorValue = devFreqSlave.showColor("ch_b")
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
            id: comboSlaveRadioStat
            posTop: comboSlaveAtten.posBottom
            posLeft: (rectSlave.width - marginWidget) / 4 * 2
            txtText: qsTr("Radio") + (devFreqUp ? qsTr("Output") : qsTr("Input"))

            Component.onCompleted: {
                slaveGotData.connect(function() {
                    txtValue = devFreqSlave.showDisplay("radio_stat")
                    colorValue = devFreqSlave.showColor("radio_stat")
                })
            }
        }

        ComboText {
            id: comboSlaveMidStat
            posTop: comboSlaveAtten.posBottom
            posLeft: (rectSlave.width - marginWidget) / 4 * 3
            txtText: qsTr("Mid Freq") + (devFreqUp ? qsTr("Input") : qsTr("Output"))

            Component.onCompleted: {
                slaveGotData.connect(function() {
                    txtValue = devFreqSlave.showDisplay("mid_stat")
                    colorValue = devFreqSlave.showColor("mid_stat")
                })
            }
        }

        ComboText {
            id: comboSlaveLOB1
            posTop: comboSlaveVoltage.posBottom
            posLeft: 0
            txtText: qsTr("Local Oscillator") + " B1"

            Component.onCompleted: {
                slaveGotData.connect(function() {
                    txtValue = devFreqSlave.showDisplay("lock_b1")
                    colorValue = devFreqSlave.showColor("lock_b1")
                })
            }
        }

        /*
        ComboText {
            id: comboSlaveLOB2
            posTop: comboSlaveVoltage.posBottom
            posLeft: (rectSlave.width - marginWidget) / 2
            txtText: qsTr("Local Oscillator") + " B2"

            Component.onCompleted: {
                slaveGotData.connect(function() {
                    txtValue = devFreqSlave.showDisplay("lock_b2")
                    colorValue = devFreqSlave.showColor("lock_b2")
                })
            }
        }
        */

        ComboText {
            id: comboSlave10Ref1
            posTop: comboSlaveLOB1.posBottom
            posLeft: 0
            txtText: "10 MHz 1"

            Component.onCompleted: {
                slaveGotData.connect(function() {
                    txtValue = devFreqSlave.showDisplay("ref_3")
                    colorValue = devFreqSlave.showColor("ref_3")
                })
            }
        }

        ComboText {
            id: comboSlave10Ref2
            posTop: comboSlaveLOB1.posBottom
            posLeft: (rectSlave.width - marginWidget) / 4
            txtText: "10 MHz 2"

            Component.onCompleted: {
                slaveGotData.connect(function() {
                    txtValue = devFreqSlave.showDisplay("ref_4")
                    colorValue = devFreqSlave.showColor("ref_4")
                })
            }
        }

        ComboText {
            id: comboSlave16RefInner
            posTop: comboSlaveLOB1.posBottom
            posLeft: (rectSlave.width - marginWidget) / 4 * 2
            txtText: "10 MHz " + qsTr("Inner Ref")

            Component.onCompleted: {
                slaveGotData.connect(function() {
                    txtValue = devFreqSlave.showDisplay("ref_4")
                    colorValue = devFreqSlave.showColor("ref_4")
                })
            }
        }

        ComboText {
            id: comboSlaveCommunication
            posTop: comboSlave10Ref1.posBottom
            posLeft: 0
            txtText: "Network Communication"
        }

        ComboText {
            id: comboSlaveSignal
            posTop: comboSlave10Ref1.posBottom
            posLeft: (rectSlave.width - marginWidget) / 4 * 2
            txtText: "Control Signal"
        }

        Button {
            id: buttonSlaveSubmit
            x: rectSlave.width - marginWidget - widthWidget
            y: comboSlave10Ref1.posBottom + marginWidget
            width: widthWidget
            height: heightWidget
            text: qsTr("Submit")

            onClicked: {
                comboMasterAtten.submit()
                comboMasterRef.submit()
                comboSlaveAtten.submit()
                comboSlaveRef.submit()
                devFreqSlave.createCntlMsg()
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

    onClosing: {
        close.accepted = false
        this.hide()
    }
}
