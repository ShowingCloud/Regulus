import QtQuick 2.9
import QtQuick.Controls 1.6

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
