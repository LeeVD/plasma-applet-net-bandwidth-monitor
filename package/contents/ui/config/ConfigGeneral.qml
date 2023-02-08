/*
 * Copyright 2023  LeeVD <thoth360@hotmail.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 3 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http: //www.gnu.org/licenses/>.
 */

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.1

Item {
    property alias  cfg_showSeparately: showSeparately.checked
    property string cfg_speedLayout:    speedLayout
    property bool   cfg_swapDownUp:     false
    property string cfg_iconType:       iconType
    property bool   cfg_iconPosition:   iconPosition   //  true = right | false = left
    property alias  cfg_showIcons:      showIcons.checked
    property alias  cfg_showUnits:      showUnits.checked
    property string cfg_speedUnits:     'bits'
    property alias  cfg_shortUnits:     shortUnits.checked
    property double cfg_fontSize:       fontSize
    property double cfg_updateInterval: updateInterval
    property string cfg_binaryDecimal:  'binary'
    property double cfg_decimalPlace:   decimalPlace
    property int    cfg_layoutPadding:  layoutPadding
    property bool   cfg_accumulator:    accumulator
    property alias  cfg_hideInactive:   hideInactive.checked
    property bool   cfg_hideZone:       hideZone

    GridLayout {
        columns: 3
        columnSpacing: 15
        rowSpacing: 15

        //________ COLUMN WIDTH ________ 
        TextMetrics {
            id: labelTextMetrics
            text: " 10 pixel closer  "
            //font.pixelSize: 64
        }

        //________ PADDING ________ 
        Rectangle {
            Layout.column: 0
            height: 2
            Layout.minimumWidth: 10 //(parent.width / 100) * 40 
            width: 5 // (parent.width / 100) * 40 
            color: "transparent"
        }

        //________ LAYOUT ________ 
        Label {
            Layout.row:                 1
            Layout.column:              1
            text:                       i18n('Layout:')
        }
        RowLayout {
            RadioButton {
                id:                     speedLayout_rb0
                Layout.row:             1
                Layout.column:          2
                Layout.rightMargin:     20      // PADDING RIGHT
                checked:                plasmoid.configuration.speedLayout === 'auto'
                text:                   i18n("Automatic")
                onReleased:             cfg_speedLayout = 'auto'
            }
            RadioButton {
                id:                     speedLayout_rb1
                Layout.row:             1
                Layout.column:          2
                Layout.rightMargin:     20      // PADDING RIGHT
                checked:                plasmoid.configuration.speedLayout === 'column'
                text:                   i18n("Vertical")
                onReleased:             cfg_speedLayout = 'column'    // ONE ABOVE OTHER
            }
            RadioButton {
                id:                     speedLayout_rb2
                Layout.row:             1
                Layout.column:          2
                checked:                plasmoid.configuration.speedLayout === 'row'
                text:                   i18n("Horizontal")
                onReleased:             cfg_speedLayout = 'row'       // SIDE BY SIDE
            }
        }

        //________ DISPLAY ORDER ________ 
        Label {
            Layout.row:                 2
            Layout.column:              1
            text:                       i18n('Display order:')
        }
        RowLayout {
            RadioButton {
                // Layout.row: 2
                // Layout.column: 2
                Layout.rightMargin:     20  // PADDING RIGHT
                checked:                plasmoid.configuration.swapDownUp === true
                text:                   i18n("Upload speed first")
                onReleased:             cfg_swapDownUp = true
            }
            RadioButton {
                // Layout.row: 2
                // Layout.column: 2
                checked:                plasmoid.configuration.swapDownUp === false
                text:                   i18n("Download speed first")
                onReleased:             cfg_swapDownUp = false
            }
        }
        //________ SHOW SPEED SEPERATELY ________ 
        Label {
            Layout.row: 3
            Layout.column: 1
            text: i18n('Show speeds separately:')
        }
        CheckBox {
            id: showSeparately
            Layout.row: 3
            Layout.column: 2
            checked: true
        }

        //________ FONT SIZE ________ 
        Label {
            Layout.row: 4
            Layout.column: 1
            text: i18n('Font size:')
        }
        RowLayout {
            id: fontSizeRow
            Layout.row: 4
            Layout.column: 2

            property var buttonPressed

            function setFontSize() {

                var s
                if (buttonPressed.text === "▲") {
                    fontSizeUP.enabled == true
                    cfg_fontSize += 0.01
                    s = 2

                    if (cfg_fontSize === s) {
                        fontSizeUP.enabled = false
                        fontSizeButtonTimer.stop()
                    } else {
                        fontSizeDOWN.enabled = true
                    }
                }
                if (buttonPressed.text === "▼") {
                    fontSizeDOWN.enabled == true
                    cfg_fontSize -= 0.01
                    s = 0.5

                    if (cfg_fontSize === s) {
                        fontSizeDOWN.enabled = false
                        fontSizeButtonTimer.stop()
                    } else {
                        fontSizeUP.enabled = true
                    }
                }       
                cfg_fontSize = Number.parseFloat(cfg_fontSize).toFixed(2);
            }
            Rectangle {
                width: labelTextMetrics.width
                height: textLabel.height
                color: "transparent"
                Label {
                    id: textLabel
                    text: (cfg_fontSize * 100).toFixed(0) + " %"
                }
            }
            Rectangle {
                width: (fontSizeUP.x - fontSizeDOWN.x) + (fontSizeDOWN.width + 2)
                height: fontSizeDOWN.height + 2
                color: "transparent"
                border.color: "dark grey"
                border.width: 0.5
                radius: 4           
                RowLayout {              
                    Button {
                        id: fontSizeDOWN
                        text: "▼"
                        implicitWidth: fontSizeDOWN.height
                        Layout.margins: 1   //buttonMargin
                        enabled: cfg_fontSize != 0.5
                        onPressAndHold: {
                            fontSizeRow.buttonPressed = fontSizeDOWN
                            fontSizeButtonTimer.start() 
                            }
                        onReleased: {
                            fontSizeRow.buttonPressed = fontSizeDOWN
                            fontSizeRow.setFontSize()
                            fontSizeButtonTimer.stop()
                        }
                    }
                    Button {
                        id: fontSizeUP
                        text: "▲"
                        implicitWidth: fontSizeUP.height
                        Layout.margins: 1   //buttonMargin
                        enabled: cfg_fontSize != 2
                        onPressAndHold: { 
                            fontSizeRow.buttonPressed = fontSizeUP 
                            fontSizeButtonTimer.start() 
                            }
                        onReleased: {
                            fontSizeRow.buttonPressed = fontSizeUP
                            fontSizeRow.setFontSize()
                            fontSizeButtonTimer.stop()
                        }
                    }
                    Timer {
                        id: fontSizeButtonTimer
                        interval: 100 // repeat every 200 milliseconds
                        running: false
                        repeat: true
                        onTriggered: fontSizeRow.setFontSize()
                    }
                }
            }
        }  

        //________ UPDATE INTERVAL ________ 
        Label {
            Layout.row: 5
            Layout.column: 1
            text: i18n('Update interval:')
        }
        RowLayout {
            id: intervalRow
            Layout.row: 5
            Layout.column: 2

            property var buttonPressed

            function setInterval(){

                var s
                if (buttonPressed.text === "▲") {
                    intervalUP.enabled == true
                    cfg_updateInterval += 500
                    s = 5000

                    if (cfg_updateInterval === s) {
                        intervalUP.enabled = false
                        intervalButtonTimer.stop()
                    } else {
                        intervalDOWN.enabled = true
                    }
                }
                if (buttonPressed.text === "▼") {
                    intervalDOWN.enabled == true
                    cfg_updateInterval -= 500
                    s = 500

                    if (cfg_updateInterval === s) {
                        intervalDOWN.enabled = false
                        intervalButtonTimer.stop()

                    } else {
                        intervalUP.enabled = true
                    }
                }
            }
            Rectangle {
                width: labelTextMetrics.width
                height: intervalLabel.height
                color: "transparent"
                Label {
                    id: intervalLabel
                    text: {
                        if (cfg_updateInterval===1000)  return (cfg_updateInterval / 1000) + " second"
                        else                            return (cfg_updateInterval / 1000) + " seconds"
                    }
                }
            }
            Rectangle {
                width: (intervalUP.x - intervalDOWN.x) + (intervalDOWN.width + 2)
                height: intervalDOWN.height + 2
                color: "transparent"
                border.color: "dark grey"
                border.width: 0.5
                radius: 4           
                RowLayout {
                    //id: buttonB                    
                    Button {
                        id: intervalDOWN
                        text: "▼"
                        implicitWidth: intervalDOWN.height
                        Layout.margins: 1   //buttonMargin
                        enabled: cfg_updateInterval  != 500
                        onPressAndHold: {
                            intervalRow.buttonPressed = intervalDOWN
                            intervalButtonTimer.start() 
                            }
                        onReleased: {
                            intervalRow.buttonPressed = intervalDOWN
                            intervalRow.setInterval()
                            intervalButtonTimer.stop()
                        }
                    }
                    Button {
                        id: intervalUP
                        text: "▲"
                        implicitWidth: intervalUP.height
                        Layout.margins: 1   //buttonMargin
                        enabled: cfg_updateInterval  != 5000
                        onPressAndHold: { 
                            intervalRow.buttonPressed = intervalUP 
                            intervalButtonTimer.start() 
                            }
                        onReleased: {
                            intervalRow.buttonPressed = intervalUP
                            intervalRow.setInterval()
                            intervalButtonTimer.stop()
                        }
                    }
                    Timer {
                        id: intervalButtonTimer
                        interval: 200 // repeat every 200 milliseconds
                        running: false
                        repeat: true
                        onTriggered: intervalRow.setInterval()
                    }
                }
            }
        }  

        //________ ACCUMULATOR ________ 
        Label {
            Layout.row:                 6
            Layout.column:              1
            text:                       i18n('Interval data relay:')
        }
        RowLayout {
            id: accumRow
            function setEnabled() {
                if (cfg_updateInterval > 500)  {
                    return true
                } else {
                    rbAccum.checked = true
                    cfg_accumulator = false
                    return false
                }
            }
            RadioButton {
                id:                     rbAccum
                Layout.row:             1
                Layout.column:          2
                Layout.rightMargin:     20  // PADDING RIGHT
                enabled:                accumRow.setEnabled()
                checked:                plasmoid.configuration.accumulator === false
                text:                   i18n("Current")
                onReleased:             cfg_accumulator = false
            }
            RadioButton {
                Layout.row:             1
                Layout.column:          2
                checked:                plasmoid.configuration.accumulator === true
                enabled:                accumRow.setEnabled()
                text:                   i18n("Accumulated")
                onReleased:             cfg_accumulator = true
            }
        }

        //________ LAYOUT 'COLUMN' PADDING ________ 
        Label {
            Layout.row:                 7
            Layout.column:              1
            text:                       i18n('Layout Padding:')
        }
        RowLayout {
            id:                         paddingRow
            Layout.row:                 7
            Layout.column:              2

            property var buttonPressed

            function setPadding() {
                
                var s
                if (buttonPressed.text === "▲") {
                    paddingUP.enabled == true
                    cfg_layoutPadding -= 1
                    s = -10

                    if (cfg_layoutPadding === s) {
                        paddingUP.enabled = false
                        paddingButtonTimer.stop()
                    } else {
                        paddingDOWN.enabled = true
                    }
                }
                if (buttonPressed.text === "▼") {
                    paddingDOWN.enabled == true
                    cfg_layoutPadding += 1
                    s = 10

                    if (cfg_layoutPadding === s) {
                        paddingDOWN.enabled = false
                        paddingButtonTimer.stop()
                    } else {
                        paddingUP.enabled = true
                    }
                }             
            }
            function paddingText() {        // MATH -i * -1 = +i
                if          (cfg_layoutPadding === 0) {
                    return "Default pixels"
                // NEGATIVE NUMBER = MOVE LAYOUT CLOSER
                } else if   (Math.sign(cfg_layoutPadding) === -1) {   //Math.sign returns '-1' if number is a negative
                    if      (cfg_layoutPadding === -1) return (cfg_layoutPadding * -1) + " pixel closer"
                    return  (cfg_layoutPadding * -1) + " pixels closer"
                // POSITIVE NUMBER = MOVE LAYOUT APART
                } else {
                    if      (cfg_layoutPadding ===  1) return cfg_layoutPadding + " pixel apart"
                    return   cfg_layoutPadding + " pixels apart"
                }
            }
            Rectangle {
                width: labelTextMetrics.width
                height: paddingLabel.height
                color: "transparent"
                Label {
                    id: paddingLabel
                    text: paddingRow.paddingText()
                }
            }
            Rectangle {
                width: (paddingUP.x - paddingDOWN.x) + (paddingDOWN.width + 2)
                height: paddingDOWN.height + 2
                color: "transparent"
                border.color: "dark grey"
                border.width: 0.5
                radius: 4           
                RowLayout {                  
                    Button {
                        id: paddingDOWN
                        text: "▼"
                        implicitWidth: paddingDOWN.height
                        Layout.margins: 1   //buttonMargin
                        enabled: cfg_layoutPadding != 10
                        onPressAndHold: {
                            paddingRow.buttonPressed = paddingDOWN
                            paddingButtonTimer.start() 
                        }
                        onReleased: {
                            paddingRow.buttonPressed = paddingDOWN
                            paddingRow.setPadding()
                            paddingButtonTimer.stop()
                        }
                    }
                    Button {
                        id: paddingUP
                        text: "▲"
                        implicitWidth: paddingUP.height
                        Layout.margins: 1   //buttonMargin
                        enabled: cfg_layoutPadding != -10 
                        onPressAndHold: { 
                            paddingRow.buttonPressed = paddingUP 
                            paddingButtonTimer.start() 
                        }
                        onReleased: {
                            paddingRow.buttonPressed = paddingUP
                            paddingRow.setPadding()
                            paddingButtonTimer.stop()
                        }
                    }
                    Timer {
                        id: paddingButtonTimer
                        interval: 200 // repeat every 200 milliseconds
                        running: false
                        repeat: true
                        onTriggered: paddingRow.setPadding()
                    }
                }
            }
        }  

        //________ INACTIVE HIDE ________ 
        Label {
            Layout.row:                 8
            Layout.column:              1
            text:                       i18n('Hide when inactive:')
        }
        CheckBox {
            id:                         hideInactive
            Layout.row:                 8
            Layout.column:              2
            onCheckedChanged: {
                if (!hideInactive.checked) {
                    cfg_hideZone = false
                    //rbZone1.checked = true
                }
            }
        }    

        //________ SPACER ________ 
        Rectangle {
            Layout.row:                 9
            Layout.column:              0
            height:                     20
            Layout.minimumWidth:        10 //(parent.width / 100) * 40 
            width:                      (parent.width / 100) * 40 
            color:                      "transparent"
        }

        //________ SHOW SPEED UNITS ________
        Label {
            Layout.row:                 10
            Layout.column:              1
            text:                       i18n('Show speed units:')
        }
        CheckBox {
            id:                         showUnits
            Layout.row:                 10
            Layout.column:              2
        } 

        //________ SPEED UNITS ________
        Label {
            Layout.row:                 11
            Layout.column:              1
            text:                       i18n('Speed units:')
        }
        RowLayout {
            RadioButton {
                //Layout.row:             10
                //Layout.column:          2
                Layout.rightMargin:     20  // PADDING RIGHT
                checked:                plasmoid.configuration.speedUnits === 'bits'
                text:                   i18n("Bits")
                onReleased:             cfg_speedUnits = 'bits'
            }
            RadioButton {
                //Layout.row:             9
                //Layout.column:          2
                checked:                plasmoid.configuration.speedUnits === 'bytes'
                text:                   i18n("Bytes")
                onReleased:             cfg_speedUnits = 'bytes'
            }
        }

        //________ SHORTEN SPEED UNITS ________
        Label {
            Layout.row:                 12
            Layout.column:              1
            text:                       i18n('Shorten speed units:')
        }
        CheckBox {
            id:                         shortUnits
            Layout.row:                 12
            Layout.column:              2
        }  

        //________ SPACER ________ 
        Rectangle {
            Layout.row:                 13
            Layout.column:              0
            height:                     20
            Layout.minimumWidth:        10 //(parent.width / 100) * 40 
            width:                      (parent.width / 100) * 40 
            color:                      "transparent"
        }

        //________ SHOW SPEED ICONS ________
        Label {
            Layout.row:                 14
            Layout.column:              1
            text:                       i18n('Show speed icons:')
        }
        CheckBox {
            id:                         showIcons
            Layout.row:                 14
            Layout.column:              2
        }          

        //________ ICONS STYLE ________
        Label {
            Layout.row:                 15
            Layout.column:              1            
            text:                       i18n('Icon Style:')
        }
        ComboBox {
            // ICONS FROM HACK FONT AND NATO SAN
            id:                         iconType
            Layout.row:                 15
            Layout.column:              2
            textRole:                   'text'

            model: [
                { text: i18n('ᐁ ᐃ') },
                { text: i18n('▽ △') },
                { text: i18n('▼ ▲') },
                { text: i18n('⮟ ⮝') }, 
                { text: i18n('⩔ ⩓') }, 
                { text: i18n('🢗 🢕') }, 
                { text: i18n('⋁ ⋀') }, 
                { text: i18n('◥ ◢') }, 
                { text: i18n('D: U:') },
                { text: i18n('🠇 🠅') },
                { text: i18n('🠋 🠉') },
                { text: i18n('🡇 🡅') },
                { text: i18n('🡫 🡩') },
                { text: i18n('⮋ ⮉') },
                { text: i18n('⇩ ⇧') },
                { text: i18n('⮯ ⮭') },
                { text: i18n('⥥ ⥣') }
            ]

            onCurrentIndexChanged: cfg_iconType = model[currentIndex]['text']

            Component.onCompleted: {
                for (var i = 0; i < model.length; i++) {
                    if (model[i]['text'] === plasmoid.configuration.iconType) {
                        iconType.currentIndex = i
                    }
                }
            }
        }

        //________ ICON POSITION ________
        Label {
            Layout.row:                 16
            Layout.column:              1
            text:                       i18n('Icon position:')
        }
        RowLayout {
            RadioButton {
                Layout.row:             15
                Layout.column:          2
                Layout.rightMargin:     20          // PADDING RIGHT
                checked:                plasmoid.configuration.iconPosition === false
                text:                   i18n("Left")
                onReleased:             cfg_iconPosition = false
            }
            RadioButton {
                Layout.row:             15
                Layout.column:          2
                checked:                plasmoid.configuration.iconPosition === true
                text:                   i18n("Right")
                onReleased:             cfg_iconPosition = true
            }
        }

        //________ SPACER ________ 
        Rectangle {
            Layout.row:                 17
            Layout.column:              0
            height:                     20
            Layout.minimumWidth:        10
            width:                      (parent.width / 100) * 40 
            color:                      "transparent"
        }

        //________ NUMBERS ________ 
        Label {
            Layout.row:                 18
            Layout.column:              1
            text:                       i18n('Numbers:')
        }
        RowLayout {
            RadioButton {
                Layout.row:             18
                Layout.column:          2
                Layout.rightMargin:     20          // PADDING RIGHT
                checked:                plasmoid.configuration.binaryDecimal === 'binary'
                text:                   i18n("Binary (1024)")
                onReleased:             cfg_binaryDecimal = 'binary'
            }
            RadioButton {
                Layout.row:             18
                Layout.column:          2
                checked:                plasmoid.configuration.binaryDecimal === 'decimal'
                text:                   i18n("Metric (1000)")
                onReleased:             cfg_binaryDecimal = 'decimal'
            }
        }

        //________ DECIMAL PLACE ________ 
        Label {
            Layout.row:                 19
            Layout.column:              1
            text:                       i18n('Decimal Place:')
        }
        RowLayout {
            id:                         decimalPlaceRow
            Layout.row:                 19
            Layout.column:              2

            property var buttonPressed

            function setDecimalPlace() {     // .toFixed(x);
                var s
                if (buttonPressed.text === "▲") {
                    decimalPlaceUP.enabled == true
                    cfg_decimalPlace += 1
                    s = 3

                    if (cfg_decimalPlace === s) {
                        decimalPlaceUP.enabled = false
                        decimalPlaceButtonTimer.stop()
                    } else {
                        decimalPlaceDOWN.enabled = true
                    }
                }
                if (buttonPressed.text === "▼") {
                    decimalPlaceDOWN.enabled == true
                    cfg_decimalPlace -= 1
                    s = 0

                    if (cfg_decimalPlace === s) {
                        decimalPlaceDOWN.enabled = false
                        decimalPlaceButtonTimer.stop()
                    } else {
                        decimalPlaceUP.enabled = true
                    }
                }             
            }
            function decimalPlaceText() {        // 0.00
                var x
                if (cfg_binaryDecimal === 'binary')     x = 1024; 
                else                                    x = 1000; 

                return Number.parseFloat(x).toFixed( cfg_decimalPlace );
            }
            Rectangle {
                width: labelTextMetrics.width
                height: decimalPlaceLabel.height
                color: "transparent"
                Label {
                    id: decimalPlaceLabel
                    text: decimalPlaceRow.decimalPlaceText()
                }
            }
            Rectangle {
                width: (decimalPlaceUP.x - decimalPlaceDOWN.x) + (decimalPlaceDOWN.width + 2)
                height: decimalPlaceDOWN.height + 2
                color: "transparent"
                border.color: "dark grey"
                border.width: 0.5
                radius: 4           
                RowLayout {
                    //id: buttonB                    
                    Button {
                        id: decimalPlaceDOWN
                        text: "▼"
                        implicitWidth: decimalPlaceDOWN.height
                        Layout.margins: 1   //buttonMargin
                        enabled: cfg_decimalPlace != 0
                        onPressAndHold: {
                            decimalPlaceRow.buttonPressed = decimalPlaceDOWN
                            decimalPlaceButtonTimer.start() 
                        }
                        onReleased: {
                            decimalPlaceRow.buttonPressed = decimalPlaceDOWN
                            decimalPlaceRow.setDecimalPlace()
                            decimalPlaceButtonTimer.stop()
                        }
                    }
                    Button {
                        id: decimalPlaceUP
                        text: "▲"
                        implicitWidth: decimalPlaceUP.height
                        Layout.margins: 1   //buttonMargin
                        enabled: cfg_decimalPlace != 3
                        onPressAndHold: { 
                            decimalPlaceRow.buttonPressed = decimalPlaceUP 
                            decimalPlaceButtonTimer.start() 
                        }
                        onReleased: {
                            decimalPlaceRow.buttonPressed = decimalPlaceUP
                            decimalPlaceRow.setDecimalPlace()
                            decimalPlaceButtonTimer.stop()
                        }
                    }
                    Timer {
                        id: decimalPlaceButtonTimer
                        interval: 200 // repeat every 200 milliseconds
                        running: false
                        repeat: true
                        onTriggered: decimalPlaceRow.setDecimalPlace()
                    }
                }
            }
        }  

        //________ INACTIVE HIDE ZONE ________ 
        // Label {
        //     Layout.row: 20
        //     Layout.column: 1
        //     text: i18n('Widget space:')
        // }
        // RowLayout {
        //     id: hideZoneRow
        //     function setEnabled() {
        //         if (hideInactive.checked)   return true
        //         else                        return false
        //     }
        //     RadioButton {
        //         id: rbZone1
        //         Layout.row: 1
        //         Layout.column: 2
        //         Layout.rightMargin: 20  // PADDING RIGHT
        //         enabled: hideZoneRow.setEnabled()
        //         checked: true
        //         text: i18n("Keep zone")
        //         onReleased: cfg_hideZone = false
        //     }
        //     RadioButton {
        //         id: rbZone2
        //         Layout.row: 1
        //         Layout.column: 2
        //         enabled: hideZoneRow.setEnabled()
        //         text: i18n("Shrink zone")
        //         onReleased: cfg_hideZone = true
        //     }
        // }

                //________ SPACER ________ 
        Rectangle {
            Layout.row:             20
            Layout.column:          0
            height:                 20
            Layout.minimumWidth:    10
            width:                  (parent.width / 100) * 40 
            color:                  "transparent"
        }
    }
}



