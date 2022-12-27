/*
 * Copyright 2019 Barry Strong <bstrong@softtechok.com>
 *
 * This file is part of System Monitor Plasmoid
 *
 * System Monitor Plasmoid is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * System Monitor Plasmoid is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with System Monitor Plasmoid.  If not, see <https://www.gnu.org/licenses/>.
 */

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.0
import org.kde.plasma.core 2.0 as PlasmaCore
import DbusModel 1.1

Item {
    property var cfg_netSources: [] 

    Grid {
        id: gridRoot
        columns: 1
        leftPadding: 20
        spacing: 10 

        Rectangle {
            height: 10
            //width: (parent.width / 100) * 40 
            color: "transparent"
        }

        // Rectangle{
        //     width: 200
        //     height: 200
        //     color: "red"
        // }

        QtObject {
            id: data
            property bool loading: false
        }

        Column {
            Repeater {
                model: sources

                // Grid {
                //     id: gridRoot
                //     columns: 1
                //     leftPadding: 10
                //     spacing: 10 

                    CheckBox {
                        text: model.name
                        checked: model.checked
                        onCheckedChanged: {
                            var idx;

                            if(!data.loading) {
                                if (checked) {
                                    idx = cfg_netSources.indexOf(model.keyid);
                                    if (idx < 0) {
                                        cfg_netSources.push(model.keyid);
                                    }
                                } else {
                                    idx = cfg_netSources.indexOf(model.keyid);
                                    cfg_netSources.splice(idx, 1);
                                }
                                cfg_netSourcesChanged();
                            }
                        }
                    }
                //}
            }
        }

        ListModel {
            id: sources
        }

        Dbus {
            id : dbus1
        }
        
        Component.onCompleted: {
            var cfgLength;
            var netName;
            var sensors = [];
            var nameIdx;
            var key;

            data.loading = true;
            cfg_netSources = plasmoid.configuration.netSources;
            
            //console.log("cfg_netSources: " + cfg_netSources)
            // qml: cfg_netSources: network/wlp2s0

            sensors = dbus1.allSensors("network/");
            for (var idx = 0; idx < sensors.length; idx++) {
                //console.log("dbus: " + sensors)

                // network/wlp2s0/ipv4subnet,
                // network/wlp2s0/totalDownload,
                // network/wlp2s0/ipv4address,
                // network/all/download,
                // network/wlp2s0/ipv6gateway,
                // network/wlp2s0/ipv4dns,
                // network/wlp2s0/downloadBits,
                // network/wlp2s0/ipv6dns,
                // network/wlp2s0/ipv6address,
                // network/wlp2s0/uploadBits,
                // network/wlp2s0/download,
                // network/all/downloadBits,
                // network/wlp2s0,
                // network/wlp2s0/totalUpload,
                // network/wlp2s0/ipv6subnet,
                // network/wlp2s0/upload,
                // network/wlp2s0/ipv4withPrefixLength,
                // network/wlp2s0/signal,
                // network/wlp2s0/ipv6withPrefixLength,
                // network/wlp2s0/network,
                // network/all/totalDownload,
                // network/wlp2s0/ipv4gateway,
                // network/all,
                // network/all/totalUpload,
                // network/all/uploadBits,
                // network/all/upload

                if (sensors[idx].endsWith("/network")) {
                    nameIdx = sensors[idx].indexOf("/network");
                    key = sensors[idx].slice(0,nameIdx);
                    netName = dbus1.stringData(sensors[idx]);
                    if (cfg_netSources.indexOf(key) < 0 ) {
                        sources.append({keyid:key, name: netName, checked: false});
                    } else {
                        //console.log("endswith: " + key + " || " + netName)
                        // qml: endswith: network/wlp2s0 || DUAT
                        sources.append({keyid:key, name: netName, checked: true});
                    }
                }
            }
            cfg_netSources.length = 0;
            for (idx = 0; idx < sources.count; idx++) {
                if (sources.get(idx).checked)
                    cfg_netSources.push(sources.get(idx).keyid);
            }
            plasmoid.configuration.netSources = cfg_netSources;
            data.loading = false;
        }
    }
}

