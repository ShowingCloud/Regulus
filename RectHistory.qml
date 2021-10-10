import QtQuick 2.15
import QtQuick.Controls 2.15

import rdss.alert 1.0

Item {
    id: rectHist
    property int itemWidth
    property int itemHeight : defaultHistoryAreaHeight
    property alias model : tableview.model

    HorizontalHeaderView {
        id: headerview
        syncView: tableview
    }

    TableView {
        id: tableview
        width: itemWidth
        height: itemHeight - headerview.height
        anchors.top: headerview.bottom
        clip: true

        model: AlertRecordModel

        delegate: Rectangle {
            implicitHeight: 40
            implicitWidth: sizehint
            border.width: 1

            Text {
                text: display
                anchors.fill: parent
                anchors.margins: 10
                font.pixelSize: rectBigFontSize
                verticalAlignment: Qt.AlignVCenter
                horizontalAlignment: textalignment
                color: foreground
            }
        }

        ScrollIndicator.vertical: ScrollIndicator {}
    }
}
