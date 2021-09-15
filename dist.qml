import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Dialogs 1.3
import QtQuick.Window 2.11

Window {
    id: winDist
    visible: false
    modality: Qt.ApplicationModal
    width: 600
    height: 600
    title: qsTr("Frequency Distribution Device")

    property QtObject devDist

    TextField {
        id: input
        x: 0
        y: 0
        height: 100
        width: 900
        placeholderText: qsTr("Master")
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: defaultLabelFontSize
    }

    onClosing: {
        close.accepted = false
        this.hide()
    }
}
