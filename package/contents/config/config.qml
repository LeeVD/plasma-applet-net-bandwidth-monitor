import QtQuick 2.2
import org.kde.plasma.configuration 2.0

ConfigModel {
    ConfigCategory {
         name: i18n("General")
         icon: 'preferences-desktop-settings'
         source: 'config/configGeneral.qml'
    }
    ConfigCategory {
        name: i18n("Network")
        icon: 'network-card' //'network-wired'
        source: 'config/configNetwork.qml'
    }
    // ConfigCategory {
    //     name: i18n('Tooltip')
    //     icon: 'dialog-information' //'preferences-desktop-locale' //'configure'
    //     source: 'config/configToolTip.qml'
    // }
}
