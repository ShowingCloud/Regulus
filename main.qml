import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Scene2D 2.9
import QtQuick.Scene3D 2.0
import QtQuick.Shapes 1.11
import QtQuick.Controls 1.6
import QtQuick.Controls.Styles.Desktop 1.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Window {
    visible: true
    width: 1800
    height: 900
    title: qsTr("RDSS Project")

    Rectangle {
            id: rackFreq
            x: 74
            y: 71
            width: 791
            height: 697
            border.width: 2

            Text {
                    id: txtRackFreqId
                    x: 0
                    y: 0
                    width: 791
                    height: 30
                    text: qsTr("Frequency Conversion Rack")
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 20
            }

            Text {
                    id: txtDownFreq1Id
                    anchors.top: devDownFreq1Master.top
                    anchors.right: devDownFreq1Master.left
                    width: 30
                    height: 146
                    text: "C1" + qsTr("Down Frequency Conversion")
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    wrapMode: Text.WrapAnywhere
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 20
            }

            Rectangle {
                    id: devDownFreq1Master
                    x: 60
                    y: 60
                    width: 320
                    height: 73
                    StatusIndicator {
                            id: indDownFreq1Master
                            x: 10
                            y: 10
                    }
                    border.width: 2
            }

            Rectangle {
                    id: devDownFreq1Slave
                    anchors.left: devDownFreq1Master.left
                    anchors.top: devDownFreq1Master.bottom
                    anchors.topMargin: -2
                    width: 320
                    height: 73
                    StatusIndicator {
                            id: indDownFreq1Slave
                            x: 10
                            y: 10
                    }
                    border.width: 2
            }

            Text {
                    id: txtDownFreq2Id
                    anchors.top: devDownFreq2Master.top
                    anchors.right: devDownFreq2Master.left
                    width: 30
                    height: 146
                    text: "C2" + qsTr("Down Frequency Conversion")
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    wrapMode: Text.WrapAnywhere
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 20
            }

            Rectangle {
                    id: devDownFreq2Master
                    anchors.left: devDownFreq1Master.right
                    anchors.leftMargin: 60
                    anchors.top: devDownFreq1Master.top
                    width: 320
                    height: 73
                    StatusIndicator {
                            id: indDownFreq2Master
                            x: 10
                            y: 10
                    }
                    border.width: 2
            }

            Rectangle {
                    id: devDownFreq2Slave
                    anchors.left: devDownFreq2Master.left
                    anchors.top: devDownFreq2Master.bottom
                    anchors.topMargin: -2
                    width: 320
                    height: 73
                    StatusIndicator {
                            id: indDownFreq2Slave
                            x: 10
                            y: 10
                    }
                    border.width: 2
            }

            Text {
                    id: txtUpFreq1Id
                    anchors.top: devUpFreq1Master.top
                    anchors.right: devUpFreq1Master.left
                    width: 30
                    height: 146
                    text: "C1" + qsTr("Up Frequency Conversion")
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    wrapMode: Text.WrapAnywhere
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 20
            }

            Rectangle {
                    id: devUpFreq1Master
                    anchors.top: devDownFreq1Slave.bottom
                    anchors.topMargin: 30
                    anchors.left: devDownFreq1Slave.left
                    width: 320
                    height: 73
                    StatusIndicator {
                            id: indUpFreq1Master
                            x: 10
                            y: 10
                    }
                    border.width: 2
            }

            Rectangle {
                    id: devUpFreq1Slave
                    anchors.left: devUpFreq1Master.left
                    anchors.top: devUpFreq1Master.bottom
                    anchors.topMargin: -2
                    width: 320
                    height: 73
                    StatusIndicator {
                            id: indUpFreq1Slave
                            x: 10
                            y: 10
                    }
                    border.width: 2
            }

            Text {
                    id: txtUpFreq2Id
                    anchors.top: devUpFreq2Master.top
                    anchors.right: devUpFreq2Master.left
                    width: 30
                    height: 146
                    text: "C2" + qsTr("Up Frequency Conversion")
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    wrapMode: Text.WrapAnywhere
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 20
            }

            Rectangle {
                    id: devUpFreq2Master
                    anchors.left: devUpFreq1Master.right
                    anchors.leftMargin: 60
                    anchors.top: devUpFreq1Master.top
                    width: 320
                    height: 73
                    StatusIndicator {
                            id: indUpFreq2Master
                            x: 10
                            y: 10
                    }
                    border.width: 2
            }

            Rectangle {
                    id: devUpFreq2Slave
                    anchors.left: devUpFreq2Master.left
                    anchors.top: devUpFreq2Master.bottom
                    anchors.topMargin: -2
                    width: 320
                    height: 73
                    StatusIndicator {
                            id: indUpFreq2Slave
                            x: 10
                            y: 10
                    }
                    border.width: 2
            }

            Text {
                    id: txtMidFreq1Id
                    anchors.top: devMidFreq1.top
                    anchors.topMargin: -10
                    anchors.right: devMidFreq1.left
                    width: 30
                    height: 166
                    text: qsTr("Middle Frequency Distribution") + "A"
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    wrapMode: Text.WrapAnywhere
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 20
            }

            Rectangle {
                    id: devMidFreq1
                    anchors.top: devUpFreq1Slave.bottom
                    anchors.topMargin: 30
                    anchors.left: devUpFreq1Slave.left
                    width: 320
                    height: 146
                    StatusIndicator {
                            id: indMidFreq1
                            x: 10
                            y: 10
                    }
                    border.width: 2
            }

            Text {
                    id: txtMidFreq2Id
                    anchors.top: devMidFreq2.top
                    anchors.topMargin: -10
                    anchors.right: devMidFreq2.left
                    width: 30
                    height: 166
                    text: qsTr("Middle Frequency Distribution") + "B"
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    wrapMode: Text.WrapAnywhere
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 20
            }

            Rectangle {
                    id: devMidFreq2
                    anchors.left: devMidFreq1.right
                    anchors.leftMargin: 60
                    anchors.top: devMidFreq1.top
                    width: 320
                    height: 146
                    StatusIndicator {
                            id: indMidFreq2
                            x: 10
                            y: 10
                    }
                    border.width: 2
            }

            Rectangle {
                    id: devSW1
                    anchors.left: devSerial1.left
                    anchors.top: devSerial1.bottom
                    anchors.topMargin: 60
                    width: 352
                    height: 79
                    border.width: 2

                    StatusIndicator {
                            id: indSW1
                            x: 10
                            y: 10
                    }

                    Text {
                            id: txtSW1Id
                            x: 50
                            y: 10
                            height: indSW1.height
                            text: qsTr("Switch") + " 1"
                            verticalAlignment: Text.AlignVCenter
                            font.pixelSize: 20
                    }
            }

            Rectangle {
                    id: devSerial1
                    anchors.right: rackFreq.right
                    anchors.rightMargin: 30
                    anchors.bottom: rackFreq.bottom
                    anchors.bottomMargin: 30
                    width: 352
                    height: 79
                    border.width: 2

                    StatusIndicator {
                            id: indSerial1
                            x: 10
                            y: 10
                    }

                    Text {
                            id: txtSerial1Id
                            x: 50
                            y: 10
                            height: indSerial1.height
                            text: qsTr("Serial") + " 1"
                            verticalAlignment: Text.AlignVCenter
                            font.pixelSize: 20
                    }
            }
    }

    Rectangle {
            id: rackAmp
            anchors.top: rackFreq.top
            anchors.left: rackFreq.right
            anchors.leftMargin: 74
            width: 791
            height: 697
            border.width: 2

            Text {
                    id: txtRackAmpId
                    x: 0
                    y: 0
                    width: 791
                    height: 30
                    text: qsTr("Amplification Rack")
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 20
            }

            Text {
                    id: txtAmpA1Id
                    anchors.top: devAmpA1Master.top
                    anchors.right: devAmpA1Master.left
                    width: 30
                    height: 234
                    text: "C1" + qsTr("High Amplification") + "A"
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    wrapMode: Text.WrapAnywhere
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 20
            }

            Rectangle {
                    id: devAmpA1Master
                    x: 60
                    y: 60
                    width: 320
                    height: 117
                    StatusIndicator {
                            id: indAmpA1Master
                            x: 10
                            y: 10
                    }
                    border.width: 2
            }

            Rectangle {
                    id: devAmpA1Slave
                    anchors.left: devAmpA1Master.left
                    anchors.top: devAmpA1Master.bottom
                    anchors.topMargin: -2
                    width: 320
                    height: 117
                    StatusIndicator {
                            id: indAmpA1Slave
                            x: 10
                            y: 10
                    }
                    border.width: 2
            }

            Text {
                    id: txtAmpB1Id
                    anchors.top: devAmpB1Master.top
                    anchors.right: devAmpB1Master.left
                    width: 30
                    height: 234
                    text: "C1" + qsTr("High Amplification") + "B"
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    wrapMode: Text.WrapAnywhere
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 20
            }

            Rectangle {
                    id: devAmpB1Master
                    anchors.top: devAmpA1Master.top
                    anchors.left: devAmpA1Master.right
                    anchors.leftMargin: 60
                    width: 320
                    height: 117
                    StatusIndicator {
                            id: indAmpB1Master
                            x: 10
                            y: 10
                    }
                    border.width: 2
            }

            Rectangle {
                    id: devAmpB1Slave
                    anchors.left: devAmpB1Master.left
                    anchors.top: devAmpB1Master.bottom
                    anchors.topMargin: -2
                    width: 320
                    height: 117
                    StatusIndicator {
                            id: indAmpB1Slave
                            x: 10
                            y: 10
                    }
                    border.width: 2
            }

            Text {
                    id: txtAmpA2Id
                    anchors.top: devAmpA2Master.top
                    anchors.right: devAmpA2Master.left
                    width: 30
                    height: 234
                    text: "C2" + qsTr("High Amplification") + "A"
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    wrapMode: Text.WrapAnywhere
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 20
            }

            Rectangle {
                    id: devAmpA2Master
                    anchors.left: devAmpA1Slave.left
                    anchors.top: devAmpA1Slave.bottom
                    anchors.topMargin: 30
                    width: 320
                    height: 117
                    StatusIndicator {
                            id: indAmpA2Master
                            x: 10
                            y: 10
                    }
                    border.width: 2
            }

            Rectangle {
                    id: devAmpA2Slave
                    anchors.left: devAmpA2Master.left
                    anchors.top: devAmpA2Master.bottom
                    anchors.topMargin: -2
                    width: 320
                    height: 117
                    StatusIndicator {
                            id: indAmpA2Slave
                            x: 10
                            y: 10
                    }
                    border.width: 2
            }

            Text {
                    id: txtAmpB2Id
                    anchors.top: devAmpB2Master.top
                    anchors.right: devAmpB2Master.left
                    width: 30
                    height: 234
                    text: "C2" + qsTr("High Amplification") + "B"
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    wrapMode: Text.WrapAnywhere
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 20
            }

            Rectangle {
                    id: devAmpB2Master
                    anchors.top: devAmpA2Master.top
                    anchors.left: devAmpA2Master.right
                    anchors.leftMargin: 60
                    width: 320
                    height: 117
                    StatusIndicator {
                            id: indAmpB2Master
                            x: 10
                            y: 10
                    }
                    border.width: 2
            }

            Rectangle {
                    id: devAmpB2Slave
                    anchors.left: devAmpB2Master.left
                    anchors.top: devAmpB2Master.bottom
                    anchors.topMargin: -2
                    width: 320
                    height: 117
                    StatusIndicator {
                            id: indAmpB2Slave
                            x: 10
                            y: 10
                    }
                    border.width: 2
            }

            Rectangle {
                    id: devSW2
                    anchors.left: devSerial2.left
                    anchors.top: devSerial2.bottom
                    anchors.topMargin: 60
                    width: 352
                    height: 79
                    border.width: 2

                    StatusIndicator {
                            id: indSW2
                            x: 10
                            y: 10
                    }

                    Text {
                            id: txtSW2Id
                            x: 50
                            y: 10
                            height: indSW2.height
                            text: qsTr("Switch") + " 2"
                            verticalAlignment: Text.AlignVCenter
                            font.pixelSize: 20
                    }
            }

            Rectangle {
                    id: devSerial2
                    anchors.left: rackAmp.left
                    anchors.leftMargin: 30
                    anchors.bottom: rackAmp.bottom
                    anchors.bottomMargin: 30
                    width: 352
                    height: 79
                    border.width: 2

                    StatusIndicator {
                            id: indSerial2
                            x: 10
                            y: 10
                    }

                    Text {
                            id: txtSerial2Id
                            x: 50
                            y: 10
                            height: indSerial2.height
                            text: qsTr("Serial") + " 2"
                            verticalAlignment: Text.AlignVCenter
                            font.pixelSize: 20
                    }
            }
    }

    Shape {
        anchors.verticalCenter: rackFreq.bottom
        anchors.horizontalCenter: rackFreq.right
        anchors.horizontalCenterOffset: 37
        width: 838
        height: 218

        ShapePath {
            strokeWidth: 3
            strokeColor: "black"
            strokeStyle: ShapePath.DashLine
            fillColor: "transparent"

            startX: 176; startY: 79
            PathLine { x: 176; y: 139 }
            PathLine { x: 662; y: 79 }
            PathLine { x: 662; y: 139 }
            PathLine { x: 176; y: 79 }
        }

        ShapePath {
            strokeWidth: 3
            strokeColor: "black"
            strokeStyle: ShapePath.DashLine
            fillColor: "transparent"

            startX: 352; startY: 174
            PathLine { x: 486; y: 174 }
        }

        ShapePath {
            strokeWidth: 3
            strokeColor: "black"
            strokeStyle: ShapePath.DashLine
            fillColor: "transparent"

            startX: 352; startY: 182
            PathLine { x: 486; y: 182 }
        }
    }
}
