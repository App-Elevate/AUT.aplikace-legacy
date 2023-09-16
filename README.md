# autojidelna

Aplikace pro objednávání ze systému Icanteen. Cíl této aplikace je zjednodušit, zrychlit, (případně i zautomatizovat) objednávání obědů.

## Kompilování

            
Odstraňte klíče originálního autora tím, že přepíšete ['signingConfig signingConfigs.release'](https://github.com/tpkowastaken/autojidelna/blob/35ed7ff2f0dec0c4582973b6c5b111dea43f2a0b/android/app/build.gradle#L72) na ```signingConfig signingConfigs.debug``` a odstraněním [signing Keys]()
Pro systém android stačí mít nainstalovaný [Flutter](https://docs.flutter.dev/get-started/install) a poté ```flutter build apk``` pro android na windows nebo ```flutter build ipa``` pro ios na macbooku. Aplikaci na IOS můžete nainstalovat pomocí [tohoto návodu](https://chrunos.com/install-ipa-on-iphone/)

## Prémiové Featury

Featury pro prémiové uživatele jsou na našem server-side softwaru a tato aplikace pouze tyto featury používá. V kódu je tu tedy nenajdete.
