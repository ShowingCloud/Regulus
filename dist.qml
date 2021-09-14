import QtQuick 2.9
import QtQuick.Controls 1.6
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.9

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
