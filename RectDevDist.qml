import QtQuick 2.15
import QtQuick.Extras 1.4

import rdss.alert 1.0

Item {
    property QtObject devDist
    property alias ind: ind

    StatusIndicator {
        id: ind
        x: marginIndicators
        y: marginIndicators
        active: false

        Component.onCompleted: devDist.gotData.connect(function() {
            active = true
            color = devDist.showIndicatorColor()
        })
    }
}
