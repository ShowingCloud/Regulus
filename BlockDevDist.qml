import QtQuick 2.15
import QtQuick.Extras 1.4

import rdss.device 1.0
import rdss.alert 1.0

Item {
    id: blockDevDist
    property int posLeft : 0
    property int posTop : 0
    property int posRight : rectDev.x + rectDev.width
    property int posBottom: rectDev.y + rectDev.height

    DevDist {
        id: devDist
    }
    property alias deviceId : devDist.dId

    Rectangle {
        id: rectDev
        x: posLeft
        y: posTop
        width: singleBoxWidth
        height: singleBoxHeight
        border.width: defaultBorderWidth

        Rectangle {
            x: 0
            y: 0
            width: 50
            height: singleBoxHeight
            border.width: defaultBorderWidth
            Text {
                id: txtId
                anchors.fill: parent
                text: devDist.name
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                wrapMode: Text.WrapAnywhere
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: defaultLabelFontSize
            }
        }

        StatusIndicator {
            id: ind
            anchors.right: rectDev.right
            anchors.rightMargin: marginIndicators
            anchors.top: rectDev.top
            anchors.topMargin: marginIndicators
            active: false

            Component.onCompleted: devDist.gotData.connect(function() {
                active = true
                color = devDist.showIndicatorColor()
            })
        }

        MouseArea {
            id: mouseDev
            anchors.fill: parent
            onClicked: mouseClick()
        }

        Timer {
            property string colorValue: Alert.MAP_COLOR["OTHERS"]

            id: timer
            interval: Alert.timeout * 1000
            running: true
            repeat: true

            Component.onCompleted: devDist.gotData.connect(function() {
                if (!devDist.timedout()) colorValue = Alert.MAP_COLOR["NORMAL"]
                if (objWinDist.devDist === devDist)
                    objWinDist.communicationColorValue = colorValue
                restart()
            });
            onTriggered: {
                colorValue = devDist.timedout() ? Alert.MAP_COLOR["ABNORMAL"] : Alert.MAP_COLOR["NORMAL"]
                if (objWinDist.devDist === devDist)
                    objWinDist.communicationColorValue = colorValue
                if (devDist.timedout()) {
                    devDist.alertTimeout()
                    if (ind.active)
                        ind.color = Alert.MAP_COLOR["ABNORMAL"]
                }
            }
        }
    }

    function mouseClick() {
        objWinDist.setVisible(true)
        objWinDist.opened(devDist)
        objWinDist.communicationColorValue = timer.colorValue
    }
}
