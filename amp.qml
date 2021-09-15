import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Dialogs 1.3
import QtQuick.Window 2.11

Window {
    id: winAmp
    visible: false
    modality: Qt.ApplicationModal
    width: 900
    height: 900
    title: qsTr("Amplification Device")

    onClosing: {
        close.accepted = false
        this.hide()
    }
}
