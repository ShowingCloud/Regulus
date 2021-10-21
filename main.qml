import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Extras 1.4
import QtQuick.Shapes 1.11

import rdss.device 1.0
import rdss.alert 1.0

Window {
    readonly property int singleBoxWidth: 270
    readonly property int singleBoxHeight: 73
    readonly property int doubleBoxHeight: 98
    readonly property int heightCircuit: doubleBoxHeight * 2 + defaultMarginAndTextWidthHeight
    readonly property int defaultBorderWidth: 2
    readonly property int defaultMarginAndTextWidthHeight: 30
    readonly property int windowLeftMargin: 60
    readonly property int marginIndicators: 10
    readonly property int defaultLabelFontSize: 20
    readonly property int rectBigFontSize: 15
    readonly property int rectSmallFontSize: 12 // 8
    readonly property int timerStringFontSize: 10

    property QtObject objWinFreq;
    property QtObject objWinDist;
    property QtObject objWinAmp;

    id: winMain
    visible: true
    width: 1550
    height: heightCircuit * 2 + singleBoxHeight * 3 + defaultMarginAndTextWidthHeight * 5
    title: qsTr("RDSS Project")

    Component.onCompleted: {
        objWinFreq = Qt.createComponent("qrc:/freq.qml").createObject(winMain);
        objWinDist = Qt.createComponent("qrc:/dist.qml").createObject(winMain);
        objWinAmp = Qt.createComponent("qrc:/amp.qml").createObject(winMain);
    }

    Text {
        id: txtTitle
        width: winMain.width
        height: singleBoxHeight
        text: winMain.title
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        wrapMode: Text.WrapAnywhere
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: defaultLabelFontSize + 10
    }

    Rectangle {
        id: circuit1
        x: windowLeftMargin
        y: singleBoxHeight + defaultMarginAndTextWidthHeight
        width: winMain.width - 2 * windowLeftMargin
        height: heightCircuit
        color: "#00000000"

        BlockDevFreq {
            id: blkFreqUpFreq1
            masterId: 0x00
            slaveId: 0x01
            posTop: heightCircuit / 5 - doubleBoxHeight / 2
            posLeft: circuit1.width / 5 - singleBoxWidth / 2
            devFreqUp: true
        }

        BlockDevFreq {
            id: blkFreqDownFreq1
            masterId: 0x04
            slaveId: 0x05
            posTop: heightCircuit * 4 / 5 - doubleBoxHeight / 2
            posLeft: circuit1.width * 2 / 5 - singleBoxWidth / 2
            devFreqUp: false
        }

        BlockDevAmp {
            id: blkAmpAmpA1
            masterId: 0x0C
            slaveId: 0x0D
            posTop: heightCircuit / 5 - doubleBoxHeight / 2
            posLeft: circuit1.width * 3 / 5 - singleBoxWidth / 2
        }

        Shape {
            z: -1

            ShapePath {
                strokeWidth: 5
                strokeColor: "black"
                fillColor: "transparent"

                startX: 0
                startY: heightCircuit / 5
                PathLine {
                    x: circuit1.width * 4 / 5
                    y: heightCircuit / 5
                }
                PathLine {
                    x: circuit1.width * 4 / 5
                    y: heightCircuit * 2 / 5
                }
                PathLine {
                    x: circuit1.width * 9 / 10
                    y: heightCircuit * 2 / 5
                }
            }

            ShapePath {
                strokeWidth: 5
                strokeColor: "black"
                fillColor: "transparent"

                startX: 0
                startY: heightCircuit * 4 / 5
                PathLine {
                    x: circuit1.width * 4 / 5
                    y: heightCircuit * 4 / 5
                }
                PathLine {
                    x: circuit1.width * 4 / 5
                    y: heightCircuit * 3 / 5
                }
                PathLine {
                    x: circuit1.width * 9 / 10
                    y: heightCircuit * 3 / 5
                }
            }
        }
    }

    Rectangle {
        id: circuit2
        anchors.top: circuit1.bottom
        anchors.topMargin: defaultMarginAndTextWidthHeight
        anchors.left: circuit1.left
        width: circuit1.width
        height: heightCircuit
        color: "#00000000"

        BlockDevFreq {
            id: blkFreqUpFreq2
            masterId: 0x02
            slaveId: 0x03
            posTop: heightCircuit / 5 - doubleBoxHeight / 2
            posLeft: circuit1.width / 5 - singleBoxWidth / 2
            devFreqUp: true
        }

        BlockDevFreq {
            id: blkFreqDownFreq2
            masterId: 0x06
            slaveId: 0x07
            posTop: heightCircuit * 4 / 5 - doubleBoxHeight / 2
            posLeft: circuit1.width * 2 / 5 - singleBoxWidth / 2
            devFreqUp: false
        }

        BlockDevAmp {
            id: blkAmpAmpB1
            masterId: 0x0E
            slaveId: 0x0F
            posTop: heightCircuit / 5 - doubleBoxHeight / 2
            posLeft: circuit1.width * 3 / 5 - singleBoxWidth / 2
        }

        Shape {
            z: -1

            ShapePath {
                strokeWidth: 5
                strokeColor: "black"
                fillColor: "transparent"

                startX: 0
                startY: heightCircuit / 5
                PathLine {
                    x: circuit1.width * 4 / 5
                    y: heightCircuit / 5
                }
                PathLine {
                    x: circuit1.width * 4 / 5
                    y: heightCircuit * 2 / 5
                }
                PathLine {
                    x: circuit1.width * 9 / 10
                    y: heightCircuit * 2 / 5
                }
            }

            ShapePath {
                strokeWidth: 5
                strokeColor: "black"
                fillColor: "transparent"

                startX: 0
                startY: heightCircuit * 4 / 5
                PathLine {
                    x: circuit1.width * 4 / 5
                    y: heightCircuit * 4 / 5
                }
                PathLine {
                    x: circuit1.width * 4 / 5
                    y: heightCircuit * 3 / 5
                }
                PathLine {
                    x: circuit1.width * 9 / 10
                    y: heightCircuit * 3 / 5
                }
            }
        }
    }

    Rectangle {
        id: rectAnt
        x: windowLeftMargin + circuit1.width * 9 / 10
        y: singleBoxHeight + defaultMarginAndTextWidthHeight + heightCircuit / 5
        width: circuit1.width / 10
        height: heightCircuit * 8 / 5 + defaultMarginAndTextWidthHeight
        border.width: defaultBorderWidth
        Text {
            id: txtAnt
            anchors.fill: parent
            text: qsTr("Antenna")
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            wrapMode: Text.WrapAnywhere
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: defaultLabelFontSize
        }
    }

    BlockDevDist {
        id: blkDistMidFreq1
        deviceId: 0x0A
        posTop: singleBoxHeight + defaultMarginAndTextWidthHeight * 3 + heightCircuit * 2
        posLeft: windowLeftMargin + blkFreqUpFreq1.posLeft
    }

    BlockDevDist {
        id: blkDistMidFreq2
        deviceId: 0x0B
        posTop: singleBoxHeight + defaultMarginAndTextWidthHeight * 3 + heightCircuit * 2
        posLeft: windowLeftMargin + blkAmpAmpA1.posLeft
    }

    Rectangle {
        id: rectSerial1
        x: blkDistMidFreq1.posLeft
        y: blkDistMidFreq1.posBottom + defaultMarginAndTextWidthHeight
        width: singleBoxWidth
        height: singleBoxHeight
        border.width: defaultBorderWidth

        DevNet {
            id: devSerial1
            dId: 0x10
        }

        StatusIndicator {
            id: indSerial1
            anchors.right: rectSerial1.right
            anchors.rightMargin: marginIndicators
            anchors.top: rectSerial1.top
            anchors.topMargin: marginIndicators

            Component.onCompleted: devSerial1.gotData.connect(function() {
                active = true
                color = devSerial1.showIndicatorColor()
            })
        }

        Text {
            id: txtSerial1Id
            x: marginIndicators
            y: marginIndicators
            height: indSerial1.height
            text: devSerial1.name
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: defaultLabelFontSize
        }

        Timer {
            property string colorValue: Alert.MAP_COLOR["OTHERS"]

            id: timerSerial1
            interval: Alert.timeout * 1000
            running: true
            repeat: true

            Component.onCompleted: devSerial1.gotData.connect(function() {
                if (!devSerial1.timedout()) colorValue = Alert.MAP_COLOR["NORMAL"]
                restart()
            });
            onTriggered: {
                colorValue = devSerial1.timedout() ? Alert.MAP_COLOR["ABNORMAL"] : Alert.MAP_COLOR["NORMAL"]
                if (devSerial1.timedout()) {
                    devSerial1.alertTimeout()
                    if (indSerial1.active)
                        indSerial1.color = Alert.MAP_COLOR["ABNORMAL"]
                }
            }
        }
    }

    Rectangle {
        id: rectSerial2
        x: blkDistMidFreq2.posLeft
        y: blkDistMidFreq1.posBottom + defaultMarginAndTextWidthHeight
        width: singleBoxWidth
        height: singleBoxHeight
        border.width: defaultBorderWidth

        DevNet {
            id: devSerial2
            dId: 0x11
        }

        StatusIndicator {
            id: indSerial2
            anchors.right: rectSerial2.right
            anchors.rightMargin: marginIndicators
            anchors.top: rectSerial2.top
            anchors.topMargin: marginIndicators

            Component.onCompleted: devSerial2.gotData.connect(function() {
                active = true
                color = devSerial2.showIndicatorColor()
            })
        }

        Text {
            id: txtSerial2Id
            x: marginIndicators
            y: marginIndicators
            height: indSerial2.height
            text: devSerial2.name
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: defaultLabelFontSize
        }

        Timer {
            property string colorValue: Alert.MAP_COLOR["OTHERS"]

            id: timerSerial2
            interval: Alert.timeout * 1000
            running: true
            repeat: true

            Component.onCompleted: devSerial2.gotData.connect(function() {
                if (!devSerial2.timedout()) colorValue = Alert.MAP_COLOR["NORMAL"]
                restart()
            });
            onTriggered: {
                colorValue = devSerial2.timedout() ? Alert.MAP_COLOR["ABNORMAL"] : Alert.MAP_COLOR["NORMAL"]
                if (devSerial2.timedout()) {
                    devSerial2.alertTimeout()
                    if (indSerial2.active)
                        indSerial2.color = Alert.MAP_COLOR["ABNORMAL"]
                }
            }
        }
    }

    Rectangle {
        id: rectSW
        x: windowLeftMargin + blkFreqDownFreq1.posLeft
        anchors.bottom: rectSerial1.bottom
        width: singleBoxWidth
        height: doubleBoxHeight
        border.width: defaultBorderWidth

        DevNet {
            id: devSW
            dId: 0x12
        }

        StatusIndicator {
            id: indSW
            anchors.right: rectSW.right
            anchors.rightMargin: marginIndicators
            anchors.top: rectSW.top
            anchors.topMargin: marginIndicators

            Component.onCompleted: devSW.gotData.connect(function() {
                active = true
                color = devSW.showIndicatorColor()
            })
        }

        Text {
            id: txtSWId
            x: marginIndicators
            y: marginIndicators
            height: indSW.height
            text: devSW.name
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: defaultLabelFontSize
        }

        Timer {
            property string colorValue: Alert.MAP_COLOR["OTHERS"]

            id: timerSW
            interval: Alert.timeout * 1000
            running: true
            repeat: true

            Component.onCompleted: devSW.gotData.connect(function() {
                if (!devSW.timedout()) colorValue = Alert.MAP_COLOR["NORMAL"]
                restart()
            });
            onTriggered: {
                colorValue = devSW.timedout() ? Alert.MAP_COLOR["ABNORMAL"] : Alert.MAP_COLOR["NORMAL"]
                if (devSW.timedout()) {
                    devSW.alertTimeout()
                    if (indSW.active)
                        indSW.color = Alert.MAP_COLOR["ABNORMAL"]
                }
            }
        }
    }
}
