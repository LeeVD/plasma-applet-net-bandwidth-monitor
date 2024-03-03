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
import org.kde.plasma.core 2.0

// # CUSTOM COLOR PICKER ##
import QtQuick.Layouts 1.15
// # COLOR PICKER #########
import QtQuick.Dialogs 1.3

Item {
    // configGeneral.qml >>> plasmoid.configuration
    property alias      cfg_showSeparately:     showSeparately.checked
    property string     cfg_speedLayout:        speedLayout
    property bool       cfg_swapDownUp:         false           //  true = t:down / b:up | false = t:up / b:down 
    property string     cfg_iconType:           iconType
    property bool       cfg_iconPosition:       iconPosition    //  true = right | false = left
    property alias      cfg_showIcons:          showIcons.checked
    property alias      cfg_showUnits:          showUnits.checked
    property string     cfg_speedUnits:         'bits'
    property alias      cfg_shortUnits:         shortUnits.checked
    property double     cfg_fontSize:           fontSize
    property double     cfg_updateInterval:     updateInterval
    property string     cfg_binaryDecimal:      'binary'
    property double     cfg_decimalPlace:       decimalPlace
    property int        cfg_layoutPadding:      layoutPadding
    property int        cfg_accumulator:        accumulator
    property alias      cfg_hideInactive:       hideInactive.checked
    property bool       cfg_hideZone:           hideZone
    property alias      cfg_showSeconds:        showSeconds.checked
    property string     cfg_secondsPrefix:      '/s'
    property alias      cfg_decimalFilter0:     decimalFilter0.checked
    property alias      cfg_decimalFilter1:     decimalFilter1.checked
    property alias      cfg_decimalFilter2:     decimalFilter2.checked
    property alias      cfg_decimalFilter3:     decimalFilter3.checked
    property int        cfg_roundedNumber:      roundedNumber
    property double     cfg_iconSize:           iconSize
    property double     cfg_sufixSize:          sufixSize
    property alias      cfg_colorDefault:       colorDefault.checked
    property string     cfg_colorDownIcon:      colorDownIcon
    property string     cfg_colorDownDigits:    colorDownDigits
    property string     cfg_colorDownSuffix:    colorDownSuffix
    property string     cfg_colorUpIcon:        colorUpIcon
    property string     cfg_colorUpDigits:      colorUpDigits
    property string     cfg_colorUpSuffix:      colorUpSuffix
    property string     cfg_color_b_square:     color_b_square
    property string     cfg_color_k_square:     color_k_square
    property string     cfg_color_m_square:     color_m_square
    property string     cfg_color_g_square:     color_g_square
    property alias      cfg_speedColorActive1:  speedColorActive1.checked
    property alias      cfg_speedColorActive2:  speedColorActive2.checked
    property alias      cfg_speedColorActive3:  speedColorActive3.checked  
    property alias      cfg_speedUnitB:         speedUnitB.checked  
    property alias      cfg_speedUnitK:         speedUnitK.checked  
    property alias      cfg_speedUnitM:         speedUnitM.checked  
    property alias      cfg_speedUnitG:         speedUnitG.checked  
    property alias      cfg_ignoreDecimalIdle:  ignoreDecimalIdle.checked   // true : 0 | false : 0.0 
    

    property int spacerA: 8
    property int spacerB: 30

    id: main
    //________ COLUMN WIDTH ________ 
    TextMetrics {
        id: titleTextMetrics
        text: "Show 'per seconds' suffix:   "
        //font.pixelSize: 64
    }
    //________ COLUMN WIDTH ________ 
    TextMetrics {
        id: labelTextMetrics
        text: " 10 pixel closer  "
        //font.pixelSize: 64
    }
    //________ TOOLTIP ANIMATIONS ________ 
    NumberAnimation {
        id:         heightAnimation
        target:     null     //rootRec
        property:   "height"
        duration:   100
        onStopped: {  
                                                                            // target contains reference to rec | rootRec#
            var buttonObject = target.children[0].children[1]               // GET infoButton Object
            var buttonState = buttonObject.state                            // GET infoButton state
            if (buttonState === true) {                                     // infoButton#.MouseArea.state
                
                opacityAnimation.target = target.children[2].children[0]    // target infoText#
                opacityAnimation.to = 1;                                    // open infoText# tooltip
                opacityAnimation.start()                                    // start Animation
            }
        }
    }

    OpacityAnimator {
        id:         opacityAnimation
        target:     null    //infoText
        duration:   200
        onStopped: {   
                                                                            // target contains reference infoText#
            var buttonObject = target.parent.parent.children[0].children[1] // GET infoButton Object (MouseArea for the state)
            var buttonState = buttonObject.state                            // GET infoButton state

            if (buttonState === false) {                                    // infoButton#.MouseArea.state
                heightAnimation.target = target.parent.parent               // target rootRec#
                heightAnimation.to = infoButton.height                      // close infoText# tooltip
                heightAnimation.start()                                     // start Animation
            }
        }
    }

    SystemPalette { 
        id: myPalette; colorGroup: 
        SystemPalette.Active 
    }

    //________ ANIMATION CALLER ________ 
    function toggleTooltip(rec) {           // SEND ENTIRE ROW OBJECT TO ANIMATION FUNCTION
        
        var rec_infoButton  = rec.children[0]                       // GET rec infoButton MouseArea Object (MEMORY ADDRESS IDENTIFIER)
        var rec_infoText    = rec.children[2].children[0]           // GET rec infoText Object (MEMORY ADDRESS IDENTIFIER)
        var rec_state       = rec_infoButton.children[1].state      // GET rec infoButton MouseArea state toggle

        if (rec_state === true) {                        // OPEN NEW TOOLTIP

            var heightAnimationTo = rec_infoButton.height + rec_infoText.contentHeight + (rec_infoText.padding * 2)

            heightAnimation.target = rec                            // target rootRec or rec in this instance
            heightAnimation.to = heightAnimationTo
            heightAnimation.start()

            rec_infoButton.opacity = 1.0
            rec.border.width = 0.5

        } else {                                                    // CLOSE NEW TOOLTIP

            opacityAnimation.target = rec_infoText                  // TARGET infoText FROM THE rec OBJECT
            opacityAnimation.to = 0
            opacityAnimation.start()
            
            rec_infoButton.opacity = 0.5
            rec.border.width = 0
        }
    }

    Rectangle {

        id: rootRec
        width: parent.width
        height: 40//infoButton.height
        color: "transparent" //"red"
        border.color: "dark grey"
        border.width: 0
        radius: 4

        ToolButton {
            //property bool state: false
            id: infoButton
            icon.name: 'kt-info-widget'
            implicitWidth: infoButton.height    
            anchors.right: parent.right
            opacity: 0.5

            MouseArea {
                property bool state:    false
                anchors.fill:           parent
                hoverEnabled:           true
                onEntered:              infoButton.opacity = 1 
                onExited:               state ? infoButton.opacity = 1 : infoButton.opacity = 0.5
                onClicked: {
                    state = !state
                    main.toggleTooltip(rootRec)
                }
            }
        }

        Grid {
            // TITLE | CHOICE BUTTONS GO HERE
            id: gA
            //anchors.verticalCenter: infoButton.verticalCenter

            Row {
                //spacing: 10                
                Column {
                    Rectangle {
                        height: 10
                        width: spacerA
                        color: "transparent" //"red"
                    }
                }
                Column {
                    //________ LAYOUT ________ 
                    Label {
                        width:                      titleTextMetrics.width
                        text:                       i18n("Layout:")
                        height:                     infoButton.height
                    }
                }
                Column {
                    RowLayout {
                        id: testing
                        height:                     infoButton.height
                        function paddingFix(caller) {
                            // row
                            if (caller == 'row'){
                                cfg_layoutPadding   = 0         // RESET PADDING TO DEFAULT
                                paddingLabel.color  = "grey"    // SET 'Default pixels' FONT COLOR TO GREY
                                paddingDOWN.enabled = false     // SET BOTH BUTTONS TO DISABLED
                                paddingUP.enabled   = false 
                            } else {
                                paddingLabel.color  = myPalette.windowText
                                if (paddingUP.enabled === false && paddingDOWN.enabled === false ) {        // IF BOTH BUTTONS DISABLED, CAME FROM 'row' LAYOUT
                                    paddingUP.enabled = true
                                    paddingDOWN.enabled = true
                                } 
                            }
                        }                         
                        RadioButton {
                            id:                     speedLayout_rb0
                            Layout.rightMargin:     20      // PADDING RIGHT
                            checked:                plasmoid.configuration.speedLayout === 'auto'
                            text:                   i18n("Automatic")
                            onReleased:            {cfg_speedLayout = 'auto'
                                                    testing.paddingFix('auto')} 
                            
                        }
                        RadioButton {
                            id:                     speedLayout_rb1
                            Layout.rightMargin:     20      // PADDING RIGHT
                            checked:                plasmoid.configuration.speedLayout === 'column'
                            text:                   i18n("Vertical")
                            onReleased:            {cfg_speedLayout = 'column'      // ONE ABOVE OTHER
                                                    testing.paddingFix('column')}                             
                        }
                        RadioButton {
                            id:                     speedLayout_rb2
                            checked:                plasmoid.configuration.speedLayout === 'row'
                            text:                   i18n("Horizontal")
                            onReleased:            {cfg_speedLayout     = 'row'     // SIDE BY SIDE
                                                    testing.paddingFix('row')}        
                        }
                       
                    }
                }
            }
        }
        Grid {

            property alias nText: infoText
            // NEW TOOLTIP INFORMATION
            anchors.top: gA.bottom
            Text {
                id: infoText
                opacity: 0
                padding: 10 
                width: rootRec.width
                color: myPalette.windowText
                textFormat: Text.RichText
                wrapMode: Text.Wrap
                text: "<table>"
                        + "<tr><td><b>" + i18n("Automatic") + "</b>: </td> <td>" + i18n("Should automatically adjust to size available in taskbar.") +"</td></tr>"
                        + "<tr><td><b>" + i18n("Vertical") + "</b>: </td> <td>" + i18n("Upload and Download will be stacked on top of each other:") + "</td></tr>"
                        + "<tr><td></td> <td><img src='../image/1a2.png' width='120' height='65'></td></tr>"
                        + "<tr><td><b>" + i18n("Horizontal") + "</b>: </td> <td>" + i18n("Upload and Download will be aligned side by side:") + "</td></tr>"
                        + "<tr><td></td> <td><img src='../image/1b2.png' width='240' height='40'></td></tr>"
                    + "</table>"
            }
        }
    }
    //###############################################################################################
    // Rectangle {
    //     id: spacer
    //     height: 20
    //     width:  20
    //     anchors.top: rootRec.bottom
    //     color: "transparent"
    // }
    //###############################################################################################
    Rectangle {

        id: rootRec2
        width: parent.width
        height: infoButton2.height
        anchors.top: rootRec.bottom
        anchors.topMargin: spacerA
        color: "transparent" //"red"
        border.color: "dark grey"
        border.width: 0
        radius: 4

        ToolButton {
            id: infoButton2
            icon.name: 'kt-info-widget'
            implicitWidth: infoButton2.height
            anchors.right: parent.right
            opacity: 0.5

            MouseArea {
                property bool state:    false
                anchors.fill:           parent
                hoverEnabled:           true
                onEntered:              infoButton2.opacity = 1
                onExited:               state ? infoButton2.opacity = 1 : infoButton2.opacity = 0.5
                onClicked: {
                    state = !state
                    main.toggleTooltip(rootRec2)
                }
            }
        }
        Grid {
            // TITLE | CHOICE BUTTONS GO HERE
            id: gA2
            //anchors.verticalCenter: infoButton2.verticalCenter
            Row {
                //spacing: 10                                
                Column {
                    Rectangle {
                        height: 10
                        width: spacerA
                        color: "transparent" //"red"
                    }    
                }
                Column {
                    //________ LAYOUT ________ 
                    Label {
                        width:                      titleTextMetrics.width
                        text:                       i18n("Display order:")
                        height:                     infoButton2.height
                    }
                }
                Column {
                    RowLayout {
                        height:                     infoButton2.height
                        RadioButton {
                            Layout.rightMargin:     20  // PADDING RIGHT
                            checked:                plasmoid.configuration.swapDownUp === true
                            text:                   i18n("Upload speed first")
                            onReleased:             cfg_swapDownUp = true
                        }
                        RadioButton {
                            checked:                plasmoid.configuration.swapDownUp === false
                            text:                   i18n("Download speed first")
                            onReleased:             cfg_swapDownUp = false
                        }
                    }
                }
            }
        }
        Grid {
            // NEW TOOLTIP INFORMATION
            anchors.top: gA2.bottom
            Text {
                id: infoText2
                opacity: 0
                padding: 10 
                width: rootRec2.width
                color: myPalette.windowText
                textFormat: Text.RichText
                wrapMode: Text.Wrap
                text: "<table>"
                        + "<tr><td><b>" + i18n("Upload speed first") + "</b>: </td>   <td>" + i18n("Upload data on the top in Vertical layout or left in Horizontal.") + "</td></tr>"
                        + "<tr><td><b>" + i18n("Download speed first") + "</b>: </td> <td>" + i18n("Download data on the top in Vertical layout or left in Horizontal.") + "</td></tr>"
                        + "<tr><td></td> <td><img src='../image/2a.png' width='150' height='65'><img src='../image/2b.png' width='250' height='70'></td></tr>"
                    + "</table>" 
            }
        }
    }
    //#######################################################################################################
    Rectangle {
        id: rootRec3
        width: parent.width
        height: infoButton3.height
        anchors.top: rootRec2.bottom
        anchors.topMargin: spacerA
        color: "transparent" //"red"
        border.color: "dark grey"
        border.width: 0
        radius: 4

        ToolButton {
            id: infoButton3
            icon.name: 'kt-info-widget'
            implicitWidth: infoButton3.height
            anchors.right: parent.right
            opacity: 0.5

            MouseArea {
                property bool state:    false
                anchors.fill:           parent
                hoverEnabled:           true
                onEntered:              infoButton3.opacity = 1
                onExited:               state ? infoButton3.opacity = 1 : infoButton3.opacity = 0.5
                onClicked: {
                    state = !state
                    main.toggleTooltip(rootRec3)
                }
            }
        }
        Grid {
            // TITLE | CHOICE BUTTONS GO HERE
            id: gA3
            //anchors.verticalCenter: infoButton3.verticalCenter
            Row {
                //spacing: 10                
                Column {
                    Rectangle {
                        height: 10
                        width: spacerA
                        color: "transparent" //"red"
                    } 
                }
                Column {
                    //________ LAYOUT ________ 
                    Label {
                        width: titleTextMetrics.width
                        text:  i18n("Show speeds separately:")
                        height: infoButton3.height
                    }
                }
                Column {
                    CheckBox {
                        id:      showSeparately
                        checked: true
                        height: infoButton3.height
                    }
                }
            }
        }
        Grid {
            // NEW TOOLTIP INFORMATION
            anchors.top: gA3.bottom
            Text {
                id: infoText3
                opacity: 0
                padding: 10 
                width: rootRec3.width
                color: myPalette.windowText
                textFormat: Text.RichText
                wrapMode: Text.Wrap
                text: "<table>"
                        + "<tr><td><b>" + i18n("Checked") + "</b>: </td> <td>" + i18n("The Upload and Download data will be displayed separately either stacked or side by side.") + "</td></tr>"
                        + "<tr><td><b>" + i18n("Unchecked") + "</b>: </td> <td>" + i18n("The Upload and Download data will be combined both in data calculation and display. Only one row of data will be shown combining both data measurements with a matching icon.") + "</td></tr>"
                        + "<tr><td></td> <td><img src='../image/3a.png' width='305' height='65'></td></tr>"
                    + "</table>"
            }
        }
    }

    //#######################################################################################################
    Rectangle {
        id: rootRec5
        width: parent.width
        height: infoButton5.height
        anchors.top: rootRec3.bottom
        anchors.topMargin: spacerA
        color: "transparent" //"red"
        border.color: "dark grey"
        border.width: 0
        radius: 4

        ToolButton {
            id: infoButton5
            icon.name: 'kt-info-widget'
            implicitWidth: infoButton5.height
            anchors.right: parent.right
            opacity: 0.5
            MouseArea {
                property bool state:    false
                anchors.fill:           parent
                hoverEnabled:           true
                onEntered:              infoButton5.opacity = 1
                onExited:               state ? infoButton5.opacity = 1 : infoButton5.opacity = 0.5
                onClicked: {
                    state = !state
                    main.toggleTooltip(rootRec5)
                }
            }
        }
        Grid {
            // TITLE | CHOICE BUTTONS GO HERE
            id: gA5
            //anchors.verticalCenter: infoButton5.verticalCenter

            Row {
                //spacing: 10  
                // Rectangle {     // USED FOR LABEL ALIGNMENT - NOT SURE WHY HAVING BELOW BUTTONS CAUSED 'anchors.verticalCenter: infoButtonX.verticalCenter' NOT TO WORK WITH LABEL.
                //     id: recAlign5
                //     height: infoButton5.height
                //     width: 0
                //     color: "transparent"
                // }      
                Column {
                    Rectangle {
                        height: 10
                        width: spacerA
                        color: "transparent" //"red"
                    } 
                }
                Column {
                    //anchors.verticalCenter: recAlign5.verticalCenter
                    Label {
                        width: titleTextMetrics.width
                        text:  i18n("Update interval:")
                        height: infoButton5.height
                    }
                }
                Column {
                    //####################################################
                    RowLayout {
                        id: intervalRow
                        height: infoButton5.height
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
                                    if (cfg_updateInterval===1000)  return i18n("%1 second", (cfg_updateInterval / 1000))
                                    else                            return i18n("%1 seconds", (cfg_updateInterval / 1000))
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
                    // ################################################################    
                }
            }
        }
        Grid {
            // NEW TOOLTIP INFORMATION
            anchors.top: gA5.bottom
            Text {
                id: infoText5
                opacity: 0
                padding: 10 
                width: rootRec4.width
                color: myPalette.windowText
                textFormat: Text.RichText
                wrapMode: Text.Wrap
                text: "<table>"
                        + "<tr><td><b>" + i18n("Summary") + "</b>: </td> <td>" + i18n("Controls the time interval new network data is displayed in the widget.") + "</td></tr>"
                        + "<tr><td></td>   <td style='padding-bottom:6px'>" + i18n("Adjustments are in 0.5 second increments.") + "</td></tr>"
                        + "<tr><td><b>▲</b>: </td> <td>" + i18n("Increase the time interval, maximum 5 seconds.") + "</td></tr>"
                        + "<tr><td><b>▼</b>: </td> <td>" + i18n("Decrease the time interval, minimum 0.5 seconds.") + "</td></tr>"
                    + "</table>"
            }
        }
    }
 //#######################################################################################################
    Rectangle {
        id: rootRec6
        width: parent.width
        height: infoButton6.height
        anchors.top: rootRec5.bottom
        anchors.topMargin: spacerA
        color: "transparent" //"red"
        border.color: "dark grey"
        border.width: 0
        radius: 4

        ToolButton {
            id: infoButton6
            icon.name: 'kt-info-widget'
            implicitWidth: infoButton6.height
            anchors.right: parent.right
            opacity: 0.5
            MouseArea {
                property bool state:    false
                anchors.fill:           parent
                hoverEnabled:           true
                onEntered:              infoButton6.opacity = 1
                onExited:               state ? infoButton6.opacity = 1 : infoButton6.opacity = 0.5
                onClicked: {
                    state = !state
                    main.toggleTooltip(rootRec6)
                }
            }
        }
        Grid {
            // TITLE | CHOICE BUTTONS GO HERE
            id: gA6
            //anchors.verticalCenter: infoButton6.verticalCenter

            Row {
                //spacing: 10        
                Column {
                    Rectangle {
                        height: 10
                        width: spacerA
                        color: "transparent" //"red"
                    } 
                }
                Column {
                    //________ LAYOUT ________ 
                    Label {
                        width: titleTextMetrics.width
                        text:  i18n("Interval data relay:")
                        height: infoButton6.height
                    }
                }
                Column {
                    //####################################################
                    RowLayout {
                        id: accumRow
                        height: infoButton6.height
                        function setEnabled() {
                            if (cfg_updateInterval > 500)  {
                                return true
                            } else {
                                rbAccum.checked = true
                                cfg_accumulator = 0
                                return false
                            }
                        }
                        RadioButton {
                            id:                     rbAccum
                            Layout.rightMargin:     20  // PADDING RIGHT
                            enabled:                accumRow.setEnabled()
                            checked:                plasmoid.configuration.accumulator === 0
                            text:                   i18n("Current")
                            onReleased:             cfg_accumulator = 0
                        }
                        RadioButton {
                            Layout.rightMargin:     20  // PADDING RIGHT
                            checked:                plasmoid.configuration.accumulator === 1
                            enabled:                accumRow.setEnabled()
                            text:                   i18n("Average")
                            onReleased:             cfg_accumulator = 1
                        }
                        RadioButton {
                            checked:                plasmoid.configuration.accumulator === 2
                            enabled:                accumRow.setEnabled()
                            text:                   i18n("Accumulated")
                            onReleased:             cfg_accumulator = 2
                        }
                    }    
                    // ################################################################    
                }
            }
        }
        Grid {
            // NEW TOOLTIP INFORMATION
            anchors.top: gA6.bottom
            Text {
                id: infoText6
                opacity: 0
                padding: 10 
                width: rootRec6.width
                color: myPalette.windowText
                textFormat: Text.RichText
                wrapMode: Text.Wrap
                
                text: "<div>" + i18n("This option becomes usable when 'Update interval' is above 0.5 seconds.") + "</div><br>"
                        + "<table>"
                        + "<tr><td><b>" + i18n("Current") + "</b>: </td> <td style='padding-bottom:6px'>"
                        + i18n("Shows the amount of used network speed at the interval set in 'Update interval'. \
For example, if 'Update interval' is 4 seconds, at every 4th second the display will only show the amount of speed traversing at that point (statistical value for the past 0.5 seconds, this is the minimum resolution of the data source) in time. \
The display will not refresh for the following 4 seconds.")
                        + "</td></tr>"
                        + "<tr><td><b>" + i18n("Average") + "</b>: </td> <td style='padding-bottom:6px'>"
                        + i18n("The mathematically correct way to calculate the network speed over time. \
This setting will return the network speed averaged over the period specified in 'Update interval'. \
Using the per second prefix ('/s' or 'ps') is correct with this option.")
                        + "</td></tr>"
                        + "<tr><td><b>" + i18n("Accumulated") + "</b>: </td> <td>"
                        + i18n("Returns the accumulated network traffic over the specified time period. \
For example, if 'Update interval' is set to 4 seconds, at every 4th second you will be presented with the sum total of network traffic over the time period selected. \
Using the per second prefix ('/s' or 'ps') with this option is not technically correct but the choice is yours.")
                        + "</td></tr>"
                    + "</table>"
            }
        }
    }

 //#######################################################################################################
    Rectangle {
        id: rootRec7
        width: parent.width
        height: infoButton7.height
        anchors.top: rootRec6.bottom
        anchors.topMargin: spacerA
        color: "transparent" //"red"
        border.color: "dark grey"
        border.width: 0
        radius: 4

        ToolButton {
            id: infoButton7
            icon.name: 'kt-info-widget'
            implicitWidth: infoButton7.height
            anchors.right: parent.right
            opacity: 0.5
            MouseArea {
                property bool state:    false
                anchors.fill:           parent
                hoverEnabled:           true
                onEntered:              infoButton7.opacity = 1
                onExited:               state ? infoButton7.opacity = 1 : infoButton7.opacity = 0.5
                onClicked: {
                    state = !state
                    main.toggleTooltip(rootRec7)
                }
            }
        }
        Grid {
            // TITLE | CHOICE BUTTONS GO HERE
            id: gA7
            //anchors.verticalCenter: infoButton7.verticalCenter

            Row {
                id: rr
                //spacing: 10    
                // Rectangle {     // USED FOR LABEL ALIGNMENT - NOT SURE WHY HAVING BELOW BUTTONS CAUSED 'anchors.verticalCenter: infoButtonX.verticalCenter' NOT TO WORK WITH LABEL.
                //     id: recAlign7
                //     height: infoButton7.height
                //     width: 0
                //     color: "transparent"
                // }    
                Column {
                    Rectangle {
                        height: 10
                        width: spacerA
                        color: "transparent" //"red"
                    } 
                }
                Column {
                    //anchors.verticalCenter: recAlign7.verticalCenter
                    //________ LAYOUT ________ 
                    Label {
                        width: titleTextMetrics.width
                        text:  i18n("Layout Padding:")
                        height: infoButton7.height
                    }
                }
                Column {
                    //####################################################
                    RowLayout {
                        id: paddingRow
                        height: infoButton7.height
                        property var buttonPressed

                        function setPadding() {
                            
                            var s
                            if (buttonPressed.text === "▲") {
                                paddingUP.enabled == true
                                cfg_layoutPadding -= 1
                                s = -20

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
                                s = 20

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
                                return i18n("Default pixels")
                            // NEGATIVE NUMBER = MOVE LAYOUT CLOSER
                            } else if   (Math.sign(cfg_layoutPadding) === -1) {   //Math.sign returns '-1' if number is a negative
                                if      (cfg_layoutPadding === -1) return i18n("%1 pixel closer", (cfg_layoutPadding * -1))
                                return  i18n("%1 pixels closer", (cfg_layoutPadding * -1))
                            // POSITIVE NUMBER = MOVE LAYOUT APART
                            } else {
                                if      (cfg_layoutPadding ===  1) return i18n("%1 pixel apart", cfg_layoutPadding)
                                return  i18n("%1 pixels apart", cfg_layoutPadding)
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
                                id:paddingRow2           
                                Button {
                                    id: paddingDOWN
                                    text: "▼"
                                    implicitWidth: paddingDOWN.height
                                    Layout.margins: 1   //buttonMargin
                                    enabled: cfg_layoutPadding != 20
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
                                    enabled: cfg_layoutPadding != -20 
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
                    // ################################################################    
                }
            }
        }
        Grid {
            // NEW TOOLTIP INFORMATION
            anchors.top: gA7.bottom
            Text {
                id: infoText7
                opacity: 0
                padding: 10 
                width: rootRec7.width
                color: myPalette.windowText
                textFormat: Text.RichText
                wrapMode: Text.Wrap
                
                text: "<table>"
                        + "<tr><td><b>▲</b>: </td> <td>" + i18n("Move the upload and download data rows closer together, maximum 20 pixels closer.") + "</td></tr>"
                        + "<tr><td><b>▼</b>: </td> <td>" + i18n("Increase the distance between upload and download data rows, maximum 20 pixels apart.") + "</td></tr>"
                        + "<tr><td></td> <td style='padding-bottom:6px'><img src='../image/4a.png' width='280' height='85'></td></tr>"
                    + "</table>"
                    + i18n("* Function disabled in 'Horizontal' layout mode.")
            }
        } 
    }
 //#######################################################################################################
    Rectangle {
        id: rootRec8
        width: parent.width
        height: infoButton8.height
        anchors.top: rootRec7.bottom
        anchors.topMargin: spacerA
        color: "transparent" //"red"
        border.color: "dark grey"
        border.width: 0
        radius: 4

        ToolButton {
            id: infoButton8
            icon.name: 'kt-info-widget'
            implicitWidth: infoButton8.height
            anchors.right: parent.right
            opacity: 0.5
            MouseArea {
                property bool state:    false
                anchors.fill:           parent
                hoverEnabled:           true
                onEntered:              infoButton8.opacity = 1
                onExited:               state ? infoButton8.opacity = 1 : infoButton8.opacity = 0.5
                onClicked: {
                    state = !state
                    main.toggleTooltip(rootRec8)
                }
            }
        }
        Grid {
            // TITLE | CHOICE BUTTONS GO HERE
            id: gA8
            //anchors.verticalCenter: infoButton8.verticalCenter

            Row {
                //spacing: 10        
                Column {
                    Rectangle {
                        height: 10
                        width: spacerA
                        color: "transparent" //"red"
                    } 
                }
                Column {
                    //________ LAYOUT ________ 
                    Label {
                        width: titleTextMetrics.width
                        text:  i18n("Hide when inactive:")
                        height: infoButton8.height
                    }
                }
                Column {
                    //####################################################
                    CheckBox {
                        id:                         hideInactive
                        checked:                    !cfg_hideZone
                        onCheckedChanged: {
                            cfg_hideZone = !hideInactive.checked
                        }
                        height: infoButton8.height
                    }   
                    // ################################################################    
                }
            }
        }
        Grid {
            // NEW TOOLTIP INFORMATION
            anchors.top: gA8.bottom
            Text {
                id: infoText8
                opacity: 0
                padding: 10 
                width: rootRec8.width
                color: myPalette.windowText
                textFormat: Text.RichText
                wrapMode: Text.Wrap
                
                text: "<table>"
                        + "<tr><td><b>" + i18n("Checked") + "</b>: </td> <td style='padding-bottom:6px'>" + i18n("Hides the display when '0' traffic is reported.  Displays will become visible again when traffic starts to flow.") + "</td></tr>"
                        + "<tr><td><b>" + i18n("Unchecked") + "</b>: </td> <td style='padding-bottom:6px'>" + i18n("Shows the display even when no traffic is traversing the network interfaces.") + "</td></tr>"
                    + "</table>"
            }
        } 
    }
 //#######################################################################################################
    MenuSeparator {
        id: separator1
        padding: 0
        topPadding: 20
        bottomPadding: 20
        contentItem: Rectangle {
            implicitWidth: parent.parent.width
            implicitHeight: 1
            color: myPalette.light //"light grey"
        }
        anchors.top: rootRec8.bottom
    }
 //#######################################################################################################   
    // -- SIZE --

    Rectangle {
        id: rootRec4
        width: parent.width
        height: infoButton4.height + 8
        anchors.top: separator1.bottom
        anchors.topMargin: spacerA
        color: "transparent" //"red"
        border.color: "dark grey"
        border.width: 0
        radius: 4

        ToolButton {
            id: infoButton4
            icon.name: 'kt-info-widget'
            implicitWidth: infoButton4.height
            anchors.right: parent.right
            opacity: 0.5

            MouseArea {
                property bool state:    false
                anchors.fill:           parent
                hoverEnabled:           true
                onEntered:              infoButton4.opacity = 1
                onExited:               state ? infoButton4.opacity = 1 : infoButton4.opacity = 0.5
                onClicked: {
                    state = !state
                    main.toggleTooltip(rootRec4)
                }
            }
        }
        Grid {              // TITLE | CHOICE BUTTONS GO HERE
            id: gA4
            //anchors.verticalCenter: infoButton4.verticalCenter

            Row {
                //spacing: 10        
                // Rectangle {     // USED FOR LABEL ALIGNMENT - NOT SURE WHY HAVING BELOW BUTTONS CAUSED 'anchors.verticalCenter: recAlign4.verticalCenter' NOT TO WORK WITH LABEL.
                //     id: recAlign4
                //     height: infoButton4.height
                //     width: 0
                //     color: "transparent"
                // }
                Column {
                    Rectangle {
                        height: 10
                        width: spacerA
                        color: "transparent" //"red"
                    } 
                }
                Column {
                    //anchors.verticalCenter: recAlign4.verticalCenter
                    Label {
                        width: titleTextMetrics.width
                        text:  i18n("Numbers font size:")
                        height: infoButton4.height
                    }
                }
                Column {
                    //####################################################
                    RowLayout {
                        id: fontSizeRow
                        height: infoButton4.height
                        property var buttonPressed;
                        property var t: 2;
                        property var f: 0.5;

                        function disableButton() {
                            if (cfg_fontSize === f) {
                                fontSizeDOWN.enabled = false;
                            } else {
                                fontSizeDOWN.enabled = true;
                            }                 
                            if (cfg_fontSize === t) {
                                fontSizeUP.enabled = false;
                            } else {
                                fontSizeUP.enabled = true;
                            }                
                        }
                        function setFontSize() {
                            if (buttonPressed.text === "▲") {           // BUTTONS
                                cfg_fontSize += 0.01;
                            } else if (buttonPressed.text === "▼") {
                                cfg_fontSize -= 0.01;
                            } 
                            fontSizeSlider.value = cfg_fontSize
                            disableButton()
                        }    
                            
                        function setFontSizeSlider() {                  // SLIDER
                            var sliderVal
                            sliderVal = buttonPressed.value.toFixed(2)
                            if (sliderVal !==  cfg_fontSize) {
                                cfg_fontSize = sliderVal
                            }
                            disableButton()
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
                                    enabled: cfg_fontSize != fontSizeRow.f
                                    onReleased: {
                                        fontSizeRow.buttonPressed = fontSizeDOWN
                                        fontSizeRow.setFontSize()
                                    }
                                }
                                Button {
                                    id: fontSizeUP
                                    text: "▲"
                                    implicitWidth: fontSizeUP.height
                                    Layout.margins: 1   //buttonMargin
                                    enabled: cfg_fontSize != fontSizeRow.t
                                    onReleased: {
                                        fontSizeRow.buttonPressed = fontSizeUP
                                        fontSizeRow.setFontSize()
                                    }
                                }
                                Slider {
                                    id: fontSizeSlider
                                    implicitWidth: 140
                                    from: fontSizeRow.f
                                    value: cfg_fontSize
                                    to: fontSizeRow.t
                                    onValueChanged: {
                                        fontSizeRow.buttonPressed = fontSizeSlider
                                        fontSizeRow.setFontSizeSlider()
                                    }
                                }
                            }
                        }
                    } 
                    //##################################################  
                }
            }
        }
        Grid {
            // NEW TOOLTIP INFORMATION
            anchors.top: gA4.bottom
            Text {
                id: infoText4
                opacity: 0
                padding: 10 
                width: rootRec4.width
                color: myPalette.windowText
                textFormat: Text.RichText
                wrapMode: Text.Wrap
                text: i18n("Use the slider to quickly increase or decrease item size, with finer controls via the adjacent buttons.")
                    + "<table>"
                        + "<tr><td><b>▲</b>: </td> <td>" + i18n("Increase font size of the numbers in the display, maximum 200%.") + "</td></tr>"
                        + "<tr><td><b>▼</b>: </td> <td>" + i18n("Decrease font size of the numbers in the display, minimum 50%") + "</td></tr>"
                    + "</table>"
            }
        }
    }
    //#######################################################################################################
    Rectangle {
        id: rootRec45
        width: parent.width
        height: infoButton45.height + 8
        anchors.top: rootRec4.bottom
        anchors.topMargin: spacerA
        color: "transparent" //"red"
        border.color: "dark grey"
        border.width: 0
        radius: 4

        ToolButton {
            id: infoButton45
            icon.name: 'kt-info-widget'
            implicitWidth: infoButton45.height
            anchors.right: parent.right
            opacity: 0.5

            MouseArea {
                property bool state:    false
                anchors.fill:           parent
                hoverEnabled:           true
                onEntered:              infoButton45.opacity = 1
                onExited:               state ? infoButton45.opacity = 1 : infoButton45.opacity = 0.5
                onClicked: {
                    state = !state
                    main.toggleTooltip(rootRec45)
                }
            }
        }
        Grid {
            // TITLE | CHOICE BUTTONS GO HERE
            id: gA45
            //anchors.verticalCenter: infoButton45.verticalCenter

            Row {
                //spacing: 10        
                // Rectangle {     // USED FOR LABEL ALIGNMENT - NOT SURE WHY HAVING BELOW BUTTONS CAUSED 'anchors.verticalCenter: recAlign4.verticalCenter' NOT TO WORK WITH LABEL.
                //     id: recAlign45
                //     height: infoButton45.height
                //     width: 0
                //     color: "transparent"
                // }
                Column {
                    Rectangle {
                        height: 10
                        width: spacerA
                        color: "transparent" //"red"
                    } 
                }
                Column {
                    //anchors.verticalCenter: recAlign45.verticalCenter
                    Label {
                        width: titleTextMetrics.width
                        text:  i18n("Icon size:")
                        height: infoButton45.height
                    }
                }
                Column {
                    //####################################################
                    RowLayout {
                        id: iconSizeRow
                        height: infoButton45.height
                        property var buttonPressed;
                        property var t: 2;
                        property var f: 0.5;

                        function disableButton() {
                            if (cfg_iconSize === f) {
                                iconSizeDOWN.enabled = false;
                            } else {
                                iconSizeDOWN.enabled = true;
                            }                 
                            if (cfg_iconSize === t) {
                                iconSizeUP.enabled = false;
                            } else {
                                iconSizeUP.enabled = true;
                            }                
                        }
                        function seticonSize() {
                            if (buttonPressed.text === "▲") {           // BUTTONS
                                cfg_iconSize += 0.01;
                            } else if (buttonPressed.text === "▼") {
                                cfg_iconSize -= 0.01;
                            } 
                            iconSizeSlider.value = cfg_iconSize
                            disableButton()
                        }    
                            
                        function seticonSizeSlider() {                  // SLIDER
                            var sliderVal
                            sliderVal = buttonPressed.value.toFixed(2)
                            if (sliderVal !==  cfg_iconSize) {
                                cfg_iconSize = sliderVal
                            }
                            disableButton()
                        }

                        Rectangle {
                            width: labelTextMetrics.width
                            height: iconSizeLabel.height
                            color: "transparent"
                            Label {
                                id: iconSizeLabel
                                text: (cfg_iconSize * 100).toFixed(0) + " %"
                            }
                        }

                        Rectangle { 
                            width: (iconSizeUP.x - iconSizeDOWN.x) + (iconSizeDOWN.width + 2)
                            height: iconSizeDOWN.height + 2
                            color: "transparent"
                            border.color: "dark grey"
                            border.width: 0.5
                            radius: 4           
                            RowLayout {       
                                Button {
                                    id: iconSizeDOWN
                                    text: "▼"
                                    implicitWidth: iconSizeDOWN.height
                                    Layout.margins: 1   //buttonMargin
                                    enabled: cfg_iconSize != iconSizeRow.f
                                    onReleased: {
                                        iconSizeRow.buttonPressed = iconSizeDOWN
                                        iconSizeRow.seticonSize()
                                    }
                                }
                                Button {
                                    id: iconSizeUP
                                    text: "▲"
                                    implicitWidth: iconSizeUP.height
                                    Layout.margins: 1   //buttonMargin
                                    enabled: cfg_iconSize != iconSizeRow.t
                                    onReleased: {
                                        iconSizeRow.buttonPressed = iconSizeUP
                                        iconSizeRow.seticonSize()
                                    }
                                }
                                Slider {
                                    id: iconSizeSlider
                                    implicitWidth: 140
                                    from: iconSizeRow.f
                                    value: cfg_iconSize
                                    to: iconSizeRow.t
                                    onValueChanged: {
                                        iconSizeRow.buttonPressed = iconSizeSlider
                                        iconSizeRow.seticonSizeSlider()
                                    }
                                }
                            }
                        }
                    } 
                }
            }
        }
        Grid {
            // NEW TOOLTIP INFORMATION
            anchors.top: gA45.bottom
            Text {
                id: infoText45
                opacity: 0
                padding: 10 
                width: rootRec45.width
                color: myPalette.windowText
                textFormat: Text.RichText
                wrapMode: Text.Wrap
                text: i18n("Use the slider to quickly increase or decrease item size, with finer controls via the adjacent buttons.")
                    + "<table>"
                        + "<tr><td><b>▲</b>: </td> <td>" + i18n("Increase speed icon size, maximum 200%.") + "</td></tr>"
                        + "<tr><td><b>▼</b>: </td> <td>" + i18n("Decrease speed icon size, minimum 50%") + "</td></tr>"
                    + "</table>"
            }
        }
    } 
    //#######################################################################################################
    Rectangle {
        id: rootRec46
        width: parent.width
        height: infoButton46.height + 8
        anchors.top: rootRec45.bottom
        anchors.topMargin: spacerA
        color: "transparent" //"red"
        border.color: "dark grey"
        border.width: 0
        radius: 4

        ToolButton {
            id: infoButton46
            icon.name: 'kt-info-widget'
            implicitWidth: infoButton46.height
            anchors.right: parent.right
            opacity: 0.5

            MouseArea {
                property bool state:    false
                anchors.fill:           parent
                hoverEnabled:           true
                onEntered:              infoButton46.opacity = 1
                onExited:               state ? infoButton46.opacity = 1 : infoButton46.opacity = 0.5
                onClicked: {
                    state = !state
                    main.toggleTooltip(rootRec46)
                }
            }
        }
        Grid {
            // TITLE | CHOICE BUTTONS GO HERE
            id: gA46
            anchors.verticalCenter: infoButton46.verticalCenter

            Row {
                //spacing: 10        
                // Rectangle {     // USED FOR LABEL ALIGNMENT - NOT SURE WHY HAVING BELOW BUTTONS CAUSED 'anchors.verticalCenter: recAlign4.verticalCenter' NOT TO WORK WITH LABEL.
                //     id: recAlign46
                //     height: infoButton46.height
                //     width: 0
                //     color: "transparent"
                // }
                Column {
                    Rectangle {
                        height: 10
                        width: spacerA
                        color: "transparent" //"red"
                    } 
                }
                Column {
                    //anchors.verticalCenter: recAlign46.verticalCenter
                    Label {
                        width: titleTextMetrics.width
                        text:  i18n("Prefix/Suffix size:")
                        height: infoButton46.height
                    }
                }
                Column {
                    //####################################################
                    RowLayout {
                        id: sufixSizeRow
                        height: infoButton46.height
                        property var buttonPressed;
                        property var t: 2;
                        property var f: 0.5;

                        function disableButton() {
                            if (cfg_sufixSize === f) {
                                sufixSizeDOWN.enabled = false;
                            } else {
                                sufixSizeDOWN.enabled = true;
                            }                 
                            if (cfg_sufixSize === t) {
                                sufixSizeUP.enabled = false;
                            } else {
                                sufixSizeUP.enabled = true;
                            }                
                        }
                        function setsufixSize() {
                            if (buttonPressed.text === "▲") {           // BUTTONS
                                cfg_sufixSize += 0.01;
                            } else if (buttonPressed.text === "▼") {
                                cfg_sufixSize -= 0.01;
                            } 
                            sufixSizeSlider.value = cfg_sufixSize
                            disableButton()
                        }    
                            
                        function setsufixSizeSlider() {                  // SLIDER
                            var sliderVal
                            sliderVal = buttonPressed.value.toFixed(2)
                            if (sliderVal !==  cfg_sufixSize) {
                                cfg_sufixSize = sliderVal
                            }
                            disableButton()
                        }

                        Rectangle {
                            width: labelTextMetrics.width
                            height: sufixSizeLabel.height
                            color: "transparent"
                            Label {
                                id: sufixSizeLabel
                                text: (cfg_sufixSize * 100).toFixed(0) + " %"
                            }
                        }

                        Rectangle { 
                            width: (sufixSizeUP.x - sufixSizeDOWN.x) + (sufixSizeDOWN.width + 2)
                            height: sufixSizeDOWN.height + 2
                            color: "transparent"
                            border.color: "dark grey"
                            border.width: 0.5
                            radius: 4           
                            RowLayout {       
                                Button {
                                    id: sufixSizeDOWN
                                    text: "▼"
                                    implicitWidth: sufixSizeDOWN.height
                                    Layout.margins: 1   //buttonMargin
                                    enabled: cfg_sufixSize != sufixSizeRow.f
                                    onReleased: {
                                        sufixSizeRow.buttonPressed = sufixSizeDOWN
                                        sufixSizeRow.setsufixSize()
                                    }
                                }
                                Button {
                                    id: sufixSizeUP
                                    text: "▲"
                                    implicitWidth: sufixSizeUP.height
                                    Layout.margins: 1   //buttonMargin
                                    enabled: cfg_sufixSize != sufixSizeRow.t
                                    onReleased: {
                                        sufixSizeRow.buttonPressed = sufixSizeUP
                                        sufixSizeRow.setsufixSize()
                                    }
                                }
                                Slider {
                                    id: sufixSizeSlider
                                    implicitWidth: 140
                                    from: sufixSizeRow.f
                                    value: cfg_sufixSize
                                    to: sufixSizeRow.t
                                    onValueChanged: {
                                        sufixSizeRow.buttonPressed = sufixSizeSlider
                                        sufixSizeRow.setsufixSizeSlider()
                                    }
                                }
                            }
                        }
                    } 
                }
            }
        }
        Grid {
            // NEW TOOLTIP INFORMATION
            anchors.top: gA46.bottom
            Text {
                id: infoText46
                opacity: 0
                padding: 10 
                width: rootRec46.width
                color: myPalette.windowText
                textFormat: Text.RichText
                wrapMode: Text.Wrap
                text: i18n("Use the slider to quickly increase or decrease item size, with finer controls via the adjacent buttons.")
                    + "<table>"
                        + "<tr><td><b>▲</b>: </td> <td>" + i18n("Increase speed prefix/suffix font size, maximum 200%.") + "</td></tr>"
                        + "<tr><td><b>▼</b>: </td> <td>" + i18n("Decrease speed prefix/suffix font size, minimum 50%") + "</td></tr>"
                    + "</table>"
            }
        }
    }    

 //#######################################################################################################
    MenuSeparator {
        id: separator11
        padding: 0
        topPadding: 20
        bottomPadding: 20
        contentItem: Rectangle {
            implicitWidth: parent.parent.width
            implicitHeight: 1
            color: myPalette.light //"light grey"
        }
        anchors.top: rootRec46.bottom
    }
 //#######################################################################################################  
    Rectangle {
        id: rootRec9
        width: parent.width
        height: infoButton9.height
        //anchors.top: rootRec8.bottom
        anchors.top: separator11.bottom
        //anchors.topMargin: spacerB
        color: "transparent" //"red"
        border.color: "dark grey"
        border.width: 0
        radius: 4

        ToolButton {
            id: infoButton9
            icon.name: 'kt-info-widget'
            implicitWidth: infoButton9.height
            anchors.right: parent.right
            opacity: 0.5
            MouseArea {
                property bool state:    false
                anchors.fill:           parent
                hoverEnabled:           true
                onEntered:              infoButton9.opacity = 1
                onExited:               state ? infoButton9.opacity = 1 : infoButton9.opacity = 0.5
                onClicked: {
                    state = !state
                    main.toggleTooltip(rootRec9)
                }
            }
        }
        Grid {
            // TITLE | CHOICE BUTTONS GO HERE
            id: gA9
            //anchors.verticalCenter: infoButton9.verticalCenter

            Row {
                //spacing: 10        
                Column {
                    Rectangle {
                        height: 10
                        width: spacerA
                        color: "transparent" //"red"
                    } 
                }
                Column {
                    //________ LAYOUT ________ 
                    Label {
                        width: titleTextMetrics.width
                        text:  i18n("Show speed units:")
                        height: infoButton9.height
                    }
                }
                Column {
                    //####################################################
                    CheckBox {
                        id: showUnits
                        height: infoButton9.height
                    }  
                    // ################################################################    
                }
            }
        }
        Grid {
            // NEW TOOLTIP INFORMATION
            anchors.top: gA9.bottom
            Text {
                id: infoText9
                opacity: 0
                padding: 10 
                width: rootRec9.width
                color: myPalette.windowText
                textFormat: Text.RichText
                wrapMode: Text.Wrap
                
                text: "<table>"
                        + "<tr><td><b>" + i18n("Checked") + "</b>: </td> <td style='padding-bottom:6px'>" + i18n("Hides the trailing suffix for the bits (b, kib, Mib Gib) or bytes (B, KB, MB, GB).") + "</td></tr>"
                        + "<tr><td><b>" + i18n("Unchecked") + "</b>: </td> <td style='padding-bottom:6px'>" + i18n("Shows the suffixes for bits or bytes.") + "</td></tr>"
                    + "</table>"
            }
        } 
    }
 //#######################################################################################################
    Rectangle {
        id: rootRec10
        width: parent.width
        height: infoButton10.height
        anchors.top: rootRec9.bottom
        anchors.topMargin: spacerA
        color: "transparent" //"red"
        border.color: "dark grey"
        border.width: 0
        radius: 4

        ToolButton {
            id: infoButton10
            icon.name: 'kt-info-widget'
            implicitWidth: infoButton10.height
            anchors.right: parent.right
            opacity: 0.5
            MouseArea {
                property bool state:    false
                anchors.fill:           parent
                hoverEnabled:           true
                onEntered:              infoButton10.opacity = 1
                onExited:               state ? infoButton10.opacity = 1 : infoButton10.opacity = 0.5
                onClicked: {
                    state = !state
                    main.toggleTooltip(rootRec10)
                }
            }
        }
        Grid {
            // TITLE | CHOICE BUTTONS GO HERE
            id: gA10
            //anchors.verticalCenter: infoButton10.verticalCenter

            Row {
                //spacing: 10        
                Column {
                    Rectangle {
                        height: 10
                        width: spacerA
                        color: "transparent" //"red"
                    } 
                }
                Column {
                    //________ LAYOUT ________ 
                    Label {
                        width: titleTextMetrics.width
                        text:  i18n("Speed units:")
                        height: infoButton10.height
                    }
                }
                Column {
                    //####################################################
                    RowLayout {
                        height: infoButton10.height
                        RadioButton {
                            Layout.rightMargin:     20  // PADDING RIGHT
                            checked:                plasmoid.configuration.speedUnits === 'bits'
                            text:                   i18n("Bits")
                            onReleased:             cfg_speedUnits = 'bits'
                        }
                        RadioButton {
                            checked:                plasmoid.configuration.speedUnits === 'bytes'
                            text:                   i18n("Bytes")
                            onReleased:             cfg_speedUnits = 'bytes'
                        }
                    } 
                    // ################################################################    
                }
            }
        }
        Grid {
            // NEW TOOLTIP INFORMATION
            anchors.top: gA10.bottom
            Text {
                id: infoText10
                opacity: 0
                padding: 10 
                width: rootRec10.width
                color: myPalette.windowText
                textFormat: Text.RichText
                wrapMode: Text.Wrap
                
                text: "<table>"
                        + "<tr><td><b>" + i18n("Bits") + "</b>: </td> <td style='padding-bottom:6px'>" + i18n("Displays data throughput based on bit units. The default option, bits are normally used to measure a data transfer.") + "</td></tr>"
                        + "<tr><td><b>" + i18n("Bytes") + "</b>: </td> <td style='padding-bottom:6px'>" + i18n("Displays data throughput based on byte units. Second option as bytes can be used to measure an amount of data, normally storage data.") + "</td></tr>"
                    + "</table>"
            }
        } 
    }
 //#######################################################################################################
    Rectangle {
        id: rootRec11
        width: parent.width
        height: infoButton11.height
        anchors.top: rootRec10.bottom
        anchors.topMargin: spacerA
        color: "transparent" //"red"
        border.color: "dark grey"
        border.width: 0
        radius: 4

        ToolButton {
            id: infoButton11
            icon.name: 'kt-info-widget'
            implicitWidth: infoButton11.height
            anchors.right: parent.right
            opacity: 0.5
            MouseArea {
                property bool state:    false
                anchors.fill:           parent
                hoverEnabled:           true
                onEntered:              infoButton11.opacity = 1
                onExited:               state ? infoButton11.opacity = 1 : infoButton11.opacity = 0.5
                onClicked: {
                    state = !state
                    main.toggleTooltip(rootRec11)
                }
            }
        }
        Grid {
            // TITLE | CHOICE BUTTONS GO HERE
            id: gA11
            //anchors.verticalCenter: infoButton11.verticalCenter

            Row {
                //spacing: 10        
                Column {
                    Rectangle {
                        height: 10
                        width: spacerA
                        color: "transparent" //"red"
                    } 
                }
                Column {
                    //________ LAYOUT ________ 
                    Label {
                        width: titleTextMetrics.width
                        text:  i18n("Shorten speed units:")
                        height: infoButton11.height
                    }
                }
                Column {
                    //####################################################
                    CheckBox {
                        id: shortUnits
                        height: infoButton11.height
                    } 
                    // ################################################################    
                }
            }
        }
        Grid {
            // NEW TOOLTIP INFORMATION
            anchors.top: gA11.bottom
            Text {
                id: infoText11
                opacity: 0
                padding: 10 
                width: rootRec11.width
                color: myPalette.windowText
                textFormat: Text.RichText
                wrapMode: Text.Wrap
                
                text: "<table>"
                        + "<tr><td><b>" + i18n("Checked") + "</b>: </td> <td style='padding-bottom:6px'>" + i18n("Will only use a single character to represent the bits or bytes suffix, for example kb = k, Mb = M etc.  Per second units will also not be displayed.") + "</td></tr>"
                        + "<tr><td><b>" + i18n("Unchecked") + "</b>: </td> <td style='padding-bottom:6px'>" + i18n("The complete suffix will be displayed including the per second unit.") + "</td></tr>"
                    + "</table>"
            }
        } 
    }
 //#######################################################################################################
    MenuSeparator {
        id: separator2
        padding: 0
        topPadding: 20
        bottomPadding: 20
        contentItem: Rectangle {
            implicitWidth: parent.parent.width
            implicitHeight: 1
            color: myPalette.light //"light grey"
        }
        anchors.top: rootRec11.bottom
    }
 //#######################################################################################################   
    Rectangle {
        id: rootRec12
        width: parent.width
        height: infoButton12.height
        anchors.top: separator2.bottom
        //anchors.top: rootRec11.bottom
        //anchors.topMargin: spacerB
        color: "transparent" //"red"
        border.color: "dark grey"
        border.width: 0
        radius: 4

        ToolButton {
            id: infoButton12
            icon.name: 'kt-info-widget'
            implicitWidth: infoButton12.height
            anchors.right: parent.right
            opacity: 0.5
            MouseArea {
                property bool state:    false
                anchors.fill:           parent
                hoverEnabled:           true
                onEntered:              infoButton12.opacity = 1
                onExited:               state ? infoButton12.opacity = 1 : infoButton12.opacity = 0.5
                onClicked: {
                    state = !state
                    main.toggleTooltip(rootRec12)
                }
            }
        }
        Grid {
            // TITLE | CHOICE BUTTONS GO HERE
            id: gA12
            //anchors.verticalCenter: infoButton12.verticalCenter

            Row {
                //spacing: 10        
                Column {
                    Rectangle {
                        height: 10
                        width: spacerA
                        color: "transparent" //"red"
                    } 
                }
                Column {
                    //________ LAYOUT ________ 
                    Label {
                        width: titleTextMetrics.width
                        text:  i18n("Show 'per seconds' suffix:")
                        height: infoButton12.height
                    }
                }
                Column {
                    //####################################################
                    CheckBox {
                        id: showSeconds
                        height: infoButton12.height
                    }  
                    // DISABLE THE SECONDS PREFIX OPTIONS IF CHECKBOX NOT CHECKED
                    // ################################################################    
                }
            }
        }
        Grid {
            // NEW TOOLTIP INFORMATION
            anchors.top: gA12.bottom
            Text {
                id: infoText12
                opacity: 0
                padding: 10 
                width: rootRec12.width
                color: myPalette.windowText
                textFormat: Text.RichText
                wrapMode: Text.Wrap
                
                text: "<table>"
                        + "<tr><td><b>" + i18n("Checked") + "</b>: </td> <td style='padding-bottom:6px'>" + i18n("Appends the per second suffix to the trailing measurement unit.") + "</td></tr>"
                        + "<tr><td><b></b></td> <td style='padding-bottom:6px'>" + i18n("* This option is technically correct when used in conjunction with 'Interval data relay' choice other than 'Accumulated'.") + "</td></tr>"
                        + "<tr><td><b>" + i18n("Unchecked") + "</b>: </td> <td style='padding-bottom:6px'>" + i18n("Removes the per second suffix ('/s' or 'ps') from the trailing bit or byte measurement unit.") + "</td></tr>"
                        + "<tr><td><b></b></td> <td style='padding-bottom:6px'>" + i18n("* This option is technically correct when used in conjunction with 'Interval data relay' choice of 'Accumulated'.") + "</td></tr>"
                    + "</table>"
            }
        } 
    }
 //#######################################################################################################
    Rectangle {
        id: rootRec13
        width: parent.width
        height: infoButton13.height
        anchors.top: rootRec12.bottom
        anchors.topMargin: spacerA
        color: "transparent" //"red"
        border.color: "dark grey"
        border.width: 0
        radius: 4

        ToolButton {
            id: infoButton13
            icon.name: 'kt-info-widget'
            implicitWidth: infoButton13.height
            anchors.right: parent.right
            opacity: 0.5
            MouseArea {
                property bool state:    false
                anchors.fill:           parent
                hoverEnabled:           true
                onEntered:              infoButton13.opacity = 1
                onExited:               state ? infoButton13.opacity = 1 : infoButton13.opacity = 0.5
                onClicked: {
                    state = !state
                    main.toggleTooltip(rootRec13)
                }
            }
        }
        Grid {
            // TITLE | CHOICE BUTTONS GO HERE
            id: gA13
            //anchors.verticalCenter: infoButton13.verticalCenter

            Row {
                //spacing: 10        
                Column {
                    Rectangle {
                        height: 10
                        width: spacerA
                        color: "transparent" //"red"
                    } 
                }
                Column {
                    //________ LAYOUT ________ 
                    Label {
                        width: titleTextMetrics.width
                        text:  i18n("Per Seconds prefix:")
                        height: infoButton13.height
                    }
                }
                Column {
                    //####################################################
                    RowLayout {
                        height: infoButton13.height
                        RadioButton {
                            Layout.rightMargin:     20  // PADDING RIGHT
                            enabled:                cfg_showSeconds
                            checked:                plasmoid.configuration.secondsPrefix === '/s'
                            text:                   i18n("/s")
                            onReleased:             cfg_secondsPrefix = '/s'
                        }
                        RadioButton {
                            enabled:                cfg_showSeconds
                            checked:                plasmoid.configuration.secondsPrefix === 'ps'
                            text:                   i18n("ps")
                            onReleased:             cfg_secondsPrefix = 'ps'
                        }
                    }  
                    // ################################################################    
                }
            }
        }
        Grid {
            // NEW TOOLTIP INFORMATION
            anchors.top: gA13.bottom
            Text {
                id: infoText13
                opacity: 0
                padding: 10 
                width: rootRec13.width
                color: myPalette.windowText
                textFormat: Text.RichText
                wrapMode: Text.Wrap
                
                text: "<table>"
                        + "<tr><td>" + i18n("Choose between a per second unit of '/s' or 'ps'.") + "</td></tr>"
                        + "<tr><td>" + i18n("Example, measuring in bits: Kib<b>/s</b> or Kib<b>ps</b>, measuring in bytes: KB<b>/s</b> or KB<b>ps</b>.") + "</td></tr>"
                    + "</table>"
            }
        } 
    }
 //#######################################################################################################
    MenuSeparator {
        id: separator3
        padding: 0
        topPadding: 20
        bottomPadding: 20
        contentItem: Rectangle {
            implicitWidth: parent.parent.width
            implicitHeight: 1
            color: myPalette.light //"light grey"
        }
        anchors.top: rootRec13.bottom
    }
 //#######################################################################################################   
    Rectangle {
        id: rootRec14
        width: parent.width
        height: infoButton14.height
        anchors.top: separator3.bottom
        //anchors.topMargin: spacerB
        color: "transparent" //"red"
        border.color: "dark grey"
        border.width: 0
        radius: 4

        ToolButton {
            id: infoButton14
            icon.name: 'kt-info-widget'
            implicitWidth: infoButton14.height
            anchors.right: parent.right
            opacity: 0.5
            MouseArea {
                property bool state:    false
                anchors.fill:           parent
                hoverEnabled:           true
                onEntered:              infoButton14.opacity = 1
                onExited:               state ? infoButton14.opacity = 1 : infoButton14.opacity = 0.5
                onClicked: {
                    state = !state
                    main.toggleTooltip(rootRec14)
                }
            }
        }
        Grid {
            // TITLE | CHOICE BUTTONS GO HERE
            id: gA14
            //anchors.verticalCenter: infoButton14.verticalCenter

            Row {
                //spacing: 10        
                Column {
                    Rectangle {
                        height: 10
                        width: spacerA
                        color: "transparent" //"red"
                    } 
                }
                Column {
                    //________ LAYOUT ________ 
                    Label {
                        width: titleTextMetrics.width
                        text:  i18n("Show speed icons:")
                        height: infoButton14.height
                    }
                }
                Column {
                    //####################################################
                    CheckBox {
                        id: showIcons
                        height: infoButton14.height
                    } 
                    // ################################################################    
                }
            }
        }
        Grid {
            // NEW TOOLTIP INFORMATION
            anchors.top: gA14.bottom
            Text {
                id: infoText14
                opacity: 0
                padding: 10 
                width: rootRec14.width
                color: myPalette.windowText
                textFormat: Text.RichText
                wrapMode: Text.Wrap
                
                text: "<table>"
                        + "<tr><td><b>" + i18n("Checked") + "</b>: </td> <td style='padding-bottom:6px'>" + i18n("Displays the Download or Upload icons in the widget.") + "</td></tr>"
                        + "<tr><td><b>" + i18n("Unchecked") + "</b>: </td> <td style='padding-bottom:6px'>" + i18n("Hides the Download or Upload icons in the widget.") + "</td></tr>"
                    + "</table>"
            }
        } 
    }    
 //#######################################################################################################
    Rectangle {
        id: rootRec15
        width: parent.width
        height: infoButton15.height
        anchors.top: rootRec14.bottom
        anchors.topMargin: spacerA
        color: "transparent" //"red"
        border.color: "dark grey"
        border.width: 0
        radius: 4

        ToolButton {
            id: infoButton15
            icon.name: 'kt-info-widget'
            implicitWidth: infoButton15.height
            anchors.right: parent.right
            opacity: 0.5
            MouseArea {
                property bool state:    false
                anchors.fill:           parent
                hoverEnabled:           true
                onEntered:              infoButton15.opacity = 1
                onExited:               state ? infoButton15.opacity = 1 : infoButton15.opacity = 0.5
                onClicked: {
                    state = !state
                    main.toggleTooltip(rootRec15)
                }
            }
        }
        Grid {
            // TITLE | CHOICE BUTTONS GO HERE
            id: gA15
            //anchors.verticalCenter: infoButton15.verticalCenter

            Row {
                //spacing: 10     
                // Rectangle {     // USED FOR LABEL ALIGNMENT - NOT SURE WHY HAVING BELOW BUTTONS CAUSED 'anchors.verticalCenter: infoButtonX.verticalCenter' NOT TO WORK WITH LABEL.
                //     id: recAlign15
                //     height: infoButton15.height
                //     width: 0
                //     color: "transparent"
                // }   
                Column {
                    Rectangle {
                        height: 10
                        width: spacerA
                        color: "transparent" //"red"
                    } 
                }
                Column {
                    //anchors.verticalCenter: recAlign15.verticalCenter
                    //________ LAYOUT ________ 
                    Label {
                        width: titleTextMetrics.width
                        text:  i18n("Icon Style:")
                        height: infoButton15.height
                    }
                }
                Column {
                    //####################################################
                    ComboBox {
                        // ICONS FROM HACK FONT AND NATO SAN
                        id:                         iconType
                        textRole:                   'text'
                        height: infoButton15.height
                        model: [
                            { text: 'ᐁ ᐃ' },
                            { text: '▽ △' },
                            { text: '▼ ▲' },
                            { text: '⮟ ⮝' }, 
                            { text: '⩔ ⩓' }, 
                            { text: '🢗 🢕' }, 
                            { text: '⋁ ⋀' }, 
                            { text: '◥ ◢' }, 
                            { text: 'D: U:' },
                            { text: '🠇 🠅' },
                            { text: '🠋 🠉' },
                            { text: '🡇 🡅' },
                            { text: '🡫 🡩' },
                            { text: '⮋ ⮉' },
                            { text: '⇩ ⇧' },
                            { text: '⮯ ⮭' },
                            { text: '⥥ ⥣' }
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
                    // ################################################################    
                }
            }
        }
        Grid {
            // NEW TOOLTIP INFORMATION
            anchors.top: gA15.bottom
            Text {
                id: infoText15
                opacity: 0
                padding: 10 
                width: rootRec15.width
                color: myPalette.windowText
                textFormat: Text.RichText
                wrapMode: Text.Wrap
                
                text: "<table>"
                        + "<tr><td>" + i18n("Choose the Upload and Download icon style to be displayed in the widget.") + "</td></tr>"
                    + "</table>"
            }
        } 
    }   
 //#######################################################################################################
    Rectangle {
        id: rootRec155
        width: parent.width
        height: infoButton155.height
        anchors.top: rootRec15.bottom
        anchors.topMargin: spacerA
        color: "transparent" //"red"
        border.color: "dark grey"
        border.width: 0
        radius: 4

        ToolButton {
            id: infoButton155
            icon.name: 'kt-info-widget'
            implicitWidth: infoButton155.height
            anchors.right: parent.right
            opacity: 0.5
            MouseArea {
                property bool state:    false
                anchors.fill:           parent
                hoverEnabled:           true
                onEntered:              infoButton155.opacity = 1
                onExited:               state ? infoButton155.opacity = 1 : infoButton155.opacity = 0.5
                onClicked: {
                    state = !state
                    main.toggleTooltip(rootRec155)
                }
            }
        }
        Grid {
            // TITLE | CHOICE BUTTONS GO HERE
            id: gA155
            //anchors.verticalCenter: infoButton155.verticalCenter

            Row {
                //spacing: 10     
                // Rectangle {     // USED FOR LABEL ALIGNMENT - NOT SURE WHY HAVING BELOW BUTTONS CAUSED 'anchors.verticalCenter: infoButtonX.verticalCenter' NOT TO WORK WITH LABEL.
                //     id: recAlign155
                //     height: infoButton155.height
                //     width: 0
                //     color: "transparent"
                // }   
                Column {
                    Rectangle {
                        height: 10
                        width: spacerA
                        color: "transparent" //"red"
                    } 
                }
                Column {
                    //anchors.verticalCenter: recAlign155.verticalCenter
                    //________ LAYOUT ________ 
                    Label {
                        width: titleTextMetrics.width
                        text:  i18n("Custom Icon Style:")
                        height: infoButton155.height
                    }
                }
                Column {
                    //####################################################
                    Row {
                        id: custIconRow
                        height: infoButton155.height
                        function getCustIcons() {
                            cfg_iconType = custIconDown.text + " " + custIconUp.text
                        }
                        CheckBox {
                            id:     custIcon 
                            height: infoButton155.height
                            onCheckedChanged: {
                                custIconDown.enabled = custIcon.checked
                                custIconUp.enabled = custIcon.checked
                                iconType.enabled = !iconType.enabled        // Disable Icon ComboBox
                            }
                        } 
                        TextField {
                            id: custIconDown
                            placeholderText: "Receive"
                            enabled: custIcon.checked
                            width:      100
                            onTextChanged: {
                                custIconRow.getCustIcons()
                                if (text.length > 10) {
                                    text = text.substring(0, 10); // Limit to 10 characters
                                }
                            }
                        }
                        Rectangle {
                            height: 10
                            width: spacerA
                            color: "transparent" //"red"
                        } 
                        TextField {
                            id: custIconUp
                            placeholderText: "Transmit"
                            enabled: custIcon.checked
                            width:      100
                            onTextChanged: {
                                custIconRow.getCustIcons()
                                if (text.length > 10) {
                                    text = text.substring(0, 10); // Limit to 10 characters
                                }
                            }
                        }
                    }
                    // ################################################################    
                }
            }
        }
        Grid {
            // NEW TOOLTIP INFORMATION
            anchors.top: gA155.bottom
            Text {
                id: infoText155
                opacity: 0
                padding: 10 
                width: rootRec155.width
                color: myPalette.windowText
                textFormat: Text.RichText
                wrapMode: Text.Wrap
                
                text: "<table>"
                        + "<tr><td>" + i18n("Input your custom font icons or text of choice.  Each text field is limited to 10 characters.") + "</td></tr>"
                    + "</table>"
            }
        } 
    }  
 //#######################################################################################################
    Rectangle {
        id: rootRec16
        width: parent.width
        height: infoButton16.height
        anchors.top: rootRec155.bottom
        anchors.topMargin: spacerA
        color: "transparent" //"red"
        border.color: "dark grey"
        border.width: 0
        radius: 4

        ToolButton {
            id: infoButton16
            icon.name: 'kt-info-widget'
            implicitWidth: infoButton16.height
            anchors.right: parent.right
            opacity: 0.5
            MouseArea {
                property bool state:    false
                anchors.fill:           parent
                hoverEnabled:           true
                onEntered:              infoButton16.opacity = 1
                onExited:               state ? infoButton16.opacity = 1 : infoButton16.opacity = 0.5
                onClicked: {
                    state = !state
                    main.toggleTooltip(rootRec16)
                }
            }
        }
        Grid {
            // TITLE | CHOICE BUTTONS GO HERE
            id: gA16
            //anchors.verticalCenter: infoButton16.verticalCenter

            Row {
                //spacing: 10        
                Column {
                    Rectangle {
                        height: 10
                        width: spacerA
                        color: "transparent" //"red"
                    } 
                }
                Column {
                    //________ LAYOUT ________ 
                    Label {
                        width: titleTextMetrics.width
                        text:  i18n("Icon position:")
                        height: infoButton16.height
                    }
                }
                Column {
                    //####################################################
                    RowLayout {
                        height: infoButton16.height
                        RadioButton {
                            Layout.rightMargin: 20          // PADDING RIGHT
                            checked:            plasmoid.configuration.iconPosition === false
                            text:               i18n("Left")
                            onReleased:         cfg_iconPosition = false
                        }
                        RadioButton {
                            checked:            plasmoid.configuration.iconPosition === true
                            text:               i18n("Right")
                            onReleased:         cfg_iconPosition = true
                        }
                    }
                    // ################################################################    
                }
            }
        }
        Grid {
            // NEW TOOLTIP INFORMATION
            anchors.top: gA16.bottom
            Text {
                id: infoText16
                opacity: 0
                padding: 10 
                width: rootRec16.width
                color: myPalette.windowText
                textFormat: Text.RichText
                wrapMode: Text.Wrap
                
                text: "<table>"
                        + "<tr><td>" + i18n("Choose to have the Upload and Download icons to the left or the right of the speed data.") + "</td></tr>"
                    + "</table>"
            }
        } 
    }  

 //#######################################################################################################
    MenuSeparator {
        id: separator4
        padding: 0
        topPadding: 20
        bottomPadding: 20
        contentItem: Rectangle {
            implicitWidth: parent.parent.width
            implicitHeight: 1
            color: myPalette.light //"light grey"
        }
        anchors.top: rootRec16.bottom
    }
 //#######################################################################################################   
 
    Rectangle {
        id: rootRec17
        width: parent.width
        height: infoButton17.height
        anchors.top: separator4.bottom
        //anchors.topMargin: spacerB
        color: "transparent" // myPalette.window
        border.color: "dark grey"
        border.width: 0
        radius: 4

        ToolButton {
            id: infoButton17
            icon.name: 'kt-info-widget'
            implicitWidth: infoButton17.height
            anchors.right: parent.right
            opacity: 0.5
            MouseArea {
                property bool state:    false
                anchors.fill:           parent
                hoverEnabled:           true
                onEntered:              infoButton17.opacity = 1
                onExited:               state ? infoButton17.opacity = 1 : infoButton17.opacity = 0.5
                onClicked: {
                    state = !state
                    main.toggleTooltip(rootRec17)
                }
            }
        }
        Grid {
            // TITLE | CHOICE BUTTONS GO HERE
            id: gA17
            //anchors.verticalCenter: infoButton17.verticalCenter

            Row {
                //spacing: 10        
                // Rectangle {     // USED FOR LABEL ALIGNMENT - NOT SURE WHY HAVING BELOW BUTTONS CAUSED 
                //                 // 'anchors.verticalCenter: infoButtonX.verticalCenter' NOT TO WORK WITH LABEL.
                //     id: recAlign17
                //     height: infoButton17.height
                //     width: 0
                //     color: "transparent"
                // }
                Column {
                    Rectangle {
                        height: 10
                        width: spacerA
                        color: "transparent" //"red"
                    } 
                }
                Column {
                    //anchors.verticalCenter: recAlign17.verticalCenter
                    //________ LAYOUT ________ 
                    Label {
                        width: titleTextMetrics.width
                        text:  i18n("Numbers:")
                        height: infoButton17.height
                    }
                }
                Column {
                    //####################################################
                    RowLayout {
                        height: infoButton17.height
                        RadioButton {
                            Layout.rightMargin:     20          // PADDING RIGHT
                            checked:                plasmoid.configuration.binaryDecimal === 'binary'
                            text:                   i18n("Binary (1024 - 2^10)")
                            onReleased:             cfg_binaryDecimal = 'binary'
                        }
                        RadioButton {
                            checked:                plasmoid.configuration.binaryDecimal === 'decimal'
                            text:                   i18n("Metric (1000 - 10^3)")
                            onReleased:             cfg_binaryDecimal = 'decimal'
                        }
                    }
                    // ################################################################    
                }
            }
        }
        Grid {
            // NEW TOOLTIP INFORMATION
            anchors.top: gA17.bottom
            Text {
                id: infoText17
                opacity: 0
                padding: 10 
                width: rootRec17.width
                color: myPalette.windowText
                textFormat: Text.RichText
                wrapMode: Text.Wrap
                text: "<table>" +
                        + "<tr><td>"
                        + i18n("In computing, binary 1024 and decimal 1000 are two different ways of measuring units of digital information.")
                        + "<p>"
                        + i18n("Decimal 1000 is based on the metric system, which is based on powers of 10. In this system, each unit is 10 times larger than the previous unit. \
For example, 1 kilometer is 1000 meters, 1 megabyte is 1000 kilobytes, and so on.")
                        + "</p>"
                        + "<p>"
                        + i18n("Binary 1024 is based on the binary system, which is based on powers of 2. In this system, each unit is twice as large as the previous unit. \
For example, 1 kilobyte is 1024 bytes, 1 megabyte is 1024 kilobytes, and so on.")
                        + "</p>"
                        + "<p>"
                        + i18n("The reason why binary 1024 is used in computing is because computers store and process data in binary (0s and 1s), and it is convenient to use units that are based on powers of 2. \
However, for some purposes, such as networking, decimal 1000 units are used instead.")
                        + "</p>"
                        + "<p>"
                        + i18n("To avoid confusion, it is important to clearly specify which unit system is being used, and to use the correct prefix (e.g., kilo, mega) for the unit. \
The prefixes 'kibi,' 'mebi,' 'gibi,' etc. have been introduced to refer to binary 1024 units, while the prefixes 'kilo,' 'mega,' 'giga,' etc. continue to refer to decimal 1000 units.")
                        + "</p></td></tr>"
                    + "</table>"
            }
        } 
    }  
 //#######################################################################################################
//#######################################################################################################
    Rectangle {
        id: rootRec17a
        width: parent.width
        height: infoButton17a.height
        anchors.top: rootRec17.bottom
        anchors.topMargin: spacerA
        color: "transparent" //"red"
        border.color: "dark grey"
        border.width: 0
        radius: 4

        ToolButton {
            id: infoButton17a
            icon.name: 'kt-info-widget'
            implicitWidth: infoButton17a.height
            anchors.right: parent.right
            opacity: 0.5
            MouseArea {
                property bool state:    false
                anchors.fill:           parent
                hoverEnabled:           true
                onEntered:              infoButton17a.opacity = 1
                onExited:               state ? infoButton17a.opacity = 1 : infoButton17a.opacity = 0.5
                onClicked: {
                    state = !state
                    main.toggleTooltip(rootRec17a)
                }
            }
        }
        Grid {
            // TITLE | CHOICE BUTTONS GO HERE
            id: gA17a
            //anchors.verticalCenter: infoButton19.verticalCenter

            Row {
                //spacing: 10        
                Column {
                    Rectangle {
                        height: 10
                        width: spacerA
                        color: "transparent" //"red"
                    } 
                }
                Column {
                    //________ LAYOUT ________ 
                    Label {
                        width: titleTextMetrics.width
                        text:  i18n("Idle decimal:")
                        height: infoButton17a.height
                    }
                }
                Column {
                    Row {
                        //id: speedUnitRow
                        //#################################################################
                        // IGNORE DECINAL PLACE AT IDLE, 0 VS 0.0

                        CheckBox {
                            id:     ignoreDecimalIdle
                            height: infoButton19a.height
                        } 
                        // ################################################################                         
                    }
                }
            }
        }
        Grid {
            // NEW TOOLTIP INFORMATION
            anchors.top: gA17a.bottom
            Text {
                id: infoText17a
                opacity: 0
                padding: 10 
                width: rootRec17a.width
                color: myPalette.windowText
                textFormat: Text.RichText
                wrapMode: Text.Wrap  
                text: "<table>"
                    + "<tr><td>" + i18n("Ignore the 'Decimal place' setting at idle. At zero speed, only '0' will show rather than '0.0', '0.00' or '0.000', depending on additional fractional digit settings.") + "</td></tr>"
                    + "</table>"
            }
        }  
        
    }   
 //#######################################################################################################





    Rectangle {
        id: rootRec18
        width: parent.width
        height: infoButton18.height
        anchors.top: rootRec17a.bottom
        anchors.topMargin: spacerA
        color: "transparent" //"red"
        border.color: "dark grey"
        border.width: 0
        radius: 4

        ToolButton {
            id: infoButton18
            icon.name: 'kt-info-widget'
            implicitWidth: infoButton18.height
            anchors.right: parent.right
            opacity: 0.5
            MouseArea {
                property bool state:    false
                anchors.fill:           parent
                hoverEnabled:           true
                onEntered:              infoButton18.opacity = 1
                onExited:               state ? infoButton18.opacity = 1 : infoButton18.opacity = 0.5
                onClicked: {
                    state = !state
                    main.toggleTooltip(rootRec18)
                }
            }
        }
        Grid {
            // TITLE | CHOICE BUTTONS GO HERE
            id: gA18
            //anchors.verticalCenter: infoButton18.verticalCenter

            Row {
                //spacing: 10     
                // Rectangle {     // USED FOR LABEL ALIGNMENT - NOT SURE WHY HAVING BELOW BUTTONS CAUSED 'anchors.verticalCenter: infoButtonX.verticalCenter' NOT TO WORK WITH LABEL.
                //     id: recAlign18
                //     height: infoButton18.height
                //     width: 0
                //     color: "transparent"
                // }   
                Column {
                    Rectangle {
                        height: 10
                        width: spacerA
                        color: "transparent" //"red"
                    } 
                }
                Column {
                    //anchors.verticalCenter: gA18.verticalCenter //recAlign18.verticalCenter
                    //________ LAYOUT ________ 
                    Label {
                        width: titleTextMetrics.width
                        text:  i18n("Decimal Place:")
                        //anchors.verticalCenter: infoButton18.verticalCenter //recAlign18.verticalCenter
                        height: infoButton18.height
                    }
                }
                Column {
                    //####################################################
                    RowLayout {
                            id:                         decimalPlaceRow
                            height: infoButton18.height
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
                    // ################################################################    
                }
            }
        }
        Grid {
            // NEW TOOLTIP INFORMATION
            anchors.top: gA18.bottom
            Text {
                id: infoText18
                opacity: 0
                padding: 10 
                width: rootRec18.width
                color: myPalette.windowText
                textFormat: Text.RichText
                wrapMode: Text.Wrap
                
                text: "<table>"
                        + "<tr><td>" + i18n("Choose the number of decimal fraction digits to the right of the decimal point.") + "</td></tr>"
                    + "</table>"
            }
        } 
    } 
//#######################################################################################################
    Rectangle {
        id: rootRec19a
        width: parent.width
        height: infoButton19a.height
        anchors.top: rootRec18.bottom
        anchors.topMargin: spacerA
        color: "transparent" //"red"
        border.color: "dark grey"
        border.width: 0
        radius: 4

        ToolButton {
            id: infoButton19a
            icon.name: 'kt-info-widget'
            implicitWidth: infoButton19a.height
            anchors.right: parent.right
            opacity: 0.5
            MouseArea {
                property bool state:    false
                anchors.fill:           parent
                hoverEnabled:           true
                onEntered:              infoButton19a.opacity = 1
                onExited:               state ? infoButton19a.opacity = 1 : infoButton19a.opacity = 0.5
                onClicked: {
                    state = !state
                    main.toggleTooltip(rootRec19a)
                }
            }
        }
        Grid {
            // TITLE | CHOICE BUTTONS GO HERE
            id: gA19a
            //anchors.verticalCenter: infoButton19.verticalCenter

            Row {
                //spacing: 10        
                Column {
                    Rectangle {
                        height: 10
                        width: spacerA
                        color: "transparent" //"red"
                    } 
                }
                Column {
                    //________ LAYOUT ________ 
                    Label {
                        width: titleTextMetrics.width
                        text:  i18n("Speed unit selection:")
                        height: infoButton19a.height
                    }
                }
                Column {
                    Row {
                        id: speedUnitRow
                        //________ CHECKBOX WIDTH ________ 
                        TextMetrics {
                            id: checkBoxMetricsA
                            text: "Bytes    "
                        }
                        CheckBox {
                            id:     speedUnitB
                            height: infoButton19a.height
                        } 
                        Label {
                            id: speedUnitBLabel
                            text: cfg_speedUnits === 'bits' ? "bits" : "Bytes"
                            width: checkBoxMetricsA.width
                            height: infoButton19a.height
                        }
                        CheckBox {
                            id:     speedUnitK
                            height: infoButton19a.height
                        } 
                        Label {
                            id: speedUnitKLabel
                            text: cfg_binaryDecimal === 'binary' ? "Kibi" : "Kilo"
                            width: checkBoxMetricsA.width
                            height: infoButton19a.height
                        }
                        CheckBox {
                            id:     speedUnitM
                            height: infoButton19a.height
                        } 
                        Label {
                            id: speedUnitMLabel
                            text: cfg_binaryDecimal === 'binary' ? "Mebi" : "Mega"
                            width: checkBoxMetricsA.width
                            height: infoButton19a.height
                        }
                        CheckBox {
                            id:     speedUnitG
                            height: infoButton19a.height
                        } 
                        Label {
                            id: speedUnitGLabel
                            text: cfg_binaryDecimal === 'binary' ? "Gibi" : "Giga"
                            width: checkBoxMetricsA.width
                            height: infoButton19a.height
                        }
                        // ################################################################                         
                    }
                }
            }
        }
        Grid {
            // NEW TOOLTIP INFORMATION
            anchors.top: gA19a.bottom
            Text {
                id: infoText19a
                opacity: 0
                padding: 10 
                width: rootRec19a.width
                color: myPalette.windowText
                textFormat: Text.RichText
                wrapMode: Text.Wrap  
                text: "<table>"
                    + "<tr><td>" + i18n("Toggle each checkbox to enable or disable the calculation of network speed in the unit of measure.") + "</td></tr>"
                    + "<tr><td>" + i18n("When a checkbox is disabled, the calculation automatically shifts to the next enabled unit. This functionality provides flexibility and customization in determining the desired speed unit representation.") + "</td></tr>"
                    + "</table>"
            }
        }  
        
    }   
 //#######################################################################################################
    Rectangle {
        id: rootRec19
        width: parent.width
        height: infoButton19.height
        anchors.top: rootRec19a.bottom
        anchors.topMargin: spacerA
        color: "transparent" //"red"
        border.color: "dark grey"
        border.width: 0
        radius: 4

        ToolButton {
            id: infoButton19
            icon.name: 'kt-info-widget'
            implicitWidth: infoButton19.height
            anchors.right: parent.right
            opacity: 0.5
            MouseArea {
                property bool state:    false
                anchors.fill:           parent
                hoverEnabled:           true
                onEntered:              infoButton19.opacity = 1
                onExited:               state ? infoButton19.opacity = 1 : infoButton19.opacity = 0.5
                onClicked: {
                    state = !state
                    main.toggleTooltip(rootRec19)
                }
            }
        }
        Grid {
            // TITLE | CHOICE BUTTONS GO HERE
            id: gA19
            //anchors.verticalCenter: infoButton19.verticalCenter

            Row {
                //spacing: 10        
                Column {
                    Rectangle {
                        height: 10
                        width: spacerA
                        color: "transparent" //"red"
                    } 
                }
                Column {
                    //________ LAYOUT ________ 
                    Label {
                        width: titleTextMetrics.width
                        text:  i18n("Decimal place filter:")
                        height: infoButton19.height
                    }
                }
                Column {
                    Row {
                        id: filterRow
                        //#################################################################
                        // FILTERING IS THE DEFAULT SETTING AND ALLOWS THE RECIEVED BITS TO BE  
                        // ROUNDED TO THE LEAST POSSIBLE NUMBERS:
                        // EXAMPLE: 1,553,808 BITS = 1.6 Mb (ASSUMING 1 DECIMAL PLACE HAS BEEN SELECTED)
                        // DISABLING THE MEGA CHECKBOXES WILL ROUND THE VALUE DOWN THE THE NEAREST KILOBIT
                        // EXAMPLE: 1,553,808 BITS = 1554 Kb (ASSUMING 4 DIGIT ROUNDING WAS SELECTED)

                        //________ CHECKBOX WIDTH ________ 
                        TextMetrics {
                            id: checkBoxMetrics
                            text: "Bytes    "
                        }
                        CheckBox {
                            id:     decimalFilter0
                            height: infoButton19.height
                        } 
                        Label {
                            id: decimalFilter0Label
                            text: cfg_speedUnits === 'bits' ? "bits" : "Bytes"
                            //anchors.verticalCenter: decimalFilter0.verticalCenter
                            width:                  checkBoxMetrics.width
                            height: infoButton19.height
                        }
                        CheckBox {
                            id:     decimalFilter1
                            height: infoButton19.height
                        } 
                        Label {
                            id:                     decimalFilter1Label
                            text:                   cfg_binaryDecimal === 'binary' ? "Kibi" : "Kilo"
                            //anchors.verticalCenter: decimalFilter0.verticalCenter
                            width:                  checkBoxMetrics.width
                            height: infoButton19.height
                        }
                        CheckBox {
                            id:     decimalFilter2
                            height: infoButton19.height
                        } 
                        Label {
                            id:                     decimalFilter2Label
                            text:                   cfg_binaryDecimal === 'binary' ? "Mebi" : "Mega"
                            //anchors.verticalCenter: decimalFilter0.verticalCenter
                            width:                  checkBoxMetrics.width
                            height: infoButton19.height
                        }
                        CheckBox {
                            id:     decimalFilter3
                            height: infoButton19.height
                        } 
                        Label {
                            id:                     decimalFilter3Label
                            text:                   cfg_binaryDecimal === 'binary' ? "Gibi" : "Giga"
                            //anchors.verticalCenter: decimalFilter0.verticalCenter
                            width:                  checkBoxMetrics.width
                            height: infoButton19.height
                        }
                        // ################################################################                         
                    }
                }
            }
        }
        Grid {
            // NEW TOOLTIP INFORMATION
            anchors.top: gA19.bottom

            Text {
                id: infoText19
                opacity: 0
                padding: 10 
                width: rootRec19.width
                color: myPalette.windowText
                textFormat: Text.RichText
                wrapMode: Text.Wrap  
                text: "<table>"
                        + "<tr><td>" + i18n("Provides fine-grained control over speed rounding / decimal places in each unit of measure zone for the data display.") + "</td></tr>"
                        + "<tr><td>" + i18n("If the control is turned off, data values will be shown as whole numbers in the chosen zone as per the selected rounding method (either 3 or 4 digits rounding).") + "</td></tr>"
                        + "<tr><td><i>" + i18n("Example: 1,553,808 BITS = 1517.4 Kb (with one decimal place selected).") + "</i></td></tr>"
                        + "<tr><td>" + i18n("If the control is turned on, data values will be shown with the appropriate decimal places and the default 3 digit rounding enabled.") + "</td></tr>"
                        + "<tr><td><i>" + i18n("Example: 1,553,808 BITS = 1.5 Mb (with one decimal place selected).") + "</i></td></tr>"
                    + "</table>"  
            }  
        }   
    }     
 //#######################################################################################################
    Rectangle {
        id: rootRec20
        width: parent.width
        height: infoButton20.height
        anchors.top: rootRec19.bottom
        anchors.topMargin: spacerA
        color: "transparent" //"red"
        border.color: "dark grey"
        border.width: 0
        radius: 4

        ToolButton {
            id: infoButton20
            icon.name: 'kt-info-widget'
            implicitWidth: infoButton20.height
            anchors.right: parent.right
            opacity: 0.5
            MouseArea {
                property bool state:    false
                anchors.fill:           parent
                hoverEnabled:           true
                onEntered:              infoButton20.opacity = 1
                onExited:               state ? infoButton20.opacity = 1 : infoButton20.opacity = 0.5
                onClicked: {
                    state = !state
                    main.toggleTooltip(rootRec20)
                }
            }
        }
        Grid {
            // TITLE | CHOICE BUTTONS GO HERE
            id: gA20
            //anchors.verticalCenter: infoButton20.verticalCenter

            Row {
                //spacing: 10        
                Column {
                    Rectangle {
                        height: 10
                        width: spacerA
                        color: "transparent" //"red"
                    } 
                }
                Column {
                    //________ LAYOUT ________ 
                    Label {
                        width: titleTextMetrics.width
                        text:  i18n("Rounded whole number:")
                        height: infoButton20.height
                    }
                }
                Column {
                    //####################################################
                    // THIS WILL ROUND THE FIGURE DOWN TO THE NEAREST 3 OR 4 DIGIT, IF THIS ISNT POSSIBLE   
                    // A DECIMAL PLACE WILL BE USED TO DISPLAY THE NUMBER.
                    // EXAMPLE: 
                    // [3] 408,288 BITS = 408 Kb || 1,553,808 BITS = 1.6 Mb
                    // [4] 408,288 BITS = 408 Kb || 1,553,808 BITS = 1554 Kb
                    RowLayout {
                        id: roundedNumberRow
                        height: infoButton20.height
                        function enableState() {
                            if (cfg_decimalFilter0 && cfg_decimalFilter1 && cfg_decimalFilter2 && cfg_decimalFilter3) {
                                if (rb_roundedNumber1.checked === true) {
                                    rb_roundedNumber0.checked = true
                                }
                                return false;           // DISABLE 
                            } else {
                                return true;            // ENABLE
                            }
                        }
                        RadioButton {
                            Layout.rightMargin:     20          // PADDING RIGHT
                            id:                     rb_roundedNumber0
                            checked:                true
                            text:                   i18n("3")
                            onReleased:             cfg_roundedNumber = 3
                            enabled:                roundedNumberRow.enableState()
                        }
                        RadioButton {
                            //checked:                plasmoid.configuration.binaryDecimal === 'decimal'
                            id:                     rb_roundedNumber1        
                            text:                   i18n("4")
                            onReleased:             cfg_roundedNumber = 4
                            enabled:                roundedNumberRow.enableState()
                        }
                    }
                    // ################################################################                              
                }
            }
        }
        Grid {
            // NEW TOOLTIP INFORMATION
            anchors.top: gA20.bottom
            Text {
                id: infoText20
                opacity: 0
                padding: 10 
                width: rootRec20.width
                color: myPalette.windowText
                textFormat: Text.RichText
                wrapMode: Text.Wrap               
                text: "<div>" + i18n("This option becomes active when 'Decimal place filter' checkbox(es) are disabled.") + "</div><br>"
                    + "<table>"
                    + "<tr><td>" + i18n("Provides finer control over how the bit / Byte data is displayed and rounded.") + "</td></tr>"
                    + "<tr><td>" + i18n("By default (3), the logic will round a 4-digit bit figure to a Kilobit / Kilobyte figure. For example, 3456 bits becomes 3.38 Kb.") + "</td></tr>"
                    + "<tr><td>" + i18n("Selecting 4 will only round up if the digit count exceeds 4 digits. For example, 1234567 bits will become 1206 Kb (not 1.2 Mb).") + "</td></tr>"
                    + "</table>"
            }
        } 
    }  
 //####################################################################################################### 
    MenuSeparator {
        id: separator10
        padding: 0
        topPadding: 20
        bottomPadding: 20
        contentItem: Rectangle {
            implicitWidth: parent.parent.width
            implicitHeight: 1
            color: myPalette.light //"light grey"
        }
        anchors.top: rootRec20.bottom
    }
 //#######################################################################################################          
    Rectangle {
        id: rootRec22
        width: parent.width
        height: infoButton22.height
        //anchors.top: rootRec8.bottom
        anchors.top: separator10.bottom
        //anchors.topMargin: spacerA
        color: "transparent" //"red"
        border.color: "dark grey"
        border.width: 0
        radius: 4

        ToolButton {
            id: infoButton22
            icon.name: 'kt-info-widget'
            implicitWidth: infoButton22.height
            anchors.right: parent.right
            opacity: 0.5
            MouseArea {
                property bool state:    false
                anchors.fill:           parent
                hoverEnabled:           true
                onEntered:              infoButton22.opacity = 1
                onExited:               state ? infoButton22.opacity = 1 : infoButton22.opacity = 0.5
                onClicked: {
                    state = !state
                    main.toggleTooltip(rootRec22)
                }
            }
        }
        Grid {
            // TITLE | CHOICE BUTTONS GO HERE
            id: gA22
            Row {
                //spacing: 10        
                Column {
                    Rectangle {
                        height: 10
                        width: spacerA
                        color: "transparent" //"red"
                    } 
                }
                Column {
                    //________ LAYOUT ________ 
                    Label {
                        width: titleTextMetrics.width
                        text:  i18n("Default theme colours:")
                        height: infoButton22.height
                    }
                }
                Column {
                    //####################################################
                    CheckBox {
                        id: colorDefault
                        height: infoButton22.height
                    }  
                    // ################################################################    
                }
            }
        }
        Grid {
            // NEW TOOLTIP INFORMATION
            anchors.top: gA22.bottom
            Text {
                id: infoText22
                opacity: 0
                padding: 10 
                width: rootRec22.width
                color: myPalette.windowText
                textFormat: Text.RichText
                wrapMode: Text.Wrap
                
                text: "<table>"
                        + "<tr><td><b>" + i18n("Checked") + "</b>: </td> <td style='padding-bottom:6px'>" + i18n("UI text color will respect the current default theme.") + "</td></tr>"
                        + "<tr><td><b>" + i18n("Unchecked") + "</b>: </td> <td style='padding-bottom:6px'>" + i18n("Enables manual color assignments. ") + "</td></tr>"
                    + "</table>"
            }
        } 
    }
 //#######################################################################################################
   Rectangle {
        id: rootRec21
        width: parent.width
        height: infoButton22.height
        anchors.top: rootRec22.bottom
        //anchors.top: separator10.bottom
        anchors.topMargin: spacerA
        color: "transparent" //myPalette.dark
        border.color: "dark grey"
        border.width: 0
        radius: 4

        ToolButton {
            id: infoButton21
            icon.name: 'kt-info-widget'
            implicitWidth: infoButton21.height
            anchors.right: parent.right
            opacity: 0.5
            MouseArea {
                property bool state:    false
                anchors.fill:           parent
                hoverEnabled:           true
                onEntered:              infoButton21.opacity = 1
                onExited:               state ? infoButton21.opacity = 1 : infoButton21.opacity = 0.5
                onClicked: {
                    state = !state
                    main.toggleTooltip(rootRec21)
                }
            }
        }
        Grid {
            // TITLE | CHOICE BUTTONS GO HERE
            id: gA21

            property var selectedButton: "" 
            property var label_padding: 4
            property var popularColors: ["#f9ebea","#fdedec","#f5eef8","#f4ecf7","#eaf2f8","#ebf5fb","#e8f8f5","#e8f6f3","#e9f7ef","#eafaf1","#fef9e7","#fef5e7","#fdf2e9","#fbeee6","#fdfefe","#f8f9f9","#f4f6f6","#f2f4f4","#ebedef","#eaecee",
                            "#f2d7d5","#fadbd8","#ebdef0","#e8daef","#d4e6f1","#d6eaf8","#d1f2eb","#d0ece7","#d4efdf","#d5f5e3","#fcf3cf","#fdebd0","#fae5d3","#f6ddcc","#fbfcfc","#f2f3f4","#eaeded","#e5e8e8","#d6dbdf","#d5d8dc",
                            "#e6b0aa","#f5b7b1","#d7bde2","#d2b4de","#a9cce3","#aed6f1","#a3e4d7","#a2d9ce","#a9dfbf","#abebc6","#f9e79f","#fad7a0","#f5cba7","#edbb99","#f7f9f9","#e5e7e9","#d5dbdb","#ccd1d1","#aeb6bf","#abb2b9",
                            "#d98880","#f1948a","#c39bd3","#bb8fce","#7fb3d5","#85c1e9","#76d7c4","#73c6b6","#7dcea0","#82e0aa","#f7dc6f","#f8c471","#f0b27a","#e59866","#f4f6f7","#d7dbdd","#bfc9ca","#b2babb","#85929e","#808b96",
                            "#cd6155","#ec7063","#af7ac5","#a569bd","#5499c7","#5dade2","#48c9b0","#45b39d","#52be80","#58d68d","#f4d03f","#f5b041","#eb984e","#dc7633","#f0f3f4","#cacfd2","#aab7b8","#99a3a4","#5d6d7e","#566573",
                            "#c0392b","#e74c3c","#9b59b6","#8e44ad","#2980b9","#3498db","#1abc9c","#16a085","#27ae60","#2ecc71","#f1c40f","#f39c12","#e67e22","#d35400","#ecf0f1","#bdc3c7","#95a5a6","#7f8c8d","#34495e","#2c3e50",
                            "#a93226","#cb4335","#884ea0","#7d3c98","#2471a3","#2e86c1","#17a589","#138d75","#229954","#28b463","#d4ac0d","#d68910","#ca6f1e","#ba4a00","#d0d3d4","#a6acaf","#839192","#707b7c","#2e4053","#273746",
                            "#922b21","#b03a2e","#76448a","#6c3483","#1f618d","#2874a6","#148f77","#117a65","#1e8449","#239b56","#b7950b","#b9770e","#af601a","#a04000","#b3b6b7","#909497","#717d7e","#616a6b","#283747","#212f3d",
                            "#7b241c","#943126","#633974","#5b2c6f","#1a5276","#21618c","#117864","#0e6655","#196f3d","#1d8348","#9a7d0a","#9c640c","#935116","#873600","#979a9a","#797d7f","#5f6a6a","#515a5a","#212f3c","#1c2833",
                            "#641e16","#78281f","#512e5f","#4a235a","#154360","#1b4f72","#0e6251","#0b5345","#145a32","#186a3b","#7d6608","#7e5109","#784212","#6e2c00","#7b7d7d","#626567","#4d5656","#424949","#1b2631","#17202a"]
            function set_color() {
                if (selectedButton == colour_t1) {
                    cfg_colorDownIcon = colorChoiceBG1.color
                } else if (selectedButton === colour_t2) {
                    cfg_colorDownDigits = colorChoiceBG1.color
                } else if (selectedButton === colour_t3) {
                    cfg_colorDownSuffix = colorChoiceBG1.color
                } else if (selectedButton === colour_b1) {
                    cfg_colorUpIcon = colorChoiceBG1.color
                } else if (selectedButton === colour_b2) {
                    cfg_colorUpDigits = colorChoiceBG1.color
                } else if (selectedButton === colour_b3) {
                    cfg_colorUpSuffix = colorChoiceBG1.color
                }
            }
            function buttonLogic(trigger, button) {
                if (trigger === "entered"){
                    button.font.underline = true

                } else if (trigger === "exited"){
                    button.font.underline = false

                } else if (trigger === "clicked"){
                    gA21.selectedButton = button

                    colorPickerPopup1.open()
                }
            }            
            ColorDialog {
                id: colorDialog

                title: "Choose a color for " + gA21.selectedButton.text
                onAccepted: {
                    // DISPLAY SELECTED COLOUR IN CUSTOM COLOR PICKER
                    colorTextField1.text = colorDialog.color // Set the hex value in the text field
                    colorChoiceBG1.color = colorDialog.color     
                }
            }
            Popup {
                id: colorPickerPopup1
                width: 400 + 8
                height: 250
                //modal: true
                padding: 4
                parent: Overlay.overlay
                x: Math.round((parent.width - width) / 2)       // center color popup on x axis
                y: Math.round((parent.height - height) / 2)     // center color popup on y axis

                Rectangle {
                    anchors.fill: parent
                    color: myPalette.window

                    Grid {
                        id: colorGrid1
                        anchors.fill: parent
                        rows: 10
                        columns: 20
                        anchors.centerIn: parent // Center the popup horizontally and vertically within the window

                        Repeater {
                            model: gA21.popularColors.length

                            Rectangle {
                                id: colorRect
                                width: 20 //colorGrid.width / colorGrid.columns
                                height: 20 //colorGrid.height / colorGrid.rows
                                x: (colorGrid1.cellWidth - width) / 2 // Center horizontally within the cell
                                y: (colorGrid1.cellHeight - height) / 2 // Center vertically within the cell
                                color: gA21.popularColors[modelData]
                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onEntered: {
                                        colorRect.z = 1
                                        colorRect.radius = 2
                                        colorRect.border.width = 1
                                        colorRect.border.color = "black"
                                        colorRect.scale = 1.5
                                    }
                                    onExited: {
                                        colorRect.z = 0
                                        colorRect.scale = 1
                                        colorRect.radius = 0
                                        colorRect.border.width = 0                                       
                                    }                                        
                                    onClicked: {
                                        colorTextField1.text = gA21.popularColors[modelData] // Set the hex value in the text field
                                        colorChoiceBG1.color = gA21.popularColors[modelData]
                                    }
                                }
                            }
                        }
                    }

                    RowLayout {
                        anchors.bottom: parent.bottom

                        Rectangle {
                            id: colorChoiceBG1
                                    // window width - 3 buttons
                            width: colorPickerPopup1.width - okButton1.width - colorDialogButton1.width - colorChoiceDefault1.width - 22//colorChoiceField.width
                            height: colorDialogButton1.height
                            radius: 3
                            color: myPalette.button
                            border.color: myPalette.light
                            border.width: 1                           
                            Label {
                                id: colorTextField1
                                text: "Selected Color"
                                height: colorChoiceBG1.height
                                anchors.centerIn: parent
                            }                            
                        }
                        Button {
                            id: colorChoiceDefault1
                            text: "Default"
                            onClicked: {
                                colorTextField1.text = myPalette.windowText // Set the hex value in the text field
                                colorChoiceBG1.color = myPalette.windowText                                
                            }
                        }
                        Button {
                            id: colorDialogButton1
                            text: "More colours"
                            onClicked: colorDialog.open()
                        }
                        Button {
                            id: okButton1
                            text: "OK"
                            onClicked: {
                                if (gA21.selectedButton) {
                                    gA21.set_color()//gA21.selectedButton)
                                }
                                colorPickerPopup1.close()
                            }
                        }
                    }
                }
            }    
            Row {        
                Column {
                    Rectangle {
                        height: 10
                        width: spacerA
                        color: "transparent"
                    } 
                }
                Column {
                    //________ LAYOUT ________ 
                    Label {
                        width: titleTextMetrics.width
                        text:  i18n("Manual colours:")
                        height: infoButton21.height
                    }
                }
                Column {
                    //####################################################
                    id: col1

                    RowLayout {
                        Column {    // ICONS OR DIGITS
                            id: color_col1
                            function iconStyle(b) {

                                var iconArray = []

                                iconArray = cfg_iconType.replace(' ', ',').split(",")

                                switch(b) {
                                    case 't1': return cfg_swapDownUp ? iconArray[1] : iconArray[0]
                                    case 'b1': return cfg_swapDownUp ? iconArray[0] : iconArray[1]
                                }
                            }
                            // t1
                            Rectangle {
                                color: "transparent"
                                width: colour_t1.implicitWidth + gA21.label_padding
                                height: colour_t1.contentHeight//colour_t1.implicitHeight + gA21.label_padding
                                Label {
                                    id: colour_t1
                                    text: color_col1.iconStyle('t1')
                                    color: cfg_colorDownIcon || myPalette.windowText
                                    anchors.centerIn: parent
                                }  
                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    enabled: !colorDefault.checked
                                    onEntered: {
                                        gA21.buttonLogic("entered", colour_t1)
                                    }
                                    onExited: {
                                        gA21.buttonLogic("exited", colour_t1)                                     
                                    }
                                    onClicked: {
                                        gA21.buttonLogic("clicked", colour_t1)
                                    }
                                }  
                            }
                            // b1
                            Rectangle {
                                color: "transparent"
                                width: colour_b1.implicitWidth + gA21.label_padding
                                height: colour_b1.contentHeight //implicitHeight + gA21.label_padding
                                Label {
                                    id: colour_b1
                                    text: color_col1.iconStyle('b1')
                                    color: cfg_colorUpIcon || myPalette.windowText
                                    anchors.centerIn: parent
                                }  
                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    enabled: !colorDefault.checked
                                    onEntered: {
                                        gA21.buttonLogic("entered", colour_b1)
                                    }
                                    onExited: {
                                        gA21.buttonLogic("exited", colour_b1)                                     
                                    }
                                    onClicked: {
                                        gA21.buttonLogic("clicked", colour_b1)
                                    }
                                }  
                            }
                        }
                       Column { // DIGITS OR SUFFIX
                            // t2
                            Rectangle {
                                color: "transparent"
                                width: colour_t2.implicitWidth + gA21.label_padding
                                height: colour_t2.contentHeight //implicitHeight + gA21.label_padding
                                Label {
                                    id: colour_t2
                                    text: decimalPlaceRow.decimalPlaceText()
                                    color: cfg_colorDownDigits || myPalette.windowText
                                    anchors.centerIn: parent
                                }  
                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    enabled: !colorDefault.checked
                                    onEntered: {
                                        gA21.buttonLogic("entered", colour_t2)
                                    }
                                    onExited: {
                                        gA21.buttonLogic("exited", colour_t2)                                     
                                    }
                                    onClicked: {
                                        gA21.buttonLogic("clicked", colour_t2)
                                    }
                                }  
                            }
                            // b2
                            Rectangle {
                                color: "transparent"
                                width: colour_b2.implicitWidth + gA21.label_padding
                                height: colour_b2.contentHeight //implicitHeight + gA21.label_padding
                                Label {
                                    id: colour_b2
                                    text: decimalPlaceRow.decimalPlaceText()
                                    color: cfg_colorUpDigits || myPalette.windowText
                                    anchors.centerIn: parent
                                }  
                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    enabled: !colorDefault.checked
                                    onEntered: {
                                        //parent.color = "transparent"
                                        gA21.buttonLogic("entered", colour_b2)
                                    }
                                    onExited: {
                                        //parent.color = "transparent"
                                        gA21.buttonLogic("exited", colour_b2)                                     
                                    }
                                    onClicked: {
                                        gA21.buttonLogic("clicked", colour_b2)
                                    }
                                }  
                            }
                        }  
                       Column { // SUFFIX OR ICONS
                            // t3
                            id: color_col3
                            function colorPrefix(){
                                if (cfg_speedUnits === 'bits'){
                                    return 'Mb' + cfg_secondsPrefix
                                } else {
                                    return 'MB' + cfg_secondsPrefix
                                }
                            }
                            Rectangle {
                                color: "transparent"
                                width: colour_t3.implicitWidth + gA21.label_padding
                                height: colour_t3.contentHeight //implicitHeight + gA21.label_padding
                                Label {
                                    id: colour_t3
                                    text: color_col3.colorPrefix()
                                    color: cfg_colorDownSuffix || myPalette.windowText
                                    anchors.centerIn: parent
                                }  
                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    enabled: !colorDefault.checked
                                    onEntered: {
                                        gA21.buttonLogic("entered", colour_t3)
                                    }
                                    onExited: {
                                        gA21.buttonLogic("exited", colour_t3)                                     
                                    }
                                    onClicked: {
                                        gA21.buttonLogic("clicked", colour_t3)
                                    }
                                }  
                            }
                            // b3
                            Rectangle {
                                color: "transparent"
                                width: colour_b3.implicitWidth + gA21.label_padding
                                height: colour_b3.contentHeight //implicitHeight + gA21.label_padding
                                Label {
                                    id: colour_b3
                                    text: color_col3.colorPrefix()
                                    color: cfg_colorUpSuffix || myPalette.windowText
                                    anchors.centerIn: parent
                                }  
                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    enabled: !colorDefault.checked
                                    onEntered: {
                                        //parent.color = "transparent"
                                        gA21.buttonLogic("entered", colour_b3)
                                    }
                                    onExited: {
                                        //parent.color = "transparent"
                                        gA21.buttonLogic("exited", colour_b3)                                     
                                    }
                                    onClicked: {
                                        gA21.buttonLogic("clicked", colour_b3)
                                    }
                                }  
                            }
                        }                                                
                    }

                    // ################################################################    
                }
            }
        }
        Grid {
            // NEW TOOLTIP INFORMATION
            anchors.top: gA21.bottom
            Text {
                id: infoText21
                opacity: 0
                padding: 10 
                width: rootRec21.width
                color: myPalette.windowText
                textFormat: Text.RichText
                wrapMode: Text.Wrap
                text: "<table>"
                    + "<tr><td>" + i18n("Clicking on each of the UI elements will allow manual colour selection.") + "</td></tr>"
                    + "<tr><td>" + i18n("This will overide the default theme colour.") + "</td></tr>"
                    + "</table>"
            }
        } 
    }


 //#######################################################################################################
    Rectangle {
        id: rootRec23
        width: parent.width
        height: infoButton23.height
        anchors.top: rootRec21.bottom
        anchors.topMargin: spacerA
        color: "transparent" //"red"
        border.color: "dark grey"
        border.width: 0
        radius: 4

        ToolButton {
            id: infoButton23
            icon.name: 'kt-info-widget'
            implicitWidth: infoButton23.height
            anchors.right: parent.right
            opacity: 0.5
            MouseArea {
                property bool state:    false
                anchors.fill:           parent
                hoverEnabled:           true
                onEntered:              infoButton23.opacity = 1
                onExited:               state ? infoButton23.opacity = 1 : infoButton23.opacity = 0.5
                onClicked: {
                    state = !state
                    main.toggleTooltip(rootRec23)
                }
            }
        }
        Grid {
            // TITLE | CHOICE BUTTONS GO HERE
            id: gA23
            //anchors.verticalCenter: infoButton19.verticalCenter

            property var selectedSpeedColorButton: "" 
            property var labelSpeedColorPadding: 4
            // Hard-coded popular colors
            property var popularColors: ["#f9ebea","#fdedec","#f5eef8","#f4ecf7","#eaf2f8","#ebf5fb","#e8f8f5","#e8f6f3","#e9f7ef","#eafaf1","#fef9e7","#fef5e7","#fdf2e9","#fbeee6","#fdfefe","#f8f9f9","#f4f6f6","#f2f4f4","#ebedef","#eaecee",
                                      "#f2d7d5","#fadbd8","#ebdef0","#e8daef","#d4e6f1","#d6eaf8","#d1f2eb","#d0ece7","#d4efdf","#d5f5e3","#fcf3cf","#fdebd0","#fae5d3","#f6ddcc","#fbfcfc","#f2f3f4","#eaeded","#e5e8e8","#d6dbdf","#d5d8dc",
                                      "#e6b0aa","#f5b7b1","#d7bde2","#d2b4de","#a9cce3","#aed6f1","#a3e4d7","#a2d9ce","#a9dfbf","#abebc6","#f9e79f","#fad7a0","#f5cba7","#edbb99","#f7f9f9","#e5e7e9","#d5dbdb","#ccd1d1","#aeb6bf","#abb2b9",
                                      "#d98880","#f1948a","#c39bd3","#bb8fce","#7fb3d5","#85c1e9","#76d7c4","#73c6b6","#7dcea0","#82e0aa","#f7dc6f","#f8c471","#f0b27a","#e59866","#f4f6f7","#d7dbdd","#bfc9ca","#b2babb","#85929e","#808b96",
                                      "#cd6155","#ec7063","#af7ac5","#a569bd","#5499c7","#5dade2","#48c9b0","#45b39d","#52be80","#58d68d","#f4d03f","#f5b041","#eb984e","#dc7633","#f0f3f4","#cacfd2","#aab7b8","#99a3a4","#5d6d7e","#566573",
                                      "#c0392b","#e74c3c","#9b59b6","#8e44ad","#2980b9","#3498db","#1abc9c","#16a085","#27ae60","#2ecc71","#f1c40f","#f39c12","#e67e22","#d35400","#ecf0f1","#bdc3c7","#95a5a6","#7f8c8d","#34495e","#2c3e50",
                                      "#a93226","#cb4335","#884ea0","#7d3c98","#2471a3","#2e86c1","#17a589","#138d75","#229954","#28b463","#d4ac0d","#d68910","#ca6f1e","#ba4a00","#d0d3d4","#a6acaf","#839192","#707b7c","#2e4053","#273746",
                                      "#922b21","#b03a2e","#76448a","#6c3483","#1f618d","#2874a6","#148f77","#117a65","#1e8449","#239b56","#b7950b","#b9770e","#af601a","#a04000","#b3b6b7","#909497","#717d7e","#616a6b","#283747","#212f3d",
                                      "#7b241c","#943126","#633974","#5b2c6f","#1a5276","#21618c","#117864","#0e6655","#196f3d","#1d8348","#9a7d0a","#9c640c","#935116","#873600","#979a9a","#797d7f","#5f6a6a","#515a5a","#212f3c","#1c2833",
                                      "#641e16","#78281f","#512e5f","#4a235a","#154360","#1b4f72","#0e6251","#0b5345","#145a32","#186a3b","#7d6608","#7e5109","#784212","#6e2c00","#7b7d7d","#626567","#4d5656","#424949","#1b2631","#17202a"]
           

            function colorSquareLogic(trigger, square) {
                if (trigger === "entered"){
                    square.border.color = myPalette.light //windowText
                    square.border.width = 2
                } else if (trigger === "exited"){
                    square.border.width = 0
                } else if (trigger === "clicked"){
                    square.border.color = myPalette.windowText
                    square.border.width = 4
                    gA23.selectedSpeedColorButton = square
                    // CUSTOM COLOR PICKER
                    colorPickerPopup.open()
                    //speedColorDialog.open()
                }
            }   
            function set_color(selectedSpeedColorButton) {

                // if (selectedColor === myPalette.windowText) {
                //     // reset variable
                // }

                if (selectedSpeedColorButton == color_b_square) {
                    cfg_color_b_square = colorChoiceBG.color // speedColorDialog.color

                } else if (selectedSpeedColorButton === color_k_square) {
                    cfg_color_k_square = colorChoiceBG.color //speedColorDialog.color

                } else if (selectedSpeedColorButton === color_m_square) {
                    cfg_color_m_square = colorChoiceBG.color //speedColorDialog.color

                } else if (selectedSpeedColorButton === color_g_square) {
                    cfg_color_g_square = colorChoiceBG.color //speedColorDialog.color

                }
            }
            ColorDialog {
                id: speedColorDialog
                title: "Choose a color for " + gA23.selectedSpeedColorButton.text
                onAccepted: {
                    // DISPLAY SELECTED COLOUR IN CUSTOM COLOR PICKER
                    colorTextField.text = speedColorDialog.color // Set the hex value in the text field
                    colorChoiceBG.color = speedColorDialog.color                    
                }
            }  
            // CUSTOM COLOR PICKER
            Popup {
                id: colorPickerPopup
                width: 400 + 8
                height: 250
                //modal: true
                padding: 4
                parent: Overlay.overlay
                x: Math.round((parent.width - width) / 2)       // center color popup on x axis
                y: Math.round((parent.height - height) / 2)     // center color popup on y axis

                Rectangle {
                    anchors.fill: parent
                    color: myPalette.window

                    Grid {
                        id: colorGrid
                        anchors.fill: parent
                        rows: 10
                        columns: 20
                        anchors.centerIn: parent // Center the popup horizontally and vertically within the window

                        Repeater {
                            model: gA23.popularColors.length

                            Rectangle {
                                id: colorRect
                                width: 20 //colorGrid.width / colorGrid.columns
                                height: 20 //colorGrid.height / colorGrid.rows
                                x: (colorGrid.cellWidth - width) / 2 // Center horizontally within the cell
                                y: (colorGrid.cellHeight - height) / 2 // Center vertically within the cell
                                color: gA23.popularColors[modelData]
                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onEntered: {
                                        colorRect.z = 1
                                        colorRect.radius = 2
                                        colorRect.border.width = 1
                                        colorRect.border.color = "black"
                                        colorRect.scale = 1.5
                                    }
                                    onExited: {
                                        colorRect.z = 0
                                        colorRect.scale = 1
                                        colorRect.radius = 0
                                        colorRect.border.width = 0                                       
                                    }                                        
                                    onClicked: {
                                        colorTextField.text = gA23.popularColors[modelData] // Set the hex value in the text field
                                        colorChoiceBG.color = gA23.popularColors[modelData]
                                    }
                                }
                            }
                        }
                    }

                    RowLayout {
                        anchors.bottom: parent.bottom

                        Rectangle {
                            id: colorChoiceBG
                                    // window width - 3 buttons
                            width: colorPickerPopup.width - okButton.width - colorDialogButton.width - colorChoiceDefault.width - 22//colorChoiceField.width
                            height: colorDialogButton.height
                            radius: 3
                            color: myPalette.button
                            border.color: myPalette.light
                            border.width: 1                           
                            Label {
                                id: colorTextField
                                text: "Selected Color"
                                height: colorChoiceBG.height
                                anchors.centerIn: parent
                            }                            
                        }
                        Button {
                            id: colorChoiceDefault
                            text: "Default"
                            onClicked: {
                                colorTextField.text = myPalette.windowText // Set the hex value in the text field
                                colorChoiceBG.color = myPalette.windowText                                
                            }
                        }
                        Button {
                            id: colorDialogButton
                            text: "More colours"
                            onClicked: speedColorDialog.open()
                        }
                        Button {
                            id: okButton
                            text: "OK"
                            onClicked: {
                                if (gA23.selectedSpeedColorButton) {
                                    gA23.set_color(gA23.selectedSpeedColorButton)
                                }
                                colorPickerPopup.close()
                            }
                        }
                    }
                }

            }    

            Row {
                //spacing: 10        
                Column {
                    Rectangle {
                        height: 10
                        width: spacerA
                        color: "transparent" //"red"
                    } 
                }
                Column {
                    //________ LAYOUT ________ 
                    Label {
                        width: titleTextMetrics.width
                        text:  i18n("Speed based colour:")
                        height: infoButton23.height
                    }
                }
                Column {
                    id: colorSpeedCol

                    Row {
                        id: colorSpeedRow
                        //________ CHECKBOX WIDTH ________ 
                        TextMetrics {
                            id: colorCheckBoxMetrics
                            text: "Bytes        "
                        }
                        // ##################################################################
                    
                        Rectangle {
                            id: color_b_square
                            color: cfg_color_b_square || myPalette.windowText
                            width: infoButton23.height / 2
                            height: infoButton23.height / 2
                            radius: 4
                            anchors.verticalCenter: colorSpeedRow.verticalCenter

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                enabled: !colorDefault.checked
                                onEntered: {
                                    gA23.colorSquareLogic("entered", color_b_square)
                                }
                                onExited: {
                                    gA23.colorSquareLogic("exited", color_b_square)                                     
                                }
                                onClicked: {
                                    gA23.colorSquareLogic("clicked", color_b_square)
                                }
                            }  
                        }
                        Label {
                            id: color_b_Label
                            text: cfg_speedUnits === 'bits' ? "bits" : "Bytes"
                            width: colorCheckBoxMetrics.width
                            height: infoButton23.height
                            leftPadding: 8
                        } 
                        // ##################################################################
                        Rectangle {
                            id: color_k_square
                            color: cfg_color_k_square || myPalette.windowText
                            width: infoButton23.height / 2
                            height: infoButton23.height / 2
                            radius: 4
                            anchors.verticalCenter: colorSpeedRow.verticalCenter
                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                enabled: !colorDefault.checked
                                onEntered: {
                                    gA23.colorSquareLogic("entered", color_k_square)
                                }
                                onExited: {
                                    gA23.colorSquareLogic("exited", color_k_square)                                     
                                }
                                onClicked: {
                                    gA23.colorSquareLogic("clicked", color_k_square)
                                }
                            }  
                        }
                        Label {
                            id: color_k_Label
                            text: cfg_binaryDecimal === 'binary' ? "Kibi" : "Kilo"
                            width: colorCheckBoxMetrics.width
                            height: infoButton23.height
                            leftPadding: 8
                        } 
                        // ##################################################################
                        Rectangle {
                            id: color_m_square
                            color: cfg_color_m_square || myPalette.windowText
                            width: infoButton23.height / 2
                            height: infoButton23.height / 2
                            radius: 4
                            anchors.verticalCenter: colorSpeedRow.verticalCenter
                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                enabled: !colorDefault.checked
                                onEntered: {
                                    gA23.colorSquareLogic("entered", color_m_square)
                                }
                                onExited: {
                                    gA23.colorSquareLogic("exited", color_m_square)                                     
                                }
                                onClicked: {
                                    gA23.colorSquareLogic("clicked", color_m_square)
                                }
                            }  
                        }
                        Label {
                            id: color_m_Label
                            text: cfg_binaryDecimal === 'binary' ? "Mebi" : "Mega"
                            width: colorCheckBoxMetrics.width
                            height: infoButton23.height
                            leftPadding: 8
                        } 
                        // ##################################################################
                        Rectangle {
                            id: color_g_square
                            color: cfg_color_g_square || myPalette.windowText
                            width: infoButton23.height / 2
                            height: infoButton23.height / 2
                            radius: 4
                            anchors.verticalCenter: colorSpeedRow.verticalCenter
                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                enabled: !colorDefault.checked
                                onEntered: {
                                    gA23.colorSquareLogic("entered", color_g_square)
                                }
                                onExited: {
                                    gA23.colorSquareLogic("exited", color_g_square)                                     
                                }
                                onClicked: {
                                    gA23.colorSquareLogic("clicked", color_g_square)
                                }
                            }  
                        }
                        Label {
                            id: color_g_Label
                            text: cfg_binaryDecimal === 'binary' ? "Gibi" : "Giga"
                            width: colorCheckBoxMetrics.width
                            //color: cfg_color_k_Label || myPalette.windowText
                            //anchors.centerIn: parent
                            height: infoButton23.height
                            leftPadding: 8
                        } 
                        // ################################################################                         
                    }
                }
            }
        }
        Grid {
            // NEW TOOLTIP INFORMATION
            anchors.top: gA23.bottom
            Text {
                id: infoText23
                opacity: 0
                padding: 10 
                width: rootRec23.width
                color: myPalette.windowText
                textFormat: Text.RichText
                wrapMode: Text.Wrap  
                text: "<table>"
                    + "<tr><td>" + i18n("Click on each square to select a colour that will be assigned to the UI elements based on the network speed calculation.") + "</td></tr>"
                    + "<tr><td>" + i18n("Used in conjunction with 'Speed colours active on' setting below.") + "</td></tr>"
                    + "<tr><td>" + i18n("This will override both the default theme colour and the base manual colour selection.") + "</td></tr>"
                    + "</table>"
            }
        }  
        
    }     
 //####################################################################################################### 
    Rectangle {
        id: rootRec24
        width: parent.width
        height: infoButton24.height
        anchors.top: rootRec23.bottom
        anchors.topMargin: spacerA
        color: "transparent" //"red"
        border.color: "dark grey"
        border.width: 0
        radius: 4

        ToolButton {
            id: infoButton24
            icon.name: 'kt-info-widget'
            implicitWidth: infoButton24.height
            anchors.right: parent.right
            opacity: 0.5
            MouseArea {
                property bool state:    false
                anchors.fill:           parent
                hoverEnabled:           true
                onEntered:              infoButton24.opacity = 1
                onExited:               state ? infoButton24.opacity = 1 : infoButton24.opacity = 0.5
                onClicked: {
                    state = !state
                    main.toggleTooltip(rootRec24)
                }
            }
        }
        Grid {
            // TITLE | CHOICE BUTTONS GO HERE
            id: gA24
            //anchors.verticalCenter: infoButton19.verticalCenter

            Row {
                //spacing: 10        
                Column {
                    Rectangle {
                        height: 10
                        width: spacerA
                        color: "transparent" //"red"
                    } 
                }
                Column {
                    //________ LAYOUT ________ 
                    Label {
                        width: titleTextMetrics.width
                        text:  i18n("Speed colours active on:")
                        height: infoButton24.height
                    }
                }
                Column {
                    Row {
                        //________ CHECKBOX WIDTH ________ 
                        TextMetrics {
                            id: speedActiveMetrics
                            text: "Bytes    "
                        }
                        CheckBox {
                            id:     speedColorActive1
                            height: infoButton24.height
                            enabled: !colorDefault.checked
                        } 
                        Label {
                            text: "Icons"
                            width: speedActiveMetrics.width
                            height: infoButton24.height
                        }
                        CheckBox {
                            id:     speedColorActive2
                            height: infoButton24.height
                            enabled: !colorDefault.checked
                        } 
                        Label {
                            text: "Digits"
                            width: speedActiveMetrics.width
                            height: infoButton24.height
                        }
                        CheckBox {
                            id:     speedColorActive3
                            height: infoButton24.height
                            enabled: !colorDefault.checked
                        } 
                        Label {
                            text: "Suffix"
                            width: speedActiveMetrics.width
                            height: infoButton24.height
                        }
                        // ################################################################                         
                    }
                }
            }
        }
        Grid {
            // NEW TOOLTIP INFORMATION
            anchors.top: gA24.bottom
            Text {
                id: infoText24
                opacity: 0
                padding: 10 
                width: rootRec24.width
                color: myPalette.windowText
                textFormat: Text.RichText
                wrapMode: Text.Wrap  
                text: "<table>"
                        + "<tr><td>" + i18n("Select one of the 3 options to enable speed colour assignment selected in the setting above 'Speed based colour' on the widget UI.") + "</td></tr>"
                    + "</table>"
                    + "<table>"
                        + "<tr><td><b>" + i18n("'Icons'")  + "</b>: </td> <td style='padding-bottom:6px'>" + i18n("colour will be assigned to either of the speed icons when the network speed reaches either of the 4 states.") + "</td></tr>"
                        + "<tr><td><b>" + i18n("'Digits'") + "</b>: </td> <td style='padding-bottom:6px'>" + i18n("colour will be assigned to either of the speed digits when the network speed reaches either of the 4 states.") + "</td></tr>"
                        + "<tr><td><b>" + i18n("'Suffix'") + "</b>: </td> <td style='padding-bottom:6px'>" + i18n("colour will be assigned to either of the speed suffix when the network speed reaches either of the 4 states.") + "</td></tr>"
                    + "</table>"

                // text: "<table>"
                //         + "<tr><td><b>" + i18n("Checked")   + "</b>: </td> <td style='padding-bottom:6px'>" + i18n("UI text color will respect the current default theme.") + "</td></tr>"
                //         + "<tr><td><b>" + i18n("Unchecked") + "</b>: </td> <td style='padding-bottom:6px'>" + i18n("Enables manual color assignments. ") + "</td></tr>"
                //     + "</table>"
            }
        }  
        
    }     
 //#######################################################################################################
    MenuSeparator {
        id: separator12
        padding: 0
        topPadding: 20
        bottomPadding: 20
        contentItem: Rectangle {
            implicitWidth: Math.max(200, parent.parent.width)
            implicitHeight: 1
            color: myPalette.light //"light grey"
        }
        anchors.top: rootRec24.bottom
    }
 //#######################################################################################################         

}
