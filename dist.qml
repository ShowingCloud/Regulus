import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.3
import QtQuick.Window 2.15

import rdss.alert 1.0

Window {
    property alias communicationColorValue: comboCommunication.colorValue

    id: winDist
    visible: false
    modality: Qt.ApplicationModal
    width: rect.width + 2 * defaultMarginRect
    height: rect.height + defaultHeightWidget + 2 * defaultMarginRect + defaultMarginWidget
    title: qsTr("Frequency Distribution Device")

    property QtObject devDist: null
    signal opened(QtObject dev)
    signal refreshData()

    Component.onCompleted: {
        winDist.opened.connect(function(dev) {
            devDist = dev
            name.text = devDist.name
            dev.gotData.connect(refreshData)
            refreshData()
        })
    }

    onClosing: {
        close.accepted = false
        this.hide()
        devDist.gotData.disconnect(refreshData)
        name.text = ""
        devDist = null
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

    Rectangle {
        id: rect
        x: defaultMarginRect
        anchors.top: name.bottom
        anchors.topMargin: defaultMarginWidget
        width: 4 * defaultWidthWidget + 4 * defaultWidthWidgetLabel + 9 * defaultMarginWidget
        height: 4 * defaultHeightWidget + 5 * defaultMarginWidget
        border.width: defaultBorderWidth

        ComboText {
            id: comboRef10
            posTop: 0
            posLeft: 0
            txtText: devDist ? devDist.varName("ref_10") : qsTr("Outer Ref") + " 10 MHz"

            Component.onCompleted: {
                refreshData.connect(function() {
                    txtValue = qsTr("Channel") + devDist.showDisplay("ref_10")
                    colorValue = devDist.showColor("ref_10")
                })
            }
        }

        ComboText {
            id: comboRef16
            posTop: 0
            posLeft: (rect.width - defaultMarginWidget) / 2
            txtText: devDist ? devDist.varName("ref_16") : qsTr("Outer Ref") + " 16 MHz"

            Component.onCompleted: {
                refreshData.connect(function() {
                    txtValue = qsTr("Channel") + devDist.showDisplay("ref_16")
                    colorValue = devDist.showColor("ref_16")
                })
            }
        }

        ComboText {
            id: comboVoltage
            posTop: comboRef10.posBottom
            posLeft: 0
            txtText: devDist ? devDist.varName("voltage") : qsTr("Voltage")
            txtSuffix: " V"

            Component.onCompleted: {
                refreshData.connect(function() {
                    txtValue = devDist.showDisplay("voltage")
                    colorValue = devDist.showColor("voltage")
                })
            }
        }

        ComboText {
            id: comboCurrent
            posTop: comboRef10.posBottom
            posLeft: (rect.width - defaultMarginWidget) / 2
            txtText: devDist ? devDist.varName("current") : qsTr("Current")
            txtSuffix: " mA"

            Component.onCompleted: {
                refreshData.connect(function() {
                    txtValue = devDist.showDisplay("current")
                    colorValue = devDist.showColor("current")
                })
            }
        }

        ComboText {
            id: combo10Lock1
            posTop: comboVoltage.posBottom
            posLeft: 0
            txtText: devDist ? devDist.varName("lock_10_1") : "10 MHz " + qsTr("Lock") + " 1"

            Component.onCompleted: {
                refreshData.connect(function() {
                    txtValue = devDist.showDisplay("lock_10_1")
                    colorValue = devDist.showColor("lock_10_1")
                })
            }
        }

        ComboText {
            id: combo10Lock2
            posTop: comboVoltage.posBottom
            posLeft: (rect.width - defaultMarginWidget) / 4
            txtText: devDist ? devDist.varName("lock_10_2") : "10 MHz " + qsTr("Lock") + " 2"

            Component.onCompleted: {
                refreshData.connect(function() {
                    txtValue = devDist.showDisplay("lock_10_2")
                    colorValue = devDist.showColor("lock_10_2")
                })
            }
        }

        ComboText {
            id: combo16Lock1
            posTop: comboVoltage.posBottom
            posLeft: (rect.width - defaultMarginWidget) / 2
            txtText: devDist ? devDist.varName("lock_16_1") : "16 MHz " + qsTr("Lock") + " 1"

            Component.onCompleted: {
                refreshData.connect(function() {
                    txtValue = devDist.showDisplay("lock_16_1")
                    colorValue = devDist.showColor("lock_16_1")
                })
            }
        }

        ComboText {
            id: combo16Lock2
            posTop: comboVoltage.posBottom
            posLeft: (rect.width - defaultMarginWidget) * 3 / 4
            txtText: devDist ? devDist.varName("lock_16_2") : "16 MHz " + qsTr("Lock") + " 2"

            Component.onCompleted: {
                refreshData.connect(function() {
                    txtValue = devDist.showDisplay("lock_16_2")
                    colorValue = devDist.showColor("lock_16_2")
                })
            }
        }

        ComboText {
            id: comboCommunication
            posTop: combo10Lock1.posBottom
            posLeft: 0
            txtText: qsTr("Network Communication")
            fontSize: timerStringFontSize
            txtValue: devDist ? devDist.timerStr : qsTr("No data")
        }
    }
}
