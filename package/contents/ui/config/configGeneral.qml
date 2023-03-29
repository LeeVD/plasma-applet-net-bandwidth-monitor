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
    property int    cfg_accumulator:    accumulator
    property alias  cfg_hideInactive:   hideInactive.checked
    property bool   cfg_hideZone:       hideZone
    property alias  cfg_showSeconds:    showSeconds.checked
    property string cfg_secondsPrefix:  '/s'

    property int spacerA: 8
    property int spacerB: 30

    //________ COLUMN WIDTH ________ 
    TextMetrics {
        id: titleTextMetrics
        text: " Show Speeds separately: "
        //font.pixelSize: 64
    }
    //________ COLUMN WIDTH ________ 
    TextMetrics {
        id: labelTextMetrics
        text: " 10 pixel closer  "
        //font.pixelSize: 64
    }

    Rectangle {

        id: rootRec
        width: parent.width
        height: infoButton.height
        color: "transparent" //"red"
        border.color: "dark grey"
        border.width: 0
        radius: 4

        NumberAnimation {
            id: heightAnimation
            target: rootRec
            property: "height"
            duration: 100
            onStopped: {   
                if (infoButton.state === true) {
                     anim.to = 1;  anim.start()                 
                }
            }
        }
        Button {
            property bool state: false

            id: infoButton
            implicitWidth: infoButton.height
            text: i18n("i")
            anchors.right: parent.right 
            onClicked: {
                if (state === false) {  // OPEN NEW TOOLTIP
                    state = true
                    heightAnimation.to = infoButton.height + infoText.contentHeight + (infoText.padding * 2) 
                    heightAnimation.start()
                    opacity = 1.0
                    rootRec.border.width = 0.5
                } else {                // CLOSE NEW TOOLTIP
                    state = false
                    anim.to = 0;  anim.start();
                    opacity = 0.5
                    rootRec.border.width = 0
                }
            }
            opacity: 0.5
        }
        Grid {
            // TITLE | CHOICE BUTTONS GO HERE
            id: gA
            anchors.verticalCenter: infoButton.verticalCenter

            Row {
                    spacing: 10                
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
                    }
                }
                Column {
                    RowLayout {
                        id: testing
                        function paddingFix(caller) {
                            // row
                            if (caller == 'row'){
                                cfg_layoutPadding   = 0         // RESET PADDING TO DEFAULT
                                paddingLabel.color  = "grey"    // SET 'Default pixels' FONT COLOR TO GREY
                                paddingDOWN.enabled = false     // SET BOTH BUTTONS TO DISABLED
                                paddingUP.enabled   = false 
                            } else {
                                paddingLabel.color  = theme.textColor
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
            // NEW TOOLTIP INFORMATION
            //id: gB
            anchors.top: gA.bottom
            Text {
                id: infoText
                opacity: 0
                padding: 10 
                width: rootRec.width
                color: theme.textColor
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
            OpacityAnimator {
                id:anim
                target: infoText
                duration: 200
                onStopped: {   
                    if (infoButton.state === false) {     
                        heightAnimation.to = infoButton.height
                        heightAnimation.start()               
                    }
                }
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

        NumberAnimation {
            id: heightAnimation2
            target: rootRec2
            property: "height"
            duration: 100
            onStopped: {   
                if (infoButton2.state === true) {
                     anim2.to = 1;  anim2.start()                 
                }
            }
        }
        Button {
            property bool state: false

            id: infoButton2
            implicitWidth: infoButton2.height
            text: i18n("i")
            anchors.right: parent.right 
            onClicked: {
                if (state === false) {  // OPEN NEW TOOLTIP
                    state = true
                    heightAnimation2.to = infoButton2.height + infoText2.contentHeight + (infoText2.padding * 2) 
                    heightAnimation2.start()
                    opacity = 1.0
                    rootRec2.border.width = 0.5
                } else {                // CLOSE NEW TOOLTIP
                    state = false
                    anim2.to = 0;  anim2.start();
                    opacity = 0.5
                    rootRec2.border.width = 0
                }
            }
            opacity: 0.5
        }
        Grid {
            // TITLE | CHOICE BUTTONS GO HERE
            id: gA2
            anchors.verticalCenter: infoButton2.verticalCenter
            Row {
                spacing: 10                                
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
                    }
                }
                Column {
                    RowLayout {
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
            //id: gB
            anchors.top: gA2.bottom
            Text {
                id: infoText2
                opacity: 0
                padding: 10 
                width: rootRec2.width
                color: theme.textColor
                textFormat: Text.RichText
                wrapMode: Text.Wrap
                text: "<table>"
                        + "<tr><td><b>" + i18n("Upload speed first") + "</b>: </td>   <td>" + i18n("Upload data on the top in Vertical layout or left in Horizontal.") + "</td></tr>"
                        + "<tr><td><b>" + i18n("Download speed first") + "</b>: </td> <td>" + i18n("Download data on the top in Vertical layout or left in Horizontal.") + "</td></tr>"
                        + "<tr><td></td> <td><img src='../image/2a.png' width='150' height='65'><img src='../image/2b.png' width='250' height='70'></td></tr>"
                    + "</table>" 
            }
            OpacityAnimator {
                id:anim2
                target: infoText2
                duration: 200
                onStopped: {   
                    if (infoButton2.state === false) {     
                        heightAnimation2.to = infoButton2.height
                        heightAnimation2.start()               
                    }
                }
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

        NumberAnimation {
            id: heightAnimation3
            target: rootRec3
            property: "height"
            duration: 100
            onStopped: {   
                if (infoButton3.state === true) {
                     anim3.to = 1;  anim3.start()                 
                }
            }
        }
        Button {
            property bool state: false

            id: infoButton3
            implicitWidth: infoButton3.height
            text: i18n("i")
            anchors.right: parent.right 
            onClicked: {
                if (state === false) {  // OPEN NEW TOOLTIP
                    state = true
                    heightAnimation3.to = infoButton3.height + infoText3.contentHeight + (infoText3.padding * 2) 
                    heightAnimation3.start()
                    opacity = 1.0
                    rootRec3.border.width = 0.5
                } else {                // CLOSE NEW TOOLTIP
                    state = false
                    anim3.to = 0;  anim3.start();
                    opacity = 0.5
                    rootRec3.border.width = 0
                }
            }
            opacity: 0.5
        }
        Grid {
            // TITLE | CHOICE BUTTONS GO HERE
            id: gA3
            anchors.verticalCenter: infoButton3.verticalCenter
            Row {
                spacing: 10                
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
                    }
                }
                Column {
                    CheckBox {
                        id:      showSeparately
                        checked: true
                    }
                }
            }
        }
        Grid {
            // NEW TOOLTIP INFORMATION
            //id: gB
            anchors.top: gA3.bottom
            Text {
                id: infoText3
                opacity: 0
                padding: 10 
                width: rootRec3.width
                color: theme.textColor
                textFormat: Text.RichText
                wrapMode: Text.Wrap
                text: "<table>"
                        + "<tr><td><b>" + i18n("Checked") + "</b>: </td> <td>" + i18n("The Upload and Download data will be displayed separately either stacked or side by side.") + "</td></tr>"
                        + "<tr><td><b>" + i18n("Unchecked") + "</b>: </td> <td>" + i18n("The Upload and Download data will be combined both in data calculation and display. Only one row of data will be shown combining both data measurements with a matching icon.") + "</td></tr>"
                        + "<tr><td></td> <td><img src='../image/3a.png' width='305' height='65'></td></tr>"
                    + "</table>"
            }
            OpacityAnimator {
                id:anim3
                target: infoText3
                duration: 200
                onStopped: {   
                    if (infoButton3.state === false) {     
                        heightAnimation3.to = infoButton3.height
                        heightAnimation3.start()               
                    }
                }
            }
        }
    }
    //#######################################################################################################
    Rectangle {
        id: rootRec4
        width: parent.width
        height: infoButton4.height + 8
        anchors.top: rootRec3.bottom
        anchors.topMargin: spacerA
        color: "transparent" //"red"
        border.color: "dark grey"
        border.width: 0
        radius: 4

        NumberAnimation {
            id: heightAnimation4
            target: rootRec4
            property: "height"
            duration: 100
            onStopped: {   
                if (infoButton4.state === true) {
                     anim4.to = 1;  anim4.start()                 
                }
            }
        }
        Button {
            property bool state: false

            id: infoButton4
            implicitWidth: infoButton4.height
            text: i18n("i")
            //anchors.right: parent.right 
            anchors.right: parent.right 
            onClicked: {
                if (state === false) {  // OPEN NEW TOOLTIP
                    state = true
                    heightAnimation4.to = infoButton4.height + infoText4.contentHeight + (infoText4.padding * 2) 
                    heightAnimation4.start()
                    opacity = 1.0
                    rootRec4.border.width = 0.5
                } else {                // CLOSE NEW TOOLTIP
                    state = false
                    anim4.to = 0;  anim4.start();
                    opacity = 0.5
                    rootRec4.border.width = 0
                }
            }
            opacity: 0.5
        }
        Grid {
            // TITLE | CHOICE BUTTONS GO HERE
            id: gA4
            anchors.verticalCenter: infoButton4.verticalCenter

            Row {
                spacing: 10        
                Rectangle {     // USED FOR LABEL ALIGNMENT - NOT SURE WHY HAVING BELOW BUTTONS CAUSED 'anchors.verticalCenter: recAlign4.verticalCenter' NOT TO WORK WITH LABEL.
                    id: recAlign4
                    height: infoButton4.height
                    width: 0
                    color: "transparent"
                }
                Column {
                    Rectangle {
                        height: 10
                        width: spacerA
                        color: "transparent" //"red"
                    } 
                }
                Column {
                    anchors.verticalCenter: recAlign4.verticalCenter
                    Label {
                        width: titleTextMetrics.width
                        text:  i18n("Font size:")
                    }
                }
                Column {
                    //####################################################
                    RowLayout {
                        id: fontSizeRow

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
                    //##################################################  
                }
            }
        }
        Grid {
            // NEW TOOLTIP INFORMATION
            //id: gB
            anchors.top: gA4.bottom
            Text {
                id: infoText4
                opacity: 0
                padding: 10 
                width: rootRec4.width
                color: theme.textColor
                textFormat: Text.RichText
                wrapMode: Text.Wrap
                text: "<table>"
                        + "<tr><td><b>▲</b>: </td> <td>" + i18n("Increase font size, maximum 200%.") + "</td></tr>"
                        + "<tr><td><b>▼</b>: </td> <td>" + i18n("Decrease font size, minimum 50%") + "</td></tr>"
                    + "</table>"
            }
            OpacityAnimator {
                id:anim4
                target: infoText4
                duration: 200
                onStopped: {   
                    if (infoButton4.state === false) {     
                        heightAnimation4.to = infoButton4.height
                        heightAnimation4.start()               
                    }
                }
            }
        }
    }
    //#######################################################################################################
    Rectangle {
        id: rootRec5
        width: parent.width
        height: infoButton5.height
        anchors.top: rootRec4.bottom
        anchors.topMargin: spacerA
        color: "transparent" //"red"
        border.color: "dark grey"
        border.width: 0
        radius: 4

        NumberAnimation {
            id: heightAnimation5
            target: rootRec5
            property: "height"
            duration: 100
            onStopped: {   
                if (infoButton5.state === true) {
                     anim5.to = 1;  anim5.start()                 
                }
            }
        }
        Button {
            property bool state: false

            id: infoButton5
            implicitWidth: infoButton5.height
            text: i18n("i")
            anchors.right: parent.right 
            onClicked: {
                if (state === false) {  // OPEN NEW TOOLTIP
                    state = true
                    heightAnimation5.to = infoButton5.height + infoText5.contentHeight + (infoText5.padding * 2) 
                    heightAnimation5.start()
                    opacity = 1.0
                    rootRec5.border.width = 0.5
                } else {                // CLOSE NEW TOOLTIP
                    state = false
                    anim5.to = 0;  anim5.start();
                    opacity = 0.5
                    rootRec5.border.width = 0
                }
            }
            opacity: 0.5
        }
        Grid {
            // TITLE | CHOICE BUTTONS GO HERE
            id: gA5
            anchors.verticalCenter: infoButton5.verticalCenter

            Row {
                spacing: 10  
                Rectangle {     // USED FOR LABEL ALIGNMENT - NOT SURE WHY HAVING BELOW BUTTONS CAUSED 'anchors.verticalCenter: infoButtonX.verticalCenter' NOT TO WORK WITH LABEL.
                    id: recAlign5
                    height: infoButton5.height
                    width: 0
                    color: "transparent"
                }      
                Column {
                    Rectangle {
                        height: 10
                        width: spacerA
                        color: "transparent" //"red"
                    } 
                }
                Column {
                    anchors.verticalCenter: recAlign5.verticalCenter
                    Label {
                        width: titleTextMetrics.width
                        text:  i18n("Update interval:")
                    }
                }
                Column {
                    //####################################################
                    RowLayout {
                        id: intervalRow

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
            //id: gB
            anchors.top: gA5.bottom
            Text {
                id: infoText5
                opacity: 0
                padding: 10 
                width: rootRec4.width
                color: theme.textColor
                textFormat: Text.RichText
                wrapMode: Text.Wrap
                text: "<table>"
                        + "<tr><td><b>" + i18n("Summary") + "</b>: </td> <td>" + i18n("Controls the time interval new network data is displayed in the widget.") + "</td></tr>"
                        + "<tr><td></td>   <td style='padding-bottom:6px'>" + i18n("Adjustments are in 0.5 second increments.") + "</td></tr>"
                        + "<tr><td><b>▲</b>: </td> <td>" + i18n("Increase the time interval, maximum 5 seconds.") + "</td></tr>"
                        + "<tr><td><b>▼</b>: </td> <td>" + i18n("Decrease the time interval, minimum 0.5 seconds.") + "</td></tr>"
                    + "</table>"
            }
            OpacityAnimator {
                id:anim5
                target: infoText5
                duration: 200
                onStopped: {   
                    if (infoButton5.state === false) {     
                        heightAnimation5.to = infoButton5.height
                        heightAnimation5.start()               
                    }
                }
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

        NumberAnimation {
            id: heightAnimation6
            target: rootRec6
            property: "height"
            duration: 100
            onStopped: {   
                if (infoButton6.state === true) {
                     anim6.to = 1;  anim6.start()                 
                }
            }
        }
        Button {
            property bool state: false

            id: infoButton6
            implicitWidth: infoButton6.height
            text: i18n("i")
            anchors.right: parent.right 
            onClicked: {
                if (state === false) {  // OPEN NEW TOOLTIP
                    state = true
                    heightAnimation6.to = infoButton6.height + infoText6.contentHeight + (infoText6.padding * 2) 
                    heightAnimation6.start()
                    opacity = 1.0
                    rootRec6.border.width = 0.5
                } else {                // CLOSE NEW TOOLTIP
                    state = false
                    anim6.to = 0;  anim6.start();
                    opacity = 0.5
                    rootRec6.border.width = 0
                }
            }
            opacity: 0.5
        }
        Grid {
            // TITLE | CHOICE BUTTONS GO HERE
            id: gA6
            anchors.verticalCenter: infoButton6.verticalCenter

            Row {
                spacing: 10        
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
                    }
                }
                Column {
                    //####################################################
                    RowLayout {
                        id: accumRow
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
            //id: gB
            anchors.top: gA6.bottom
            Text {
                id: infoText6
                opacity: 0
                padding: 10 
                width: rootRec6.width
                color: theme.textColor
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
            OpacityAnimator {
                id:anim6
                target: infoText6
                duration: 200
                onStopped: {   
                    if (infoButton6.state === false) {     
                        heightAnimation6.to = infoButton6.height
                        heightAnimation6.start()               
                    }
                }
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

        NumberAnimation {
            id: heightAnimation7
            target: rootRec7
            property: "height"
            duration: 100
            onStopped: {   
                if (infoButton7.state === true) {
                     anim7.to = 1;  anim7.start()                 
                }
            }
        }
        Button {
            property bool state: false

            id: infoButton7
            implicitWidth: infoButton7.height
            text: i18n("i")
            anchors.right: parent.right 
            onClicked: {
                if (state === false) {  // OPEN NEW TOOLTIP
                    state = true
                    heightAnimation7.to = infoButton7.height + infoText7.contentHeight + (infoText7.padding * 2) 
                    heightAnimation7.start()
                    opacity = 1.0
                    rootRec7.border.width = 0.5
                } else {                // CLOSE NEW TOOLTIP
                    state = false
                    anim7.to = 0;  anim7.start();
                    opacity = 0.5
                    rootRec7.border.width = 0
                }
            }
            opacity: 0.5
        }
        Grid {
            // TITLE | CHOICE BUTTONS GO HERE
            id: gA7
            anchors.verticalCenter: infoButton7.verticalCenter

            Row {
                id: rr
                spacing: 10    
                Rectangle {     // USED FOR LABEL ALIGNMENT - NOT SURE WHY HAVING BELOW BUTTONS CAUSED 'anchors.verticalCenter: infoButtonX.verticalCenter' NOT TO WORK WITH LABEL.
                    id: recAlign7
                    height: infoButton7.height
                    width: 0
                    color: "transparent"
                }    
                Column {
                    Rectangle {
                        height: 10
                        width: spacerA
                        color: "transparent" //"red"
                    } 
                }
                Column {
                    anchors.verticalCenter: recAlign7.verticalCenter
                    //________ LAYOUT ________ 
                    Label {
                        width: titleTextMetrics.width
                        text:  i18n("Layout Padding:")
                    }
                }
                Column {
                    //####################################################
                    RowLayout {
                        id: paddingRow

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
            //id: gB
            anchors.top: gA7.bottom
            Text {
                id: infoText7
                opacity: 0
                padding: 10 
                width: rootRec7.width
                color: theme.textColor
                textFormat: Text.RichText
                wrapMode: Text.Wrap
                
                text: "<table>"
                        + "<tr><td><b>▲</b>: </td> <td>" + i18n("Move the upload and download data rows closer together, maximum 20 pixels closer.") + "</td></tr>"
                        + "<tr><td><b>▼</b>: </td> <td>" + i18n("Increase the distance between upload and download data rows, maximum 20 pixels apart.") + "</td></tr>"
                        + "<tr><td></td> <td style='padding-bottom:6px'><img src='../image/4a.png' width='280' height='85'></td></tr>"
                    + "</table>"
                    + i18n("* Function disabled in 'Horizontal' layout mode.")
            }
            OpacityAnimator {
                id:anim7
                target: infoText7
                duration: 200
                onStopped: {   
                    if (infoButton7.state === false) {     
                        heightAnimation7.to = infoButton7.height
                        heightAnimation7.start()               
                    }
                }
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

        NumberAnimation {
            id: heightAnimation8
            target: rootRec8
            property: "height"
            duration: 100
            onStopped: {   
                if (infoButton8.state === true) {
                     anim8.to = 1;  anim8.start()                 
                }
            }
        }
        Button {
            property bool state: false

            id: infoButton8
            implicitWidth: infoButton8.height
            text: i18n("i")
            anchors.right: parent.right 
            onClicked: {
                if (state === false) {  // OPEN NEW TOOLTIP
                    state = true
                    heightAnimation8.to = infoButton8.height + infoText8.contentHeight + (infoText8.padding * 2) 
                    heightAnimation8.start()
                    opacity = 1.0
                    rootRec8.border.width = 0.5
                } else {                // CLOSE NEW TOOLTIP
                    state = false
                    anim8.to = 0;  anim8.start();
                    opacity = 0.5
                    rootRec8.border.width = 0
                }
            }
            opacity: 0.5
        }
        Grid {
            // TITLE | CHOICE BUTTONS GO HERE
            id: gA8
            anchors.verticalCenter: infoButton8.verticalCenter

            Row {
                spacing: 10        
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
                    }
                }
                Column {
                    //####################################################
                    CheckBox {
                        id:                         hideInactive
                        onCheckedChanged: {
                            if (!hideInactive.checked) {
                                cfg_hideZone = false
                                //rbZone1.checked = true
                            }
                        }
                    }   
                    // ################################################################    
                }
            }
        }
        Grid {
            // NEW TOOLTIP INFORMATION
            //id: gB
            anchors.top: gA8.bottom
            Text {
                id: infoText8
                opacity: 0
                padding: 10 
                width: rootRec8.width
                color: theme.textColor
                textFormat: Text.RichText
                wrapMode: Text.Wrap
                
                text: "<table>"
                        + "<tr><td><b>" + i18n("Checked") + "</b>: </td> <td style='padding-bottom:6px'>" + i18n("Hides the display when '0' traffic is reported.  Displays will become visible again when traffic starts to flow.") + "</td></tr>"
                        + "<tr><td><b>" + i18n("Unchecked") + "</b>: </td> <td style='padding-bottom:6px'>" + i18n("Shows the display even when no traffic is traversing the network interfaces.") + "</td></tr>"
                    + "</table>"
            }
            OpacityAnimator {
                id:anim8
                target: infoText8
                duration: 200
                onStopped: {   
                    if (infoButton8.state === false) {     
                        heightAnimation8.to = infoButton8.height
                        heightAnimation8.start()               
                    }
                }
            }
        } 
    }
 //#######################################################################################################
    Rectangle {
        id: rootRec9
        width: parent.width
        height: infoButton9.height
        anchors.top: rootRec8.bottom
        anchors.topMargin: spacerB
        color: "transparent" //"red"
        border.color: "dark grey"
        border.width: 0
        radius: 4

        NumberAnimation {
            id: heightAnimation9
            target: rootRec9
            property: "height"
            duration: 100
            onStopped: {   
                if (infoButton9.state === true) {
                     anim9.to = 1;  anim9.start()                 
                }
            }
        }
        Button {
            property bool state: false

            id: infoButton9
            implicitWidth: infoButton9.height
            text: i18n("i")
            anchors.right: parent.right 
            onClicked: {
                if (state === false) {  // OPEN NEW TOOLTIP
                    state = true
                    heightAnimation9.to = infoButton9.height + infoText9.contentHeight + (infoText9.padding * 2) 
                    heightAnimation9.start()
                    opacity = 1.0
                    rootRec9.border.width = 0.5
                } else {                // CLOSE NEW TOOLTIP
                    state = false
                    anim9.to = 0;  anim9.start();
                    opacity = 0.5
                    rootRec9.border.width = 0
                }
            }
            opacity: 0.5
        }
        Grid {
            // TITLE | CHOICE BUTTONS GO HERE
            id: gA9
            anchors.verticalCenter: infoButton9.verticalCenter

            Row {
                spacing: 10        
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
                    }
                }
                Column {
                    //####################################################
                    CheckBox {
                        id: showUnits
                    }  
                    // ################################################################    
                }
            }
        }
        Grid {
            // NEW TOOLTIP INFORMATION
            //id: gB
            anchors.top: gA9.bottom
            Text {
                id: infoText9
                opacity: 0
                padding: 10 
                width: rootRec9.width
                color: theme.textColor
                textFormat: Text.RichText
                wrapMode: Text.Wrap
                
                text: "<table>"
                        + "<tr><td><b>" + i18n("Checked") + "</b>: </td> <td style='padding-bottom:6px'>" + i18n("Hides the trailing suffix for the bits (b, kib, Mib Gib) or bytes (B, KB, MB, GB).") + "</td></tr>"
                        + "<tr><td><b>" + i18n("Unchecked") + "</b>: </td> <td style='padding-bottom:6px'>" + i18n("Shows the suffixes for bits or bytes.") + "</td></tr>"
                    + "</table>"
            }
            OpacityAnimator {
                id:anim9
                target: infoText9
                duration: 200
                onStopped: {   
                    if (infoButton9.state === false) {     
                        heightAnimation9.to = infoButton9.height
                        heightAnimation9.start()               
                    }
                }
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

        NumberAnimation {
            id: heightAnimation10
            target: rootRec10
            property: "height"
            duration: 100
            onStopped: {   
                if (infoButton10.state === true) {
                     anim10.to = 1;  anim10.start()                 
                }
            }
        }
        Button {
            property bool state: false

            id: infoButton10
            implicitWidth: infoButton10.height
            text: i18n("i")
            anchors.right: parent.right 
            onClicked: {
                if (state === false) {  // OPEN NEW TOOLTIP
                    state = true
                    heightAnimation10.to = infoButton10.height + infoText10.contentHeight + (infoText10.padding * 2) 
                    heightAnimation10.start()
                    opacity = 1.0
                    rootRec10.border.width = 0.5
                } else {                // CLOSE NEW TOOLTIP
                    state = false
                    anim10.to = 0;  anim10.start();
                    opacity = 0.5
                    rootRec10.border.width = 0
                }
            }
            opacity: 0.5
        }
        Grid {
            // TITLE | CHOICE BUTTONS GO HERE
            id: gA10
            anchors.verticalCenter: infoButton10.verticalCenter

            Row {
                spacing: 10        
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
                    }
                }
                Column {
                    //####################################################
                    RowLayout {
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
            //id: gB
            anchors.top: gA10.bottom
            Text {
                id: infoText10
                opacity: 0
                padding: 10 
                width: rootRec10.width
                color: theme.textColor
                textFormat: Text.RichText
                wrapMode: Text.Wrap
                
                text: "<table>"
                        + "<tr><td><b>" + i18n("Bits") + "</b>: </td> <td style='padding-bottom:6px'>" + i18n("Displays data throughput based on bit units. The default option, bits are normally used to measure a data transfer.") + "</td></tr>"
                        + "<tr><td><b>" + i18n("Bytes") + "</b>: </td> <td style='padding-bottom:6px'>" + i18n("Displays data throughput based on byte units. Second option as bytes can be used to measure an amount of data, normally storage data.") + "</td></tr>"
                    + "</table>"
            }
            OpacityAnimator {
                id:anim10
                target: infoText10
                duration: 200
                onStopped: {   
                    if (infoButton10.state === false) {     
                        heightAnimation10.to = infoButton10.height
                        heightAnimation10.start()               
                    }
                }
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

        NumberAnimation {
            id: heightAnimation11
            target: rootRec11
            property: "height"
            duration: 100
            onStopped: {   
                if (infoButton11.state === true) {
                     anim11.to = 1;  anim11.start()                 
                }
            }
        }
        Button {
            property bool state: false

            id: infoButton11
            implicitWidth: infoButton11.height
            text: i18n("i")
            anchors.right: parent.right 
            onClicked: {
                if (state === false) {  // OPEN NEW TOOLTIP
                    state = true
                    heightAnimation11.to = infoButton11.height + infoText11.contentHeight + (infoText11.padding * 2) 
                    heightAnimation11.start()
                    opacity = 1.0
                    rootRec11.border.width = 0.5
                } else {                // CLOSE NEW TOOLTIP
                    state = false
                    anim11.to = 0;  anim11.start();
                    opacity = 0.5
                    rootRec11.border.width = 0
                }
            }
            opacity: 0.5
        }
        Grid {
            // TITLE | CHOICE BUTTONS GO HERE
            id: gA11
            anchors.verticalCenter: infoButton11.verticalCenter

            Row {
                spacing: 10        
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
                    }
                }
                Column {
                    //####################################################
                    CheckBox {
                        id: shortUnits
                    } 
                    // ################################################################    
                }
            }
        }
        Grid {
            // NEW TOOLTIP INFORMATION
            //id: gB
            anchors.top: gA11.bottom
            Text {
                id: infoText11
                opacity: 0
                padding: 10 
                width: rootRec11.width
                color: theme.textColor
                textFormat: Text.RichText
                wrapMode: Text.Wrap
                
                text: "<table>"
                        + "<tr><td><b>" + i18n("Checked") + "</b>: </td> <td style='padding-bottom:6px'>" + i18n("Will only use a single character to represent the bits or bytes suffix, for example kb = k, Mb = M etc.  Per second units will also not be displayed.") + "</td></tr>"
                        + "<tr><td><b>" + i18n("Unchecked") + "</b>: </td> <td style='padding-bottom:6px'>" + i18n("The complete suffix will be displayed including the per second unit.") + "</td></tr>"
                    + "</table>"
            }
            OpacityAnimator {
                id:anim11
                target: infoText11
                duration: 200
                onStopped: {   
                    if (infoButton11.state === false) {     
                        heightAnimation11.to = infoButton11.height
                        heightAnimation11.start()               
                    }
                }
            }
        } 
    }
 //#######################################################################################################
    Rectangle {
        id: rootRec12
        width: parent.width
        height: infoButton12.height
        anchors.top: rootRec11.bottom
        anchors.topMargin: spacerB
        color: "transparent" //"red"
        border.color: "dark grey"
        border.width: 0
        radius: 4

        NumberAnimation {
            id: heightAnimation12
            target: rootRec12
            property: "height"
            duration: 100
            onStopped: {   
                if (infoButton12.state === true) {
                     anim12.to = 1;  anim12.start()                 
                }
            }
        }
        Button {
            property bool state: false

            id: infoButton12
            implicitWidth: infoButton12.height
            text: i18n("i")
            anchors.right: parent.right 
            onClicked: {
                if (state === false) {  // OPEN NEW TOOLTIP
                    state = true
                    heightAnimation12.to = infoButton12.height + infoText12.contentHeight + (infoText12.padding * 2) 
                    heightAnimation12.start()
                    opacity = 1.0
                    rootRec12.border.width = 0.5
                } else {                // CLOSE NEW TOOLTIP
                    state = false
                    anim12.to = 0;  anim12.start();
                    opacity = 0.5
                    rootRec12.border.width = 0
                }
            }
            opacity: 0.5
        }
        Grid {
            // TITLE | CHOICE BUTTONS GO HERE
            id: gA12
            anchors.verticalCenter: infoButton12.verticalCenter

            Row {
                spacing: 10        
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
                    }
                }
                Column {
                    //####################################################
                    CheckBox {
                        id: showSeconds
                    }  
                    // DISABLE THE SECONDS PREFIX OPTIONS IF CHECKBOX NOT CHECKED
                    // ################################################################    
                }
            }
        }
        Grid {
            // NEW TOOLTIP INFORMATION
            //id: gB
            anchors.top: gA12.bottom
            Text {
                id: infoText12
                opacity: 0
                padding: 10 
                width: rootRec12.width
                color: theme.textColor
                textFormat: Text.RichText
                wrapMode: Text.Wrap
                
                text: "<table>"
                        + "<tr><td><b>" + i18n("Checked") + "</b>: </td> <td style='padding-bottom:6px'>" + i18n("Appends the per second suffix to the trailing measurement unit.") + "</td></tr>"
                        + "<tr><td><b></b></td> <td style='padding-bottom:6px'>" + i18n("* This option is technically correct when used in conjunction with 'Interval data relay' choice other than 'Accumulated'.") + "</td></tr>"
                        + "<tr><td><b>" + i18n("Unchecked") + "</b>: </td> <td style='padding-bottom:6px'>" + i18n("Removes the per second suffix ('/s' or 'ps') from the trailing bit or byte measurement unit.") + "</td></tr>"
                        + "<tr><td><b></b></td> <td style='padding-bottom:6px'>" + i18n("* This option is technically correct when used in conjunction with 'Interval data relay' choice of 'Accumulated'.") + "</td></tr>"
                    + "</table>"
            }
            OpacityAnimator {
                id:anim12
                target: infoText12
                duration: 200
                onStopped: {   
                    if (infoButton12.state === false) {     
                        heightAnimation12.to = infoButton12.height
                        heightAnimation12.start()               
                    }
                }
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

        NumberAnimation {
            id: heightAnimation13
            target: rootRec13
            property: "height"
            duration: 100
            onStopped: {   
                if (infoButton13.state === true) {
                     anim13.to = 1;  anim13.start()                 
                }
            }
        }
        Button {
            property bool state: false

            id: infoButton13
            implicitWidth: infoButton13.height
            text: i18n("i")
            anchors.right: parent.right 
            onClicked: {
                if (state === false) {  // OPEN NEW TOOLTIP
                    state = true
                    heightAnimation13.to = infoButton13.height + infoText13.contentHeight + (infoText13.padding * 2) 
                    heightAnimation13.start()
                    opacity = 1.0
                    rootRec13.border.width = 0.5
                } else {                // CLOSE NEW TOOLTIP
                    state = false
                    anim13.to = 0;  anim13.start();
                    opacity = 0.5
                    rootRec13.border.width = 0
                }
            }
            opacity: 0.5
        }
        Grid {
            // TITLE | CHOICE BUTTONS GO HERE
            id: gA13
            anchors.verticalCenter: infoButton13.verticalCenter

            Row {
                spacing: 10        
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
                    }
                }
                Column {
                    //####################################################
                    RowLayout {
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
            //id: gB
            anchors.top: gA13.bottom
            Text {
                id: infoText13
                opacity: 0
                padding: 10 
                width: rootRec13.width
                color: theme.textColor
                textFormat: Text.RichText
                wrapMode: Text.Wrap
                
                text: "<table>"
                        + "<tr><td>" + i18n("Choose between a per second unit of '/s' or 'ps'.") + "</td></tr>"
                        + "<tr><td>" + i18n("Example, measuring in bits: Kib<b>/s</b> or Kib<b>ps</b>, measuring in bytes: KB<b>/s</b> or KB<b>ps</b>.") + "</td></tr>"
                    + "</table>"
            }
            OpacityAnimator {
                id:anim13
                target: infoText13
                duration: 200
                onStopped: {   
                    if (infoButton13.state === false) {     
                        heightAnimation13.to = infoButton13.height
                        heightAnimation13.start()               
                    }
                }
            }
        } 
    }
 //#######################################################################################################
    Rectangle {
        id: rootRec14
        width: parent.width
        height: infoButton14.height
        anchors.top: rootRec13.bottom
        anchors.topMargin: spacerB
        color: "transparent" //"red"
        border.color: "dark grey"
        border.width: 0
        radius: 4

        NumberAnimation {
            id: heightAnimation14
            target: rootRec14
            property: "height"
            duration: 100
            onStopped: {   
                if (infoButton14.state === true) {
                     anim14.to = 1;  anim14.start()                 
                }
            }
        }
        Button {
            property bool state: false

            id: infoButton14
            implicitWidth: infoButton14.height
            text: i18n("i")
            anchors.right: parent.right 
            onClicked: {
                if (state === false) {  // OPEN NEW TOOLTIP
                    state = true
                    heightAnimation14.to = infoButton14.height + infoText14.contentHeight + (infoText14.padding * 2) 
                    heightAnimation14.start()
                    opacity = 1.0
                    rootRec14.border.width = 0.5
                } else {                // CLOSE NEW TOOLTIP
                    state = false
                    anim14.to = 0;  anim14.start();
                    opacity = 0.5
                    rootRec14.border.width = 0
                }
            }
            opacity: 0.5
        }
        Grid {
            // TITLE | CHOICE BUTTONS GO HERE
            id: gA14
            anchors.verticalCenter: infoButton14.verticalCenter

            Row {
                spacing: 10        
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
                    }
                }
                Column {
                    //####################################################
                    CheckBox {
                        id: showIcons
                    } 
                    // ################################################################    
                }
            }
        }
        Grid {
            // NEW TOOLTIP INFORMATION
            //id: gB
            anchors.top: gA14.bottom
            Text {
                id: infoText14
                opacity: 0
                padding: 10 
                width: rootRec14.width
                color: theme.textColor
                textFormat: Text.RichText
                wrapMode: Text.Wrap
                
                text: "<table>"
                        + "<tr><td><b>" + i18n("Checked") + "</b>: </td> <td style='padding-bottom:6px'>" + i18n("Displays the Download or Upload icons in the widget.") + "</td></tr>"
                        + "<tr><td><b>" + i18n("Unchecked") + "</b>: </td> <td style='padding-bottom:6px'>" + i18n("Hides the Download or Upload icons in the widget.") + "</td></tr>"
                    + "</table>"
            }
            OpacityAnimator {
                id:anim14
                target: infoText14
                duration: 200
                onStopped: {   
                    if (infoButton14.state === false) {     
                        heightAnimation14.to = infoButton14.height
                        heightAnimation14.start()               
                    }
                }
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

        NumberAnimation {
            id: heightAnimation15
            target: rootRec15
            property: "height"
            duration: 100
            onStopped: {   
                if (infoButton15.state === true) {
                     anim15.to = 1;  anim15.start()                 
                }
            }
        }
        Button {
            property bool state: false

            id: infoButton15
            implicitWidth: infoButton15.height
            text: i18n("i")
            anchors.right: parent.right 
            onClicked: {
                if (state === false) {  // OPEN NEW TOOLTIP
                    state = true
                    heightAnimation15.to = infoButton15.height + infoText15.contentHeight + (infoText15.padding * 2) 
                    heightAnimation15.start()
                    opacity = 1.0
                    rootRec15.border.width = 0.5
                } else {                // CLOSE NEW TOOLTIP
                    state = false
                    anim15.to = 0;  anim15.start();
                    opacity = 0.5
                    rootRec15.border.width = 0
                }
            }
            opacity: 0.5
        }
        Grid {
            // TITLE | CHOICE BUTTONS GO HERE
            id: gA15
            anchors.verticalCenter: infoButton15.verticalCenter

            Row {
                spacing: 10     
                Rectangle {     // USED FOR LABEL ALIGNMENT - NOT SURE WHY HAVING BELOW BUTTONS CAUSED 'anchors.verticalCenter: infoButtonX.verticalCenter' NOT TO WORK WITH LABEL.
                    id: recAlign15
                    height: infoButton15.height
                    width: 0
                    color: "transparent"
                }   
                Column {
                    Rectangle {
                        height: 10
                        width: spacerA
                        color: "transparent" //"red"
                    } 
                }
                Column {
                    anchors.verticalCenter: recAlign15.verticalCenter
                    //________ LAYOUT ________ 
                    Label {
                        width: titleTextMetrics.width
                        text:  i18n("Icon Style:")
                    }
                }
                Column {
                    //####################################################
                    ComboBox {
                        // ICONS FROM HACK FONT AND NATO SAN
                        id:                         iconType
                        textRole:                   'text'
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
            //id: gB
            anchors.top: gA15.bottom
            Text {
                id: infoText15
                opacity: 0
                padding: 10 
                width: rootRec15.width
                color: theme.textColor
                textFormat: Text.RichText
                wrapMode: Text.Wrap
                
                text: "<table>"
                        + "<tr><td>" + i18n("Choose the Upload and Download icon style to be displayed in the widget.") + "</td></tr>"
                    + "</table>"
            }
            OpacityAnimator {
                id:anim15
                target: infoText15
                duration: 200
                onStopped: {   
                    if (infoButton15.state === false) {     
                        heightAnimation15.to = infoButton15.height
                        heightAnimation15.start()               
                    }
                }
            }
        } 
    }   
 //#######################################################################################################
    Rectangle {
        id: rootRec16
        width: parent.width
        height: infoButton16.height
        anchors.top: rootRec15.bottom
        anchors.topMargin: spacerA
        color: "transparent" //"red"
        border.color: "dark grey"
        border.width: 0
        radius: 4

        NumberAnimation {
            id: heightAnimation16
            target: rootRec16
            property: "height"
            duration: 100
            onStopped: {   
                if (infoButton16.state === true) {
                     anim16.to = 1;  anim16.start()                 
                }
            }
        }
        Button {
            property bool state: false

            id: infoButton16
            implicitWidth: infoButton16.height
            text: i18n("i")
            anchors.right: parent.right 
            onClicked: {
                if (state === false) {  // OPEN NEW TOOLTIP
                    state = true
                    heightAnimation16.to = infoButton16.height + infoText16.contentHeight + (infoText16.padding * 2) 
                    heightAnimation16.start()
                    opacity = 1.0
                    rootRec16.border.width = 0.5
                } else {                // CLOSE NEW TOOLTIP
                    state = false
                    anim16.to = 0;  anim16.start();
                    opacity = 0.5
                    rootRec16.border.width = 0
                }
            }
            opacity: 0.5
        }
        Grid {
            // TITLE | CHOICE BUTTONS GO HERE
            id: gA16
            anchors.verticalCenter: infoButton16.verticalCenter

            Row {
                spacing: 10        
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
                    }
                }
                Column {
                    //####################################################
                    RowLayout {
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
            //id: gB
            anchors.top: gA16.bottom
            Text {
                id: infoText16
                opacity: 0
                padding: 10 
                width: rootRec16.width
                color: theme.textColor
                textFormat: Text.RichText
                wrapMode: Text.Wrap
                
                text: "<table>"
                        + "<tr><td>" + i18n("Choose to have the Upload and Download icons to the left or the right of the speed data.") + "</td></tr>"
                    + "</table>"
            }
            OpacityAnimator {
                id:anim16
                target: infoText16
                duration: 200
                onStopped: {   
                    if (infoButton16.state === false) {     
                        heightAnimation16.to = infoButton16.height
                        heightAnimation16.start()               
                    }
                }
            }
        } 
    }  
 //#######################################################################################################
    Rectangle {
        id: rootRec17
        width: parent.width
        height: infoButton17.height
        anchors.top: rootRec16.bottom
        anchors.topMargin: spacerB
        color: "transparent" //"red"
        border.color: "dark grey"
        border.width: 0
        radius: 4

        NumberAnimation {
            id: heightAnimation17
            target: rootRec17
            property: "height"
            duration: 100
            onStopped: {   
                if (infoButton17.state === true) {
                     anim17.to = 1;  anim17.start()                 
                }
            }
        }
        Button {
            property bool state: false

            id: infoButton17
            implicitWidth: infoButton17.height
            text: i18n("i")
            anchors.right: parent.right 
            onClicked: {
                if (state === false) {  // OPEN NEW TOOLTIP
                    state = true
                    heightAnimation17.to = infoButton17.height + infoText17.contentHeight + (infoText17.padding * 2) 
                    heightAnimation17.start()
                    opacity = 1.0
                    rootRec17.border.width = 0.5
                } else {                // CLOSE NEW TOOLTIP
                    state = false
                    anim17.to = 0;  anim17.start();
                    opacity = 0.5
                    rootRec17.border.width = 0
                }
            }
            opacity: 0.5
        }
        Grid {
            // TITLE | CHOICE BUTTONS GO HERE
            id: gA17
            anchors.verticalCenter: infoButton17.verticalCenter

            Row {
                spacing: 10        
                Rectangle {     // USED FOR LABEL ALIGNMENT - NOT SURE WHY HAVING BELOW BUTTONS CAUSED 'anchors.verticalCenter: infoButtonX.verticalCenter' NOT TO WORK WITH LABEL.
                    id: recAlign17
                    height: infoButton17.height
                    width: 0
                    color: "transparent"
                }
                Column {
                    Rectangle {
                        height: 10
                        width: spacerA
                        color: "transparent" //"red"
                    } 
                }
                Column {
                    anchors.verticalCenter: recAlign17.verticalCenter
                    //________ LAYOUT ________ 
                    Label {
                        width: titleTextMetrics.width
                        text:  i18n("Numbers:")
                    }
                }
                Column {
                    //####################################################
                    RowLayout {
                        RadioButton {
                            Layout.rightMargin:     20          // PADDING RIGHT
                            checked:                plasmoid.configuration.binaryDecimal === 'binary'
                            text:                   i18n("Binary (1024)")
                            onReleased:             cfg_binaryDecimal = 'binary'
                        }
                        RadioButton {
                            checked:                plasmoid.configuration.binaryDecimal === 'decimal'
                            text:                   i18n("Metric (1000)")
                            onReleased:             cfg_binaryDecimal = 'decimal'
                        }
                    }
                    // ################################################################    
                }
            }
        }
        Grid {
            // NEW TOOLTIP INFORMATION
            //id: gB
            anchors.top: gA17.bottom
            Text {
                id: infoText17
                opacity: 0
                padding: 10 
                width: rootRec17.width
                color: theme.textColor
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
            OpacityAnimator {
                id:anim17
                target: infoText17
                duration: 200
                onStopped: {   
                    if (infoButton17.state === false) {     
                        heightAnimation17.to = infoButton17.height
                        heightAnimation17.start()               
                    }
                }
            }
        } 
    }  
 //#######################################################################################################
    Rectangle {
        id: rootRec18
        width: parent.width
        height: infoButton18.height
        anchors.top: rootRec17.bottom
        anchors.topMargin: spacerA
        color: "transparent" //"red"
        border.color: "dark grey"
        border.width: 0
        radius: 4

        NumberAnimation {
            id: heightAnimation18
            target: rootRec18
            property: "height"
            duration: 100
            onStopped: {   
                if (infoButton18.state === true) {
                     anim18.to = 1;  anim18.start()                 
                }
            }
        }
        Button {
            property bool state: false

            id: infoButton18
            implicitWidth: infoButton18.height
            text: i18n("i")
            anchors.right: parent.right 
            onClicked: {
                if (state === false) {  // OPEN NEW TOOLTIP
                    state = true
                    heightAnimation18.to = infoButton18.height + infoText18.contentHeight + (infoText18.padding * 2) 
                    heightAnimation18.start()
                    opacity = 1.0
                    rootRec18.border.width = 0.5
                } else {                // CLOSE NEW TOOLTIP
                    state = false
                    anim18.to = 0;  anim18.start();
                    opacity = 0.5
                    rootRec18.border.width = 0
                }
            }
            opacity: 0.5
        }
        Grid {
            // TITLE | CHOICE BUTTONS GO HERE
            id: gA18
            anchors.verticalCenter: infoButton18.verticalCenter

            Row {
                spacing: 10     
                Rectangle {     // USED FOR LABEL ALIGNMENT - NOT SURE WHY HAVING BELOW BUTTONS CAUSED 'anchors.verticalCenter: infoButtonX.verticalCenter' NOT TO WORK WITH LABEL.
                    id: recAlign18
                    height: infoButton18.height
                    width: 0
                    color: "transparent"
                }   
                Column {
                    Rectangle {
                        height: 10
                        width: spacerA
                        color: "transparent" //"red"
                    } 
                }
                Column {
                    anchors.verticalCenter: recAlign18.verticalCenter
                    //________ LAYOUT ________ 
                    Label {
                        width: titleTextMetrics.width
                        text:  i18n("Decimal Place:")
                    }
                }
                Column {
                    //####################################################
                    RowLayout {
                            id:                         decimalPlaceRow

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
            //id: gB
            anchors.top: gA18.bottom
            Text {
                id: infoText18
                opacity: 0
                padding: 10 
                width: rootRec18.width
                color: theme.textColor
                textFormat: Text.RichText
                wrapMode: Text.Wrap
                
                text: "<table>"
                        + "<tr><td>" + i18n("Choose the number of decimal fraction digits to the right of the decimal point.") + "</td></tr>"
                    + "</table>"
            }
            OpacityAnimator {
                id:anim18
                target: infoText18
                duration: 200
                onStopped: {   
                    if (infoButton18.state === false) {     
                        heightAnimation18.to = infoButton18.height
                        heightAnimation18.start()               
                    }
                }
            }
        } 
    }   
}