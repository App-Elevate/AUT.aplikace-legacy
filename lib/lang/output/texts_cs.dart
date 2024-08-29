import 'package:intl/intl.dart' as intl;

import 'texts.dart';

/// The translations for Czech (`cs`).
class TextsCs extends Texts {
  TextsCs([String locale = 'cs']) : super(locale);

  @override
  String get toastExit => 'Zmáčkněte tlačítko zpět pro ukončení aplikace';

  @override
  String get errorsBadLogin => 'Nesprávné přihlašovací údaje';

  @override
  String get errorsBadUrl => 'Nesprávné Url';

  @override
  String get errorsBadPassword => 'Špatné heslo nebo uživatelské jméno';

  @override
  String get errorsUpdatingData => 'Nastala chyba při aktualizaci dat';

  @override
  String get errorsLoadingData => 'Nastala chyba při načítání dat';

  @override
  String get errorsObjednavaniJidla => 'Nastala chyba při objednávání jídla';

  @override
  String get errorsJidloNeniNaBurze => 'Jídlo není na burze';

  @override
  String get errorsChybaPriDavaniNaBurzu =>
      'Nastala chyba při dávání jídla na burzu';

  @override
  String get errorsBadConnection =>
      'Nepodařilo se připojit k serveru icanteen. Zkuste to znovu později';

  @override
  String get errorsNoInternet => 'Nemáte připojení k internetu';

  @override
  String get errorsLoginFailed => 'Přihlašování selhalo';

  @override
  String errorsLoginFailedDetail(String error) {
    return 'Při přihlašování došlo k chybě: $error';
  }

  @override
  String get errorsDownloadingApp => 'Aktualizace aplikace selhala';

  @override
  String get errorsDownloadingAppDetail =>
      'Při Stahování aplikace došlo k chybě. Ověřte vaše připojení a zkuste znovu.';

  @override
  String get errorsLoad => 'Selhalo načítání jídelníčku';

  @override
  String get errorsObedNelzeZrusit =>
      'Oběd nelze zrušit. Platnost objednávky vypršela.';

  @override
  String get errorsNelzeObjednat => 'Oběd nelze objednat';

  @override
  String get errorsNelzeObjednatKredit =>
      'Oběd nelze objednat - Nedostatečný kredit.';

  @override
  String get errorsChybaPriRuseni => 'Nastala chyba při rušení objednávky';

  @override
  String get errorsUndefined => 'Nastala Chyba';

  @override
  String get errorsChangelog => 'Nepodařilo se získat změny :/';

  @override
  String get tryAgain => 'Zkusit znovu';

  @override
  String get cancel => 'Zrušit';

  @override
  String get ok => 'OK';

  @override
  String get currency => 'Kč';

  @override
  String get appName => 'Autojídelna';

  @override
  String get shareDescription => 'Autojídelna (aplikace na objednávání jídla)';

  @override
  String get settings => 'Nastavení';

  @override
  String get menu => 'Jídelníček';

  @override
  String get addAccount => 'Přidat účet';

  @override
  String get changeAccount => 'Změnit účet';

  @override
  String get switchAccountPanelTitle => 'Účty';

  @override
  String get updateSnackbarWaiting => 'Aktualizace - Čeká se na oprávnění';

  @override
  String get updateSnackbarError =>
      'Došlo k chybě při stahování. Ověřte připojení a zkuste to znovu';

  @override
  String updateSnackbarDownloading(int value) {
    return 'Nová Aktualizace se stahuje - $value%';
  }

  @override
  String get updateSnackbarDownloaded =>
      'Aktualizace byla stažena, instalování';

  @override
  String popupNewVersionAvailable(String version) {
    return 'Nová verze aplikace - $version';
  }

  @override
  String get popupNewUpdateInfo => 'Nová verze přináší: ';

  @override
  String get popupChangelogNotAvailable => 'Changelog není k dispozici';

  @override
  String get popupUpdate => 'Aktualizovat';

  @override
  String get popupShowOnGithub => 'Zobrazit na Githubu';

  @override
  String get popupNotNow => 'Teď ne';

  @override
  String get logoutUSure => 'Opravdu se chcete odhlásit?';

  @override
  String get logoutConfirm => 'Odhlásit se';

  @override
  String get accountDrawerLocationsUnknown => 'Neznámá lokalita';

  @override
  String get account => 'Účet';

  @override
  String get shareApp => 'Sdílet aplikaci';

