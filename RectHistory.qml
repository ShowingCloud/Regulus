import QtQuick 2.15
import QtQuick.Controls 2.15

import rdss.alert 1.0

Item {
    id: rectHist
    property int itemWidth
    property int itemHeight : defaultHistoryAreaHeight
    property alias model : tableview.model

    TableView {
        id: tableview
        columnSpacing: 1
        rowSpacing: 1
        width: itemWidth
        height: itemHeight
        clip: true

        model: AlertRecordModel

        delegate: Rectangle {
            implicitHeight: 50
            implicitWidth: 200
            border.width: 1

            Text {
                text: display
                anchors.centerIn: parent
                font.pixelSize: rectBigFontSize
            }
        }

        ScrollIndicator.vertical: ScrollIndicator {}
    }
}
