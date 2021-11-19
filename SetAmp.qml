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
            if (channelMaster) {
                devAmpMaster.holdValue("remote", comboMasterRemote.index)
                devAmpMaster.holdValue("radio", comboMasterRadio.index)
                devAmpMaster.holdValue("atten_mode", comboMasterAttenMode.index)
                devAmpMaster.holdValue("atten", comboMasterAtten.txtValue)
                devAmpMaster.holdValue("output_power", comboMasterPower.txtValue)
                devAmpMaster.holdValue("gain", comboMasterGain.txtValue)
                devAmpMaster.setStandby = true
                devAmpSlave.setStandby = false
                devAmpMaster.createCntlMsg()
                devAmpMaster.releaseHold("remote")
                devAmpMaster.releaseHold("radio")
                devAmpMaster.releaseHold("atten_mode")
                devAmpMaster.releaseHold("atten")
                devAmpMaster.releaseHold("output_power")
                devAmpMaster.releaseHold("gain")
            } else {
                devAmpSlave.holdValue("remote", comboSlaveRemote.index)
                devAmpSlave.holdValue("radio", comboSlaveRadio.index)
                devAmpSlave.holdValue("atten_mode", comboSlaveAttenMode.index)
                devAmpSlave.holdValue("atten", comboSlaveAtten.txtValue)
                devAmpSlave.holdValue("output_power", comboSlavePower.txtValue)
                devAmpSlave.holdValue("gain", comboSlaveGain.txtValue)
                devAmpMaster.setStandby = false
                devAmpSlave.setStandby = true
                devAmpSlave.createCntlMsg()
                devAmpSlave.releaseHold("remote")
                devAmpSlave.releaseHold("radio")
                devAmpSlave.releaseHold("atten_mode")
                devAmpSlave.releaseHold("atten")
                devAmpSlave.releaseHold("output_power")
                devAmpSlave.releaseHold("gain")
            }
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
