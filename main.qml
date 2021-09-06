import QtQuick 2.9
import QtQuick.Window 2.9
import QtQuick.Extras 1.4
import QtQuick.Scene2D 2.9
import QtQuick.Scene3D 2.0
import QtQuick.Shapes 1.11
import QtQuick.Controls 1.6
import QtQuick.Controls.Styles.Desktop 1.0
import QtQuick.Layouts 1.11
import QtGraphicalEffects 1.0

import rdss.device 1.0

Window {
    readonly property int rackWidth: 791
    readonly property int rackHeight: 692
    readonly property int defaultBorderWidth: 2
    readonly property int rackFreqBoxWidth: 320
    readonly property int rackFreqBoxHeight: 73
    readonly property int rackAmpBoxWidth: 320
    readonly property int rackAmpBoxHeight: 117
    readonly property int serialSWWidth: 352
    readonly property int serialSWHeight: 79
    readonly property int defaultMarginAndTextWidthHeight: 30
    readonly property int marginRacks: 74
    readonly property int marginIndicators: 10
    readonly property int defaultLabelFontSize: 20

    property QtObject objWinFreq;
    property QtObject objWinDist;
    property QtObject objWinAmp;

    id: winMain
    visible: true
    width: 1800
    height: 900
    title: qsTr("RDSS Project")

    Component.onCompleted: {
        objWinFreq = Qt.createComponent("qrc:/freq.qml").createObject(winMain);
        objWinDist = Qt.createComponent("qrc:/dist.qml").createObject(winMain);
        objWinAmp = Qt.createComponent("qrc:/amp.qml").createObject(winMain);
    }

    Rectangle {
        id: rackFreq
        x: marginRacks
        y: 71
        width: rackWidth
        height: rackHeight
        border.width: defaultBorderWidth

        Text {
            id: txtRackFreqId
            x: 0
            y: 0
            width: rackWidth
            height: defaultMarginAndTextWidthHeight
            text: qsTr("Frequency Conversion Rack")
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: defaultLabelFontSize
        }

        BlockDevFreq {
            id: blkFreqDownFreq1
            masterId: 0x04
            slaveId: 0x05
            posTop: txtRackFreqId.height
            posLeft: 0
        }

        BlockDevFreq {
            id: blkFreqDownFreq2
            masterId: 0x06
            slaveId: 0x07
            posTop: txtRackFreqId.height
            posLeft: blkFreqDownFreq1.posRight
        }

        BlockDevFreq {
            id: blkFreqUpFreq1
            masterId: 0x00
            slaveId: 0x01
            posTop: blkFreqDownFreq1.posBottom
            posLeft: 0
        }

        BlockDevFreq {
            id: blkFreqUpFreq2
            masterId: 0x02
            slaveId: 0x03
            posTop: blkFreqDownFreq1.posBottom
            posLeft: blkFreqUpFreq1.posRight
        }

        BlockDevDist {
            id: blkDistMidFreq1
            deviceId: 0x0A
            posTop: blkFreqUpFreq1.posBottom
            posLeft: 0
        }

        BlockDevDist {
            id: blkDistMidFreq2
            deviceId: 0x0B
            posTop: blkFreqUpFreq1.posBottom
            posLeft: blkDistMidFreq1.posRight
        }

        Rectangle {
            id: devSW1
            anchors.left: devSerial1.left
            anchors.top: devSerial1.bottom
            anchors.topMargin: 2 * defaultMarginAndTextWidthHeight
            width: serialSWWidth
            height: serialSWHeight
            border.width: defaultBorderWidth

            StatusIndicator {
                id: indSW1
                x: marginIndicators
                y: marginIndicators
            }

            Text {
                id: txtSW1Id
                x: 50
                y: marginIndicators
                height: indSW1.height
                text: qsTr("Switch") + " 1"
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: defaultLabelFontSize
            }
        }

        Rectangle {
            id: devSerial1
            anchors.right: rackFreq.right
            anchors.rightMargin: defaultMarginAndTextWidthHeight
            anchors.bottom: rackFreq.bottom
            anchors.bottomMargin: defaultMarginAndTextWidthHeight
            width: serialSWWidth
            height: serialSWHeight
            border.width: defaultBorderWidth

            StatusIndicator {
                id: indSerial1
                x: marginIndicators
                y: marginIndicators
            }

            Text {
                id: txtSerial1Id
                x: 50
                y: marginIndicators
                height: indSerial1.height
                text: qsTr("Serial") + " 1"
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: defaultLabelFontSize
            }
        }
    }

    Rectangle {
        id: rackAmp
        anchors.top: rackFreq.top
        anchors.left: rackFreq.right
        anchors.leftMargin: marginRacks
        width: rackWidth
        height: rackHeight
        border.width: defaultBorderWidth

        Text {
            id: txtRackAmpId
            x: 0
            y: 0
            width: rackWidth
            height: defaultMarginAndTextWidthHeight
            text: qsTr("Amplification Rack")
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: defaultLabelFontSize
        }

        BlockDevAmp {
            id: blkAmpAmpA1
            masterId: 0x0C
            slaveId: 0x0D
            posTop: txtRackAmpId.height
            posLeft: 0
        }

        BlockDevAmp {
            id: blkAmpAmpB1
            masterId: 0x0E
            slaveId: 0x0F
            posTop: txtRackAmpId.height
            posLeft: blkAmpAmpA1.posRight
        }

        Text {
            id: txtAmpA2Id
            anchors.top: devAmpA2Master.top
            anchors.right: devAmpA2Master.left
            width: defaultMarginAndTextWidthHeight
            height: 2 * rackAmpBoxHeight
            text: "C2" + qsTr("High Amplification") + "A"
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            wrapMode: Text.WrapAnywhere
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: defaultLabelFontSize

            MouseArea {
                id: mouseAmpA2Id
                anchors.fill: parent
                onClicked: {
                    objWinAmp.setVisible(true);
                }
            }
        }

        Rectangle {
            id: devAmpA2Master
            x: 2 * defaultMarginAndTextWidthHeight
            y: blkAmpAmpA1.posBottom + defaultMarginAndTextWidthHeight
            width: rackAmpBoxWidth
            height: rackAmpBoxHeight
            StatusIndicator {
                id: indAmpA2Master
                x: marginIndicators
                y: marginIndicators
            }
            border.width: defaultBorderWidth

            MouseArea {
                id: mouseAmpA2Master
                anchors.fill: parent
                onClicked: {
                    objWinAmp.setVisible(true);
                }
            }
        }

        Rectangle {
            id: devAmpA2Slave
            anchors.left: devAmpA2Master.left
            anchors.top: devAmpA2Master.bottom
            anchors.topMargin: -defaultBorderWidth
            width: rackAmpBoxWidth
            height: rackAmpBoxHeight
            StatusIndicator {
                id: indAmpA2Slave
                x: marginIndicators
                y: marginIndicators
            }
            border.width: defaultBorderWidth

            MouseArea {
                id: mouseAmpA2Slave
                anchors.fill: parent
                onClicked: {
                    objWinAmp.setVisible(true);
                }
            }
        }

        Text {
            id: txtAmpB2Id
            anchors.top: devAmpB2Master.top
            anchors.right: devAmpB2Master.left
            width: defaultMarginAndTextWidthHeight
            height: 2 * rackAmpBoxHeight
            text: "C2" + qsTr("High Amplification") + "B"
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            wrapMode: Text.WrapAnywhere
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: defaultLabelFontSize

            MouseArea {
                id: mouseAmpB2Id
                anchors.fill: parent
                onClicked: {
                    objWinAmp.setVisible(true);
                }
            }
        }

        Rectangle {
            id: devAmpB2Master
            anchors.top: devAmpA2Master.top
            anchors.left: devAmpA2Master.right
            anchors.leftMargin: 2 * defaultMarginAndTextWidthHeight
            width: rackAmpBoxWidth
            height: rackAmpBoxHeight
            StatusIndicator {
                id: indAmpB2Master
                x: marginIndicators
                y: marginIndicators
            }
            border.width: defaultBorderWidth

            MouseArea {
                id: mouseAmpB2Master
                anchors.fill: parent
                onClicked: {
                    objWinAmp.setVisible(true);
                }
            }
        }

        Rectangle {
            id: devAmpB2Slave
            anchors.left: devAmpB2Master.left
            anchors.top: devAmpB2Master.bottom
            anchors.topMargin: -defaultBorderWidth
            width: rackAmpBoxWidth
            height: rackAmpBoxHeight
            StatusIndicator {
                id: indAmpB2Slave
                x: marginIndicators
                y: marginIndicators
            }
            border.width: defaultBorderWidth

            MouseArea {
                id: mouseAmpB2Slave
                anchors.fill: parent
                onClicked: {
                    objWinAmp.setVisible(true);
                }
            }
        }

        Rectangle {
            id: devSW2
            anchors.left: devSerial2.left
            anchors.top: devSerial2.bottom
            anchors.topMargin: 2 * defaultMarginAndTextWidthHeight
            width: serialSWWidth
            height: serialSWHeight
            border.width: defaultBorderWidth

            StatusIndicator {
                id: indSW2
                x: marginIndicators
                y: marginIndicators
            }

            Text {
                id: txtSW2Id
                x: 50
                y: marginIndicators
                height: indSW2.height
                text: qsTr("Switch") + " 2"
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: defaultLabelFontSize
            }
        }

        Rectangle {
            id: devSerial2
            anchors.left: rackAmp.left
            anchors.leftMargin: defaultMarginAndTextWidthHeight
            anchors.bottom: rackAmp.bottom
            anchors.bottomMargin: defaultMarginAndTextWidthHeight
            width: serialSWWidth
            height: serialSWHeight
            border.width: defaultBorderWidth

            StatusIndicator {
                id: indSerial2
                x: marginIndicators
                y: marginIndicators
            }

            Text {
                id: txtSerial2Id
                x: 50
                y: marginIndicators
                height: indSerial2.height
                text: qsTr("Serial") + " 2"
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: defaultLabelFontSize
            }
        }
    }

    Shape {
        anchors.verticalCenter: rackFreq.bottom
        anchors.horizontalCenter: rackFreq.right
        anchors.horizontalCenterOffset: marginRacks / 2
        width: 2 * serialSWWidth + marginRacks + 2 * defaultMarginAndTextWidthHeight
        height: 2 * serialSWHeight + 2 * defaultMarginAndTextWidthHeight

        ShapePath {
            strokeWidth: 3
            strokeColor: "black"
            strokeStyle: ShapePath.DashLine
            fillColor: "transparent"

            startX: serialSWWidth / 2
            startY: serialSWHeight
            PathLine {
                x: serialSWWidth / 2
                y: serialSWHeight + 2 * defaultMarginAndTextWidthHeight
            }
            PathLine {
                x: serialSWWidth + 2 * defaultMarginAndTextWidthHeight + marginRacks + serialSWWidth / 2
                y: serialSWHeight
            }
            PathLine {
                x: serialSWWidth + 2 * defaultMarginAndTextWidthHeight + marginRacks + serialSWWidth / 2
                y: serialSWHeight + 2 * defaultMarginAndTextWidthHeight
            }
            PathLine {
                x: serialSWWidth / 2
                y: serialSWHeight
            }
        }

        ShapePath {
            strokeWidth: 3
            strokeColor: "black"
            strokeStyle: ShapePath.DashLine
            fillColor: "transparent"

            startX: serialSWWidth
            startY: serialSWHeight + 2 * defaultMarginAndTextWidthHeight + serialSWHeight / 2 - 15
            PathLine {
                x: serialSWWidth + 2 * defaultMarginAndTextWidthHeight + marginRacks
                y: serialSWHeight  + 2 * defaultMarginAndTextWidthHeight + serialSWHeight / 2 - 15
            }
        }

        ShapePath {
            strokeWidth: 3
            strokeColor: "black"
            strokeStyle: ShapePath.DashLine
            fillColor: "transparent"

            startX: serialSWWidth
            startY: serialSWHeight + 2 * defaultMarginAndTextWidthHeight + serialSWHeight / 2 + 15
            PathLine {
                x: serialSWWidth + 2 * defaultMarginAndTextWidthHeight + marginRacks
                y: serialSWHeight  + 2 * defaultMarginAndTextWidthHeight + serialSWHeight / 2 + 15
            }
        }
    }
}
