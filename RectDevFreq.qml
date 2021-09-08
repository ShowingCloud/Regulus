import QtQuick 2.0
import QtQuick.Extras 1.4

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
        text: devFreq.atten
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
        text: devFreq.voltage
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
        text: devFreq.current
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
        text: qsTr("radio") + ((devFreq.output_stat === true) ? qsTr("normal") : qsTr("abnormal"))
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
        text: qsTr("mid freq") + ((devFreq.input_stat === true) ? qsTr("normal") : qsTr("abnormal"))
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
        text: "A1" + devFreq.lock_a1
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
        text: "A2" + devFreq.lock_a2
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
        text: "B1" + devFreq.lock_b1
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
        text: "B2" + devFreq.lock_b2
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
        text: devFreq.ref_10_1 === true ? qsTr("normal") : qsTr("abnormal")
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
        text: devFreq.ref_10_2 === true ? qsTr("normal") : qsTr("abnormal")
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
        text: devFreq.ref_3 === true ? qsTr("normal") : qsTr("abnormal")
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
        text: devFreq.ref_4 === true ? qsTr("normal") : qsTr("abnormal")
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectSmallFontSize
    }
}
