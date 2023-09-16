# autojidelna

Aplikace pro objednávání ze systému Icanteen. Cíl této aplikace je zjednodušit, zrychlit, (případně i zautomatizovat) objednávání obědů.

## Kompilování

            
Odstraňte klíče originálního autora tím, že přepíšete ['signingConfig signingConfigs.release'](https://github.com/tpkowastaken/autojidelna/blob/35ed7ff2f0dec0c4582973b6c5b111dea43f2a0b/android/app/build.gradle#L72-L73) na ```signingConfig signingConfigs.debug``` a odstraněním [signing Keys](https://github.com/tpkowastaken/autojidelna/blob/5d0587befd74fd58315ccc131894feb8588b09fe/android/app/build.gradle#L27-L31) a odstraněním [signing Configs](https://github.com/tpkowastaken/autojidelna/blob/5d0587befd74fd58315ccc131894feb8588b09fe/android/app/build.gradle#L60-L67)
Pro systém android stačí mít nainstalovaný [Flutter](https://docs.flutter.dev/get-started/install) a poté ```flutter build apk``` pro android na windows nebo ```flutter build ipa``` pro ios na macbooku. Aplikaci na IOS můžete nainstalovat pomocí [tohoto návodu](https://chrunos.com/install-ipa-on-iphone/)

## Prémiové Featury

Featury pro prémiové uživatele jsou na našem server-side softwaru a tato aplikace pouze tyto featury používá. V kódu je tu tedy nenajdete.
