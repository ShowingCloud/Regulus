import QtQuick 2.9
import QtQuick.Controls 1.6
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.9

Window {
    id: winFreq
    visible: false
    modality: Qt.ApplicationModal
    width: 900
    height: 900
    title: qsTr("Frequency Conversion Device")

    onClosing: {
        close.accepted = false
        this.hide()
    }
}
