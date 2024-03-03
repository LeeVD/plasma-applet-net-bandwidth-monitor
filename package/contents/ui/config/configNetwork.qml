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
//import org.kde.plasma.core 2.0 as PlasmaCore
import DbusModel 1.1

import QtQuick 2.2
import QtQuick.Dialogs 1.0

Item {
    // configNetwork.qml >>> plasmoid.configuration
    property var cfg_netSources: netSources   
    property var cfg_netDetails: netDetails

    //################## SERIALISATION FIX ###########################
    property var net: []
    property var det: []

    function netSourceEncode(value) {
        return JSON.stringify(value)
    }

    function netSourceDecode(value) {
        try {
            return JSON.parse(value)
        } catch (E) {
            return []
        }
    }

    //################################################################

    GridLayout {
        columns: 3
        columnSpacing: 15
        rowSpacing: 40

        //________ PADDING ________ 
        Rectangle {
            Layout.column: 0
            height: 2
            Layout.minimumWidth: 10 //(parent.width / 100) * 40 
            width: 5 // (parent.width / 100) * 40 
            color: "transparent"
        }
        QtObject {
            id: data
            property bool loading: false
        }

        ColumnLayout {

            Repeater {
                model:          net.length   //sources
                Row {
                    CheckBox {
                        id: interfaceCheckbox
                        //text:       net[index].name
                        checked:    net[index].checked 
                        onCheckedChanged: {
                            if (!data.loading) {
                                net[index].checked = checked
                                cfg_netSources = netSourceEncode(net)
                                //console.log("ip:", cfg_netDetails)
                                cfg_netSourcesChanged();    // SETS NEW VALUES IN MAIN 
                            }
                        }
                    }
                    Label {
                        text: { 
                            if (interfaceCheckbox.checked) {
                                return " Disable monitoring on interface [ " + net[index].name + " ] " 
                            } else {
                                return " Enable monitoring on interface [ " + net[index].name + " ] " 
                            }
                        }//"Enable Interface  "
                        height: interfaceCheckbox.height
                    }


                }
            }
        }

        ListModel {
            id: sources
        }

        Dbus {
            id : dbus1
        }
        
        Component.onCompleted: {
            net = netSourceDecode(cfg_netSources)
            //det = netSourceDecode(cfg_netDetails)
        }
    }
}

