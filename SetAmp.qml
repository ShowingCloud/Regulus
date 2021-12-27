import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.3

import rdss.alert 1.0

Dialog {
    id: winSetAmp
    width: rect.width + 2 * defaultMarginRect
    height: rect.height + defaultHeightWidget + 2 * defaultMarginRect + defaultMarginWidget
    standardButtons: Dialog.NoButton
    title: qsTr("Amplification Device")

    property int extendedWidthWidget : defaultWidthWidget + 2 * defaultWidthPrefixSuffix
    property int extendedWidthWidgetLabel: defaultWidthWidgetLabel + 2 * defaultMarginWidget
    property bool channelMaster: true

    required property QtObject devAmpMaster
    required property QtObject devAmpSlave
    property alias dialogName : name.text
    property alias valueChannel : comboChannel.index
    property alias valueMasterRemote : comboMasterRemote.index
    property alias valueMasterRadio : comboMasterRadio.index
    property alias valueMasterAttenMode : comboMasterAttenMode.index
    property alias valueMasterAtten : comboMasterAtten.txtValue
    property alias valueMasterPower : comboMasterPower.txtValue
    property alias valueMasterGain : comboMasterGain.txtValue
    property alias valueSlaveRemote : comboSlaveRemote.index
    property alias valueSlaveRadio : comboSlaveRadio.index
    property alias valueSlaveAttenMode : comboSlaveAttenMode.index
    property alias valueSlaveAtten : comboSlaveAtten.txtValue
    property alias valueSlavePower : comboSlavePower.txtValue
    property alias valueSlaveGain : comboSlaveGain.txtValue

    Text {
        id: name
        x: -10 + defaultMarginRect + defaultMarginWidget
        y: -15 + defaultMarginRect
        height: defaultHeightWidget
        width: 2 * defaultWidthWidget
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: defaultLabelFontSize
    }

    Button {
        id: buttonCancel
        x: -10 + defaultMarginRect + rect.width - defaultMarginWidget - extendedWidthWidget
        anchors.top: name.top
        width: extendedWidthWidget
        height: defaultHeightWidget
        text: qsTr("Cancel")
        font.pixelSize: defaultLabelFontSize

        onClicked: winSetAmp.close()
    }

    DiaConfirm {
        id: diaConfirm
        onAccepted: {
            if (channelMaster) {
                devAmpMaster.setStandby = true
                devAmpSlave.setStandby = false
                devAmpMaster.createCntlMsg()
            } else {
                devAmpMaster.setStandby = false
                devAmpSlave.setStandby = true
                devAmpSlave.createCntlMsg()
            }
            close()
        }
        onRejected: {
            devAmpMaster.releaseHold("remote")
            devAmpMaster.releaseHold("radio")
            devAmpMaster.releaseHold("atten_mode")
            devAmpMaster.releaseHold("atten")
            devAmpMaster.releaseHold("output_power")
            devAmpMaster.releaseHold("gain")
            devAmpSlave.releaseHold("remote")
            devAmpSlave.releaseHold("radio")
            devAmpSlave.releaseHold("atten_mode")
            devAmpSlave.releaseHold("atten")
            devAmpSlave.releaseHold("output_power")
            devAmpSlave.releaseHold("gain")
            close()
        }
    }

    Button {
        id: buttonSubmit
        anchors.right: buttonCancel.left
        anchors.rightMargin: defaultMarginWidget
        anchors.top: name.top
        width: extendedWidthWidget
        height: defaultHeightWidget
        text: qsTr("Submit")
        font.pixelSize: defaultLabelFontSize

        onClicked: {
            diaConfirm.reset()
            diaConfirm.append(qsTr("Sending"), "black")
            var error = false

            if (channelMaster) {
                devAmpMaster.holdValue("remote", comboMasterRemote.index)
                diaConfirm.append(comboMasterRemote.txtText + ": "
                                  + comboMasterRemote.comboModel[comboMasterRemote.index],
                                  "black")
                devAmpMaster.holdValue("radio", comboMasterRadio.index)
                diaConfirm.append(comboMasterRadio.txtText + ": "
                                  + comboMasterRadio.comboModel[comboMasterRadio.index],
                                  "black")

                devAmpMaster.holdValue("atten", 11)
                devAmpMaster.holdValue("output_power", 47.7)
                devAmpMaster.holdValue("gain", 59.0)

                var text = "", color = "black"
                if (comboMasterAttenMode.index === Alert.P_ATTEN_NORMAL) {
                    devAmpMaster.holdValue("atten", comboMasterAtten.txtValue)
                    text = comboMasterAtten.txtText + ": " + comboMasterAtten.txtValue
                    if (parseFloat(comboMasterAtten.txtValue) > comboMasterAtten.upperLimit) {
                        text += ", " + qsTr("Upper than limit: ") + comboMasterAtten.upperLimit
                        color = "red"
                        error = true
                    } else if (parseFloat(comboMasterAtten.txtValue) < comboMasterAtten.lowerLimit) {
                        text += ", " + qsTr("Lower than limit: ") + comboMasterAtten.lowerLimit
                        color = "red"
                        error = true
                    }
                } else if (comboMasterAttenMode.index === Alert.P_ATTEN_CONSTPOWER) {
                    devAmpMaster.holdValue("output_power", comboMasterPower.txtValue)
                    text = comboMasterPower.txtText + ": " + comboMasterPower.txtValue
                    if (parseFloat(comboMasterPower.txtValue) > comboMasterPower.upperLimit) {
                        text += ", " + qsTr("Upper than limit: ") + comboMasterPower.upperLimit
                        color = "red"
                        error = true
                    } else if (parseFloat(comboMasterPower.txtValue) < comboMasterPower.lowerLimit) {
                        text += ", " + qsTr("Lower than limit: ") + comboMasterPower.lowerLimit
                        color = "red"
                        error = true
                    }
                } else {
                    devAmpMaster.holdValue("gain", comboMasterGain.txtValue)
                    text = comboMasterGain.txtText + ": " + comboMasterGain.txtValue
                    if (parseFloat(comboMasterGain.txtValue) > comboMasterGain.upperLimit) {
                        text += ", " + qsTr("Upper than limit: ") + comboMasterGain.upperLimit
                        color = "red"
                        error = true
                    } else if (parseFloat(comboMasterGain.txtValue) < comboMasterGain.lowerLimit) {
                        text += ", " + qsTr("Lower than limit: ") + comboMasterGain.lowerLimit
                        color = "red"
                        error = true
                    }
                }
                diaConfirm.append(text, color)

                devAmpMaster.holdValue("atten_mode", comboMasterAttenMode.index)
                diaConfirm.append(comboMasterAttenMode.txtText + ": "
                                  + comboMasterAttenMode.comboModel[comboMasterAttenMode.index],
                                  "black")
            } else {
                devAmpSlave.holdValue("remote", comboSlaveRemote.index)
                devAmpSlave.holdValue("radio", comboSlaveRadio.index)

                devAmpSlave.holdValue("atten", 11)
                devAmpSlave.holdValue("output_power", 47.7)
                devAmpSlave.holdValue("gain", 59.0)

                if (comboSlaveAttenMode.index === Alert.P_ATTEN_NORMAL)
                    devAmpSlave.holdValue("atten", comboSlaveAtten.txtValue)
                else if (comboSlaveAttenMode.index === Alert.P_ATTEN_CONSTPOWER)
                    devAmpSlave.holdValue("output_power", comboSlavePower.txtValue)
                else
                    devAmpSlave.holdValue("gain", comboSlaveGain.txtValue)

                devAmpSlave.holdValue("atten_mode", comboSlaveAttenMode.index)
            }
            diaConfirm.standardButtons = Dialog.Cancel
            if (error) {
                diaConfirm.append(qsTr("Not sendable due to above errors."), "red")
            } else {
                diaConfirm.standardButtons |= Dialog.Ok
            }
            diaConfirm.open()
        }
    }

    Rectangle {
        id: rect
        x: -10 + defaultMarginRect
        anchors.top: name.bottom
        anchors.topMargin: defaultMarginWidget
        width: 2 * extendedWidthWidget + 2 * extendedWidthWidgetLabel + 5 * defaultMarginWidget
        height: 5 * defaultHeightWidget + 6 * defaultMarginWidget
        border.width: defaultBorderWidth

        MouseArea {
            id: mouse
            anchors.fill: parent
            onClicked: name.focus = true
        }

        ComboCombo {
            id: comboChannel
            posLeft: 0
            posTop: 0
            widthWidget: extendedWidthWidget
            widthWidgetLabel: extendedWidthWidgetLabel
            txtText: devAmpMaster ? devAmpMaster.varName("masterslave") : qsTr("Current State")

            Component.onCompleted: {
                comboModel = Alert.addEnum("P_MS")
            }
            onChangedIndex: {
                if (index === Alert.P_MS_MASTER)
                    channelMaster = true
                else if (index === Alert.P_MS_SLAVE)
                    channelMaster = false
            }
        }

        Rectangle {
            id: masterDisabler
            x: 0
            y: comboChannel.posBottom
            height: 2 * defaultHeightWidget + 3 * defaultMarginWidget
            width: rect.width
            color: "black"
            opacity: 0.5
            z: 10
            visible: !channelMaster

            MouseArea {
                id: masterMouseDev
                anchors.fill: parent
                onClicked: name.focus = true
            }
        }

        ComboCombo {
            id: comboMasterAttenMode
            posTop: comboChannel.posBottom
            posLeft: 0
            widthWidget: extendedWidthWidget
            widthWidgetLabel: extendedWidthWidgetLabel
            txtText: qsTr("Master") + ": " + (devAmpMaster ? devAmpMaster.varName("atten_mode") : qsTr("Attenuation Mode"))

            Component.onCompleted: {
                comboModel = Alert.addEnum("P_ATTEN")
            }
            onChangedIndex: {
                comboMasterAtten.visible = false
                comboMasterPower.visible = false
                comboMasterGain.visible = false
                if (index === Alert.P_ATTEN_NORMAL)
                    comboMasterAtten.visible = true
                else if (index === Alert.P_ATTEN_CONSTPOWER)
                    comboMasterPower.visible = true
                else
                    comboMasterGain.visible = true
            }
        }

        ComboTextField {
            id: comboMasterAtten
            posTop: comboChannel.posBottom
            posLeft: (rect.width - defaultMarginWidget) / 2
            widthWidgetLabel: extendedWidthWidgetLabel
            widthWidget: defaultWidthWidget
            widthPrefixSuffix: defaultWidthPrefixSuffix
            txtSuffix: "dB"
            txtText: qsTr("Master") + ": " + (devAmpMaster ? devAmpMaster.varName("atten") : qsTr("Attenuation"))
            lowerLimit: 0
            upperLimit: 22
        }

        ComboTextField {
            id: comboMasterPower
            posTop: comboChannel.posBottom
            posLeft: (rect.width - defaultMarginWidget) / 2
            widthWidgetLabel: extendedWidthWidgetLabel
            widthWidget: defaultWidthWidget
            widthPrefixSuffix: defaultWidthPrefixSuffix
            txtSuffix: "dBm"
            txtText: qsTr("Master") + ": " + (devAmpMaster ? devAmpMaster.varName("output_power") : qsTr("Output Power"))
            lowerLimit: 36.7
            upperLimit: 58.7
        }

        ComboTextField {
            id: comboMasterGain
            posTop: comboChannel.posBottom
            posLeft: (rect.width - defaultMarginWidget) / 2
            widthWidgetLabel: extendedWidthWidgetLabel
            widthWidget: defaultWidthWidget
            widthPrefixSuffix: defaultWidthPrefixSuffix
            txtSuffix: "dBm"
            txtText: qsTr("Master") + ": " + (devAmpMaster ? devAmpMaster.varName("gain") : qsTr("Gain"))
            lowerLimit: 48
            upperLimit: 70
        }

        ComboCombo {
            id: comboMasterRemote
            posTop: comboMasterAttenMode.posBottom
            posLeft: 0
            widthWidgetLabel: extendedWidthWidgetLabel
            widthWidget: extendedWidthWidget
            txtText: qsTr("Master") + ": " + (devAmpMaster ? devAmpMaster.varName("remote") : qsTr("Remote Mode"))

            Component.onCompleted: {
                comboModel = Alert.addEnum("P_REMOTE")
            }
        }

        ComboCombo {
            id: comboMasterRadio
            posTop: comboMasterAttenMode.posBottom
            posLeft: (rect.width - defaultMarginWidget) / 2
            widthWidgetLabel: extendedWidthWidgetLabel
            widthWidget: extendedWidthWidget
            txtText: qsTr("Master") + ": " + (devAmpMaster ? devAmpMaster.varName("radio") : qsTr("Silent Mode"))

            Component.onCompleted: {
                comboModel = Alert.addEnum("P_RADIO")
            }
        }

        Rectangle {
            id: slaveDisabler
            x: 0
            y: comboMasterRemote.posBottom
            height: 2 * defaultHeightWidget + 3 * defaultMarginWidget
            width: rect.width
            color: "black"
            opacity: 0.5
            z: 10
            visible: channelMaster

            MouseArea {
                id: slaveMouseDev
                anchors.fill: parent
                onClicked: name.focus = true
            }
        }

        ComboCombo {
            id: comboSlaveAttenMode
            posTop: comboMasterRemote.posBottom
            posLeft: 0
            widthWidget: extendedWidthWidget
            widthWidgetLabel: extendedWidthWidgetLabel
            txtText: qsTr("Slave") + ": " + (devAmpSlave ? devAmpSlave.varName("atten_mode") : qsTr("Attenuation Mode"))

            Component.onCompleted: {
                comboModel = Alert.addEnum("P_ATTEN")
            }
            onChangedIndex: {
                comboSlaveAtten.visible = false
                comboSlavePower.visible = false
                comboSlaveGain.visible = false
                if (index === Alert.P_ATTEN_NORMAL)
                    comboSlaveAtten.visible = true
                else if (index === Alert.P_ATTEN_CONSTPOWER)
                    comboSlavePower.visible = true
                else
                    comboSlaveGain.visible = true
            }

        }
        ComboTextField {
            id: comboSlaveAtten
            posTop: comboMasterRemote.posBottom
            posLeft: (rect.width - defaultMarginWidget) / 2
            widthWidgetLabel: extendedWidthWidgetLabel
            widthWidget: defaultWidthWidget
            widthPrefixSuffix: defaultWidthPrefixSuffix
            txtSuffix: "dB"
            txtText: qsTr("Slave") + ": " + (devAmpSlave ? devAmpSlave.varName("atten") : qsTr("Attenuation"))
            lowerLimit: 0
            upperLimit: 22
        }

        ComboTextField {
            id: comboSlavePower
            posTop: comboMasterRemote.posBottom
            posLeft: (rect.width - defaultMarginWidget) / 2
            widthWidgetLabel: extendedWidthWidgetLabel
            widthWidget: defaultWidthWidget
            widthPrefixSuffix: defaultWidthPrefixSuffix
            txtSuffix: "dBm"
            txtText: qsTr("Slave") + ": " + (devAmpSlave ? devAmpSlave.varName("output_power") : qsTr("Output Power"))
            lowerLimit: 36.7
            upperLimit: 58.7
        }

        ComboTextField {
            id: comboSlaveGain
            posTop: comboMasterRemote.posBottom
            posLeft: (rect.width - defaultMarginWidget) / 2
            widthWidgetLabel: extendedWidthWidgetLabel
            widthWidget: defaultWidthWidget
            widthPrefixSuffix: defaultWidthPrefixSuffix
            txtSuffix: "dBm"
            txtText: qsTr("Slave") + ": " + (devAmpSlave ? devAmpSlave.varName("gain") : qsTr("Gain"))
            lowerLimit: 48
            upperLimit: 70
        }

        ComboCombo {
            id: comboSlaveRemote
            posTop: comboSlaveAttenMode.posBottom
            posLeft: 0
            widthWidgetLabel: extendedWidthWidgetLabel
            widthWidget: extendedWidthWidget
            txtText: qsTr("Slave") + ": " + (devAmpSlave ? devAmpSlave.varName("remote") : qsTr("Remote Mode"))

            Component.onCompleted: {
                comboModel = Alert.addEnum("P_REMOTE")
            }
        }

        ComboCombo {
            id: comboSlaveRadio
            posTop: comboSlaveAttenMode.posBottom
            posLeft: (rect.width - defaultMarginWidget) / 2
            widthWidgetLabel: extendedWidthWidgetLabel
            widthWidget: extendedWidthWidget
            txtText: qsTr("Slave") + ": " + (devAmpSlave ? devAmpSlave.varName("radio") : qsTr("Silent Mode"))

            Component.onCompleted: {
                comboModel = Alert.addEnum("P_RADIO")
            }
        }
    }
}
