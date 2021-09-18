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

    id: winDist
    visible: false
    modality: Qt.ApplicationModal
    width: rect.width + 2 * marginRect
    height: rect.height + heightWidget + 2 * marginRect + marginWidget + defaultHistoryAreaHeight
    title: qsTr("Frequency Distribution Device")

    property QtObject devDist
    signal opened(QtObject dev)
    signal gotData()

    Component.onCompleted: {
        winDist.opened.connect(function(dev) {
            devDist = dev
            name.text = devDist.name
            dev.gotData.connect(gotData)
            buttonReset.clicked();
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

    Button {
        id: buttonReset
        anchors.right: rect.right
        anchors.rightMargin: marginWidget
        anchors.top: name.top
        width: widthWidget
        height: heightWidget
        text: qsTr("Reset")

        onClicked: {
            forceActiveFocus()
            devDist.releaseHold("ref_10")
            comboRef10.colorValue = devDist.showColor("ref_10")
            comboRef10.index = devDist.showDisplay("ref_10")
            devDist.releaseHold("ref_16")
            comboRef16.colorValue = devDist.showColor("ref_16")
            comboRef16.index = devDist.showDisplay("ref_16")
        }
    }

    Rectangle {
        id: rect
        x: marginRect
        anchors.top: name.bottom
        anchors.topMargin: marginWidget
        width: 4 * widthWidget + 4 * widthWidgetLabel + 9 * marginWidget
        height: 4 * heightWidget + 5 * marginWidget
        border.width: defaultBorderWidth

        ComboCombo {
            id: comboRef10
            posTop: 0
            posLeft: 0
            txtText: qsTr("Outer Ref") + " 10 MHz"

            Component.onCompleted: {
                comboModel = Alert.addEnum("P_CH", qsTr("Channel") + " ")
                updated.connect(function (index) {
                    devDist.holdValue("ref_10", index)
                })
                hold.connect(function() {
                    devDist.setHold("ref_10")
                    colorValue = devDist.showColor("ref_10")
                })
                gotData.connect(function() {
                    if ((colorValue = devDist.showColor("ref_10")) !== Alert.MAP_COLOR["HOLDING"])
                        index = devDist.getValue("ref_10")
                })
            }
        }

        ComboCombo {
            id: comboRef16
            posTop: 0
            posLeft: (rect.width - marginWidget) / 2
            txtText: qsTr("Outer Ref") + " 16 MHz"

            Component.onCompleted: {
                comboModel = Alert.addEnum("P_CH", qsTr("Channel") + " ")
                updated.connect(function (index) {
                    devDist.holdValue("ref_16", index)
                })
                hold.connect(function() {
                    devDist.setHold("ref_16")
                    colorValue = devDist.showColor("ref_16")
                })
                gotData.connect(function() {
                    if ((colorValue = devDist.showColor("ref_16")) !== Alert.MAP_COLOR["HOLDING"])
                        index = devDist.getValue("ref_16")
                })
            }
        }

        ComboText {
            id: comboVoltage
            posTop: comboRef10.posBottom
            posLeft: 0
            txtText: qsTr("Voltage")

            Component.onCompleted: {
                gotData.connect(function() {
                    txtValue = devDist.showDisplay("voltage") + " V"
                    colorValue = devDist.showColor("voltage")
                })
            }
        }

        ComboText {
            id: comboCurrent
            posTop: comboRef10.posBottom
            posLeft: (rect.width - marginWidget) / 2
            txtText: qsTr("Current")

            Component.onCompleted: {
                gotData.connect(function() {
                    txtValue = devDist.showDisplay("current") + " mA"
                    colorValue = devDist.showColor("current")
                })
            }
        }

        ComboText {
            id: combo10Lock1
            posTop: comboVoltage.posBottom
            posLeft: 0
            txtText: "10 MHz " + qsTr("Lock") + " 1"

            Component.onCompleted: {
                gotData.connect(function() {
                    txtValue = devDist.showDisplay("lock_10_1")
                    colorValue = devDist.showColor("lock_10_1")
                })
            }
        }

        ComboText {
            id: combo10Lock2
            posTop: comboVoltage.posBottom
            posLeft: (rect.width - marginWidget) / 4
            txtText: "10 MHz " + qsTr("Lock") + " 2"

            Component.onCompleted: {
                gotData.connect(function() {
                    txtValue = devDist.showDisplay("lock_10_2")
                    colorValue = devDist.showColor("lock_10_2")
                })
            }
        }

        ComboText {
            id: combo16Lock1
            posTop: comboVoltage.posBottom
            posLeft: (rect.width - marginWidget) / 2
            txtText: "16 MHz " + qsTr("Lock") + " 1"

            Component.onCompleted: {
                gotData.connect(function() {
                    txtValue = devDist.showDisplay("lock_16_1")
                    colorValue = devDist.showColor("lock_16_1")
                })
            }
        }

        ComboText {
            id: combo16Lock2
            posTop: comboVoltage.posBottom
            posLeft: (rect.width - marginWidget) * 3 / 4
            txtText: "16 MHz " + qsTr("Lock") + " 2"

            Component.onCompleted: {
                gotData.connect(function() {
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
        }

        Button {
            id: buttonSubmit
            x: rect.width - marginWidget - widthWidget
            y: combo10Lock1.posBottom + marginWidget
            width: widthWidget
            height: heightWidget
            text: qsTr("Submit")

            onClicked: {
                comboRef10.submit()
                comboRef16.submit()
                devDist.createCntlMsg()
                buttonReset.clicked()
            }
        }
    }

    RectHistory {
        id: rectHistory
        anchors.top: rect.bottom
        anchors.topMargin: marginRect
        anchors.left: rect.left
        itemWidth: rect.width
    }

    onClosing: {
        close.accepted = false
        this.hide()
    }
}
