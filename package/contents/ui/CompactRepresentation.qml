/*
 * Copyright 2023  LeeVD thoth360@hotmail.com
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
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
// import org.kde.plasma.components 3.0 as PlasmaComponents    // used in tooltip section
// import org.kde.plasma.extras 2.0 as PlasmaExtras            // used in tooltip section

Item {
    id: itemParent
    anchors.fill: parent

    property double marginFactor: 0.2

    // PRIMARY UI INTERFACE DATA VARIABLES 
    property double downSpeed: 0
    property double upSpeed: 0
 
    property bool singleLine: {
        if (!showSeparately) {
            return true
        }
        switch (speedLayout) {
            case 'row':    return true      // SIDE BY SIDE
            case 'column': return false     // ONE ABOVE OTHER
            default:        return height / 2 * fontSizeScale < theme.smallestFont.pixelSize && plasmoid.formFactor !== PlasmaCore.Types.Vertical
        }
    }

    property double marginWidth:        speedTextMetrics.font.pixelSize * marginFactor
    property double iconWidth:          showIcons ? iconTextMetrics.width + marginWidth : 0
    property double doubleIconWidth:    showIcons ? (doubleIconTextMetrics.width + marginWidth) : 0
    property double speedWidth:         speedTextMetrics.width + 2*marginWidth
    property double unitWidth:          showUnits ? unitTextMetrics.width + marginWidth : 0

    //property double toolTipWidth:       showTooltip ? TextMetrics2 : 0 


    property double aspectRatio: {
        if (showSeparately) {
            if (singleLine) {
                return (2*iconWidth + 2*speedWidth + 2*unitWidth + marginWidth) * fontSizeScale / speedTextMetrics.height
            } else {
                return (iconWidth + speedWidth + unitWidth) * fontSizeScale / (2*speedTextMetrics.height)
            }
        } else {
            return (doubleIconWidth + speedWidth + unitWidth) * fontSizeScale / speedTextMetrics.height
        }
    }

    property double fontHeightRatio: speedTextMetrics.font.pixelSize / speedTextMetrics.height

    property double offset: {
        if (plasmoid.formFactor === PlasmaCore.Types.Vertical) {
            return (width - height * aspectRatio) / 2
        } else {
            return 0
        }
    }

    property bool boolUnits: {
        if (speedUnits !== 'bits')  return false;
        else                        return true;     
    }

    property double getBinDec: {
        if (binaryDecimal === 'binary')     return 1024;    // binary
        else                                return 1000;    // decimal
    }

    Layout.minimumWidth: {
        if (plasmoid.formFactor === PlasmaCore.Types.Vertical) {
            return 0
        } else if (plasmoid.formFactor === PlasmaCore.Types.Horizontal) {
            return Math.ceil(height * aspectRatio)
        } else {
            return Math.ceil(height * aspectRatio)
        }
    }
    Layout.minimumHeight: {
        if (plasmoid.formFactor === PlasmaCore.Types.Vertical) {
            return Math.ceil(width / aspectRatio * fontSizeScale * fontSizeScale)
        } else if (plasmoid.formFactor === PlasmaCore.Types.Horizontal) {
            return 0
        } else {
            return Math.ceil(theme.smallestFont.pixelSize / fontSizeScale)
        }
    }

    Layout.preferredWidth:  Layout.minimumWidth
    Layout.preferredHeight: Layout.minimumHeight

    TextMetrics {
        id: iconTextMetrics
        text: iconStyle(1)
        font.pixelSize: 64
    }

    TextMetrics {
        id: doubleIconTextMetrics
        text: iconStyle(2)
        font.pixelSize: 64
    }

    TextMetrics {
        id: speedTextMetrics
        text: getDecimalPlace()      //'1000.0'
        font.pixelSize: 64    
    }

    TextMetrics {
        id: unitTextMetrics
        text: {
            if (speedUnits === 'bits') {
                return shortUnits ? 'm' : 'Mib/s'
            } else {
                return shortUnits ? 'M' : 'MiB/s'
            }
        }
        font.pixelSize: 64
    }

    Item {
        id: offsetItem
        width: offset
        height: parent.height
        x: 0
        y: 0
    }

    // USED FOR TESTING UI
    // Rectangle{
    //     id: rec_t1
    //     height:             dataShown('t1', 'height') 
    //     width:              dataShown('t1', 'width') 
    //     anchors.left:       dataShown('t1', 'anchorL') 
    //     anchors.leftMargin: dataShown('t1', 'anchorLMargin') 
    //     y:                  dataShown('t1', 'y') 
    //     visible:            true //dataShown('t1', 'visible')
    //     color: "red"
    // }
    // Rectangle{
    //     id: rec_t2
    //     height:             dataShown('t2', 'height') 
    //     width:              dataShown('t2', 'width') 
    //     anchors.left:       dataShown('t2', 'anchorL') 
    //     anchors.leftMargin: dataShown('t2', 'anchorLMargin') 
    //     y:                  dataShown('t2', 'y') 
    //     visible:            true //dataShown('t2', 'visible')
    //     color: "blue"
    // }
    // Rectangle{
    //     id: rec_t3
    //     height:             dataShown('t3', 'height') 
    //     width:              dataShown('t3', 'width') 
    //     anchors.left:       dataShown('t3', 'anchorL') 
    //     anchors.leftMargin: dataShown('t3', 'anchorLMargin') 
    //     y:                  dataShown('t3', 'y') 
    //     visible:            true //dataShown('t3', 'visible')
    //     color: "green"
    // }

    // Rectangle{
    //     id: rec_b1
    //     height:             dataShown('b1', 'height') 
    //     width:              dataShown('b1', 'width') 
    //     anchors.left:       dataShown('b1', 'anchorL') 
    //     anchors.leftMargin: dataShown('b1', 'anchorLMargin') 
    //     y:                  dataShown('b1', 'y') 
    //     visible:            true //dataShown('b1', 'visible')
    //     color: "dark blue"
    // }
    // Rectangle{
    //     id: rec_b2
    //     height:             dataShown('b2', 'height') 
    //     width:              dataShown('b2', 'width') 
    //     anchors.left:       dataShown('b2', 'anchorL') 
    //     anchors.leftMargin: dataShown('b2', 'anchorLMargin') 
    //     y:                  dataShown('b2', 'y') 
    //     visible:            true //dataShown('b2', 'visible')
    //     color: "purple"
    // }
    // Rectangle{
    //     id: rec_b3
    //     height:             dataShown('b3', 'height') 
    //     width:              dataShown('b3', 'width') 
    //     anchors.left:       dataShown('b3', 'anchorL') 
    //     anchors.leftMargin: dataShown('b3', 'anchorLMargin') 
    //     y:                  dataShown('b3', 'y') 
    //     visible:            true //dataShown('b3', 'visible')
    //     color: "pink"
    // }

    Text {
        id: t1 //topIcon
        height:             dataShown('t1', 'height') 
        width:              dataShown('t1', 'width') 
        verticalAlignment:  dataShown('t1', 'vertiAlign') 
        horizontalAlignment:dataShown('t1', 'horizAlign') 
        anchors.left:       dataShown('t1', 'anchorL') 
        anchors.leftMargin: dataShown('t1', 'anchorLMargin') 
        y:                  dataShown('t1', 'y') 
        font.pixelSize:     dataShown('t1', 'fontPixSize') 
        renderType:         dataShown('t1', 'renderType') 
        text:               dataShown('t1', 'text')  
        color:              dataShown('t1', 'color') 
        visible:            dataShown('t1', 'visible') 
        bottomPadding:      dataShown('t1', 'padding') //-10.0
    }

    Text {
        id: t2 //topText
        height:             dataShown('t2', 'height') 
        width:              dataShown('t2', 'width') 
        verticalAlignment:  dataShown('t2', 'vertiAlign') 
        horizontalAlignment:dataShown('t2', 'horizAlign') 
        anchors.left:       dataShown('t2', 'anchorL') 
        anchors.leftMargin: dataShown('t2', 'anchorLMargin') 
        y:                  dataShown('t2', 'y') 
        font.pixelSize:     dataShown('t2', 'fontPixSize') 
        renderType:         dataShown('t2', 'renderType') 
        text:               dataShown('t2', 'text')  
        color:              dataShown('t2', 'color') 
        visible:            dataShown('t2', 'visible')  
        bottomPadding:      dataShown('t2', 'padding') //-10.0
    }

    Text {
        id: t3 //topUnitText
        height:             dataShown('t3', 'height') 
        width:              dataShown('t3', 'width') 
        verticalAlignment:  dataShown('t3', 'vertiAlign') 
        horizontalAlignment:dataShown('t3', 'horizAlign') 
        anchors.left:       dataShown('t3', 'anchorL') 
        anchors.leftMargin: dataShown('t3', 'anchorLMargin') 
        y:                  dataShown('t3', 'y') 
        font.pixelSize:     dataShown('t3', 'fontPixSize') 
        renderType:         dataShown('t3', 'renderType') 
        text:               dataShown('t3', 'text')  
        color:              dataShown('t3', 'color') 
        visible:            dataShown('t3', 'visible')
        bottomPadding:      dataShown('t3', 'padding') //-10.0
    }

    Text {
        id: b1 //bottomIcon
        height:             dataShown('b1', 'height') 
        width:              dataShown('b1', 'width') 
        verticalAlignment:  dataShown('b1', 'vertiAlign') 
        horizontalAlignment:dataShown('b1', 'horizAlign') 
        anchors.left:       dataShown('b1', 'anchorL') 
        anchors.leftMargin: dataShown('b1', 'anchorLMargin') 
        y:                  dataShown('b1', 'y') 
        font.pixelSize:     dataShown('b1', 'fontPixSize') 
        renderType:         dataShown('b1', 'renderType') 
        text:               dataShown('b1', 'text')  
        color:              dataShown('b1', 'color') 
        visible:            dataShown('b1', 'visible') 
        topPadding:         dataShown('b1', 'padding') //-10.0
        //bottomPadding: 30.0
        //topPadding: -10.0
    }

    Text {
        id: b2 //bottomText    
        height:             dataShown('b2', 'height') 
        width:              dataShown('b2', 'width') 
        verticalAlignment:  dataShown('b2', 'vertiAlign') 
        horizontalAlignment:dataShown('b2', 'horizAlign') 
        anchors.left:       dataShown('b2', 'anchorL') 
        anchors.leftMargin: dataShown('b2', 'anchorLMargin') 
        y:                  dataShown('b2', 'y') 
        font.pixelSize:     dataShown('b2', 'fontPixSize') 
        renderType:         dataShown('b2', 'renderType') 
        text:               dataShown('b2', 'text')  
        color:              dataShown('b2', 'color') 
        visible:            dataShown('b2', 'visible') 
        topPadding:         dataShown('b2', 'padding') //-10.0
    }

    Text {
        id: b3 //bottomUnitText
        height:             dataShown('b3', 'height') 
        width:              dataShown('b3', 'width') 
        verticalAlignment:  dataShown('b3', 'vertiAlign') 
        horizontalAlignment:dataShown('b3', 'horizAlign') 
        anchors.left:       dataShown('b3', 'anchorL') 
        anchors.leftMargin: dataShown('b3', 'anchorLMargin') 
        y:                  dataShown('b3', 'y') 
        font.pixelSize:     dataShown('b3', 'fontPixSize') 
        renderType:         dataShown('b3', 'renderType') 
        text:               dataShown('b3', 'text')  
        color:              dataShown('b3', 'color') 
        visible:            dataShown('b3', 'visible') 
        topPadding:         dataShown('b3', 'padding') //-10.0
    }
    
    function dataShown(caller, properties){
        var height = singleLine ? itemParent.height : itemParent.height / 2
        var fontPixelSize =  height * fontHeightRatio * fontSizeScale

        if (iconPosition === true) {                            // true = icons on right
            // DIFFERENT VARIABLES WITH ICONS ON RIGHT
            switch (properties) {               
                case 'width':
                    //return setUiVisibleWidth(caller)
                    var a = (showSeparately ? 1 : 2) * iconTextMetrics.width / iconTextMetrics.height * height * fontSizeScale
                    var b = speedTextMetrics.width / speedTextMetrics.height * height * fontSizeScale
                    var c = unitTextMetrics.width / unitTextMetrics.height * height * fontSizeScale
                    var d = iconTextMetrics.width / iconTextMetrics.height * height * fontSizeScale
                    switch (caller) {
                        case 't1': return b                     //a
                        case 't2': return c                     //b
                        case 't3': return a                     //c
                        case 'b1': return b                     //d
                        case 'b2': return c                     //b
                        case 'b3': return d                     //c
                    }  
                case 'horizAlign':
                    switch (caller) {
                        // left : text in t2 & b2  |  right : text in t1 & b1  |  left Alt : see left
                        case 't1': return Text.AlignRight
                        case 't2': return Text.AlignLeft
                        case 't3': return Text.AlignVCenter
                        case 'b1': return Text.AlignRight
                        case 'b2': return Text.AlignLeft
                        case 'b3': return Text.AlignVCenter
                    }   
                case 'anchorL':
                    switch (caller) {
                        case 't1': return offsetItem.right
                        case 't2': return t1.right
                        case 't3': return showUnits ? t2.right : t1.right

                        case 'b1': return anchorLfunction()     //(singleLine && showIcons) ? t3.right : (singleLine ? t2.right : offsetItem.right) //showIcon
                        case 'b2': return b1.right
                        case 'b3': return showUnits ? b2.right : b1.right
                    } 
                case 'text':
                    switch (caller) {
                        case 't1': return speedText(showSeparately ? (swapDownUp ? upSpeed : downSpeed) : downSpeed + upSpeed)
                        case 't2': return speedUnit(showSeparately ? (swapDownUp ? upSpeed : downSpeed) : downSpeed + upSpeed)
                        case 't3': return showSeparately ? (swapDownUp ? iconStyle(0) : iconStyle(1)) : iconStyle(2)
                        case 'b1': return speedText(swapDownUp ? downSpeed : upSpeed)
                        case 'b2': return speedUnit(swapDownUp ? downSpeed : upSpeed)
                        case 'b3': return swapDownUp ? iconStyle(1) : iconStyle(0)
                    }   
                case 'visible':  
                    return setUiVisible(caller)
            }
        } else {                                                // false = icons on left [default]
            // DIFFERENT VARIABLES WITH ICONS ON LEFT
            switch (properties) {
                case 'width':
                    //return setUiVisibleWidth(caller)
                    var leftUpIconWidth = (showSeparately ? 1 : 2) * iconTextMetrics.width / iconTextMetrics.height * height * fontSizeScale
                    var leftTextWidth = speedTextMetrics.width / speedTextMetrics.height * height * fontSizeScale
                    var leftUnitWidth = unitTextMetrics.width / unitTextMetrics.height * height * fontSizeScale
                    var leftDownIconWidth = iconTextMetrics.width / iconTextMetrics.height * height * fontSizeScale
                    switch (caller) {
                        case 't1': return leftUpIconWidth       // icon
                        case 't2': return leftTextWidth         // text
                        case 't3': return leftUnitWidth         // unit
                        case 'b1': return leftDownIconWidth     // icon
                        case 'b2': return leftTextWidth         // text
                        case 'b3': return leftUnitWidth         // unit
                    }      
                case 'horizAlign':
                    switch (caller) {
                        // left : text in t2 & b2  |  right : text in t1 & b1  |  left Alt : see left
                        case 't1': return Text.AlignVCenter
                        case 't2': return Text.AlignRight
                        case 't3': return Text.AlignLeft
                        case 'b1': return Text.AlignVCenter
                        case 'b2': return Text.AlignRight
                        case 'b3': return Text.AlignLeft
                    }  
                case 'anchorL':
                    switch (caller) {
                        case 't1': return offsetItem.right
                        case 't2': return showIcons ? t1.right : offsetItem.right
                        case 't3': return t2.right
                        
                        case 'b1': return (singleLine && showUnits) ? t3.right : (singleLine ? t2.right : offsetItem.right)
                        case 'b2': return showIcons ? b1.right : ((singleLine && showUnits) ? t3.right : (singleLine ? t2.right : offsetItem.right))
                        case 'b3': return b2.right
                    }
                case 'text':
                    switch (caller) {
                        case 't1': return showSeparately ? (swapDownUp ? iconStyle(0) : iconStyle(1)) : iconStyle(2)
                        case 't2': return speedText(showSeparately ? (swapDownUp ? upSpeed : downSpeed) : downSpeed + upSpeed)
                        case 't3': return speedUnit(showSeparately ? (swapDownUp ? upSpeed : downSpeed) : downSpeed + upSpeed)
                        case 'b1': return swapDownUp ? iconStyle(1) : iconStyle(0)
                        case 'b2': return speedText(swapDownUp ? downSpeed : upSpeed)
                        case 'b3': return speedUnit(swapDownUp ? downSpeed : upSpeed)
                    } 
                case 'visible':  
                    return setUiVisible(caller)
            }
        }
        // SAME VARIABLES WITH ICONS EITHER SIDE
        switch (properties) {
            case 'height': return  singleLine ? itemParent.parent.height : itemParent.parent.height / 2
            case 'vertiAlign': //return  Text.AlignVCenter Text.AlignTop
                switch (caller) {
                    case 't1': return Text.AlignBottom          //Text.AlignVCenter
                    case 't2': return Text.AlignBottom          //Text.AlignVCenter
                    case 't3': return Text.AlignBottom          //Text.AlignVCenter
                    case 'b1': return Text.AlignTop             //Text.AlignVCenter
                    case 'b2': return Text.AlignTop             //Text.AlignVCenter 
                    case 'b3': return Text.AlignTop             //Text.AlignVCenter
                }  
            case 'fontPixSize': return height * fontHeightRatio * fontSizeScale
            case 'anchorLMargin': return fontPixelSize * marginFactor
            case 'y':
                switch (caller) {
                    case 't1': return 0
                    case 't2': return 0
                    case 't3': return 0
                    case 'b1': return singleLine ? 0 : itemParent.height / 2
                    case 'b2': return singleLine ? 0 : itemParent.height / 2
                    case 'b3': return singleLine ? 0 : itemParent.height / 2
                }    
            case 'renderType': return Text.NativeRendering
            case 'color': return theme.textColor
            case 'padding': return layoutPadding    
        }    
    }

    function setUiVisible(caller) {
        // UI ELEMENTS VISIBLE BASED ON hideInactive

        if (hideInactive === true) {
            if (downSpeed === 0 && upSpeed === 0) {
                t1.visible = false
                t2.visible = false
                t3.visible = false            
                b1.visible = false
                b2.visible = false
                b3.visible = false
            } else {
                t1.visible = iconPosition ? true : showIcons
                t2.visible = iconPosition ? showUnits : true
                t3.visible = iconPosition ? showIcons : showUnits
                b1.visible = iconPosition ? showSeparately : showSeparately && showIcons
                b2.visible = iconPosition ? showSeparately && showUnits : showSeparately
                b3.visible = iconPosition ? showSeparately && showIcons : showSeparately && showUnits
            }
        } else {
            // UI ELEMENTS VISIBLE BASED ON iconPosition
            t1.visible = iconPosition ? true : showIcons
            t2.visible = iconPosition ? showUnits : true
            t3.visible = iconPosition ? showIcons : showUnits
            b1.visible = iconPosition ? showSeparately : showSeparately && showIcons
            b2.visible = iconPosition ? showSeparately && showUnits : showSeparately
            b3.visible = iconPosition ? showSeparately && showIcons : showSeparately && showUnits
        }
        switch (caller) {
            case 't1': return iconPosition ? true : showIcons
            case 't2': return iconPosition ? showUnits : true
            case 't3': return iconPosition ? showIcons : showUnits
            case 'b1': return iconPosition ? showSeparately : showSeparately && showIcons
            case 'b2': return iconPosition ? showSeparately && showUnits : showSeparately
            case 'b3': return iconPosition ? showSeparately && showIcons : showSeparately && showUnits
        }  
    }

    function anchorLfunction() {
        switch (singleLine) {
            case false :    // one above other
                return offsetItem.right

            case true :     // side by side
                switch (showUnits) {
                    case false : 
                        if (showIcons === false) {
                            return t1.right
                        } else {
                            return t3.right
                        }
                    case true :
                        if (showIcons === false) {
                            return t2.right
                        } else {
                            return t3.right
                        }
                }
        }
    }

    function iconStyle(a) {

        var iconArray = []

        iconArray = iconType.replace(' ', ',').split(",")

        switch(a) {
            case 0: return iconArray[1] 
            case 1: return iconArray[0]
            case 2: return iconArray[1] + iconArray[0]
        }
    }

     function getDecimalPlace() {
        return Number.parseFloat('1000').toFixed( decimalPlace );
    }

    function speedText(value) {
        // data communication 1 kilobit = 1000 bits, while in data storage 1 Kilobyte = 1024 Bytes
        var m    = getBinDec                    // binary 1024 | decimal 1000
        var deci = decimalPlace                 // # of decimal places
        var kilo = m;                           // One Kilo is 1024 b/B
        var mega = m * m;                       // One MB is 1024 Kb/B
        var giga = m * m * m;                   // One GB is 1024 Mb/B
        var tera = m * m * m * m;               // One TB is 1024 Gb/B

        if      (value < kilo)  return value;                        // return bytes if less than a Kx
        else if (value < mega)  return (value / kilo).toFixed(deci); // return Kx if less than a Mx
        else if (value < giga)  return (value / mega).toFixed(deci); // return Mx if less than a Gx
        else                    return (value / giga).toFixed(deci); // return Gx if less than a Tx
    }

    function speedUnit(value) {
        // data communication 1 kilobit = 1000 bits, while in data storage 1 Kilobyte = 1024 Bytes
        var m    = getBinDec                    // binary 1024 | decimal 1000
        var kilo = m;                           // One Kilo is 1024 x
        var mega = m * m;                       // One MB is 1024 Kx
        var giga = m * m * m;                   // One GB is 1024 Mx
        var tera = m * m * m * m;               // One TB is 1024 Gx
        
        if (value < kilo)       return shortUnits ? (boolUnits ? 'b' : 'B') : (boolUnits ? 'b/s'  : 'B/s' ); // return bytes if less than a KB
        else if (value < mega)  return shortUnits ? (boolUnits ? 'k' : 'K') : (boolUnits ? 'Kb/s' : 'KB/s'); // return KB if less than a MB
        else if (value < giga)  return shortUnits ? (boolUnits ? 'm' : 'M') : (boolUnits ? 'Mb/s' : 'MB/s'); // return MB if less than a GB
        else                    return shortUnits ? (boolUnits ? 'g' : 'G') : (boolUnits ? 'Gb/s' : 'GB/s'); // return GB if less than a TB                    
    }

    //2nd
    function addSources() {

        var count = 0;
        var checkedCount = 0
        var sensors = [];
        var netPath = []

        sensorList = [];      
        sensors = dbusData.allSensors("network/");

        //console.log("sensors: from CR " + sensors)
        // qml: Network-sensors: 
        // network/all,
        // network/all/download,
        // network/all/downloadBits,
        // network/all/totalDownload
        // network/all/totalUpload,
        // network/all/upload,
        // network/all/uploadBits,
        // network/wlp2s0,
        // network/wlp2s0/download,
        // network/wlp2s0/downloadBits,
        // network/wlp2s0/ipv4address,
        // network/wlp2s0/ipv4dns,
        // network/wlp2s0/ipv4gateway,
        // network/wlp2s0/ipv4subnet,
        // network/wlp2s0/ipv4withPrefixLength,
        // network/wlp2s0/ipv6address,
        // network/wlp2s0/ipv6dns,
        // network/wlp2s0/ipv6gateway,
        // network/wlp2s0/ipv6subnet,
        // network/wlp2s0/ipv6withPrefixLength,
        // network/wlp2s0/network,   <<< here 
        // network/wlp2s0/signal,
        // network/wlp2s0/totalDownload,
        // network/wlp2s0/totalUpload,
        // network/wlp2s0/upload,
        // network/wlp2s0/uploadBits,

        var duplicateCheck = {}

        for (var idx = 0; idx < sensors.length; idx++) {

            if (sensors[idx].endsWith("/network")) {

                netPath = { path:sensors[idx].replace("/network", ""),
                            name:dbusData.stringData(sensors[idx]), 
                            index:idx, 
                            checked:true }
                
                netInterfaces[count] =      netPath                     // ADD INTERFACE ARRAY DATA TO MULTI DEM ARRAY
                count += 1;
            }                
        }
        //###################################################################################################
        // HERE I NEED TO CHECK IF THE INTERFACE DATA ALREADY EXISTS - MATCH INDEX? MATCH PATH?

        // var path1
        // var path2

        // for (var i = 0; i < netInterfaces.length; i++) {
        //     path1 = netInterfaces[i].path
        //     for (var ii = 0; ii < netInterfaces.length; ii++) {
        //         path2 = netInterfaces[i].path

        //         if (path1 === path2) {      // PATH MATCHES< IS IT A DUPLICATE???
        //             if (i === ii) {
        //                 console.log("MATCH A: " + path1 + " VS " + path2 + " i & ii: " + i + " - " + ii)
        //                 continue    
        //             } 
        //             // else {
        //             //     console.log("NO MATCH B: " + path1 + " VS " + path2 + " i & ii: " + i + " - " + ii)
        //             // }


        //         } else {
        //             console.log("MATCH C: - NO MATCH")
        //         }
        //     }

        // }
        //##############################################################################################
        // COMPARE EXISTING INTERFACE SETTINGS WITH DISCOVERED INTERFACES
        // IF USER SETS AN INTERFACE TO NOT BE MONITORED, STORED SETTINGS WILL 
        // HAVE IT AS CHECKED:FALSE.  ADD THIS CHANGE TO netInterfaces ARRAY.
        // IF A NEW INTERFACE IS DISCOVERED, IT WILL BE ADDED / PUSHED TO THE SETTINGS STORE.

        var pcn = plasmoid.configuration.netSources
        var ni =  netInterfaces

        for (var i = 0; i < pcn.length; i++) {                  // LOOP THROUGH FIRST STORED SETTINGS ARRAY
            
            for (var ii = 0; ii < ni.length; ii++) {            // LOOP THROUGH SECOND netInterfaces ARRAY
                
                if (pcn[i].path === ni[ii].path) {              // PATHS MATCH - NOW COMPARE 'CHECKED'

                    if (pcn[i].checked !== ni[ii].checked) {    // DIFFERENT CHECKED MARK, PCN HAS BEEN UPDATED. MAKE NI SAME AS PCN
                        netInterfaces[ii].checked = pcn[i].checked
                    } 
                }
                // console.log("netInterfaces: PATH: " + netInterfaces[ii].path + 
                //                          ", NAME: " + netInterfaces[ii].name + 
                //                         ", INDEX: " + netInterfaces[ii].index + 
                //                       ", CHECKED: " + netInterfaces[ii].checked)
            }
        }

        plasmoid.configuration.netSources = netInterfaces       // PUSH FOUND INTERFACES TO STORED SETTINGS 
        pcn = plasmoid.configuration.netSources                 // REFRESH DATA IN VARIABLE

        netDataBits =   [];                                     // RESET ARRAYS
        netDataByte =   [];
        netDataTotal =  [];

        for (var i = 0; i < pcn.length; i++) {                  // LOOP THROUGH FIRST STORED SETTINGS ARRAY
            if (pcn[i].checked === true) {
               
                sensorList.push(pcn[i].path + "/downloadBits",  // CREATE ARRAY TO SUBSCRIBE TO AND POLL FROM DBUS
                                pcn[i].path + "/uploadBits",
                                pcn[i].path + "/download", 
                                pcn[i].path + "/upload",
                                pcn[i].path + "/totalDownload",
                                pcn[i].path + "/totalUpload",
                                pcn[i].path + "/signal")

                // INITIALISE AND SET GLOBAL VARIABLES BASED ON CHECKED:TRUE INTERFACES
                netDataBits[checkedCount] =   { down:  0, up:  0 };
                netDataByte[checkedCount] =   { down:  0, up:  0 };
                netDataTotal[checkedCount] =  { down:  0, up:  0 };

                checkedCount += 1
            }
        }
        netDataAccumulator =        { down:  0, up:  0 };
        dbusData.subscribe(sensorList);
        //numberOfNets = count;
        numCheckedNets = checkedCount
        ready = true;
    }

    Connections {
        target: plasmoid.configuration
        function onNetSourcesChanged() {            // TRIGGERED WHEN INTERFACE CHECKED CHANGED IN SETTINGS
            dbusData.unsubscribe(sensorList)
            if ( !ready )   return
            else            addSources()
        }
    }

    Connections {
        target: sysMonitor
        
        function onStatsUpd(pathKeys, values) {
            // TRIGGERED EVERY 500 MILISECONDS

            //console.log("CR-onStatsUpd: "+ pathKeys + " || "+ values)
            // qml: CR-onStatsUpd: network/wlp2s0/download,network/wlp2s0/upload || 334,128
            // qml: CR-onStatsUpd: network/wlp2s0/downloadBits,network/wlp2s0/totalDownload,network/wlp2s0/uploadBits,network/wlp2s0/totalUpload || 0,49913032,0,169202

            var sensorPathKey;                                                  // PATH AND KEY OF DBUS FOUND INTERFACE VALUE
            var configPath;                                                     // PATH OF INTERFACE IN SETTINGS / CONFIG
            var slot = 0
            var pcn = plasmoid.configuration.netSources

            if ( !ready )  return;

            for (var i = 0; i < pcn.length; i++) {                              // LOOP SETTINGS INTERFACE AND GRAB PATH OF CHECKED:TRUE 

                if (pcn[i].checked === true) {
                    configPath = pcn[i].path
                }else{
                    continue                                                    // SKIP SETTINGS INTERFACE THAT ISNT CHECKED:TRUE 
                }                            

                for ( var ii = 0; ii < pathKeys.length; ii++ ) {                // LOOP DBUS SENSOR PATH & KEYS

                    sensorPathKey = pathKeys[ii];

                    if (sensorPathKey.indexOf(configPath) == 0) {

                        if (sensorPathKey == configPath + "/download") {         // DOWNLOAD IN BYTES
                            netDataByte[slot].down  = values[ii]       
                        }                        
                        if (sensorPathKey == configPath + "/downloadBits") {     // DOWNLOAD IN BITS
                            netDataBits[slot].down  = values[ii]                            
                        }
                        if (sensorPathKey == configPath + "/totalDownload") {    // TOTAL DOWNLOAD IN BYTES:
                            netDataTotal[slot].down = values[ii]
                        }   
                        if (sensorPathKey == configPath + "/upload") {           // UPLOAD IN BYTES
                            netDataByte[slot].up    = values[ii]       
                        }                                             
                        if (sensorPathKey == configPath + "/uploadBits") {       // UPLOAD IN BITS
                            netDataBits[slot].up    = values[ii]      
                        }
                        if (sensorPathKey == configPath + "/totalUpload") {      // TOTAL UPLOAD IN BYTES:
                            netDataTotal[slot].up   = values[ii]
                        }
                    }
                }
                slot += 1
            }
            if (accumulator) {                                                  // ACCUMULATOR SWITCHED ON
                getAccumulator()
            }
        }

        function onUpdateUi() {
            // THIS FUNCTION IS TRIGGERED BY updateInterval 
            setNetData()

            setUiVisible('')
        }

        function setNetData() {
            // THIS FUNCTION IS TRIGGERED BY updateInterval 

            if (numCheckedNets == 0) {                    // NO NETWORKS ENABLED|CHECKED [undefined fix]
                downSpeed = 0
                upSpeed   = 0
            } else {                                    // ONE OR MORE NETWORKS ENABLED|CHECKED
                
                if (accumulator) {                      // ACCUMULATOR SWITCHED ON
                    downSpeed = netDataAccumulator.down
                    upSpeed   = netDataAccumulator.up

                    netDataAccumulator.down =   0       // RESET ACCUMULATOR DATA FOR NEXT COUNT
                    netDataAccumulator.up =     0
                    accumulatorCounter =        0       // RESET ACCUMULATOR COUNTER, USED TO TRIGGER updateInterval AT THE CORRECT TIME

                } else {
                    var values = multiNetAddition()     // ADD VALUES FOR MULTIPLE ACTIVE NETWORKS
                    downSpeed = values[0]
                    upSpeed   = values[1]
                }
            } 
        }

        function multiNetAddition(){
            // IF MULTIPLE INTERFACES ARE CHECKED, DATA COLLECTED FROM EACH NEEDS TO BE ADDED TOGETHER AND DISPLAYED

            var downloaded     = 0
            var uploaded       = 0

            if (speedUnits === 'bits') {                 // BITS
                for (var i = 0; i < netDataBits.length; i++) {
                    downloaded += netDataBits[i].down;
                    uploaded   += netDataBits[i].up
                }
            } else {                                    // BYTES
                for (var i = 0; i < netDataByte.length; i++) {
                    downloaded += netDataByte[i].down;
                    uploaded   += netDataByte[i].up
                }
            }
            return [ downloaded, uploaded ]
        }

        function getAccumulator() {

            // IF ACTIVATED, WILL TRIGGER EVRY 500 MILISECONDS

            var values = multiNetAddition()
            var countx = updateInterval / 500                   // GET NUMBER OF TICKS FOR COUNTER

            if (accumulatorCounter < countx) {                  // STARTING CODE [ STARTS AT 500 ]

                    netDataAccumulator.down   += values[0]
                    netDataAccumulator.up     += values[1]
            } //else 
            if (accumulatorCounter === countx) {                // ENDING CODE

                    netDataAccumulator.down   += values[0]      //netDataBits[i].down
                    netDataAccumulator.up     += values[1]      //netDataBits[i].up
            } 
            accumulatorCounter            += 1
            // console.log("updateInterval:                    " + updateInterval)
            // console.log("-- accumulatorCounter out:         " + accumulatorCounter)
            // console.log("netDataBits[i].down:               " + values[0]) //netDataBits[i].down)
            // console.log("netDataBits[i].up:                 " + values[1]) //netDataBits[i].up)
            // console.log("netDataAccumulator.down:           " + netDataAccumulator.down)
            // console.log("netDataAccumulator.up:             " + netDataAccumulator.up)
        }
    }
    
    Component.onCompleted: {
        addSources();
    }
    
    Component.onDestruction: {
        dbusData.unsubscribe(sensorList);
    }
}
