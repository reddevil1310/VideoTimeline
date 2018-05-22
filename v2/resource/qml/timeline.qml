import QtQuick 2.2
import QtQml.Models 2.1
import QtQuick.Controls 1.0
import Studio.Timeline 1.0
import QtGraphicalEffects 1.0
import QtQuick.Window 2.2
import 'Timeline.js' as TimelineLogic

Rectangle {
    // system attributes
    id: root  
    color: 'transparent' 

    // custom properties
    property int  currentTrack: 0
    property color selectedTrackColor: Qt.rgba(0.5, 0.5, 0, 0.3)
    property color sutdioYellow: Qt.rgba(255/255, 215/255, 0/255, 1.0)  
    readonly property int padding: 30
    
    // signals
    signal clipClicked()

    // signal handlers
    onCurrentTrackChanged: timeline.selection = []

    // functions
    function addClip() {
        console.log("add clip");
    }

    // components
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
    }

    DropArea {
        anchors.fill: parent
        onEntered: {}
        onExited: {}
        onPositionChanged: {}
        onDropped: {}
    }

    TimelineToolbar {
        id: toolbar 
        width: parent.width
        height: 40
        anchors.top: parent.top
    }

    Row {
        anchors.top: toolbar.bottom 

        MouseArea {
            id: tracksMouseArea
            anchors.fill: parent
            focus: true 
            hoverEnabled: true
            onClicked: {}
            onPositionChanged: {}

            Column {
                anchors.fill: parent
                Flickable {
                    contentX: tracksScrollView.flickableItem.contentX
                    width: tracksBackground.width
                    height: ruler.height
                    interactive: false
                    Ruler {
                        id: ruler
                        width: parent.width 
                    }
                } 

                ScrollView {
                    id: tracksScrollView
                    width: root.width
                    height: root.height - ruler.height - toolbar.height

                    Item { 
                        width: tracksBackground.width
                        height: tracksScrollView.height + padding
                        
                        // tracks background
                        Column {
                            id: tracksBackground 
                            width: root.width + 100
                            height: parent.height
                            Repeater {
                                id: tracksRepeater
                                model: tracksModel 
                            } 
                        }
                    } 
                } 
            }
            Rectangle {
                id: cursor
                visible: true
                color: 'black'
                width: 1
                height: tracksScrollView.height + padding - tracksScrollView.__horizontalScrollBar.height
                x: 250
                y: 0
            }

            TimelinePlayhead {
                id: playhead
                visible: true
                x: cursor.x - 5
                y: 0
                width: 11
                height: 5
            }
        }
    } 

    DelegateModel {
        id: tracksModel
        model: timelinetracks
        Track {
            model: timelinetracks
            rootIndex: tracksModel.modelIndex(index)
            color: (index == currentTrack)? selectedTrackColor : sutdioYellow;
            height: TimelineLogic.trackHeight(false)
            timeScale: timelinetracks.scaleFactor
            onClipClicked: {}
            onClipDragged: {}
            onClipDropped: {}
            onCheckSnap: {}
        } 
    }
}
