import QtQuick 2.15
import QtQuick.Extras 1.4

import rdss.alert 1.0

Item {
    property QtObject devFreq
    property alias ind: ind
    property bool devIsMaster: false

    StatusIndicator {
        id: ind
        x: marginIndicators
        y: marginIndicators
        active: false

        Component.onCompleted: devFreq.gotData.connect(function() {
            active = true
            color = devFreq.showIndicatorColor()
        })
    }
}
