import QtQuick 2.0
import QtQuick.Extras 1.4

import rdss.alert 1.0

Item {
    property QtObject devFreq
    property bool devIsMaster

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
        id: txtRadio
        anchors.top: txtPower.bottom
        anchors.left: ind.right
        anchors.leftMargin: marginIndicators
        height: rackFreqBoxFreqHeight / 3
        width: (rackFreqBoxWidth - 2 * marginIndicators - ind.width) / 3
        text: qsTr("radio") + devFreq.showDisplay("radio_stat")
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectSmallFontSize

        Component.onCompleted: {
            devFreq.gotData.connect(function() {
                text = qsTr("radio") + devFreq.showDisplay("radio_stat")
                color = devFreq.showColor("radio_stat")
            })
        }
    }

    Text {
        id: txtMid
        anchors.top: txtPower.bottom
        anchors.left: txtRadio.right
        height: rackFreqBoxFreqHeight / 3
        width: (rackFreqBoxWidth - 2 * marginIndicators - ind.width) / 3
        text: qsTr("mid freq") + devFreq.showDisplay("mid_stat")
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectSmallFontSize

        Component.onCompleted: {
            devFreq.gotData.connect(function() {
                text = qsTr("mid freq") + devFreq.showDisplay("mid_stat")
                color = devFreq.showColor("mid_stat")
            })
        }
    }

    Text {
        id: txtA1Lock
        anchors.top: txtPower.bottom
        anchors.left: txtMid.right
        height: rackFreqBoxFreqHeight / 3
        width: (rackFreqBoxWidth - 2 * marginIndicators - ind.width) / 3
        text: "A1 " + devFreq.showDisplay("lock_a1")
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectSmallFontSize
        visible: devIsMaster

        Component.onCompleted: {
            devFreq.gotData.connect(function() {
                text = "A1 " + devFreq.showDisplay("lock_a1")
                color = devFreq.showColor("lock_a1")
            })
        }
    }

    /*
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
    */

    Text {
        id: txtB1Lock
        anchors.top: txtPower.bottom
        anchors.left: txtMid.right
        height: rackFreqBoxFreqHeight / 3
        width: (rackFreqBoxWidth - 2 * marginIndicators - ind.width) / 3
        text: "B1 " + devFreq.showDisplay("lock_b1")
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectSmallFontSize
        visible: (!devIsMaster)

        Component.onCompleted: {
            devFreq.gotData.connect(function() {
                text = "B1 " + devFreq.showDisplay("lock_b1")
                color = devFreq.showColor("lock_b1")
            })
        }
    }

    /*
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
    */

    Text {
        id: txt10
        anchors.top: txtRadio.bottom
        anchors.left: ind.right
        anchors.leftMargin: marginIndicators
        height: rackFreqBoxFreqHeight / 3
        width: (rackFreqBoxWidth - 2 * marginIndicators - ind.width) / 4
        text: "10MHz"
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectSmallFontSize
    }

    Text {
        id: txt10r1
        anchors.top: txtRadio.bottom
        anchors.left: txt10.right
        height: rackFreqBoxFreqHeight / 3
        width: (rackFreqBoxWidth - 2 * marginIndicators - ind.width) / 4
        text: "1 " + devFreq.showDisplay("ref_10_1")
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectSmallFontSize

        Component.onCompleted: {
            devFreq.gotData.connect(function() {
                text = "1 " + devFreq.showDisplay("ref_10_1")
                color = devFreq.showColor("ref_10_1")
            })
        }
    }

    Text {
        id: txt10r2
        anchors.top: txtRadio.bottom
        anchors.left: txt10r1.right
        height: rackFreqBoxFreqHeight / 3
        width: (rackFreqBoxWidth - 2 * marginIndicators - ind.width) / 4
        text: "2 " + devFreq.showDisplay("ref_10_2")
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectSmallFontSize

        Component.onCompleted: {
            devFreq.gotData.connect(function() {
                text = "2 " + devFreq.showDisplay("ref_10_2")
                color = devFreq.showColor("ref_10_2")
            })
        }
    }

    Text {
        id: txt10Inner
        anchors.top: txtRadio.bottom
        anchors.left: txt10r2.right
        height: rackFreqBoxFreqHeight / 3
        width: (rackFreqBoxWidth - 2 * marginIndicators - ind.width) / 4
        text: qsTr("Inner Ref") + devFreq.showDisplay("ref_10_inner")
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectSmallFontSize

        Component.onCompleted: {
            devFreq.gotData.connect(function() {
                text = qsTr("Inner Ref") + devFreq.showDisplay("ref_10_inner")
                color = devFreq.showColor("ref_10_inner")
            })
        }
    }
}