  @override
  String get accountDrawerPickLocation => 'Vyberte lokaci: ';

  @override
  String get about => 'O aplikaci';

  @override
  String aboutCopyRight(DateTime time) {
    final intl.DateFormat timeDateFormat = intl.DateFormat.y(localeName);
    final String timeString = timeDateFormat.format(time);

    return '© 2023 - $timeString Tomáš Protiva, Matěj Verhaegen a kolaborátoři\nZveřejněno pod licencí GNU GPLv3';
  }

  @override
  String get aboutSourceCode => 'Zdrojový kód';

  @override
  String get aboutLatestVersion =>
      'Aktuálně jste na nejnovější verzi aplikace 👍';

  @override
  String get aboutCheckForUpdates => 'Zkontrolovat aktualizace';

  @override
  String get settingsAppearence => 'Vzhled';

  @override
  String get settingsTheme => 'Schéma';

  @override
  String get systemThemeMode => 'Systém';

  @override
  String get lightThemeMode => 'Světlý';

  @override
  String get darkThemeMode => 'Tmavý';

  @override
  String get settingsAmoled => 'AMOLED mód';

  @override
  String get settingsAmoledSub => 'Join the dark side!';

  @override
  String get settingsDisplay => 'Zobrazení';

  @override
  String get settingsRelativeTimestamps => 'Relativní časové značky';

  @override
  String settingsRelativeTimestampsSub(String date) {
    return 'Dnes místo {date}';
  }

  @override
  String get convenience => 'Pohodlí';

  @override
  String get listUi => 'List UI';

  @override
  String get tabletUi => 'Tablet UI';

  @override
  String get settingsCalendarBigMarkers => 'Velké ukazatele v kalendáři';

  @override
  String get settingsSkipWeekends =>
      'Přeskakovat víkendy při procházení jídelníčku';

  @override
  String settingsNotificationFor(String username) {
    return 'Oznámení pro $username';
  }

  @override
  String get settingsTitleTodaysFood => 'Dnešní jídlo';

  @override
  String get settingsTitleCredit => 'Nízký credit';

  @override
  String get settingsNotificationTime => 'Čas oznámení: ';

  @override
  String get settingsNemateObjednano => 'Nemáte objednáno na příští týden';

  @override
  String get settingsAnotherOptions => 'Další možnosti v nastavení systému...';

  @override
  String get settingsDataCollection => 'Shromažďování údajů';

  @override
  String get settingsStopDataCollection =>
      'Zastavit sledování analytických služeb';

  @override
  String get settingsDataCollectionDescription_1 =>
      'Informace sbíráme pouze pro opravování chyb v aplikaci a udržování velmi základních statistik. Vzhledem k tomu, že nemůžeme vyzkoušet autojídelnu u jídelen, kde nemáme přístup musíme záviset na tomto. Více informací naleznete ve ';

  @override
  String get settingsDataCollectionDescription_2 => 'Zdrojovém kódu';

  @override
  String get settingsDataCollectionDescription_3 => ' nebo na ';

  @override
  String settingsDataCollectionDescription_4(String arg) {
    String _temp0 = intl.Intl.selectLogic(
      arg,
      {
        '1': 'seznamu',
        'other': 'Seznam',
      },
    );
    return '$_temp0 sbíraných dat';
  }

  @override
  String get settingsDebugOptions => 'Debug Options';

  @override
  String get settingsDebugForceNotifications => 'Force send notifications';

  @override
  String get settingsDebugNotifications => 'Send Notifications';

  @override
  String credit(double ammount) {
    final intl.NumberFormat ammountNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String ammountString = ammountNumberFormat.format(ammount);

    return 'Kredit: $ammountString Kč';
  }

  @override
  String get personalInfo => 'Osobní Údaje';

  @override
  String name(String first, String last) {
    return 'Jméno: $first $last';
  }

  @override
  String category(String category) {
    return 'Kategorie: $category';
  }

  @override
  String get paymentInfo => 'Platební Údaje';

  @override
  String paymentAccountNumber(String num) {
    return 'Číslo účtu: $num';
  }

  @override
  String specificSymbol(String symbol) {
    return 'Specifický symbol: $symbol';
  }

  @override
  String variableSymbol(String symbol) {
    return 'Variabilní symbol: $symbol';
  }

  @override
  String ordersWithAutojidelna(int ammount) {
    return 'Objednávky s Autojídelnou: $ammount';
  }

  @override
  String get allowPermission => 'Udělit oprávnění';

