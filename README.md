![1a](https://user-images.githubusercontent.com/72889808/217653034-4ed63b12-875b-4001-84f7-b3159d933a99.png)

# plasma-applet-net-bandwidth-monitor

Network bandwidth monitor for plasma using dbus

Plasma 5 widget that displays network bandwidth data. Built upon the foundations of the excellent work by [dfaust](https://github.com/dfaust/plasma-applet-netspeed-widget/) and [bstrong5280](https://www.opencode.net/bstrong5280/system-monitor-plasmoid).

I've taken the UI element from netspeed-widget and the dbus workings from system-monitor, glued them together and added many additional options. This widget doesn't need ksysguard to function.
This is extremely BETA software and the first plasma widget I've worked on. If you find something or many things that aren't working, let me know and I'll take a look when I can.

## v0.4

Cleaned up lots of code in settings section, 343 lines of code removed and reworked.
Added 'Custom Icon Style' option.
Added 'Speed icon size' option.
Added 'Prefix/Suffix size' option.
reworked 'Number font size' option.
Added Sliders for font resizing.
Added 'Decimal Place Filter' to manage how the decimal place in the bandwidth data is presented.
Added 'Rounded Whole number' to manage how the rounding in the bandwidth data is presented.
Changes made to the Settings page, info button reworked, text amendments and setting section line breaks added.

## v0.5

Added multiple colour selection options with custom colour picker, options: Default Theme, Base Colour and Speed Based Colours.

- Default Theme, will respect the underlying default theme colours.
- Base Colour, each element can be assign its own hardcoded colour.
- Speed Colour, icons or digits or suffix (or all of the row of the three elements) can be assigned colours based on if the speed is in bit, Kil, Meg or Gig.

Added option to toggle speed units on or off. If 'bit' is disabled, speed values will only be displayed in 'Kil' units, etc.
Added option to remove decimal place and fraction digits at idle, only '0' will be displayed vs '0.0'.  
Continued code improvements.  
Improved theming and layout in settings panel.

Fixes:
Text colour in settings section now uses the correct theme text colour.  
To fix interfaces not being found after widget started, I've rewritten how the widget gets and stores the network interface functions and added continuous monitoring of the system network interfaces. If a new network interface is added to the system, the widget should now be aware and add it enabled to the device list to monitor.  
This is experimental and has had very limited testing.

##

Thanks to all those that feedback their experiences using the widget and the thanks received.

## DONATIONS

I like money! Donations are very much appreciated.

### Fiat Currency:

| Provider                                                                    | Address                                           |
| --------------------------------------------------------------------------- | ------------------------------------------------- |
| [**Paypal**](https://www.paypal.com/donate/?hosted_button_id=EJ3ZRERP2DK5Q) | paypal.com/donate/?hosted_button_id=EJ3ZRERP2DK5Q |

### Crypto Currency:

| Crypto           | ID      | Address                                        |
| ---------------- | ------- | ---------------------------------------------- |
| **Bitcoin**      | **BTC** | `bc1q9qec2027k8qlx4xuyhpzqe4gvc60faw3feg4zz`   |
| **Ethereum**     | **ETH** | `0x7260F14749D468FD6b91b12Ed1329239F5e54b1A`   |
| **Binance**      | **BNB** | `bnb1f4vw559m6ggel0y876y4ukc8q0xusqyvev8elq`   |
| **Solana**       | **SOL** | `9azTT48gmVxFQeKLGqg7rRw58tPokBP4MkycLEW2Fq1S` |
| **XRP**          | **XRP** | `r39tUB4AyWCwRS7bexsZ6tYW372vptj351 `          |
| **Bitcoin Cash** | **BCH** | `qpc552eputvg4qk2nlmm8gzg2s9qkrr83cm9dpjjs9`   |
| **Litecoin**     | **LTC** | `ltc1qkg9wg8t8alz5ltmyct3rs247qy98nv58qjdm2y`  |

## IF EXPERIENCING ISSUES AFTER INSTALL / UPGRADE:

When upgrading via the Plasma 'get widgets' section, make sure you have the new version in the 'about' section. If in doubt, download the .plasmoid and install via commandline with `plasmapkg2 -i /PATH/xxx.plasmoid`. Once installed, I've found its a good idea to reboot or log out and in again, it seems to refresh the serialized stored settings.

## OPTIONS:

- Layout
- Display Order
- Show speeds separately
- Update interval
- Interval data relay
- Layout Padding
- Hide when inactive
- Number font size
- Icon Font size
- Prefix/Suffix font size
- Show speed units
- Speed units
- Shorten speed units
- Show speed icons
- Show 'per seconds' suffix
- 'Per seconds' prefix
- Icon style
- Custom icon style
- Icon position
- Numbers [binary, metric]
- **Idle decimal - NEW**
- Decimal place
- **Speed unit selection - NEW**
- Decimal place filter
- Rounded whole number
- Monitor individual or multiple interfaces
- **Colour: Respect default theme - NEW**
- **Colour: Individual element base colour - NEW**
- **Colour: Dynamic Speed unit colour - NEW**

## TODO:

- Main options:
  - shrink area on taskbar when hidden
  - minimum activity for hidden
  - Translations
- ToolTip options:
  - Show ToolTip
  - Show bandwidth Totals
  - Bandwidth Units
  - Show Interface name
  - Show IP address
  - Show additional IP info
  - Show Icon
  - Icon option (Wired, Wireless, Globe)
  - Show WiFi signal strength

## SCREENSHOTS

![4](https://user-images.githubusercontent.com/72889808/209709200-9f4c045e-2b54-4fb3-9758-62c4096e8fc9.png)

![A](https://user-images.githubusercontent.com/72889808/217652964-20a0556a-a403-40e5-9e54-5a49bdb83fd5.png)

![1](https://user-images.githubusercontent.com/72889808/209696486-0419dd51-f7c8-47a4-aba6-1f2fc4590812.png)

![B](https://user-images.githubusercontent.com/72889808/217652736-9e8c7d27-d5eb-486f-ab66-e8bcc28b87ca.png)

![C](https://user-images.githubusercontent.com/72889808/217652754-07799096-c390-4bde-a974-8632371cd54d.png)

![D](https://user-images.githubusercontent.com/72889808/217654861-3e6d21ac-91bd-41eb-a592-5aedf321624b.png)
