import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.3
import QtQuick.Window 2.15

import rdss.alert 1.0

Window {
    readonly property int heightWidget: 30
    readonly property int marginWidget: 15
    readonly property int widthWidgetLabel: 150
    readonly property int widthWidget: 150
    readonly property int marginRect: 30
    property bool devFreqUp: false
    property alias masterCommunicationColorValue: comboMasterCommunication.colorValue
    property alias slaveCommunicationColorValue: comboSlaveCommunication.colorValue

    id: winFreq
    visible: false
    modality: Qt.ApplicationModal
    width: rectMaster.width + 2 * marginRect
    height: 2 * rectMaster.height + heightWidget + 3 * marginRect + marginWidget
    title: qsTr("Frequency Conversion Device")

    property QtObject devFreqMaster: null
    property QtObject devFreqSlave: null
    signal opened(QtObject devMaster, QtObject devSlave, bool devUp)
    signal masterRefreshData()
    signal slaveRefreshData()

    Component.onCompleted: {
        winFreq.opened.connect(function(devMaster, devSlave, devUp) {
            devFreqMaster = devMaster
            devFreqSlave = devSlave
            devFreqUp = devUp
            name.text = devFreqMaster.name
            devMaster.gotData.connect(masterRefreshData)
            devSlave.gotData.connect(slaveRefreshData)
            masterRefreshData()
            slaveRefreshData()
        })
    }

    onClosing: {
        close.accepted = false
        this.hide()
        devFreqMaster.gotData.disconnect(masterRefreshData)
        devFreqSlave.gotData.disconnect(slaveRefreshData)
        name.text = ""
        devFreqMaster = null
        devFreqSlave = null
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

    ComboText {
        id: comboChannel
        posLeft: marginRect + rectMaster.width - widthWidget - widthWidgetLabel - 3 * marginWidget
        posTop: marginRect - marginWidget
        txtText: devFreqMaster ? devFreqMaster.varName("masterslave") : qsTr("Current State")

        Component.onCompleted: {
            masterRefreshData.connect(function() {
                txtValue = devFreqMaster.showDisplay("masterslave")
                colorValue = devFreqMaster.showColor("masterslave")
            })
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

        ComboText {
            id: comboMasterAtten
            posTop: 0
            posLeft: 0
            txtText: devFreqMaster ? devFreqMaster.varName("atten") : qsTr("Attenuation")

            Component.onCompleted: {
                masterRefreshData.connect(function() {
                    txtValue = devFreqMaster.showDisplay("atten") + " dB"
                    colorValue = devFreqMaster.showColor("atten")
                })
            }
        }

        ComboText {
            id: comboMasterVoltage
            posTop: comboMasterAtten.posBottom
            posLeft: 0
            txtText: devFreqMaster ? devFreqMaster.varName("voltage") : qsTr("Voltage")

            Component.onCompleted: {
                masterRefreshData.connect(function() {
                    txtValue = devFreqMaster.showDisplay("voltage") + " V"
                    colorValue = devFreqMaster.showColor("voltage")
                })
            }
        }

        ComboText {
            id: comboMasterCurrent
            posTop: comboMasterAtten.posBottom
            posLeft: (rectMaster.width - marginWidget) / 4
            txtText: devFreqMaster ? devFreqMaster.varName("current") : qsTr("Current")

            Component.onCompleted: {
                masterRefreshData.connect(function() {
                    txtValue = devFreqMaster.showDisplay("current") + " mA"
                    colorValue = devFreqMaster.showColor("current")
                })
            }
        }

        ComboText {
            id: comboMasterRadioStat
            posTop: comboMasterAtten.posBottom
            posLeft: (rectMaster.width - marginWidget) / 2
            txtText: qsTr("Radio") + (devFreqUp ? qsTr("Output") : qsTr("Input"))

            Component.onCompleted: {
                masterRefreshData.connect(function() {
                    txtValue = devFreqMaster.showDisplay("radio_stat")
                    colorValue = devFreqMaster.showColor("radio_stat")
                })
            }
        }

        ComboText {
            id: comboMasterMidStat
            posTop: comboMasterAtten.posBottom
            posLeft: (rectMaster.width - marginWidget) * 3 / 4
            txtText: qsTr("Mid Freq") + (devFreqUp ? qsTr("Input") : qsTr("Output"))

            Component.onCompleted: {
                masterRefreshData.connect(function() {
                    txtValue = devFreqMaster.showDisplay("mid_stat")
                    colorValue = devFreqMaster.showColor("mid_stat")
                })
            }
        }

        ComboText {
            id: comboMasterLOA1
            posTop: comboMasterVoltage.posBottom
            posLeft: 0
            txtText: devFreqMaster ? devFreqMaster.varName("lock_a1") : qsTr("Local Oscillator") + " A1"

            Component.onCompleted: {
                masterRefreshData.connect(function() {
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
            txtText: devFreqMaster ? devFreqMaster.varName("lock_a2") : qsTr("Local Oscillator") + " A2"

            Component.onCompleted: {
                masterRefreshData.connect(function() {
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
            txtText: devFreqMaster ? devFreqMaster.varName("ref_10_1") : "10 MHz 1"

            Component.onCompleted: {
                masterRefreshData.connect(function() {
                    txtValue = devFreqMaster.showDisplay("ref_10_1")
                    colorValue = devFreqMaster.showColor("ref_10_1")
                })
            }
        }

        ComboText {
            id: comboMaster10Ref2
            posTop: comboMasterLOA1.posBottom
            posLeft: (rectMaster.width - marginWidget) / 4
            txtText: devFreqMaster ? devFreqMaster.varName("ref_10_2") : "10 MHz 2"

            Component.onCompleted: {
                masterRefreshData.connect(function() {
                    txtValue = devFreqMaster.showDisplay("ref_10_2")
                    colorValue = devFreqMaster.showColor("ref_10_2")
                })
            }
        }

        ComboText {
            id: comboMaster10RefInner
            posTop: comboMasterLOA1.posBottom
            posLeft: (rectMaster.width - marginWidget) / 2
            txtText: devFreqMaster ? devFreqMaster.varName("ref_inner_1") : "10 MHz " + qsTr("Inner Ref")

            Component.onCompleted: {
                masterRefreshData.connect(function() {
                    txtValue = devFreqMaster.showDisplay("ref_inner_1")
                    colorValue = devFreqMaster.showColor("ref_inner_1")
                })
            }
        }

        ComboText {
            id: comboMasterCommunication
            posTop: comboMaster10Ref1.posBottom
            posLeft: 0
            txtText: qsTr("Network Communication")
            fontSize: timerStringFontSize
            txtValue: devFreqMaster ? devFreqMaster.timerStr : qsTr("No data")
        }

        ComboText {
            id: comboMasterSignal
            posTop: comboMaster10Ref1.posBottom
            posLeft: (rectMaster.width - marginWidget) / 2
            txtText: devFreqMaster ? devFreqMaster.varName("handshake") : qsTr("Handshake Signal")

            Component.onCompleted: {
                masterRefreshData.connect(function() {
                    txtValue = devFreqMaster.showDisplay("handshake")
                    colorValue = devFreqMaster.showColor("handshake")
                })
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

        ComboText {
            id: comboSlaveAtten
            posTop: 0
            posLeft: 0
            txtText: devFreqSlave ? devFreqSlave.varName("atten") : qsTr("Attenuation")

            Component.onCompleted: {
                slaveRefreshData.connect(function() {
                    txtValue = devFreqSlave.showDisplay("atten") + " dB"
                    colorValue = devFreqSlave.showColor("atten")
                })
            }
        }

        ComboText {
            id: comboSlaveVoltage
            posTop: comboSlaveAtten.posBottom
            posLeft: 0
            txtText: devFreqSlave ? devFreqSlave.varName("voltage") : qsTr("Voltage")

            Component.onCompleted: {
                slaveRefreshData.connect(function() {
                    txtValue = devFreqSlave.showDisplay("voltage") + " V"
                    colorValue = devFreqSlave.showColor("voltage")
                })
            }
        }

        ComboText {
            id: comboSlaveCurrent
            posTop: comboSlaveAtten.posBottom
            posLeft: (rectSlave.width - marginWidget) / 4
            txtText: devFreqSlave ? devFreqSlave.varName("current") : qsTr("Current")

            Component.onCompleted: {
                slaveRefreshData.connect(function() {
                    txtValue = devFreqSlave.showDisplay("current") + " mA"
                    colorValue = devFreqSlave.showColor("current")
                })
            }
        }

        ComboText {
            id: comboSlaveRadioStat
            posTop: comboSlaveAtten.posBottom
            posLeft: (rectSlave.width - marginWidget) / 2
            txtText: qsTr("Radio") + (devFreqUp ? qsTr("Output") : qsTr("Input"))

            Component.onCompleted: {
                slaveRefreshData.connect(function() {
                    txtValue = devFreqSlave.showDisplay("radio_stat")
                    colorValue = devFreqSlave.showColor("radio_stat")
                })
            }
        }

        ComboText {
            id: comboSlaveMidStat
            posTop: comboSlaveAtten.posBottom
            posLeft: (rectSlave.width - marginWidget) * 3 / 4
            txtText: qsTr("Mid Freq") + (devFreqUp ? qsTr("Input") : qsTr("Output"))

            Component.onCompleted: {
                slaveRefreshData.connect(function() {
                    txtValue = devFreqSlave.showDisplay("mid_stat")
                    colorValue = devFreqSlave.showColor("mid_stat")
                })
            }
        }

        ComboText {
            id: comboSlaveLOB1
            posTop: comboSlaveVoltage.posBottom
            posLeft: 0
            txtText: devFreqSlave ? devFreqSlave.varName("lock_b1") : qsTr("Local Oscillator") + " B1"

            Component.onCompleted: {
                slaveRefreshData.connect(function() {
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
            txtText: devFreqSlave ? devFreqSlave.varName("lock_b2") : qsTr("Local Oscillator") + " B2"

            Component.onCompleted: {
                slaveRefreshData.connect(function() {
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
            txtText: devFreqSlave ? devFreqSlave.varName("ref_10_3") : "10 MHz 1"

            Component.onCompleted: {
                slaveRefreshData.connect(function() {
                    txtValue = devFreqSlave.showDisplay("ref_10_3")
                    colorValue = devFreqSlave.showColor("ref_10_3")
                })
            }
        }

        ComboText {
            id: comboSlave10Ref2
            posTop: comboSlaveLOB1.posBottom
            posLeft: (rectSlave.width - marginWidget) / 4
            txtText: devFreqSlave ? devFreqSlave.varName("ref_10_4") : "10 MHz 2"

            Component.onCompleted: {
                slaveRefreshData.connect(function() {
                    txtValue = devFreqSlave.showDisplay("ref_10_4")
                    colorValue = devFreqSlave.showColor("ref_10_4")
                })
            }
        }

        ComboText {
            id: comboSlave16RefInner
            posTop: comboSlaveLOB1.posBottom
            posLeft: (rectSlave.width - marginWidget) / 2
            txtText: devFreqSlave ? devFreqSlave.varName("ref_inner_2") : "10 MHz " + qsTr("Inner Ref")

            Component.onCompleted: {
                slaveRefreshData.connect(function() {
                    txtValue = devFreqSlave.showDisplay("ref_inner_2")
                    colorValue = devFreqSlave.showColor("ref_inner_2")
                })
            }
        }

        ComboText {
            id: comboSlaveCommunication
            posTop: comboSlave10Ref1.posBottom
            posLeft: 0
            txtText: qsTr("Network Communication")
            fontSize: timerStringFontSize
            txtValue: devFreqSlave ? devFreqSlave.timerStr : qsTr("No data")
        }

        ComboText {
            id: comboSlaveSignal
            posTop: comboSlave10Ref1.posBottom
            posLeft: (rectSlave.width - marginWidget) / 2
            txtText: devFreqSlave ? devFreqSlave.varName("handshake") : qsTr("Handshake Signal")

            Component.onCompleted: {
                slaveRefreshData.connect(function() {
                    txtValue = devFreqSlave.showDisplay("handshake")
                    colorValue = devFreqSlave.showColor("handshake")
                })
            }
        }
    }
}
