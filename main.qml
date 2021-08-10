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
                    x: 30
                    y: 60
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
                    x: 60
                    y: 131
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
                    x: 410
                    y: 60
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
                    x: 440
                    y: 60
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
                    x: 440
                    y: 131
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
                    x: 30
                    y: 234
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
                    x: 60
                    y: 234
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
                    x: 60
                    y: 305
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
                    x: 410
                    y: 234
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
                    x: 440
                    y: 234
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
                    x: 440
                    y: 305
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
                    x: 30
                    y: 398
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
                    x: 60
                    y: 408
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
                    x: 410
                    y: 398
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
                    x: 440
                    y: 408
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
                    x: 409
                    y: 727
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
                            height: 34
                            text: qsTr("Switch") + " 1"
                            verticalAlignment: Text.AlignVCenter
                            font.pixelSize: 20
                    }
            }

            Rectangle {
                    id: devSerial1
                    x: 409
                    y: 588
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
                            height: 34
                            text: qsTr("Serial") + " 1"
                            verticalAlignment: Text.AlignVCenter
                            font.pixelSize: 20
                    }
            }
    }

    Rectangle {
            id: rackAmp
            x: 939
            y: 71
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
                    x: 30
                    y: 60
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
                    x: 60
                    y: 175
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
                    x: 410
                    y: 60
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
                    x: 440
                    y: 60
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
                    x: 440
                    y: 175
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
                    x: 30
                    y: 322
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
                    x: 60
                    y: 322
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
                    x: 60
                    y: 437
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
                    x: 410
                    y: 322
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
                    x: 440
                    y: 322
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
                    x: 440
                    y: 437
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
                    x: 30
                    y: 727
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
                            height: 34
                            text: qsTr("Switch") + " 2"
                            verticalAlignment: Text.AlignVCenter
                            font.pixelSize: 20
                    }
            }

            Rectangle {
                    id: devSerial2
                    x: 30
                    y: 588
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
                            height: 34
                            text: qsTr("Serial") + " 2"
                            verticalAlignment: Text.AlignVCenter
                            font.pixelSize: 20
                    }
            }
    }
}
