import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.3

import rdss.alert 1.0

Dialog {
    id: winSetDist
    width: rect.width + 2 * defaultMarginRect
    height: rect.height + defaultHeightWidget + 2 * defaultMarginRect + defaultMarginWidget
    standardButtons: Dialog.NoButton
    title: qsTr("Frequency Distribution Device")

    required property QtObject devDist
    property alias dialogName : name.text
    property alias valueRef10 : comboRef10.index
    property alias valueRef16 : comboRef16.index

    Text {
        id: name
        x: -10 + defaultMarginRect + defaultMarginWidget
        y: -15 + defaultMarginRect
        height: defaultHeightWidget
        width: 2 * defaultWidthWidget
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: defaultLabelFontSize
    }

    Button {
        id: buttonCancel
        x: -10 + defaultMarginRect + rect.width - defaultMarginWidget - defaultWidthWidget
        anchors.top: name.top
        width: defaultWidthWidget
        height: defaultHeightWidget
        text: qsTr("Cancel")
        font.pixelSize: defaultLabelFontSize

        onClicked: winSetDist.close()
    }

    DiaConfirm {
        id: diaConfirm
        onAccepted: devDist.createCntlMsg()
        onReset: {
            devDist.releaseHold("ref_10")
            devDist.releaseHold("ref_16")
        }
    }
    Button {
        id: buttonSubmit
        anchors.right: buttonCancel.left
        anchors.rightMargin: defaultMarginWidget
        anchors.top: name.top
        width: defaultWidthWidget
        height: defaultHeightWidget
        text: qsTr("Submit")
        font.pixelSize: defaultLabelFontSize

        onClicked: {
            devDist.holdValue("ref_10", comboRef10.index)
            devDist.holdValue("ref_16", comboRef16.index)
            diaConfirm.open()
        }
    }

    Rectangle {
        id: rect
        x: -10 + defaultMarginRect
        anchors.top: name.bottom
        anchors.topMargin: defaultMarginWidget
        width: 2 * defaultWidthWidget + 2 * defaultWidthWidgetLabel + 5 * defaultMarginWidget
        height: defaultHeightWidget + 2 * defaultMarginWidget
        border.width: defaultBorderWidth

        ComboCombo {
            id: comboRef10
            posTop: 0
            posLeft: 0
            widthWidget: defaultWidthWidget
            widthWidgetLabel: defaultWidthWidgetLabel
            txtText: devDist ? devDist.varName("ref_10") : qsTr("Outer Ref") + " 10 MHz"

            Component.onCompleted: {
                comboModel = Alert.addEnum("P_CH", qsTr("Channel") + " ")
            }
        }

        ComboCombo {
            id: comboRef16
            posTop: 0
            posLeft: (rect.width - defaultMarginWidget) / 2
            widthWidget: defaultWidthWidget
            widthWidgetLabel: defaultWidthWidgetLabel
            txtText: devDist ? devDist.varName("ref_16") : qsTr("Outer Ref") + " 16 MHz"

            Component.onCompleted: {
                comboModel = Alert.addEnum("P_CH", qsTr("Channel") + " ")
            }
        }
    }
}
