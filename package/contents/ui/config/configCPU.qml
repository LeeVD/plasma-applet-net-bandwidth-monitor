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
            var buttonObject = target.parent.parent.children[0].children[1] // GET infoButton Object
            var buttonState = buttonObject.state                            // GET infoButton state

            if (buttonState === false) {                                    // infoButton#.MouseArea.state

                heightAnimation.target = target.parent.parent               // target rootRec#
                heightAnimation.to = infoButton.height                      // close infoText# tooltip
                heightAnimation.start()                                     // start Animation
            }
        }
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
            anchors.verticalCenter: infoButton.verticalCenter

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

            property alias nText: infoText
            // NEW TOOLTIP INFORMATION
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
        }
    }
    ###############################################################################################
    Rectangle {
        id: spacer
        height: 20
        width:  20
        anchors.top: rootRec.bottom
        color: "transparent"
    }
    ###############################################################################################    

}