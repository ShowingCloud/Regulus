import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.3
import QtQml.Models 2.15

import rdss.alert 1.0

Dialog {
    id: diaConfirm
    width: 500
    height: 500
    title: qsTr("Confirm")

    signal reset()
    signal append(string line, string color)

    onVisibilityChanged: if (!this.visible) reset()
    onReset: model.clear()

    ListModel {
        id: model
        Component.onCompleted: {
            diaConfirm.append.connect(function(line, color) {
                append({"line_text": line, "line_color": color})
            })
        }
    }

    ListView {
        id: list
        width: 400
        height: 300
        x: defaultMarginAndTextWidthHeight
        y: defaultMarginAndTextWidthHeight
        spacing: defaultMarginAndTextWidthHeight
        model: model
        delegate: Text {
            text: line_text
            color: line_color
            font.pixelSize: defaultLabelFontSize
        }
    }
}
