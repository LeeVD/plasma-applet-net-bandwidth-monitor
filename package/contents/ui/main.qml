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
 
import QtQuick 2.2
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
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
    property bool       accumulator:        plasmoid.configuration.accumulator
    property bool       hideInactive:       plasmoid.configuration.hideInactive
    property bool       hideZone:           plasmoid.configuration.hideZone
    property var        netSources:         plasmoid.configuration.netSources

    property var        netInterfaces:      []
    property var        netPath:            []
    //property var        numberOfNets:       0
    property var        numCheckedNets:     0
    //property var        netLabels:          []
    property bool       ready:              false
    property var        sensorList:         []
    property var        netDataBits:        []
    property var        netDataByte:        []
    property var        netDataTotal:       []
    property var        netDataAccumulator: []      
    property var        accumulatorCounter: 0
    //property var        getIPInfo:          []
    //property var        ip:                 []
    //property var        sm:                 []
    //property var        gw:                 []  
    //property var        wifiSig:            []

    // FUTURE TOOLTIP
    // property bool       showTooltip:        plasmoid.configuration.showTooltip
    // property bool       showNetTotals:      plasmoid.configuration.showNetTotals
    // property string     showTotalUnits:     plasmoid.configuration.showTotalUnits
    // property bool       showIntName:        plasmoid.configuration.showIntName
    // property bool       showIP:             plasmoid.configuration.showIP
    // property bool       showIPextra:        plasmoid.configuration.showIPextra
    // property bool       showIcon:           plasmoid.configuration.showIcon
    // property string     showIconOption:     plasmoid.configuration.showIconOption
    // property bool       showSigStrength:    plasmoid.configuration.showSigStrength
    //property var        keyVal: toolTipData()

    id: sysMonitor
    Plasmoid.compactRepresentation: CompactRepresentation {}
    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation

    signal updateUi()
    signal statsUpd(var keys, var values)

    property alias dbusData : dbusData
    
    DbusData {
        id: dbusData

        property double uiUpdateTimer: 0

        onNewSensorData: {
            // NEW DBUS DATA RECIEVED EVERY 0.5 SECONDS
            sysMonitor.statsUpd(keys, values)

            // updateInterval === 500
            if (updateInterval <= 500) {
                sysMonitor.updateUi()
                uiUpdateTimer = 0
                return
            }

            // multi times statsUpd() once updateUi()
            uiUpdateTimer += 500
            if (uiUpdateTimer >= updateInterval) {
                sysMonitor.updateUi()
                uiUpdateTimer = 0
            }
        }
    }

    // Timer {
    //     interval:   getTriggerInterval() //updateInterval
    //     running:    true
    //     repeat:     true
        
    //     onTriggered: {
    //         sysMonitor.updateUi()
    //     }
    // }

    // function getTriggerInterval() {
    //     if (numCheckedNets < 1)     return 0
    //     else                        return updateInterval
    // } 
}
