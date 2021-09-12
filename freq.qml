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
    signal gotData()

    Component.onCompleted: {
        winFreq.opened.connect(function(devMaster, devSlave) {
            devFreqMaster = devMaster
            devFreqSlave = devSlave
            //comboMaster.model = devMaster.addEnum("P_NOR")
            //comboSlave.model = devSlave.addEnum("P_LOCK")

            name.text = devFreqMaster.name
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

        ComboCombo {
            id: comboMasterAtten
            posTop: 0
            posLeft: 0
            txtText: qsTr("Attenuation")
        }

        ComboCombo {
            id: comboMasterRefA
            posTop: 0
            posLeft: (rectMaster.width - marginWidget) / 3
            txtText: "10 Mhz " + qsTr("Ref")
        }

        ComboCombo {
            id: comboMasterRefB
            posTop: 0
            posLeft: (rectMaster.width - marginWidget) / 3 * 2
            txtText: "10 Mhz " + qsTr("Ref")
        }

        ComboText {
            id: comboMasterVoltage
            posTop: comboMasterAtten.posBottom
            posLeft: 0
            txtText: qsTr("Voltage")
        }

        ComboText {
            id: comboMasterCurrent
            posTop: comboMasterAtten.posBottom
            posLeft: (rectMaster.width - marginWidget) / 4
            txtText: qsTr("Current")
        }

        ComboText {
            id: comboMasterOutputStat
            posTop: comboMasterAtten.posBottom
            posLeft: (rectMaster.width - marginWidget) / 4 * 2
            txtText: qsTr("Radio Output")
        }

        ComboText {
            id: comboMasterInputStat
            posTop: comboMasterAtten.posBottom
            posLeft: (rectMaster.width - marginWidget) / 4 * 3
            txtText: qsTr("Mid Freq Input")
        }

        ComboText {
            id: comboMasterLOA1
            posTop: comboMasterVoltage.posBottom
            posLeft: 0
            txtText: qsTr("Local Oscillator") + " A1"
        }

        ComboText {
            id: comboMasterLOA2
            posTop: comboMasterVoltage.posBottom
            posLeft: (rectMaster.width - marginWidget) / 4
            txtText: qsTr("Local Oscillator") + " A1"
        }

        ComboText {
            id: comboMasterLOB1
            posTop: comboMasterVoltage.posBottom
            posLeft: (rectMaster.width - marginWidget) / 4 * 2
            txtText: qsTr("Local Oscillator") + " B1"
        }

        ComboText {
            id: comboMasterLOB2
            posTop: comboMasterVoltage.posBottom
            posLeft: (rectMaster.width - marginWidget) / 4 * 3
            txtText: qsTr("Local Oscillator") + " B2"
        }

        ComboText {
            id: comboMaster10Ref1
            posTop: comboMasterLOA1.posBottom
            posLeft: 0
            txtText: "10 MHz 1"
        }

        ComboText {
            id: comboMaster10Ref2
            posTop: comboMasterLOA1.posBottom
            posLeft: (rectMaster.width - marginWidget) / 4
            txtText: "10 MHz 2"
        }

        ComboText {
            id: comboMaster10RefInner
            posTop: comboMasterLOA1.posBottom
            posLeft: (rectMaster.width - marginWidget) / 4 * 2
            txtText: "10 MHz " + qsTr("Inner Ref")
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

        ComboCombo {
            id: comboSlaveAtten
            posTop: 0
            posLeft: 0
            txtText: qsTr("Attenuation")
        }

        ComboCombo {
            id: comboSlaveRefA
            posTop: 0
            posLeft: (rectSlave.width - marginWidget) / 3
            txtText: "10 Mhz " + qsTr("Ref")
        }

        ComboCombo {
            id: comboSlaveRefB
            posTop: 0
            posLeft: (rectSlave.width - marginWidget) / 3 * 2
            txtText: "10 Mhz " + qsTr("Ref")
        }

        ComboText {
            id: comboSlaveVoltage
            posTop: comboSlaveAtten.posBottom
            posLeft: 0
            txtText: qsTr("Voltage")
        }

        ComboText {
            id: comboSlaveCurrent
            posTop: comboSlaveAtten.posBottom
            posLeft: (rectSlave.width - marginWidget) / 4
            txtText: qsTr("Current")
        }

        ComboText {
            id: comboSlaveOutputStat
            posTop: comboSlaveAtten.posBottom
            posLeft: (rectSlave.width - marginWidget) / 4 * 2
            txtText: qsTr("Radio Output")
        }

        ComboText {
            id: comboSlaveInputStat
            posTop: comboSlaveAtten.posBottom
            posLeft: (rectSlave.width - marginWidget) / 4 * 3
            txtText: qsTr("Mid Freq Input")
        }

        ComboText {
            id: comboSlaveLOA1
            posTop: comboSlaveVoltage.posBottom
            posLeft: 0
            txtText: qsTr("Local Oscillator") + " A1"
        }

        ComboText {
            id: comboSlaveLOA2
            posTop: comboSlaveVoltage.posBottom
            posLeft: (rectSlave.width - marginWidget) / 4
            txtText: qsTr("Local Oscillator") + " A1"
        }

        ComboText {
            id: comboSlaveLOB1
            posTop: comboSlaveVoltage.posBottom
            posLeft: (rectSlave.width - marginWidget) / 4 * 2
            txtText: qsTr("Local Oscillator") + " B1"
        }

        ComboText {
            id: comboSlaveLOB2
            posTop: comboSlaveVoltage.posBottom
            posLeft: (rectSlave.width - marginWidget) / 4 * 3
            txtText: qsTr("Local Oscillator") + " B2"
        }

        ComboText {
            id: comboSlave16Ref1
            posTop: comboSlaveLOA1.posBottom
            posLeft: 0
            txtText: "16 MHz 1"
        }

        ComboText {
            id: comboSlave16Ref2
            posTop: comboSlaveLOA1.posBottom
            posLeft: (rectSlave.width - marginWidget) / 4
            txtText: "16 MHz 2"
        }

        ComboText {
            id: comboSlave16RefInner
            posTop: comboSlaveLOA1.posBottom
            posLeft: (rectSlave.width - marginWidget) / 4 * 2
            txtText: "16 MHz " + qsTr("Inner Ref")
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
