import QtQuick 2.0
import QtQuick.Extras 1.4

import rdss.alert 1.0

Item {
    property QtObject devFreq

    StatusIndicator {
        id: ind
        x: marginIndicators
        y: marginIndicators
    }

    Text {
        id: txtPower
        x: 0
        anchors.left: ind.right
        anchors.leftMargin: marginIndicators
        height: rackFreqBoxFreqHeight / 3
        width: (rackFreqBoxWidth - 2 * marginIndicators - ind.width) / 3
        text: devFreq.atten + " dB"
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectBigFontSize
    }

    Text {
        id: txtVoltage
        x: 0
        anchors.left: txtPower.right
        height: rackFreqBoxFreqHeight / 3
        width: (rackFreqBoxWidth - 2 * marginIndicators - ind.width) / 3
        text: devFreq.voltage + " V"
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectBigFontSize
    }

    Text {
        id: txtCurrent
        x: 0
        anchors.left: txtVoltage.right
        height: rackFreqBoxFreqHeight / 3
        width: (rackFreqBoxWidth - 2 * marginIndicators - ind.width) / 3
        text: devFreq.current + " mA"
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectBigFontSize
    }

    Text {
        id: txtOutput
        anchors.top: txtPower.bottom
        anchors.left: ind.right
        anchors.leftMargin: marginIndicators
        height: rackFreqBoxFreqHeight / 3
        width: (rackFreqBoxWidth - 2 * marginIndicators - ind.width) / 6
        text: Alert.showValue(devFreq.output_stat, Alert.P_ENUM_NOR, qsTr("radio"))
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectSmallFontSize
    }

    Text {
        id: txtInput
        anchors.top: txtPower.bottom
        anchors.left: txtOutput.right
        height: rackFreqBoxFreqHeight / 3
        width: (rackFreqBoxWidth - 2 * marginIndicators - ind.width) / 6
        text: Alert.showValue(devFreq.input_stat, Alert.P_ENUM_NOR, qsTr("mid freq"))
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectSmallFontSize
    }

    Text {
        id: txtA1Lock
        anchors.top: txtPower.bottom
        anchors.left: txtInput.right
        height: rackFreqBoxFreqHeight / 3
        width: (rackFreqBoxWidth - 2 * marginIndicators - ind.width) / 6
        text: Alert.showValue(devFreq.lock_a1, Alert.P_ENUM_LOCK, "A1")
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectSmallFontSize
    }

    Text {
        id: txtA2Lock
        anchors.top: txtPower.bottom
        anchors.left: txtA1Lock.right
        height: rackFreqBoxFreqHeight / 3
        width: (rackFreqBoxWidth - 2 * marginIndicators - ind.width) / 6
        text: Alert.showValue(devFreq.lock_a2, Alert.P_ENUM_LOCK, "A2")
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectSmallFontSize
    }

    Text {
        id: txtB1Lock
        anchors.top: txtPower.bottom
        anchors.left: txtA2Lock.right
        height: rackFreqBoxFreqHeight / 3
        width: (rackFreqBoxWidth - 2 * marginIndicators - ind.width) / 6
        text: Alert.showValue(devFreq.lock_b1, Alert.P_ENUM_LOCK, "B1")
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectSmallFontSize
    }

    Text {
        id: txtB2Lock
        anchors.top: txtPower.bottom
        anchors.left: txtB1Lock.right
        height: rackFreqBoxFreqHeight / 3
        width: (rackFreqBoxWidth - 2 * marginIndicators - ind.width) / 6
        text: Alert.showValue(devFreq.lock_b2, Alert.P_ENUM_LOCK, "B2")
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectSmallFontSize
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
        text: Alert.showValue(devFreq.ref_10_1, Alert.P_ENUM_NOR)
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectSmallFontSize
    }

    Text {
        id: txt10r2
        anchors.top: txtOutput.bottom
        anchors.left: txt10r1.right
        height: rackFreqBoxFreqHeight / 3
        width: (rackFreqBoxWidth - 2 * marginIndicators - ind.width) / 6
        text: Alert.showValue(devFreq.ref_10_2, Alert.P_ENUM_NOR)
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectSmallFontSize
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
        text: Alert.showValue(devFreq.ref_3, Alert.P_ENUM_NOR)
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectSmallFontSize
    }

    Text {
        id: txt16r2
        anchors.top: txtOutput.bottom
        anchors.left: txt16r1.right
        height: rackFreqBoxFreqHeight / 3
        width: (rackFreqBoxWidth - 2 * marginIndicators - ind.width) / 6
        text: Alert.showValue(devFreq.ref_4, Alert.P_ENUM_NOR)
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectSmallFontSize
    }
}
