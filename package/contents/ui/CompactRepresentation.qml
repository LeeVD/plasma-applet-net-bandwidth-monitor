/*
 * Copyright 2022  LeeVD <thoth360@hotmail.com.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
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
import org.kde.plasma.components 3.0 as PlasmaComponents    // used in tooltip section
import org.kde.plasma.extras 2.0 as PlasmaExtras            // used in tooltip section

Item {
    id: itemParent
    anchors.fill: parent

    property double marginFactor: 0.2

    property double downSpeed: {
        var speed = 0
        // for (var key in speedData) {
        //     if (interfacesWhitelistEnabled && interfacesWhitelist.indexOf(key) === -1) {
        //         continue
        //     }
        //     speed += speedData[key].down  // assigns just the down value
        // }
        speed += netValueDown
        return speed
    }

    property double upSpeed: {
        var speed = 0
        // for (var key in speedData) {
        //     if (interfacesWhitelistEnabled && interfacesWhitelist.indexOf(key) === -1) {
        //         continue
        //     }
        //     speed += speedData[key].up
        // }
        speed += netValueUp
        return speed
    }

    property bool singleLine: {
        if (!showSeparately) {
            return true
        }
        switch (speedLayout) {
            case 'rows':    return false
            case 'columns': return true
            default:        return height / 2 * fontSizeScale < theme.smallestFont.pixelSize && plasmoid.formFactor !== PlasmaCore.Types.Vertical
        }
    }

    property double marginWidth:        speedTextMetrics.font.pixelSize * marginFactor
    property double iconWidth:          showIcons ? iconTextMetrics.width + marginWidth : 0
    property double doubleIconWidth:    showIcons ? (doubleIconTextMetrics.width + marginWidth) : 0
    property double speedWidth:         speedTextMetrics.width + 2*marginWidth
    property double unitWidth:          showUnits ? unitTextMetrics.width + marginWidth : 0


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

    Layout.preferredWidth: Layout.minimumWidth
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
        text: decimalPlace      //'1000.0'
        font.pixelSize: 64    
    }

    TextMetrics {
        id: unitTextMetrics
        text: {
            if (speedUnits === 'bits') {
                return shortUnits ? 'm' : 'Mb/s'
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
    // FOR TESTING
    // Rectangle{
    //     id: rec_t1
    //     height:             dataShown('t1', 'height') 
    //     width:              dataShown('t1', 'width') 
    //     anchors.left:       dataShown('t1', 'anchorL') 
    //     anchors.leftMargin: dataShown('t1', 'anchorLMargin') 
    //     y:                  dataShown('t1', 'y') 
    //     color: "red"
    //     visible:            dataShown('t1', 'visible')

    // }
    // Rectangle{
    //     id: rec_t2
    //     height:             dataShown('t2', 'height') 
    //     width:              dataShown('t2', 'width') 
    //     anchors.left:       dataShown('t2', 'anchorL') 
    //     anchors.leftMargin: dataShown('t2', 'anchorLMargin') 
    //     y:                  dataShown('t1', 'y') 
    //     color: "blue"
    //     visible:            dataShown('t2', 'visible')

    // }
    // Rectangle{
    //     id: rec_t3
    //     height:             dataShown('t3', 'height') 
    //     width:              dataShown('t3', 'width') 
    //     anchors.left:       dataShown('t3', 'anchorL') 
    //     anchors.leftMargin: dataShown('t3', 'anchorLMargin') 
    //     y:                  dataShown('t1', 'y') 
    //     color: "green"
    //     visible:            dataShown('t3', 'visible')

    // }

    // Rectangle{
    //     id: rec_b1
    //     height:             dataShown('b1', 'height') 
    //     width:              dataShown('b1', 'width') 
    //     anchors.left:       dataShown('b1', 'anchorL') 
    //     anchors.leftMargin: dataShown('b1', 'anchorLMargin') 
    //     y:                  dataShown('b1', 'y') 
    //     color: "dark blue"
    //     visible:            dataShown('b1', 'visible')

    // }
    // Rectangle{
    //     id: rec_b2
    //     height:             dataShown('b2', 'height') 
    //     width:              dataShown('b2', 'width') 
    //     anchors.left:       dataShown('b2', 'anchorL') 
    //     anchors.leftMargin: dataShown('b2', 'anchorLMargin') 
    //     y:                  dataShown('b2', 'y') 
    //     color: "purple"
    //     visible:            dataShown('b2', 'visible')
    // }
    // Rectangle{
    //     id: rec_b3
    //     height:             dataShown('b3', 'height') 
    //     width:              dataShown('b3', 'width') 
    //     anchors.left:       dataShown('b3', 'anchorL') 
    //     anchors.leftMargin: dataShown('b3', 'anchorLMargin') 
    //     y:                  dataShown('b3', 'y') 
    //     color: "pink"
    //     visible:            dataShown('b3', 'visible')
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
        //topPadding: 30.0
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
        if (iconPosition === true) {   // true = icons on right
            switch (properties) {               
                case 'height': return  singleLine ? itemParent.parent.height : itemParent.parent.height / 2
                    // switch (caller) {
                    //     case 't1': return singleLine ? parent.height :  parent.height / 2
                    //     case 't2': return singleLine ? parent.height :  parent.height / 2
                    //     case 't3': return singleLine ? parent.height :  parent.height / 2
                    //     case 'b1': return singleLine ? itemParent.parent.height :  itemParent.parent.height / 2
                    //     case 'b2': return singleLine ? itemParent.parent.height :  itemParent.parent.height / 2
                    //     case 'b3': return singleLine ? itemParent.parent.height :  itemParent.parent.height / 2                   
                    // }
                case 'width':
                    var rightIconAWidth = (showSeparately ? 1 : 2) * iconTextMetrics.width / iconTextMetrics.height * height * fontSizeScale
                    var rightTextWidth = speedTextMetrics.width / speedTextMetrics.height * height * fontSizeScale
                    var rightUnitWidth = unitTextMetrics.width / unitTextMetrics.height * height * fontSizeScale
                    var rightIconBWidth = iconTextMetrics.width / iconTextMetrics.height * height * fontSizeScale
                    switch (caller) {
                        case 't1': return rightTextWidth 
                        case 't2': return rightUnitWidth 
                        case 't3': return rightIconAWidth
                        case 'b1': return rightTextWidth 
                        case 'b2': return rightUnitWidth 
                        case 'b3': return rightIconBWidth
                    }                     
                case 'vertiAlign': //return  Text.AlignVCenter Text.AlignTop
                    switch (caller) {
                        case 't1': return Text.AlignBottom //Text.AlignVCenter
                        case 't2': return Text.AlignBottom //Text.AlignVCenter
                        case 't3': return Text.AlignBottom //Text.AlignVCenter
                        case 'b1': return Text.AlignTop //Text.AlignVCenter
                        case 'b2': return Text.AlignTop //Text.AlignVCenter 
                        case 'b3': return Text.AlignTop //Text.AlignVCenter
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
                        case 'b1': return anchorLfunction() //(singleLine && showIcons) ? t3.right : (singleLine ? t2.right : offsetItem.right) //showIcon
                        case 'b2': return b1.right
                        case 'b3': return showUnits ? b2.right : b1.right
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
                case 'text':
                    switch (caller) {
                        case 't1': return speedText(showSeparately ? (swapDownUp ? upSpeed : downSpeed) : downSpeed + upSpeed)
                        case 't2': return speedUnit(showSeparately ? (swapDownUp ? upSpeed : downSpeed) : downSpeed + upSpeed)
                        case 't3': return showSeparately ? (swapDownUp ? iconStyle(0) : iconStyle(1)) : iconStyle(2)
                        case 'b1': return speedText(swapDownUp ? downSpeed : upSpeed)
                        case 'b2': return speedUnit(swapDownUp ? downSpeed : upSpeed)
                        case 'b3': return swapDownUp ? iconStyle(1) : iconStyle(0)
                    }       
                case 'color': return theme.textColor
                case 'visible':  
                    switch (caller) {
                        case 't1': return true
                        case 't2': return showUnits
                        case 't3': return showIcons
                        case 'b1': return showSeparately
                        case 'b2': return showSeparately && showUnits
                        case 'b3': return showSeparately && showIcons
                    }         
                case 'padding': return getPadding
            }
        } else {                        // false = icons on left [default]
            switch (properties) {
                case 'height': return  singleLine ? itemParent.height : itemParent.height / 2
                case 'width':
                    var leftUpIconWidth = (showSeparately ? 1 : 2) * iconTextMetrics.width / iconTextMetrics.height * height * fontSizeScale
                    var leftTextWidth = speedTextMetrics.width / speedTextMetrics.height * height * fontSizeScale
                    var leftUnitWidth = unitTextMetrics.width / unitTextMetrics.height * height * fontSizeScale
                    var leftDownIconWidth = iconTextMetrics.width / iconTextMetrics.height * height * fontSizeScale
                    switch (caller) {
                        case 't1': return leftUpIconWidth   // icon
                        case 't2': return leftTextWidth     // text
                        case 't3': return leftUnitWidth     // unit
                        case 'b1': return leftDownIconWidth // icon
                        case 'b2': return leftTextWidth     // text
                        case 'b3': return leftUnitWidth     // unit
                    }                     
                case 'vertiAlign': //return  Text.AlignVCenter
                    switch (caller) {
                        case 't1': return Text.AlignBottom //Text.AlignVCenter
                        case 't2': return Text.AlignBottom //Text.AlignVCenter
                        case 't3': return Text.AlignBottom //Text.AlignVCenter
                        case 'b1': return Text.AlignTop //Text.AlignVCenter
                        case 'b2': return Text.AlignTop //Text.AlignVCenter
                        case 'b3': return Text.AlignTop //Text.AlignVCenter
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
                case 'fontPixSize': return  height * fontHeightRatio * fontSizeScale
                case 'anchorLMargin': return fontPixelSize * marginFactor //font.pixelSize * marginFactor
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
                case 'text':
                    switch (caller) {
                        case 't1': return showSeparately ? (swapDownUp ? iconStyle(0) : iconStyle(1)) : iconStyle(2)
                        case 't2': return speedText(showSeparately ? (swapDownUp ? upSpeed : downSpeed) : downSpeed + upSpeed)
                        case 't3': return speedUnit(showSeparately ? (swapDownUp ? upSpeed : downSpeed) : downSpeed + upSpeed)
                        case 'b1': return swapDownUp ? iconStyle(1) : iconStyle(0)
                        case 'b2': return speedText(swapDownUp ? downSpeed : upSpeed)
                        case 'b3': return speedUnit(swapDownUp ? downSpeed : upSpeed)
                    }      
                case 'color': return  theme.textColor
                case 'visible':  
                    switch (caller) {
                        case 't1': return showIcons
                        case 't2': return true
                        case 't3': return showUnits
                        case 'b1': return showSeparately && showIcons
                        case 'b2': return showSeparately
                        case 'b3': return showSeparately && showUnits
                    }    
                case 'padding': return getPadding     
            }
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

    function iconStyle(a){
        //single line //double line //mixed values
        if (iconType === 'iconA'){
            switch(a) {
                case 0: return 'ᐃ' 
                case 1: return 'ᐁ'
                case 2: return 'ᐁᐃ'
            }
        }
        if (iconType === 'iconB'){
            switch(a) {
                case 0: return '△' 
                case 1: return '▽'
                case 2: return '▽△'
            }
        }
        if (iconType === 'iconC'){
            switch(a) {
                case 0: return '▲' 
                case 1: return '▼'
                case 2: return '▼▲'
            }
        }
        if (iconType === 'iconD'){
            switch(a) {
                case 0: return '⮝' 
                case 1: return '⮟'
                case 2: return '⮟⮝'
                }
        }
        if (iconType === 'iconE'){
            switch(a) {
                case 0: return '⩓' 
                case 1: return '⩔'
                case 2: return '⩔⩓'
                }
        }
        if (iconType === 'iconF'){
            switch(a) {
                case 0: return '🢕' 
                case 1: return '🢗'
                case 2: return '🢗🢕'
                }
        }
        if (iconType === 'iconG'){
            switch(a) {
                case 0: return '⋀' 
                case 1: return '⋁'
                case 2: return '⋁⋀'
                }
        }
        if (iconType === 'iconH'){
            switch(a) {
                case 0: return '◢'
                case 1: return '◥'
                case 2: return '◥◢'
                }
        }
        if (iconType === 'iconI'){
            switch(a) {
                case 0: return 'U:'
                case 1: return 'D:'
                case 2: return 'U/D'
                }
        }
        if (iconType === 'iconJ'){
            switch(a) {
                case 0: return '🠅'
                case 1: return '🠇'
                case 2: return '🠇🠅'
                }
        }
        if (iconType === 'iconK'){
            switch(a) {
                case 0: return '🠉'
                case 1: return '🠋'
                case 2: return '🠋🠉'
                }
        }
        if (iconType === 'iconL'){
            switch(a) {
                case 0: return '🡅'
                case 1: return '🡇'
                case 2: return '🡇🡅'
                }
        }
        if (iconType === 'iconM'){
            switch(a) {
                case 0: return '🡩'
                case 1: return '🡫'
                case 2: return '🡫🡩'
                }
        }
        if (iconType === 'iconN'){
            switch(a) {
                case 0: return '⮉'
                case 1: return '⮋'
                case 2: return '⮋⮉'
                }
        }
        if (iconType === 'iconO'){
            switch(a) {
                case 0: return '⇧'
                case 1: return '⇩'
                case 2: return '⇩⇧'
                }
        }
        if (iconType === 'iconP'){
            switch(a) {
                case 0: return '⮭'
                case 1: return '⮯'
                case 2: return '⮯⮭'
                }
        }
        if (iconType === 'iconQ'){
            switch(a) {
                case 0: return '⥣'
                case 1: return '⥥'
                case 2: return '⥥⥣'
                }
        }
    }

    function getDecimalPlace() {
        if          (decimalPlace === '1000')       return 0;
        else if     (decimalPlace === '1000.0')     return 1;
        else if     (decimalPlace === '1000.00')    return 2;
        else if     (decimalPlace === '1000.000')   return 3;
    }

    // MERGE speedText and speedUnit - WIP
    function speedText(value) {
        // data communication 1 kilobit = 1000 bits, while in data storage 1 Kilobyte = 1024 Bytes
        var m    = getBinDec            // binary 1024 | decimal 1000
        var deci = getDecimalPlace();   // # of decimal places
        var kilo = m;                   // One Kilo is 1024 b/B
        var mega = m * m;               // One MB is 1024 Kb/B
        var giga = m * m * m;           // One GB is 1024 Mb/B
        var tera = m * m * m * m;       // One TB is 1024 Gb/B

        if (speedUnits !== 'bits') {
            value = value / 8
        }

        if      (value < kilo)  return value;                        // return bytes if less than a Kx
        else if (value < mega)  return (value / kilo).toFixed(deci); // return Kx if less than a Mx
        else if (value < giga)  return (value / mega).toFixed(deci); // return Mx if less than a Gx
        else                    return (value / giga).toFixed(deci); // return Gx if less than a Tx
    }

    function speedUnit(value) {
        // data communication 1 kilobit = 1000 bits, while in data storage 1 Kilobyte = 1024 Bytes
        var m    = getBinDec            // binary 1024 | decimal 1000
        var deci = getDecimalPlace();   // # of decimal places
        var kilo = m;                   // One Kilo is 1024 x
        var mega = m * m;               // One MB is 1024 Kx
        var giga = m * m * m;           // One GB is 1024 Mx
        var tera = m * m * m * m;       // One TB is 1024 Gx
        //console.log("bits in: " + value)
        if (speedUnits !== 'bits') {
            value = value / 8
            //console.log("bytes out: " + value)
        }
        
        if (value < kilo)       return shortUnits ? (boolUnits ? 'b' : 'B') : (boolUnits ? 'b/s'  : 'B/s' ); // return bytes if less than a KB
        else if (value < mega)  return shortUnits ? (boolUnits ? 'k' : 'K') : (boolUnits ? 'Kb/s' : 'KB/s'); // return KB if less than a MB
        else if (value < giga)  return shortUnits ? (boolUnits ? 'm' : 'M') : (boolUnits ? 'Mb/s' : 'MB/s'); // return MB if less than a GB
        else                    return shortUnits ? (boolUnits ? 'g' : 'G') : (boolUnits ? 'Gb/s' : 'GB/s'); // return GB if less than a TB                    
    }

    // function totalText(value) {
    //     var unit
    //     if (value >= 1048576) {
    //         value /= 1048576
    //         unit = 'GiB'
    //     }
    //     else if (value >= 1024) {
    //         value /= 1024
    //         unit = 'MiB'
    //     }
    //     else if (value >= 1) {
    //         unit = 'KiB'
    //     }
    //     else {
    //         value *= 1024
    //         unit = 'B'
    //     }
    //     return value.toFixed(1) + ' ' + unit
    // }

    //2nd
    function addSources() {
        var keyidx;
        var count;
        var pathKey = "";
        var sensors = [];
        var sensoridx;

        count = 0;
        sensorList = [];
        sensors = dbusData.allSensors("network/");

        //console.log("addSource triggered")
        //console.log("CR-sensors: from CR " + sensors)
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

        for (var idx = 0; idx < sensors.length; idx++) {

            if (sensors[idx].endsWith("/network")) {
                keyidx = sensors[idx].indexOf("/network");
                pathKey = sensors[idx].slice(0,keyidx);
                
                //console.log("CR-pathKey: "+ pathKey)
                // qml: CR-pathKey: network/wlp2s0

                sensoridx = plasmoid.configuration.netSources.indexOf(pathKey);     

                //console.log("CR netSource: "+ plasmoid.configuration.netSources.indexOf(key))
                // qml: CR netSource: network/wlp2s0 - loads at start - doesnt repeat

                //console.log("CR-sensoridx: "+ sensoridx)
                // qml: CR-sensoridx: 0 - doesnt repat

                if (sensoridx >= 0) {
                    netUnits[sensoridx * 2]             = dbusData.unitValue(pathKey + "/downloadBits");
                    netUnits[(sensoridx * 2) + 1]       = dbusData.unitValue(pathKey + "/uploadBits");

                    sensorList.push(pathKey + "/downloadBits", pathKey + "/uploadBits")

                    netLabels[sensoridx]                = dbusData.stringData(pathKey + "/network");

                    work[sensoridx * 2] =               0;
                    work[(sensoridx * 2) + 1] =         0;

                    values[sensoridx * 2] =             0;
                    values[(sensoridx * 2) + 1] =       0;

                    netValues[sensoridx * 2] =          {value:0, count:0};
                    netValues[(sensoridx * 2) + 1] =    {value:0, count:0};

                    netTotals[sensoridx * 2] =          {value:0, count:0};
                    netTotals[(sensoridx * 2) + 1] =    {value:0, count:0};

                    count += 1;
                                                // runs at start
                    // console.log(netUnits)    // qml: netUnits: 200,200 - signifies bits vs bytes ???
                    // console.log(sensorList)  // qml: sensorList: network/wlp2s0/download, network/wlp2s0/upload
                    // console.log(netLabels)   // qml: netLabels: netName
                    // console.log(work)        // qml: work: 0,0
                    // console.log(values)      // qml: values: 0,0
                }
            }
        }
        dbusData.subscribe(sensorList);
        numberOfNets = count;
        ready = true;
    }

    Connections {
        target: plasmoid.configuration
        function onNetSourcesChanged() {
            dbusData.unsubscribe(sensorList);
            addSources();
        }
    }

    Connections {
        target: sysMonitor
        
        function onStatsUpd(pathKeys, values) {

            //console.log("CR-onStatsUpd: "+ pathKeys + " || "+ values)
            // qml: CR-onStatsUpd: network/wlp2s0/download,network/wlp2s0/upload || 334,128
            // qml: CR-onStatsUpd: network/wlp2s0/downloadBits,network/wlp2s0/totalDownload,network/wlp2s0/uploadBits,network/wlp2s0/totalUpload || 0,49913032,0,169202 - WIP
        
            var sensorKey;
            var valueIdx;
            var configKey;

            if (!ready) 
                return;
            for (var idx = 0; idx < pathKeys.length; idx++ ) {
                sensorKey = pathKeys[idx];
                for (var idy = 0; idy < numberOfNets; idy++) {

                    // console.log("CR-netSources[idy]: "+ plasmoid.configuration.netSources[idy])
                    // qml: CR-netSources[idy]: network/wlp2s0

                    configKey = plasmoid.configuration.netSources[idy];

                    // console.log("CR-configKey: "+ configKey)
                    // qml: CR-configKey: network/wlp2s0 - repeats
                    // qml: CR-configKey: network/wlp2s0

                    if (sensorKey.indexOf(configKey) == 0) {
                        valueIdx = idy * 2;

                        if (sensorKey == configKey + "/downloadBits") {
                            netValues[valueIdx].value += values[idx];   // add up the bandwidth between calls?
                            netValues[valueIdx].count += 1;     

                            // console.log("CR-values[idx] /download: "+ values[idx])
                            // qml: onStatsUpd:             network/wlp2s0/download,network/wlp2s0/upload || 20854,11760
                            // qml: values[idx] /download:  20854

                            netValueDown = values[idx]
                        }

                        if (sensorKey == configKey + "/uploadBits") {
                            netValues[valueIdx + 1].value += values[idx];
                            netValues[valueIdx + 1].count += 1;

                            // console.log("values[idx] /upload: "+ values[idx])
                            // console.log("netValues.value /upload: "+ netValues.value)
                            // qml: onStatsUpd:             network/wlp2s0/download,network/wlp2s0/upload || 20854,11760
                            // qml: values[idx] /upload:    11760

                            netValueUp = values[idx]
                        }
                        // TOTAL DOWNLOAD / UPLOAD : - WIP
                        // if (sensorKey == configKey + "/totalDownload") {
                        //     netTotals[valueIdx].value = values[idx];
                        //     netTotals[valueIdx].count += 1
                        //     netTotalDown = values[idx]

                        //     console.log("TD: "+ speedText(netTotals[valueIdx].value))

                        // }
                        // if (sensorKey == configKey + "/totalUpload") {
                        //     netTotals[valueIdx + 1].value += values[idx];
                        //     netTotals[valueIdx + 1].count += 1
                        //     netTotalUp = values[idx]

                        //     // console.log("TU: "+ netTotalUp)
                        //     // console.log("NL: "+ netLabels )
                        // }
                        // if (sensorKey == configKey + "/signal") {
                        //     // netTotals[valueIdx + 1].value += values[idx];
                        //     // netTotals[valueIdx + 1].count += 1
                        //     wifiSig = values[idx]

                        //     // console.log("TU: "+ netTotalUp)
                        //     // console.log("NL: "+ netLabels )
                        // }
                    }
                }
            }
        }
        
        // function onUpdateUi() {
        //     var valueIdx;
        //     var netItem;
        //     var source;
            
        //     if (plasmoid.configuration.netSources != "") {
        //         for (var idx = 0; idx < numberOfNets; idx++) {

        //             // console.log("CR-onUpdateUi-idx: " + idx)
        //             // qml: CR-onUpdateUi:0 / 0 should be idx of interface

        //             valueIdx = idx * 2;
        //             for (var idy = 0; idy <= 1; idy++) {
        //                 netItem = netValues[valueIdx + idy];

        //                 if (netItem.count > 0) {
        //                     // console.log("CR-onUpdateUi: Function = "+ netItem.value / netItem.count, netUnits[idx])
        //                     work[valueIdx + idy] = Functions.convert(netItem.value / netItem.count, netUnits[idx]);
        //                     netItem.value = 0;
        //                     netItem.count = 0;
        //                 }

        //                 // console.log("CR-netItem.value: "+netItem.value)
        //                 // console.log("CR-netItem.count: "+netItem.count)
        //             }
        //         }
        //     }
        //     values = work.slice();
        //     // console.log("CR-onUpdateUi: "+ values)
        // }
    }
    
    Component.onCompleted: {
        // console.log("CR-onCompleted")
        addSources();
    }
    
    Component.onDestruction: {
        dbusData.unsubscribe(sensorList);
    }
}

// 
