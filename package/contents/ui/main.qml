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
 
// USEFUL COMMANDS:
// kquitapp5 plasmashell
// kstart5 plasmashell
// plasmoidviewer -a org.kde.nsw_dbus -l topedge -f horizontal  
// kstatsviewer --details --remain 'ADDRESS' example: network/wlp2s0/totalDownload  [ View DBUS messages ]

// USEFUL PROGRAMS:
// Qt QDBusViewer
// ksystemlog
// KCharSelect

// USEFUL LOCATIONS:
// ___ CONFIGURATIONS: ___
// /home/USER/.config/plasma-org.kde.plasma.desktop-appletsrc
// /home/USER/.config/plasmoidviewer-appletsrc
// ___ PLASMOID STORE: ___
// /home/USER/.local/share/plasma/plasmoids/

// USEFUL SITES
// https://doc.qt.io/qt-5.15/qmltypes.html
// https://community.kde.org/Plasma/DeveloperGuide

import QtQuick 2.2
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
//import QtDBus 2.0

Item {
    // plasmoid.configuration (configGeneral.qml) >>> CompactRepresentation.qml
    property bool       showSeparately:     plasmoid.configuration.showSeparately
    property string     speedLayout:        plasmoid.configuration.speedLayout
    property bool       swapDownUp:         plasmoid.configuration.swapDownUp
    property string     iconType:           plasmoid.configuration.iconType
    property bool       iconPosition:       plasmoid.configuration.iconPosition
    property bool       showIcons:          plasmoid.configuration.showIcons
    property bool       showUnits:          plasmoid.configuration.showUnits
    property string     speedUnits:         plasmoid.configuration.speedUnits
    property bool       shortUnits:         plasmoid.configuration.shortUnits
    property double     fontSizeScale:      plasmoid.configuration.fontSize // 100
    property double     updateInterval:     plasmoid.configuration.updateInterval
    property string     binaryDecimal:      plasmoid.configuration.binaryDecimal
    property double     decimalPlace:       plasmoid.configuration.decimalPlace
    property int        layoutPadding:      plasmoid.configuration.layoutPadding
    property int        accumulator:        plasmoid.configuration.accumulator
    property bool       hideInactive:       plasmoid.configuration.hideInactive
    property bool       hideZone:           plasmoid.configuration.hideZone
    property var        netSources:         plasmoid.configuration.netSources
    property bool       showSeconds:        plasmoid.configuration.showSeconds
    property string     secondsPrefix:      plasmoid.configuration.secondsPrefix
    property bool       decimalFilter0:     plasmoid.configuration.decimalFilter0
    property bool       decimalFilter1:     plasmoid.configuration.decimalFilter1
    property bool       decimalFilter2:     plasmoid.configuration.decimalFilter2
    property bool       decimalFilter3:     plasmoid.configuration.decimalFilter3
    property int        roundedNumber:      plasmoid.configuration.roundedNumber
    property double     iconSize:           plasmoid.configuration.iconSize
    property double     sufixSize:          Plasmoid.configuration.sufixSize
    property bool       colorDefault:       plasmoid.configuration.colorDefault
    property string     colorDownIcon:      plasmoid.configuration.colorDownIcon
    property string     colorDownDigits:    plasmoid.configuration.colorDownDigits
    property string     colorDownSuffix:    plasmoid.configuration.colorDownSuffix
    property string     colorUpIcon:        plasmoid.configuration.colorUpIcon
    property string     colorUpDigits:      plasmoid.configuration.colorUpDigits
    property string     colorUpSuffix:      plasmoid.configuration.colorUpSuffix
    property string     color_b_square:     plasmoid.configuration.color_b_square
    property string     color_k_square:     plasmoid.configuration.color_k_square
    property string     color_m_square:     plasmoid.configuration.color_m_square
    property string     color_g_square:     plasmoid.configuration.color_g_square
    property bool       speedColorActive1:  plasmoid.configuration.speedColorActive1
    property bool       speedColorActive2:  plasmoid.configuration.speedColorActive2
    property bool       speedColorActive3:  plasmoid.configuration.speedColorActive3  
    property bool       speedUnitB:         plasmoid.configuration.speedUnitB  
    property bool       speedUnitK:         plasmoid.configuration.speedUnitK  
    property bool       speedUnitM:         plasmoid.configuration.speedUnitM  
    property bool       speedUnitG:         plasmoid.configuration.speedUnitG  
    property bool       ignoreDecimalIdle:  plasmoid.configuration.ignoreDecimalIdle


    // CompactRepresentation.qml
    property var        netInterfaces:      []
    //property var        netPath:            []
    property var        netInformation:     []
    //property var        netInfo:            []
    property var        numCheckedNets:     0
    
    property bool       ready:              false
    property var        sensorList:         []
    property var        sensorList2:        []
    property var        netDataBits:        []
    property var        netDataByte:        []
    property var        netDataTotal:       []
    property var        netDetail:          []
    property var        netDetails:         plasmoid.configuration.netDetails
    property var        netDataAccumulator: []      
    property var        accumulatorCounter: 0
    //property var        getIPInfo:          []
    property var        showIP:             []
    //property var        sm:                 []
    //property var        gw:                 []  
    //property var        wifiSig:            []

    // FUTURE TOOLTIP
    //property bool       showTooltip:        plasmoid.configuration.showTooltip
    //property bool       showNetTotals:      plasmoid.configuration.showNetTotals
    //property string     showTotalUnits:     plasmoid.configuration.showTotalUnits
    //property bool       showIntName:        plasmoid.configuration.showIntName
    //property bool       showIP:             plasmoid.configuration.showIP
    //property bool       showIPextra:        plasmoid.configuration.showIPextra
    //property bool       showIcon:           plasmoid.configuration.showIcon
    //property string     showIconOption:     plasmoid.configuration.showIconOption
    //property bool       showSigStrength:    plasmoid.configuration.showSigStrength
    //property var        keyVal: toolTipData()

    id: sysMonitor
    Plasmoid.compactRepresentation: CompactRepresentation {}
    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation

    signal updateUi()
    signal statsUpd(var keys, var values)

    property alias dbusData : dbusData

    DbusData {
        id: dbusData
        onNewSensorData: {
            // NEW DBUS DATA RECEIVED EVERY 0.5 SECONDS
            //console.log(keys, values)
            sysMonitor.statsUpd(keys, values)
        }
    }
    
    Timer {
        interval:   getTriggerInterval() //updateInterval
        running:    true
        repeat:     true
        
        onTriggered: {
            sysMonitor.updateUi()
        }
    }

    function getTriggerInterval() {
        if (numCheckedNets < 1) {       // NO NETWORKS SELECTED
            sysMonitor.updateUi()       // UPDATE UI ONCE TO RESET DATA TO 0 
            return 0
        } else {
            return updateInterval
        }
    } 
}
