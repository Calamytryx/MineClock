import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.20 as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    property alias cfg_showTime: showTimeCheckbox.checked
    property alias cfg_imagePadding: paddingSlider.value

    Kirigami.FormLayout {
        QQC2.CheckBox {
            id: showTimeCheckbox
            text: i18n("Show digital time")
            Kirigami.FormData.label: i18n("Display options:")
        }
        
        ColumnLayout {
            Kirigami.FormData.label: i18n("Image padding:")
            spacing: Kirigami.Units.smallSpacing
            
            RowLayout {
                QQC2.Slider {
                    id: paddingSlider
                    from: 0
                    to: 50
                    stepSize: 1
                    Layout.fillWidth: true
                }
                
                QQC2.Label {
                    text: paddingSlider.value + "%"
                    Layout.minimumWidth: Kirigami.Units.gridUnit * 2
                    horizontalAlignment: Text.AlignRight
                }
            }
            
            QQC2.Label {
                text: i18n("Adds padding around the clock image")
                font: Kirigami.Theme.smallFont
                opacity: 0.7
            }
        }
    }
}
