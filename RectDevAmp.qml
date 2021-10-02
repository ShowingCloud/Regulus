import QtQuick 2.11
import QtQuick.Extras 1.4

import rdss.alert 1.0

Item {
    property QtObject devAmp
    property alias ind: ind
    property bool devIsMaster: false

    StatusIndicator {
        id: ind
        x: marginIndicators
        y: marginIndicators
        active: false

        Component.onCompleted: devAmp.gotData.connect(function() {
            active = true
            color = devAmp.showIndicatorColor()
        })
    }

    Text {
        id: txtPower
        x: 0
        anchors.left: ind.right
        anchors.leftMargin: marginIndicators
        height: rackAmpBoxHeight / 2
        width: (rackAmpBoxWidth - 2 * marginIndicators - ind.width) / 7
        text: devAmp.showDisplay("power") + " mW"
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectBigFontSize

        Component.onCompleted: {
            devAmp.gotData.connect(function() {
                text = devAmp.showDisplay("power") + " mW"
                color = devAmp.showColor("power")
            })
        }
    }

    Text {
        id: txtGain
        x: 0
        anchors.left: txtPower.right
        height: rackAmpBoxHeight / 2
        width: (rackAmpBoxWidth - 2 * marginIndicators - ind.width) / 5
        text: qsTr("Gain") + " " + devAmp.showDisplay("gain") + " dB"
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectBigFontSize

        Component.onCompleted: {
            devAmp.gotData.connect(function() {
                text = qsTr("Gain") + " " + devAmp.showDisplay("gain") + " dB"
                color = devAmp.showColor("gain")
            })
        }
    }

    Text {
        id: txtAtten
        x: 0
        anchors.left: txtGain.right
        height: rackAmpBoxHeight / 2
        width: (rackAmpBoxWidth - 2 * marginIndicators - ind.width) / 5
        text: qsTr("Attenuation") + " " + devAmp.showDisplay("atten") + " dB"
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectBigFontSize

        Component.onCompleted: {
            devAmp.gotData.connect(function() {
                text = qsTr("Attenuation") + " " + devAmp.showDisplay("atten") + " dB"
                color = devAmp.showColor("atten")
            })
        }
    }

    Text {
        id: txtLoss
        x: 0
        anchors.left: txtAtten.right
        height: rackAmpBoxHeight / 2
        width: (rackAmpBoxWidth - 2 * marginIndicators - ind.width) / 5
        text: qsTr("Return") + " -" + devAmp.showDisplay("loss") + " dB"
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectBigFontSize

        Component.onCompleted: {
            devAmp.gotData.connect(function() {
                text = qsTr("Return") + " " + devAmp.showDisplay("loss") + " dB"
                color = devAmp.showColor("loss")
            })
        }
    }

    Text {
        id: txtAmpTemp
        x: 0
        anchors.left: txtLoss.right
        height: rackAmpBoxHeight / 2
        width: (rackAmpBoxWidth - 2 * marginIndicators - ind.width) * 9 / 35
        text: qsTr("Amplifier Temperature") + " " + devAmp.showDisplay("amp_temp") + " C"
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectBigFontSize

        Component.onCompleted: {
            devAmp.gotData.connect(function() {
                text = qsTr("Amplifier Temperature") + " " + devAmp.showDisplay("amp_temp") + " C"
                color = devAmp.showColor("amp_temp")
            })
        }
    }

    Text {
        id: txtSStandWave
        anchors.top: txtPower.bottom
        anchors.left: ind.right
        anchors.leftMargin: marginIndicators
        height: rackAmpBoxHeight / 2
        width: (rackAmpBoxWidth - 2 * marginIndicators - ind.width) * 26 / 175
        text: qsTr("Stand Wave")
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectBigFontSize

        Component.onCompleted: {
            devAmp.gotData.connect(function() {
                color = devAmp.showColor("s_stand_wave")
            })
        }
    }

    Text {
        id: txtSTemp
        anchors.top: txtPower.bottom
        anchors.left: txtSStandWave.right
        height: rackAmpBoxHeight / 2
        width: (rackAmpBoxWidth - 2 * marginIndicators - ind.width) * 26 / 175
        text: qsTr("Temperature")
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectBigFontSize

        Component.onCompleted: {
            devAmp.gotData.connect(function() {
                color = devAmp.showColor("s_temp")
            })
        }
    }

    Text {
        id: txtSCurrent
        anchors.top: txtPower.bottom
        anchors.left: txtSTemp.right
        height: rackAmpBoxHeight / 2
        width: (rackAmpBoxWidth - 2 * marginIndicators - ind.width) * 26 / 175
        text: qsTr("Current")
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectBigFontSize

        Component.onCompleted: {
            devAmp.gotData.connect(function() {
                color = devAmp.showColor("s_current")
            })
        }
    }

    Text {
        id: txtSVoltage
        anchors.top: txtPower.bottom
        anchors.left: txtSCurrent.right
        height: rackAmpBoxHeight / 2
        width: (rackAmpBoxWidth - 2 * marginIndicators - ind.width) * 26 / 175
        text: qsTr("Voltage")
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectBigFontSize

        Component.onCompleted: {
            devAmp.gotData.connect(function() {
                color = devAmp.showColor("s_voltage")
            })
        }
    }

    Text {
        id: txtSPower
        anchors.top: txtPower.bottom
        anchors.left: txtSVoltage.right
        height: rackAmpBoxHeight / 2
        width: (rackAmpBoxWidth - 2 * marginIndicators - ind.width) * 26 / 175
        text: qsTr("Output Power")
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectBigFontSize

        Component.onCompleted: {
            devAmp.gotData.connect(function() {
                color = devAmp.showColor("s_power")
            })
        }
    }

    Text {
        id: txtLoadTemp
        anchors.top: txtPower.bottom
        anchors.left: txtSPower.right
        height: rackAmpBoxHeight / 2
        width: (rackAmpBoxWidth - 2 * marginIndicators - ind.width) * 9 / 35
        text: qsTr("Load Temperature") + " " + devAmp.showDisplay("load_temp") + " C"
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: rectBigFontSize

        Component.onCompleted: {
            devAmp.gotData.connect(function() {
                text = qsTr("Load Temperature") + " " + devAmp.showDisplay("load_temp") + " C"
                color = devAmp.showColor("load_temp")
            })
        }
    }
}
