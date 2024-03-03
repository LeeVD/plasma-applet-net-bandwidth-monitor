# IF ERRORS WITH ECMConfig.cmake AND ecm-config.cmake INSTALL extra-cmake-modules.

cmake_minimum_required(VERSION 3.5)

project(NetBandwidthMonitor VERSION 0.3.1)

find_package(ECM 1.4.0 REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

find_package(KF5 REQUIRED COMPONENTS
    Plasma # Required for plasma_install_package()
)

plasma_install_package(package org.kde.nsw_dbus)
