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

        DevFreq {
            id: devFreqDownFreq1Master
            Component.onCompleted: {
                setId(0x04);
                txtDownFreq1Id.text = name();
            }
        }
        DevFreq {
            id: devFreqDownFreq1Slave
            Component.onCompleted: setId(0x05)
        }

        Text {
            id: txtDownFreq1Id
            anchors.top: devDownFreq1Master.top
            anchors.right: devDownFreq1Master.left
            width: defaultMarginAndTextWidthHeight
            height: 2 * rackFreqBoxHeight
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            wrapMode: Text.WrapAnywhere
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: defaultLabelFontSize

            MouseArea {
                id: mouseDownFreqId
                anchors.fill: parent
                onClicked: {
                    objWinFreq.setVisible(true);
                }
            }
        }

        Rectangle {
            id: devDownFreq1Master
            x: 2 * defaultMarginAndTextWidthHeight
            y: 2 * defaultMarginAndTextWidthHeight
            width: rackFreqBoxWidth
            height: rackFreqBoxHeight
            StatusIndicator {
                id: indDownFreq1Master
                x: marginIndicators
                y: marginIndicators
            }
            border.width: defaultBorderWidth

            MouseArea {
                id: mouseDownFreq1Master
                anchors.fill: parent
                onClicked: {
                    objWinFreq.setVisible(true);
                    objWinFreq.requestActivate();
                    objWinFreq.raise();
                }
            }
        }

        Rectangle {
            id: devDownFreq1Slave
            anchors.left: devDownFreq1Master.left
            anchors.top: devDownFreq1Master.bottom
            anchors.topMargin: -defaultBorderWidth
            width: rackFreqBoxWidth
            height: rackFreqBoxHeight
            StatusIndicator {
                id: indDownFreq1Slave
                x: marginIndicators
                y: marginIndicators
            }
            border.width: defaultBorderWidth

            MouseArea {
                id: mouseDownFreq1Slave
                anchors.fill: parent
                onClicked: {
                    objWinFreq.setVisible(true);
                }
            }
        }

        DevFreq {
            id: devFreqDownFreq2Master
            Component.onCompleted: {
                setId(0x06);
                txtDownFreq2Id.text = name();
            }
        }
        DevFreq {
            id: devFreqDownFreq2Slave
            Component.onCompleted: setId(0x07)
        }

        Text {
            id: txtDownFreq2Id
            anchors.top: devDownFreq2Master.top
            anchors.right: devDownFreq2Master.left
            width: defaultMarginAndTextWidthHeight
            height: 2 * rackFreqBoxHeight
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            wrapMode: Text.WrapAnywhere
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: defaultLabelFontSize

            MouseArea {
                id: mouseDownFreq2Id
                anchors.fill: parent
                onClicked: {
                    objWinFreq.setVisible(true);
                }
            }
        }

        Rectangle {
            id: devDownFreq2Master
            anchors.left: devDownFreq1Master.right
            anchors.leftMargin: 2 * defaultMarginAndTextWidthHeight
            anchors.top: devDownFreq1Master.top
            width: rackFreqBoxWidth
            height: rackFreqBoxHeight
            StatusIndicator {
                id: indDownFreq2Master
                x: marginIndicators
                y: marginIndicators
            }
            border.width: defaultBorderWidth

            MouseArea {
                id: mouseDownFreq2Master
                anchors.fill: parent
                onClicked: {
                    objWinFreq.setVisible(true);
                }
            }
        }

        Rectangle {
            id: devDownFreq2Slave
            anchors.left: devDownFreq2Master.left
            anchors.top: devDownFreq2Master.bottom
            anchors.topMargin: -defaultBorderWidth
            width: rackFreqBoxWidth
            height: rackFreqBoxHeight
            StatusIndicator {
                id: indDownFreq2Slave
                x: marginIndicators
                y: marginIndicators
            }
            border.width: defaultBorderWidth

            MouseArea {
                id: mouseDownFreq2Slave
                anchors.fill: parent
                onClicked: {
                    objWinFreq.setVisible(true);
                }
            }
        }

        DevFreq {
            id: devFreqUpFreq1Master
            Component.onCompleted: {
                setId(0x00);
                txtUpFreq1Id.text = name();
            }
        }
        DevFreq {
            id: devFreqUpFreq1Slave
            Component.onCompleted: setId(0x01)
        }

        Text {
            id: txtUpFreq1Id
            anchors.top: devUpFreq1Master.top
            anchors.right: devUpFreq1Master.left
            width: defaultMarginAndTextWidthHeight
            height: 2 * rackFreqBoxHeight
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            wrapMode: Text.WrapAnywhere
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: defaultLabelFontSize

            MouseArea {
                id: mouseUpFreq1Id
                anchors.fill: parent
                onClicked: {
                    objWinFreq.setVisible(true);
                }
            }
        }

        Rectangle {
            id: devUpFreq1Master
            anchors.top: devDownFreq1Slave.bottom
            anchors.topMargin: defaultMarginAndTextWidthHeight
            anchors.left: devDownFreq1Slave.left
            width: rackFreqBoxWidth
            height: rackFreqBoxHeight
            StatusIndicator {
                id: indUpFreq1Master
                x: marginIndicators
                y: marginIndicators
            }
            border.width: defaultBorderWidth

            MouseArea {
                id: mouseUpFreq1Master
                anchors.fill: parent
                onClicked: {
                    objWinFreq.setVisible(true);
                }
            }
        }

        Rectangle {
            id: devUpFreq1Slave
            anchors.left: devUpFreq1Master.left
            anchors.top: devUpFreq1Master.bottom
            anchors.topMargin: -defaultBorderWidth
            width: rackFreqBoxWidth
            height: rackFreqBoxHeight
            StatusIndicator {
                id: indUpFreq1Slave
                x: marginIndicators
                y: marginIndicators
            }
            border.width: defaultBorderWidth

            MouseArea {
                id: mouseUpFreq1Slave
                anchors.fill: parent
                onClicked: {
                    objWinFreq.setVisible(true);
                }
            }
        }

        DevFreq {
            id: devFreqUpFreq2Master
            Component.onCompleted: {
                setId(0x02);
                txtUpFreq2Id.text = name();
            }
        }
        DevFreq {
            id: devFreqUpFreq2Slave
            Component.onCompleted: setId(0x03)
        }

        Text {
            id: txtUpFreq2Id
            anchors.top: devUpFreq2Master.top
            anchors.right: devUpFreq2Master.left
            width: defaultMarginAndTextWidthHeight
            height: 2 * rackFreqBoxHeight
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            wrapMode: Text.WrapAnywhere
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: defaultLabelFontSize

            MouseArea {
                id: mouseUpFreq2Id
                anchors.fill: parent
                onClicked: {
                    objWinFreq.setVisible(true);
                }
            }
        }

        Rectangle {
            id: devUpFreq2Master
            anchors.left: devUpFreq1Master.right
            anchors.leftMargin: 2 * defaultMarginAndTextWidthHeight
            anchors.top: devUpFreq1Master.top
            width: rackFreqBoxWidth
            height: rackFreqBoxHeight
            StatusIndicator {
                id: indUpFreq2Master
                x: marginIndicators
                y: marginIndicators
            }
            border.width: defaultBorderWidth

            MouseArea {
                id: mouseUpFreq2Master
                anchors.fill: parent
                onClicked: {
                    objWinFreq.setVisible(true);
                }
            }
        }

        Rectangle {
            id: devUpFreq2Slave
            anchors.left: devUpFreq2Master.left
            anchors.top: devUpFreq2Master.bottom
            anchors.topMargin: -defaultBorderWidth
            width: rackFreqBoxWidth
            height: rackFreqBoxHeight
            StatusIndicator {
                id: indUpFreq2Slave
                x: marginIndicators
                y: marginIndicators
            }
            border.width: defaultBorderWidth

            MouseArea {
                id: mouseUpFreq2Slave
                anchors.fill: parent
                onClicked: {
                    objWinFreq.setVisible(true);
                }
            }
        }

        DevDist {
            id: devDistMidFreq1
            Component.onCompleted: {
                setId(0x0A);
                txtMidFreq1Id.text = name();
            }
        }

        Text {
            id: txtMidFreq1Id
            anchors.top: devMidFreq1.top
            anchors.topMargin: -10
            anchors.right: devMidFreq1.left
            width: defaultMarginAndTextWidthHeight
            height: 2 * rackFreqBoxHeight + 20
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            wrapMode: Text.WrapAnywhere
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: defaultLabelFontSize

            MouseArea {
                id: mouseMidFreq1Id
                anchors.fill: parent
                onClicked: {
                    objWinDist.setVisible(true);
                }
            }
        }

        Rectangle {
            id: devMidFreq1
            anchors.top: devUpFreq1Slave.bottom
            anchors.topMargin: defaultMarginAndTextWidthHeight
            anchors.left: devUpFreq1Slave.left
            width: rackFreqBoxWidth
            height: 2 * rackFreqBoxHeight
            StatusIndicator {
                id: indMidFreq1
                x: marginIndicators
                y: marginIndicators
            }
            border.width: defaultBorderWidth

            MouseArea {
                id: mouseMidFreq1
                anchors.fill: parent
                onClicked: {
                    objWinDist.setVisible(true);
                }
            }
        }

        DevDist {
            id: devDistMidFreq2
            Component.onCompleted: {
                setId(0x0B);
                txtMidFreq2Id.text = name();
            }
        }

        Text {
            id: txtMidFreq2Id
            anchors.top: devMidFreq2.top
            anchors.topMargin: -10
            anchors.right: devMidFreq2.left
            width: defaultMarginAndTextWidthHeight
            height: 2 * rackFreqBoxHeight + 20
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            wrapMode: Text.WrapAnywhere
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: defaultLabelFontSize

            MouseArea {
                id: mouseMidFreq2Id
                anchors.fill: parent
                onClicked: {
                    objWinDist.setVisible(true);
                }
            }
        }

        Rectangle {
            id: devMidFreq2
            anchors.left: devMidFreq1.right
            anchors.leftMargin: 2 * defaultMarginAndTextWidthHeight
            anchors.top: devMidFreq1.top
            width: rackFreqBoxWidth
            height: 2 * rackFreqBoxHeight
            StatusIndicator {
                id: indMidFreq2
                x: marginIndicators
                y: marginIndicators
            }
            border.width: defaultBorderWidth

            MouseArea {
                id: mouseMidFreq2
                anchors.fill: parent
                onClicked: {
                    objWinDist.setVisible(true);
                }
            }
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

        DevAmp {
            id: devAmpAmpA1Master
            Component.onCompleted: {
                setId(0x0C);
                txtAmpA1Id.text = name();
            }
        }
        DevAmp {
            id: devAmpAmpA1Slave
            Component.onCompleted: setId(0x0D)
        }

        Text {
            id: txtAmpA1Id
            anchors.top: devAmpA1Master.top
            anchors.right: devAmpA1Master.left
            width: defaultMarginAndTextWidthHeight
            height: 2 * rackAmpBoxHeight
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            wrapMode: Text.WrapAnywhere
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: defaultLabelFontSize

            MouseArea {
                id: mouseAmpA1Id
                anchors.fill: parent
                onClicked: {
                    objWinAmp.setVisible(true);
                }
            }
        }

        Rectangle {
            id: devAmpA1Master
            x: 2 * defaultMarginAndTextWidthHeight
            y: 2 * defaultMarginAndTextWidthHeight
            width: rackAmpBoxWidth
            height: rackAmpBoxHeight
            StatusIndicator {
                id: indAmpA1Master
                x: marginIndicators
                y: marginIndicators
            }
            border.width: defaultBorderWidth

            MouseArea {
                id: mouseAmpA1Master
                anchors.fill: parent
                onClicked: {
                    objWinAmp.setVisible(true);
                }
            }
        }

        Rectangle {
            id: devAmpA1Slave
            anchors.left: devAmpA1Master.left
            anchors.top: devAmpA1Master.bottom
            anchors.topMargin: -defaultBorderWidth
            width: rackAmpBoxWidth
            height: rackAmpBoxHeight
            StatusIndicator {
                id: indAmpA1Slave
                x: marginIndicators
                y: marginIndicators
            }
            border.width: defaultBorderWidth

            MouseArea {
                id: mouseAmpA1Slave
                anchors.fill: parent
                onClicked: {
                    objWinAmp.setVisible(true);
                }
            }
        }

        DevAmp {
            id: devAmpAmpB1Master
            Component.onCompleted: {
                setId(0x0E);
                txtAmpB1Id.text = name();
            }
        }
        DevAmp {
            id: devAmpAmpB2Slave
            Component.onCompleted: setId(0x0F)
        }

        Text {
            id: txtAmpB1Id
            anchors.top: devAmpB1Master.top
            anchors.right: devAmpB1Master.left
            width: defaultMarginAndTextWidthHeight
            height: 2 * rackAmpBoxHeight
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            wrapMode: Text.WrapAnywhere
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: defaultLabelFontSize

            MouseArea {
                id: mouseAmpB1Id
                anchors.fill: parent
                onClicked: {
                    objWinAmp.setVisible(true);
                }
            }
        }

        Rectangle {
            id: devAmpB1Master
            anchors.top: devAmpA1Master.top
            anchors.left: devAmpA1Master.right
            anchors.leftMargin: 2 * defaultMarginAndTextWidthHeight
            width: rackAmpBoxWidth
            height: rackAmpBoxHeight
            StatusIndicator {
                id: indAmpB1Master
                x: marginIndicators
                y: marginIndicators
            }
            border.width: defaultBorderWidth

            MouseArea {
                id: mouseAmpB1Master
                anchors.fill: parent
                onClicked: {
                    objWinAmp.setVisible(true);
                }
            }
        }

        Rectangle {
            id: devAmpB1Slave
            anchors.left: devAmpB1Master.left
            anchors.top: devAmpB1Master.bottom
            anchors.topMargin: -defaultBorderWidth
            width: rackAmpBoxWidth
            height: rackAmpBoxHeight
            StatusIndicator {
                id: indAmpB1Slave
                x: marginIndicators
                y: marginIndicators
            }
            border.width: defaultBorderWidth

            MouseArea {
                id: mouseAmpB1Slave
                anchors.fill: parent
                onClicked: {
                    objWinAmp.setVisible(true);
                }
            }
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
            anchors.left: devAmpA1Slave.left
            anchors.top: devAmpA1Slave.bottom
            anchors.topMargin: defaultMarginAndTextWidthHeight
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
