import "." as Local
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.ksvg as KSvg
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasma5support as Plasma5Support
import org.kde.plasma.plasma5support 2.0 as P5Support
import org.kde.plasma.plasmoid
import org.kde.plasma.private.kicker 0.1 as Kicker

PlasmoidItem {
    id: root
    
    preferredRepresentation: fullRepresentation
    fullRepresentation: Item {
        id: fullRep
        
        Layout.minimumWidth: PlasmaCore.Units.gridUnit * 1
        Layout.minimumHeight: PlasmaCore.Units.gridUnit * 1
        Layout.preferredWidth: Layout.minimumWidth
        Layout.preferredHeight: Layout.minimumHeight
        anchors.fill: parent
        Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground
        
        property int frame: 0
        property string currentTime: "00:00"
        
        function updateFrame() {
            var now = new Date();
            var hours = now.getHours();
            var mins = now.getMinutes();
            
            // Format the time string with leading zeros
            currentTime = (hours < 10 ? "0" : "") + hours + ":" + (mins < 10 ? "0" : "") + mins;
            
            var minutes = hours * 60 + mins;
            var offset = minutes - 720; // Offset for noon as frame 0
            var f = Math.floor((offset / 1440) * 64) % 64;
            if (f < 0) f += 64;
            frame = f;
            console.log("Current frame: " + frame + " Time: " + hours + ":" + mins);
        }
        
        Component.onCompleted: {
            updateFrame();
            console.log("Image path: " + Qt.resolvedUrl("clock/pixil-frame-" + frame + ".png"));
        }
        
        Timer {
            interval: 60000 // Update every minute
            running: true
            repeat: true
            onTriggered: updateFrame()
        }
        
        Image {
            id: clockImage
            anchors {
                fill: parent
                // Add padding based on the configuration
                topMargin: parent.height * Plasmoid.configuration.imagePadding / 100
                bottomMargin: parent.height * Plasmoid.configuration.imagePadding / 100
                leftMargin: parent.width * Plasmoid.configuration.imagePadding / 100
                rightMargin: parent.width * Plasmoid.configuration.imagePadding / 100
            }
            source: Qt.resolvedUrl("clock/pixil-frame-" + frame + ".png")
            fillMode: Image.PreserveAspectFit
            
            onStatusChanged: {
                if (status === Image.Error) {
                    console.log("Failed to load image: " + source);
                    fallbackText.visible = true;
                } else if (status === Image.Ready) {
                    console.log("Image loaded successfully: " + source);
                    fallbackText.visible = false;
                }
            }
        }
        
        Text {
            id: timeText
            visible: Plasmoid.configuration.showTime
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                topMargin: parent.height * 0.75 // Position at 75% from top
            }
            text: currentTime
            color: "white"
            font {
                pointSize: Math.max(8, Math.min(parent.width / 6, parent.height / 6))
                bold: true
            }
            style: Text.Outline
            styleColor: "black"
            z: 2 // Ensure text is above image
        }
        
        Text {
            id: fallbackText
            anchors.centerIn: parent
            text: "Frame: " + frame + "\nCannot load image"
            color: "white"
            visible: false
        }
    }
}