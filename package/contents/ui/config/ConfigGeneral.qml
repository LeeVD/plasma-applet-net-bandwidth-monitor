/*
 * Copyright 2016  Daniel Faust <hessijames@gmail.com>
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
import QtQuick.Controls 2.15//1.3
import QtQuick.Layouts 1.1

Item {
    property alias  cfg_showSeparately: showSeparately.checked
    property string cfg_speedLayout:    speedLayout
    property bool   cfg_swapDownUp:     false
    property string cfg_iconType:       iconType
    property alias  cfg_iconPosition:   iconPosition.checked
    property alias  cfg_showIcons:      showIcons.checked
    property alias  cfg_showUnits:      showUnits.checked
    property string cfg_speedUnits:     'bits'
    property alias  cfg_shortUnits:     shortUnits.checked
    property double cfg_fontSize:       fontSize
    property double cfg_updateInterval: updateInterval
    property string cfg_binaryDecimal:  'metric'
    property string cfg_decimalPlace:   decimalPlace
    property int    cfg_getPadding:     getPadding.value

    // DESIGN SETUP
    Grid {
        columns: 2
        leftPadding: 20
        spacing: 10

        Rectangle {
            height: 10
            width: (parent.width / 100) * 40 
            color: "transparent"
        }
        Rectangle {
            height: 10
            width: 100 
            color: "transparent"
        }         

        Label {
            text: i18n('Layout:')
        }

        ComboBox {
            id: speedLayout
            textRole: 'label'
            model: [
                {
                    'label': i18n('Automatic'),
                    'value': 'auto'
                },
                {
                    'label': i18n('One above the other'),
                    'value': 'rows'
                },
                {
                    'label': i18n('Side by side'),
                    'value': 'columns'
                }
            ]
            onCurrentIndexChanged: cfg_speedLayout = model[currentIndex]['value']

            Component.onCompleted: {
                for (var i = 0; i < model.length; i++) {
                    if (model[i]['value'] === plasmoid.configuration.speedLayout) {
                        speedLayout.currentIndex = i
                    }
                }
            }
        }

        Label {
            text: i18n('Display order:')
        }

        ComboBox {
            id: displayOrder
            textRole: 'label'
            model: [
                {
                    'label': i18n('Show upload speed first'),
                    'value': 'up'
                },
                {
                    'label': i18n('Show download speed first'),
                    'value': 'down'
                }
            ]
            onCurrentIndexChanged: cfg_swapDownUp = model[currentIndex]['value'] === 'up'

            Component.onCompleted: {
                if (plasmoid.configuration.swapDownUp) {
                    displayOrder.currentIndex = 0
                } else {
                    displayOrder.currentIndex = 1
                }
            }
        }

        Label {
            text: i18n('Show speeds separately:')
        }

        CheckBox {
            id: showSeparately
            //text: i18n('Show download and upload speed separately')
            Layout.columnSpan: 2
        }

        Label {
            text: i18n('Font size:')
        }

        ComboBox {
            id: fontSize
            textRole: 'label'
            model: [
                { 'label': i18n('200 %'),   'value': 2 },
                { 'label': i18n('190 %'),   'value': 1.9 },
                { 'label': i18n('180 %'),   'value': 1.8 },
                { 'label': i18n('170 %'),   'value': 1.7 },
                { 'label': i18n('160 %'),   'value': 1.6 },
                { 'label': i18n('150 %'),   'value': 1.5 },
                { 'label': i18n('140 %'),   'value': 1.4 },
                { 'label': i18n('130 %'),   'value': 1.3 },
                { 'label': i18n('120 %'),   'value': 1.2 },
                { 'label': i18n('110 %'),   'value': 1.1 },
                { 'label': i18n('100 %'),   'value': 1 },
                { 'label': i18n('95 %'),    'value': 0.95 },
                { 'label': i18n('90 %'),    'value': 0.9 },
                { 'label': i18n('85 %'),    'value': 0.85 },
                { 'label': i18n('80 %'),    'value': 0.8 },
                { 'label': i18n('75 %'),    'value': 0.75 },
                { 'label': i18n('70 %'),    'value': 0.7 },
                { 'label': i18n('65 %'),    'value': 0.65 },
                { 'label': i18n('60 %'),    'value': 0.6 },
                { 'label': i18n('55 %'),    'value': 0.55 },
                { 'label': i18n('50 %'),    'value': 0.5 }
            ]
            onActivated: {
                cfg_fontSize = model[currentIndex]['value']
            }
            Component.onCompleted: {
                for (var i = 0; i < model.length; i++) {
                     if (model[i]['value'] === plasmoid.configuration.fontSize) {
                        fontSize.currentIndex = i
                    }
                }
            }
        }

        Label {
            text: i18n('Update interval:')
        }

        ComboBox {
            id: updateInterval
            textRole: 'label'
            model: [
                { 'label': i18n('0.5 Seconds'), 'value': 500 },
                { 'label': i18n('1.0 Seconds'), 'value': 1000 },
                { 'label': i18n('1.5 Seconds'), 'value': 1500 },
                { 'label': i18n('2.0 Seconds'), 'value': 2000 },
                { 'label': i18n('2.5 Seconds'), 'value': 2500 },
                { 'label': i18n('3.0 Seconds'), 'value': 3000 },
                { 'label': i18n('3.5 Seconds'), 'value': 3500 },
                { 'label': i18n('4.0 Seconds'), 'value': 4000 },
                { 'label': i18n('4.5 Seconds'), 'value': 4500 },
                { 'label': i18n('5.0 Seconds'), 'value': 5000 },
            ]
            onCurrentIndexChanged: cfg_updateInterval = model[currentIndex]['value']

            Component.onCompleted: {
                for (var i = 0; i < model.length; i++) {
                    if (model[i]['value'] === plasmoid.configuration.updateInterval) {
                        updateInterval.currentIndex = i
                    }
                }
            }
        }       

        Label {
            text: i18n('Padding:')
        }

        //2nd
        ComboBox {
            id: getPadding
            textRole: 'label'
            model: [
                { 'label': i18n('Close by 10'),     'value': -10 },
                { 'label': i18n('Close by 8'),      'value': -8 },
                { 'label': i18n('Close by 6'),      'value': -6 },
                { 'label': i18n('Close by 4'),      'value': -4 },
                { 'label': i18n('Close by 2'),      'value': -2 },
                { 'label': i18n('Default'),         'value': 0 },
                { 'label': i18n('Distant by 2'),    'value': 2 },
                { 'label': i18n('Distant by 4'),    'value': 4 },
                { 'label': i18n('Distant by 6'),    'value': 6 },
                { 'label': i18n('Distant by 8'),    'value': 8 },
                { 'label': i18n('Distant by 10'),   'value': 10 },
            ]
            onCurrentIndexChanged: cfg_getPadding = model[currentIndex]['value']

            Component.onCompleted: {
                for (var i = 0; i < model.length; i++) {
                    if (model[i]['value'] === plasmoid.configuration.getPadding) {
                        getPadding.currentIndex = i
                    }
                }
            }
        }  
        // SpinBox {
        //     id: getPadding
        //     from: 10
        //     to: -10
        //     value: 0

        //     textFromValue: function(value, locale) {
        //         return Number(value / 10).toLocaleString(locale, 'f', 1)
        //     }
        //     valueFromText: function(text, locale) {
        //         return Number.fromLocaleString(locale, text) * 10
        //     }
        //     validator: DoubleValidator {
        //         bottom: Math.min(getPadding.from, getPadding.to)
        //         top:  Math.max(getPadding.from, getPadding.to)
        //     }
        // }



    // }

    // // SPEED UNITS SETUP
    // Grid {
    //     id: grid2
    //     columns: 2
    //     spacing: 10

        Rectangle {
            height: 20
            width: (parent.width / 100) * 40 
            color: "transparent"
        }
        Rectangle {
            height: 20
            width: 100 
            color: "transparent"
        }     

        Label {
            text: i18n('Show speed units:')
        }

        CheckBox {
            id: showUnits
            //text: i18n('Show speed units')
            Layout.columnSpan: 2
        }

        Label {
            text: i18n('Speed units:')
        }

        ComboBox {
            id: speedUnits
            textRole: 'label'
            model: [
                {
                    'label': i18n('Bits'),
                    'value': 'bits'
                },
                {
                    'label': i18n('Bytes'),
                    'value': 'bytes'
                }
            ]
            onCurrentIndexChanged: cfg_speedUnits = model[currentIndex]['value']

            Component.onCompleted: {
                for (var i = 0; i < model.length; i++) {
                    if (model[i]['value'] === plasmoid.configuration.speedUnits) {
                        speedUnits.currentIndex = i
                    }
                }
            }
        }

        Label {
            text: i18n('Shorten speed units:')
        }

        CheckBox {
            id: shortUnits
            //text: i18n('Use shortened speed units')
            Layout.columnSpan: 2
            enabled: showUnits.checked
        }

        Rectangle {
            height: 20
            width: (parent.width / 100) * 40 
            color: "transparent"
        }
        Rectangle {
            height: 20
            width: 100 
            color: "transparent"
        }     

        Label {
            text: i18n('Show speed icons:')
        }

        CheckBox {
            id: showIcons
            //text: i18n('Show upload and download icons')
            Layout.columnSpan: 2
        }

        Label {
            text: i18n('Icon Style:')
        }

        ComboBox {
            id: iconType
            textRole: 'text'
            model: [
                { text: i18n('ᐁ ᐃ'),    value: 'iconA' },
                { text: i18n('▽ △'),    value: 'iconB' },
                { text: i18n('▼ ▲'),     value: 'iconC' },
                { text: i18n('⮟ ⮝'),    value: 'iconD' },
                { text: i18n('⩔ ⩓'),    value: 'iconE' },
                { text: i18n('🢗 🢕'),    value: 'iconF' },
                { text: i18n('⋁ ⋀'),    value: 'iconG' },
                { text: i18n('◥ ◢'),    value: 'iconH' },
                { text: i18n('D: U:'),    value: 'iconI' },
                { text: i18n('🠇 🠅'),     value: 'iconJ' },
                { text: i18n('🠋 🠉'),    value: 'iconK' },
                { text: i18n('🡇 🡅'),    value: 'iconL' },
                { text: i18n('🡫 🡩'),    value: 'iconM' },
                { text: i18n('⮋ ⮉'),     value: 'iconN' },
                { text: i18n('⇩ ⇧'),    value: 'iconO' }, 
                { text: i18n('⮯ ⮭'),    value: 'iconP' },
                { text: i18n('⥥ ⥣'),    value: 'iconQ' }   
            ]
            onCurrentIndexChanged: cfg_iconType = model[currentIndex]['value']

            Component.onCompleted: {
                for (var i = 0; i < model.length; i++) {
                    if (model[i]['value'] === plasmoid.configuration.iconType) {
                        iconType.currentIndex = i
                    }
                }
            }
        }

        Label {
            text: i18n('Show Icons on the right:')
        }
        CheckBox {
            id: iconPosition
            //text: i18n(' Show Icons on the right')
            Layout.columnSpan: 2
            enabled: showIcons.checked
        }  

        Rectangle {
            height: 10
            width: (parent.width / 100) * 40 
            color: "transparent"
        }
        Rectangle {
            height: 10
            width: 100 
            color: "transparent"
        }  

        Label {
            text: i18n('Numbers:')
        }

        ComboBox {
            id: binaryDecimal
            textRole: 'label'
            model: [
                { 'label': i18n('Binary (1024)'),  'value': 'binary' },
                { 'label': i18n('Metric (1000)'),  'value': 'decimal'}
            ]
            onCurrentIndexChanged: cfg_binaryDecimal = model[currentIndex]['value']

            Component.onCompleted: {
                for (var i = 0; i < model.length; i++) {
                    if (model[i]['value'] === plasmoid.configuration.binaryDecimal) {
                        binaryDecimal.currentIndex = i
                    }
                }
            }
        }

        Label {
            text: i18n('Decimal place:')
        }
        ComboBox {
            id: decimalPlace
            textRole: 'label'
            model: [ 
                { 'label': i18n('0'),   'value': '1000' },
                { 'label': i18n('1'),   'value': '1000.0' },
                { 'label': i18n('2'),   'value': '1000.00' },
                { 'label': i18n('3'),   'value': '1000.000' }
            ]
            onCurrentIndexChanged: {
                cfg_decimalPlace = model[currentIndex]['value']
            }
            Component.onCompleted: {
                for (var i = 0; i < model.length; i++) {
                    if (model[i]['value'] === plasmoid.configuration.decimalPlace) {
                        decimalPlace.currentIndex = i
                    }
                }
            }
        }

        Rectangle {
            width: 10
            height: 30
            color: "transparent"
        }
    }     
}



