## New Translations

1. Fill out [`template.pot`](template.pot) with your translations then open a [new issue](https://github.com/LeeVD/plasma-applet-net-bandwidth-monitor/issues/new), name the file `spanish.txt`, attach the txt file to the issue (drag and drop).

Or if you know how to make a pull request

1. Copy the `template.pot` file and name it your locale's code (Eg: `en`/`de`/`fr`) with the extension `.po`. Then fill out all the `msgstr ""`.

## Scripts

* `sh ./merge` will parse the `i18n()` calls in the `*.qml` files and write it to the `template.pot` file. Then it will merge any changes into the `*.po` language files.
* `sh ./build` will convert the `*.po` files to it's binary `*.mo` version and move it to `contents/locale/...` which will bundle the translations in the `*.plasmoid` without needing the user to manually install them.

## Links

* i18n scripts from: https://github.com/Zren/plasma-applet-lib/tree/master/package/translate

## Status

|  Locale  |  Lines  | % Done|
|----------|---------|-------|
| Template |      57 |       |
| zh_CN    |   57/57 |  100% |