  @override
  String get neededPermission => 'Potřebné oprávnění';

  @override
  String get neededPermissionDescription_1 =>
      'Pro automatickou instalaci aktualizace je potřeba povolit oprávnění pro instalaci aplikací z neznámých zdrojů.';

  @override
  String get neededPermissionDescription_2 => 'Ta může vypadat takto:';

  @override
  String get neededPermissionDescription_3 =>
      'Toto oprávnění používáme pouze k aktualizaci aplikace. Pokud si nepřejete oprávnění povolit můžete stále stáhnout apk z githubu.';

  @override
  String get loginUrlFieldLabel =>
      'Url stránky icanteen - např. jidelna.trebesin.cz';

  @override
  String get loginUrlFieldHint =>
      'Zadejte prosím url stránky icanteen - např. jidelna.trebesin.cz';

  @override
  String get loginUserFieldLabel => 'Uživatelské jméno';

  @override
  String get loginUserFieldHint => 'Zadejte prosím své uživatelské jméno';

  @override
  String get loginPasswordFieldLabel => 'Heslo';

  @override
  String get loginPasswordFieldHint => 'Zadejte prosím své heslo';

  @override
  String get dataCollectionAgreement =>
      'Používáním aplikace souhlasíte se zasíláním anonymních dat. ';

  @override
  String get moreInfo => 'Více informací.';

  @override
  String get loginButton => 'Přihlásit se';

  @override
  String get soup => 'Polévka';

  @override
  String get mainCourse => 'Hlavní chod';

  @override
  String get drinks => 'Pití';

  @override
  String get sideDish => 'Přílohy';

  @override
  String get other => 'Ostatní';

  @override
  String get allergens => 'Alergeny';

  @override
  String get noFood => 'Žádná jídla pro tento den.';

  @override
  String get objednat => 'Objednat';

  @override
  String get nelzeZrusit => 'Nelze zrušit';

  @override
  String get nedostatekKreditu => 'Nedostatek kreditu';

  @override
  String get nelzeObjednat => 'Nelze objednat';

  @override
  String get vlozitNaBurzu => 'Vložit na burzu';

  @override
  String get objednatZBurzy => 'Objednat z burzy';

  @override
  String get odebratZBurzy => 'Odebrat z burzy';

  @override
  String get notifications => 'Oznámení';

  @override
  String notificationsFor(String username) {
    return 'Oznámení pro $username';
  }

  @override
  String get jidloChannelName => 'Dnešní jídlo';

  @override
  String jidloChannelDescription(String username) {
    return 'Oznámení každý den o tom jaké je dnes jídlo pro $username';
  }

  @override
  String get dochazejiciKreditChannelName => 'Docházející kredit';

  @override
  String dochazejiciKreditChannelDescription(String username) {
    return 'Oznámení o tom, zda vám dochází kredit týden dopředu pro $username';
  }

  @override
  String get objednanoChannelName => 'Objednáno?';

  @override
  String objednanoChannelDescription(String username) {
    return 'Oznámení týden dopředu o tom, zda jste si objednal jídlo na příští týden pro $username';
  }

  @override
  String get otherDescription => 'Ostatní oznámení, např. chybové hlášky';

  @override
  String get gettingDataNotifications => 'Získávám data pro oznámení';

  @override
  String get notificationDochaziVamKredit => 'Dochází vám kredit!';

  @override
  String notificationKreditPro(String first, String last, String ammount) {
    return 'Kredit pro $first $last: $ammount Kč';
  }

  @override
  String get notificationZtlumit => 'Ztlumit na týden';

  @override
  String get notificationObjednejteSi => 'Objednejte si na příští týden';

  @override
  String notificationObjednejteSiDetail(
      String first, String last, Object fist) {
    return 'Uživatel $fist $last si stále ještě neobjenal na příští týden';
  }

  @override
  String get objednatAction => 'Objednat náhodně';

  @override
  String get version => 'Verze';

  @override
  String get debug => 'Debug';

  @override
  String get stable => 'Stable';

  @override
  String aboutVersionSubtitle(String arg, String version) {
    String _temp0 = intl.Intl.selectLogic(
      arg,
      {
        'true': 'Debug',
        'other': 'Stable',
      },
    );
    return '$_temp0 $version';
  }

  @override
  String get licenses => 'Licenses';

  @override
  String get statistics => 'Statistiky';

  @override
  String get dateFormat => 'Formát dat';
}
