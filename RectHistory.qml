import QtQuick 2.11
import QtQuick.Controls 2.4

Item {
    id: rectHist
    property int itemWidth
    property int itemHeight : defaultTextAreaHeight

    TextArea {
        id: txt
        width: itemWidth
        height: itemHeight
        wrapMode: TextEdit.Wrap
        focus: false
        readOnly: true
    }
}
