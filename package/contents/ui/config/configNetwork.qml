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

Item {
    //id: main
    property var cfg_netSources: netSources    

    GridLayout {
        columns: 3
        columnSpacing: 15
        rowSpacing: 15

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
                model:          cfg_netSources.length   //sources
                CheckBox {
                    text:       cfg_netSources[index].name
                    checked:    cfg_netSources[index].checked 
                    onCheckedChanged: {
                        if (!data.loading) {
                            cfg_netSources[index].checked = checked
                            cfg_netSourcesChanged();    // SETS NEW VALUES IN MAIN 
                        }
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
        
        // Component.onCompleted: {

        // }
    }
}

