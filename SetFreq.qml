import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.3

import rdss.alert 1.0

Dialog {
    id: winSetFreq
    width: rect.width + 2 * defaultMarginRect
    height: rect.height + defaultHeightWidget + 2 * defaultMarginRect + defaultMarginWidget
    standardButtons: Dialog.NoButton
    title: qsTr("Frequency Conversion Device")

    property int extendedWidthWidget : defaultWidthWidget + 2 * defaultMarginAndTextWidthHeight
    property int extendedWidthWidgetLabel: defaultWidthWidgetLabel + 2 * defaultMarginWidget
    property bool channelMaster: true

    required property QtObject devFreqMaster
    required property QtObject devFreqSlave
    property alias dialogName : name.text
    property alias valueChannel : comboChannel.index
    property alias valueMasterAtten : comboMasterAtten.txtValue
    property alias valueMasterRef : comboMasterRef.index
    property alias valueSlaveAtten : comboSlaveAtten.txtValue
    property alias valueSlaveRef : comboSlaveRef.index

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

        onClicked: winSetFreq.close()
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
                devFreqMaster.holdValue("ch_a", comboMasterRef.index)
                devFreqMaster.holdValue("ch_b", comboSlaveRef.index)
                devFreqMaster.holdValue("atten", comboMasterAtten.txtValue)
                devFreqMaster.createCntlMsg()
                devFreqMaster.releaseHold("ch_a")
                devFreqMaster.releaseHold("ch_b")
                devFreqMaster.releaseHold("atten")
            } else {
                devFreqSlave.holdValue("ch_a", comboMasterRef.index)
                devFreqSlave.holdValue("ch_b", comboSlaveRef.index)
                devFreqSlave.holdValue("atten", comboSlaveAtten.txtValue)
                devFreqSlave.createCntlMsg()
                devFreqSlave.releaseHold("ch_a")
                devFreqSlave.releaseHold("ch_b")
                devFreqSlave.releaseHold("atten")
            }
        }
    }

    Rectangle {
        id: rect
        x: -10 + defaultMarginRect
        anchors.top: name.bottom
        anchors.topMargin: defaultMarginWidget
        width: 2 * extendedWidthWidget + 2 * extendedWidthWidgetLabel + 5 * defaultMarginWidget
        height: 3 * defaultHeightWidget + 4 * defaultMarginWidget
        border.width: defaultBorderWidth

        ComboCombo {
            id: comboChannel
            posLeft: 0
            posTop: 0
            widthWidget: extendedWidthWidget
            widthWidgetLabel: extendedWidthWidgetLabel
            txtText: devFreqMaster ? devFreqMaster.varName("masterslave") : qsTr("Current State")

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
            height: defaultHeightWidget + 2 * defaultMarginWidget
            width: rect.width
            color: "black"
            opacity: 0.8
            z: 10
            visible: !channelMaster

            MouseArea {
                id: masterMouseDev
                anchors.fill: parent
            }
        }

        ComboTextField {
            id: comboMasterAtten
            posTop: comboChannel.posBottom
            posLeft: 0
            widthWidgetLabel: extendedWidthWidgetLabel
            widthWidget: defaultWidthWidget
            widthPrefixSuffix: defaultMarginAndTextWidthHeight
            txtSuffix: "dB"
            txtText: qsTr("Master") + ": " + (devFreqMaster ? devFreqMaster.varName("atten") : qsTr("Attenuation"))
        }

        ComboCombo {
            id: comboMasterRef
            posTop: comboChannel.posBottom
            posLeft: (rect.width - defaultMarginWidget) / 2
            widthWidget: extendedWidthWidget
            widthWidgetLabel: extendedWidthWidgetLabel
            txtText: qsTr("Master") + ": " + (devFreqMaster ? devFreqMaster.varName("ch_a") : "10 MHz " + qsTr("Ref"))

            Component.onCompleted: {
                comboModel = Alert.addEnum("P_CH", qsTr("Channel") + " ")
            }
        }

        Rectangle {
            id: slaveDisabler
            x: 0
            y: comboMasterAtten.posBottom
            height: defaultHeightWidget + 2 * defaultMarginWidget
            width: rect.width
            color: "black"
            opacity: 0.8
            z: 10
            visible: channelMaster

            MouseArea {
                id: slaveMouseDev
                anchors.fill: parent
            }
        }

        ComboTextField {
            id: comboSlaveAtten
            posTop: comboMasterAtten.posBottom
            posLeft: 0
            widthWidgetLabel: extendedWidthWidgetLabel
            widthWidget: defaultWidthWidget
            widthPrefixSuffix: defaultMarginAndTextWidthHeight
            txtSuffix: "dB"
            txtText: qsTr("Slave") + ": " + (devFreqSlave ? devFreqSlave.varName("atten") : qsTr("Attenuation"))
        }

        ComboCombo {
            id: comboSlaveRef
            posTop: comboMasterAtten.posBottom
            posLeft: (rect.width - defaultMarginWidget) / 2
            widthWidget: extendedWidthWidget
            widthWidgetLabel: extendedWidthWidgetLabel
            txtText: qsTr("Slave") + ": " + (devFreqSlave ? devFreqSlave.varName("ch_b") : "10 MHz " + qsTr("Ref"))

            Component.onCompleted: {
                comboModel = Alert.addEnum("P_CH", qsTr("Channel") + " ")
            }
        }
    }
}
