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
                id: rackAmp
                x: 939
                y: 71
                width: 791
                height: 697
                color: "#ffffff"
                border.width: 2

                Rectangle {
                        id: devSW2
                        x: 30
                        y: 727
                        width: 352
                        height: 79
                        color: "#ffffff"
                        border.width: 2

                        StatusIndicator {
                                id: indSW2
                                x: 10
                                y: 10
                        }

                        Text {
                                id: txtSW2Id
                                x: 50
                                y: 15
                                text: qsTr("Switch") + " 2"
                                font.pixelSize: 20
                        }
                }

                Rectangle {
                        id: devSerial2
                        x: 30
                        y: 588
                        width: 352
                        height: 79
                        color: "#ffffff"
                        border.width: 2

                        StatusIndicator {
                                id: indSerial2
                                x: 10
                                y: 10
                        }

                        Text {
                                id: txtSerial2Id
                                x: 50
                                y: 15
                                text: qsTr("Serial") + " 2"
                                font.pixelSize: 20
                        }
                }

        }

        Rectangle {
                id: rackFreq
                x: 74
                y: 71
                width: 791
                height: 697
                color: "#ffffff"
                border.width: 2

                Rectangle {
                        id: devSW1
                        x: 409
                        y: 727
                        width: 352
                        height: 79
                        color: "#ffffff"
                        border.width: 2

                        StatusIndicator {
                                id: indSW1
                                x: 10
                                y: 10
                        }

                        Text {
                                id: txtSW1Id
                                x: 50
                                y: 15
                                text: qsTr("Switch") + " 1"
                                font.pixelSize: 20
                        }
                }

                Rectangle {
                        id: devSerial1
                        x: 409
                        y: 588
                        width: 352
                        height: 79
                        color: "#ffffff"
                        border.width: 2

                        StatusIndicator {
                                id: indSerial1
                                x: 10
                                y: 10
                        }

                        Text {
                                id: txtSerial1Id
                                x: 50
                                y: 15
                                text: qsTr("Serial") + " 1"
                                font.pixelSize: 20
                        }
                }
        }

}
