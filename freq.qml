import QtQuick 2.9
import QtQuick.Controls 1.6
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.9

Window {
    id: winFreq
    visible: false
    modality: Qt.ApplicationModal
    width: 600
    height: 600
    title: qsTr("Frequency Conversion Device")

    property QtObject devFreqMaster
    property QtObject devFreqSlave

    TextField {
        id: inputMaster
        x: 0
        y: 0
        height: 100
        width: 900
        placeholderText: qsTr("Master")
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: defaultLabelFontSize

        onAccepted: {
            devFreqMaster.createCntlMsg(text);
        }
    }

    TextField {
        id: inputSlave
        x: 0
        anchors.top: inputMaster.bottom
        height: 100
        width: 900
        placeholderText: qsTr("Slave")
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: defaultLabelFontSize

        onAccepted: {
            devFreqSlave.createCntlMsg(text);
        }
    }

    onClosing: {
        close.accepted = false
        this.hide()
    }
}
