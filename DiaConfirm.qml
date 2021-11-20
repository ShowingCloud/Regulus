import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.3

import rdss.alert 1.0

Dialog {
    id: diaConfirm
    width: 200
    height: 200
    title: qsTr("Confirm")

    onVisibilityChanged: if (!this.visible) reset()
}
