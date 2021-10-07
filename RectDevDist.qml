import QtQuick 2.11
import QtQuick.Extras 1.4

import rdss.alert 1.0

Item {
    property QtObject devDist
    property alias ind: ind

    StatusIndicator {
        id: ind
        x: marginIndicators
        y: marginIndicators
        active: false

        Component.onCompleted: devDist.gotData.connect(function() {
            active = true
            color = devDist.showIndicatorColor()
        })
    }

    Text {
        id: txtRef10
        x: 0
        anchors.left: ind.right
        anchors.leftMargin: marginIndicators
        height: rackFreqBoxDistHeight / 4
        width: (rackFreqBoxWidth - 2 * marginIndicators - ind.width) / 2
        text: qsTr("Outer Ref") + "10MHz " + devDist.showDisplay("ref_10")
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectSmallFontSize

        Component.onCompleted: {
            devDist.gotData.connect(function() {
                text = qsTr("Outer Ref") + "10MHz " + devDist.showDisplay("ref_10")
                color = devDist.showColor("ref_10", false)
            })
        }
    }

    Text {
        id: txtRef16
        x: 0
        anchors.left: txtRef10.right
        height: rackFreqBoxDistHeight / 4
        width: (rackFreqBoxWidth - 2 * marginIndicators - ind.width) / 2
        text: qsTr("Outer Ref") + "16MHz " + devDist.showDisplay("ref_16")
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectSmallFontSize

        Component.onCompleted: {
            devDist.gotData.connect(function() {
                text = qsTr("Outer Ref") + "16MHz " + devDist.showDisplay("ref_16")
                color = devDist.showColor("ref_16", false)
            })
        }
    }

    Text {
        id: txtVoltage
        anchors.top: txtRef10.bottom
        anchors.left: ind.right
        anchors.leftMargin: marginIndicators
        height: rackFreqBoxDistHeight / 4
        width: (rackFreqBoxWidth - 2 * marginIndicators - ind.width) / 2
        text: devDist.showDisplay("voltage") + " V"
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectBigFontSize

        Component.onCompleted: {
            devDist.gotData.connect(function() {
                text = devDist.showDisplay("voltage") + " V"
                color = devDist.showColor("voltage")
            })
        }
    }

    Text {
        id: txtCurrent
        anchors.top: txtRef10.bottom
        anchors.left: txtVoltage.right
        height: rackFreqBoxDistHeight / 4
        width: (rackFreqBoxWidth - 2 * marginIndicators - ind.width) / 2
        text: devDist.showDisplay("current") + " mA"
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectBigFontSize

        Component.onCompleted: {
            devDist.gotData.connect(function() {
                text = devDist.showDisplay("current") + " mA"
                color = devDist.showColor("current")
            })
        }
    }

    Text {
        id: txt10
        anchors.top: txtCurrent.bottom
        anchors.left: ind.right
        anchors.leftMargin: marginIndicators
        height: rackFreqBoxDistHeight / 4
        width: (rackFreqBoxWidth - 2 * marginIndicators - ind.width) / 2
        text: "10MHz " + qsTr("Lock")
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectBigFontSize
    }

    Text {
        id: txt10lock1
        anchors.top: txtCurrent.bottom
        anchors.left: txt10.right
        height: rackFreqBoxDistHeight / 4
        width: (rackFreqBoxWidth - 2 * marginIndicators - ind.width) / 4
        text: "1 " + devDist.showDisplay("lock_10_1")
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectBigFontSize

        Component.onCompleted: {
            devDist.gotData.connect(function() {
                text = "1 " + devDist.showDisplay("lock_10_1")
                color = devDist.showColor("lock_10_1")
            })
        }
    }

    Text {
        id: txt10lock2
        anchors.top: txtCurrent.bottom
        anchors.left: txt10lock1.right
        height: rackFreqBoxDistHeight / 4
        width: (rackFreqBoxWidth - 2 * marginIndicators - ind.width) / 4
        text: "2 " + devDist.showDisplay("lock_10_2")
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectBigFontSize

        Component.onCompleted: {
            devDist.gotData.connect(function() {
                text = "2 " + devDist.showDisplay("lock_10_2")
                color = devDist.showColor("lock_10_2")
            })
        }
    }

    Text {
        id: txt16
        anchors.top: txt10.bottom
        anchors.left: ind.right
        anchors.leftMargin: marginIndicators
        height: rackFreqBoxDistHeight / 4
        width: (rackFreqBoxWidth - 2 * marginIndicators - ind.width) / 2
        text: "16MHz " + qsTr("Lock")
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectBigFontSize
    }

    Text {
        id: txt16lock1
        anchors.top: txt10.bottom
        anchors.left: txt16.right
        height: rackFreqBoxDistHeight / 4
        width: (rackFreqBoxWidth - 2 * marginIndicators - ind.width) / 4
        text: "1 " + devDist.showDisplay("lock_16_1")
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectBigFontSize

        Component.onCompleted: {
            devDist.gotData.connect(function() {
                text = "1 " + devDist.showDisplay("lock_16_1")
                color = devDist.showColor("lock_16_1")
            })
        }
    }

    Text {
        id: txt16lock2
        anchors.top: txt10.bottom
        anchors.left: txt16lock1.right
        height: rackFreqBoxDistHeight / 4
        width: (rackFreqBoxWidth - 2 * marginIndicators - ind.width) / 4
        text: "2 " + devDist.showDisplay("lock_16_2")
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectBigFontSize

        Component.onCompleted: {
            devDist.gotData.connect(function() {
                text = "2 " + devDist.showDisplay("lock_16_2")
                color = devDist.showColor("lock_16_2")
            })
        }
    }
}
