import QtQuick 2.0
import QtQuick.Extras 1.4

import rdss.alert 1.0

Item {
    property QtObject devFreq

    StatusIndicator {
        id: ind
        x: marginIndicators
        y: marginIndicators
        active: false

        Component.onCompleted: devFreq.gotData.connect(function() {
            active = true
            color = devFreq.showIndicatorColor()
        })
    }

    Text {
        id: txtPower
        x: 0
        anchors.left: ind.right
        anchors.leftMargin: marginIndicators
        height: rackFreqBoxFreqHeight / 3
        width: (rackFreqBoxWidth - 2 * marginIndicators - ind.width) / 3
        text: devFreq.showDisplay("atten") + " dB"
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectBigFontSize

        Component.onCompleted: {
            devFreq.gotData.connect(function() {
                text = devFreq.showDisplay("atten") + " dB"
                color = devFreq.showColor("atten")
            })
        }
    }

    Text {
        id: txtVoltage
        x: 0
        anchors.left: txtPower.right
        height: rackFreqBoxFreqHeight / 3
        width: (rackFreqBoxWidth - 2 * marginIndicators - ind.width) / 3
        text: devFreq.showDisplay("voltage") + " V"
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectBigFontSize

        Component.onCompleted: {
            devFreq.gotData.connect(function() {
                text = devFreq.showDisplay("voltage") + " V"
                color = devFreq.showColor("voltage")
            })
        }
    }

    Text {
        id: txtCurrent
        x: 0
        anchors.left: txtVoltage.right
        height: rackFreqBoxFreqHeight / 3
        width: (rackFreqBoxWidth - 2 * marginIndicators - ind.width) / 3
        text: devFreq.showDisplay("current") + " mA"
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectBigFontSize

        Component.onCompleted: {
            devFreq.gotData.connect(function() {
                text = devFreq.showDisplay("current") + " mA"
                color = devFreq.showColor("current")
            })
        }
    }

    Text {
        id: txtOutput
        anchors.top: txtPower.bottom
        anchors.left: ind.right
        anchors.leftMargin: marginIndicators
        height: rackFreqBoxFreqHeight / 3
        width: (rackFreqBoxWidth - 2 * marginIndicators - ind.width) / 6
        text: qsTr("radio") + devFreq.showDisplay("output_stat")
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectSmallFontSize

        Component.onCompleted: {
            devFreq.gotData.connect(function() {
                text = qsTr("radio") + devFreq.showDisplay("output_stat")
                color = devFreq.showColor("output_stat")
            })
        }
    }

    Text {
        id: txtInput
        anchors.top: txtPower.bottom
        anchors.left: txtOutput.right
        height: rackFreqBoxFreqHeight / 3
        width: (rackFreqBoxWidth - 2 * marginIndicators - ind.width) / 6
        text: qsTr("mid freq") + devFreq.showDisplay("input_stat")
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectSmallFontSize

        Component.onCompleted: {
            devFreq.gotData.connect(function() {
                text = qsTr("mid freq") + devFreq.showDisplay("input_stat")
                color = devFreq.showColor("input_stat")
            })
        }
    }

    Text {
        id: txtA1Lock
        anchors.top: txtPower.bottom
        anchors.left: txtInput.right
        height: rackFreqBoxFreqHeight / 3
        width: (rackFreqBoxWidth - 2 * marginIndicators - ind.width) / 6
        text: "A1" + devFreq.showDisplay("lock_a1")
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectSmallFontSize

        Component.onCompleted: {
            devFreq.gotData.connect(function() {
                text = devFreq.showDisplay("lock_a1")
                color = devFreq.showColor("lock_a1")
            })
        }
    }

    Text {
        id: txtA2Lock
        anchors.top: txtPower.bottom
        anchors.left: txtA1Lock.right
        height: rackFreqBoxFreqHeight / 3
        width: (rackFreqBoxWidth - 2 * marginIndicators - ind.width) / 6
        text: "A2" + devFreq.showDisplay("lock_a2")
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectSmallFontSize

        Component.onCompleted: {
            devFreq.gotData.connect(function() {
                text = devFreq.showDisplay("lock_a2")
                color = devFreq.showColor("lock_a2")
            })
        }
    }

    Text {
        id: txtB1Lock
        anchors.top: txtPower.bottom
        anchors.left: txtA2Lock.right
        height: rackFreqBoxFreqHeight / 3
        width: (rackFreqBoxWidth - 2 * marginIndicators - ind.width) / 6
        text: "B1" + devFreq.showDisplay("lock_b1")
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectSmallFontSize

        Component.onCompleted: {
            devFreq.gotData.connect(function() {
                text = devFreq.showDisplay("lock_b1")
                color = devFreq.showColor("lock_b1")
            })
        }
    }

    Text {
        id: txtB2Lock
        anchors.top: txtPower.bottom
        anchors.left: txtB1Lock.right
        height: rackFreqBoxFreqHeight / 3
        width: (rackFreqBoxWidth - 2 * marginIndicators - ind.width) / 6
        text: "B2" + devFreq.showDisplay("lock_b2")
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectSmallFontSize

        Component.onCompleted: {
            devFreq.gotData.connect(function() {
                text = devFreq.showDisplay("lock_b2")
                color = devFreq.showColor("lock_b2")
            })
        }
    }

    Text {
        id: txt10
        anchors.top: txtOutput.bottom
        anchors.left: ind.right
        anchors.leftMargin: marginIndicators
        height: rackFreqBoxFreqHeight / 3
        width: (rackFreqBoxWidth - 2 * marginIndicators - ind.width) / 6
        text: "10MHz"
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectSmallFontSize
    }

    Text {
        id: txt10r1
        anchors.top: txtOutput.bottom
        anchors.left: txt10.right
        height: rackFreqBoxFreqHeight / 3
        width: (rackFreqBoxWidth - 2 * marginIndicators - ind.width) / 6
        text: devFreq.showDisplay("ref_10_1")
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectSmallFontSize

        Component.onCompleted: {
            devFreq.gotData.connect(function() {
                text = devFreq.showDisplay("ref_10_1")
                color = devFreq.showColor("ref_10_1")
            })
        }
    }

    Text {
        id: txt10r2
        anchors.top: txtOutput.bottom
        anchors.left: txt10r1.right
        height: rackFreqBoxFreqHeight / 3
        width: (rackFreqBoxWidth - 2 * marginIndicators - ind.width) / 6
        text: devFreq.showDisplay("ref_10_2")
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectSmallFontSize

        Component.onCompleted: {
            devFreq.gotData.connect(function() {
                text = devFreq.showDisplay("ref_10_2")
                color = devFreq.showColor("ref_10_2")
            })
        }
    }

    Text {
        id: txt16
        anchors.top: txtOutput.bottom
        anchors.left: txt10r2.right
        height: rackFreqBoxFreqHeight / 3
        width: (rackFreqBoxWidth - 2 * marginIndicators - ind.width) / 6
        text: "16MHz"
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectSmallFontSize
    }

    Text {
        id: txt16r1
        anchors.top: txtOutput.bottom
        anchors.left: txt16.right
        height: rackFreqBoxFreqHeight / 3
        width: (rackFreqBoxWidth - 2 * marginIndicators - ind.width) / 6
        text: devFreq.showDisplay("ref_3")
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectSmallFontSize

        Component.onCompleted: {
            devFreq.gotData.connect(function() {
                text = devFreq.showDisplay("ref_3")
                color = devFreq.showColor("ref_3")
            })
        }
    }

    Text {
        id: txt16r2
        anchors.top: txtOutput.bottom
        anchors.left: txt16r1.right
        height: rackFreqBoxFreqHeight / 3
        width: (rackFreqBoxWidth - 2 * marginIndicators - ind.width) / 6
        text: devFreq.showDisplay("ref_4")
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectSmallFontSize

        Component.onCompleted: {
            devFreq.gotData.connect(function() {
                text = devFreq.showDisplay("ref_4")
                color = devFreq.showColor("ref_4")
            })
        }
    }
}
