import QtQuick 2.2
import org.kde.plasma.configuration 2.0

ConfigModel {
    ConfigCategory {
         name: i18n('General')
         icon: 'preferences-desktop-settings'
         source: 'config/ConfigGeneral.qml'
    }
    // ConfigCategory {
    //     name: i18n('Tooltip')
    //     icon: 'dialog-information' //'preferences-desktop-locale' //'configure'
    //     source: 'config/configToolTip.qml'
    // }
    ConfigCategory {
        name: i18n('Network' + ' ' + 'Interface(s)')
        icon: 'network-card' //'network-wired'
        source: 'config/configNetwork.qml'
    }
}
