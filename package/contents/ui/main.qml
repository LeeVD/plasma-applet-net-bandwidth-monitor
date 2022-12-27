/*
 * Copyright 2022  LeeVD <thoth360@hotmail.com>
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
import QtQuick 2.2
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    property bool       showSeparately: plasmoid.configuration.showSeparately
    property string     speedLayout:    plasmoid.configuration.speedLayout
    property bool       swapDownUp:     plasmoid.configuration.swapDownUp
    property string     iconType:       plasmoid.configuration.iconType
    property bool       showIcons:      plasmoid.configuration.showIcons
    property bool       showUnits:      plasmoid.configuration.showUnits
    property string     speedUnits:     plasmoid.configuration.speedUnits
    property bool       shortUnits:     plasmoid.configuration.shortUnits
    property double     fontSizeScale:  plasmoid.configuration.fontSize
    property double     updateInterval: plasmoid.configuration.updateInterval
    property string     binaryDecimal:  plasmoid.configuration.binaryDecimal
    property string     decimalPlace:   plasmoid.configuration.decimalPlace
    property int        getPadding:     plasmoid.configuration.getPadding
    property bool       iconPosition:   plasmoid.configuration.iconPosition
    property var        speedData:      []
    property double     netValueDown:   0
    property double     netValueUp:     0
    property double     netTotalDown:   0
    property double     netTotalUp:     0

    // FROM NETWORK.QML
    property var        numberOfNets:   0
    property var        values:         [0, 0] // Download, Upload
    property var        netLabels:      []
    property var        work:           []
    property var        netValues:      []
    property var        netTotals:      []
    property var        netUnits:       []
    property var        getIPInfo:      []
    // property var        ip:             []
    // property var        sm:             []
    // property var        gw:             []  
    property var        wifiSig:        []
    property bool       ready:          false
    property var        sensorList:     []
    // END FROM NETWORK.QML

    // FOR ToolTip - WIP
    // property bool       showTooltip:        plasmoid.configuration.showTooltip
    // property bool       showNetTotals:      plasmoid.configuration.showNetTotals
    // property string     showTotalUnits:     plasmoid.configuration.showTotalUnits
    // property bool       showIntName:        plasmoid.configuration.showIntName
    // property bool       showIP:             plasmoid.configuration.showIP
    // property bool       showIPextra:        plasmoid.configuration.showIPextra
    // property bool       showIcon:           plasmoid.configuration.showIcon
    // property string     showIconOption:     plasmoid.configuration.showIconOption
    // property bool       showSigStrength:    plasmoid.configuration.showSigStrength

    id: sysMonitor
    // Plasmoid.switchWidth: theme.mSize(theme.defaultFont).width * 10
    // Plasmoid.switchHeight: theme.mSize(theme.defaultFont).height * 5
    //Plasmoid.fullRepresentation: FullRepresentation {}
    Plasmoid.compactRepresentation: CompactRepresentation {}
    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation

    signal updateUi()
    signal statsUpd(var keys, var values)

    property alias dbusData : dbusData
    
    DbusData {
        id: dbusData
        onNewSensorData: {
            sysMonitor.statsUpd(keys, values)
        }
    }
    
    Timer {
        interval: updateInterval
        running: true
        repeat: true
        
        onTriggered: {
            sysMonitor.updateUi()
            
        }
    }
}

