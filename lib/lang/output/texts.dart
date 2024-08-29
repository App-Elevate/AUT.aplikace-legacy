import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'texts_cs.dart';

/// Callers can lookup localized strings with an instance of Texts
/// returned by `Texts.of(context)`.
///
/// Applications need to include `Texts.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'output/texts.dart';
///
/// return MaterialApp(
///   localizationsDelegates: Texts.localizationsDelegates,
///   supportedLocales: Texts.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the Texts.supportedLocales
/// property.
abstract class Texts {
  Texts(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static Texts of(BuildContext context) {
    return Localizations.of<Texts>(context, Texts)!;
  }

  static const LocalizationsDelegate<Texts> delegate = _TextsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('cs')];

  /// No description provided for @toastExit.
  ///
  /// In cs, this message translates to:
  /// **'Zmáčkněte tlačítko zpět pro ukončení aplikace'**
  String get toastExit;

  /// No description provided for @errorsBadLogin.
  ///
  /// In cs, this message translates to:
  /// **'Nesprávné přihlašovací údaje'**
  String get errorsBadLogin;

  /// No description provided for @errorsBadUrl.
  ///
  /// In cs, this message translates to:
  /// **'Nesprávné Url'**
  String get errorsBadUrl;

  /// No description provided for @errorsBadPassword.
  ///
  /// In cs, this message translates to:
  /// **'Špatné heslo nebo uživatelské jméno'**
  String get errorsBadPassword;

  /// No description provided for @errorsUpdatingData.
  ///
  /// In cs, this message translates to:
  /// **'Nastala chyba při aktualizaci dat'**
  String get errorsUpdatingData;

  /// No description provided for @errorsLoadingData.
  ///
  /// In cs, this message translates to:
  /// **'Nastala chyba při načítání dat'**
  String get errorsLoadingData;

  /// No description provided for @errorsObjednavaniJidla.
  ///
  /// In cs, this message translates to:
  /// **'Nastala chyba při objednávání jídla'**
  String get errorsObjednavaniJidla;

  /// No description provided for @errorsJidloNeniNaBurze.
  ///
  /// In cs, this message translates to:
  /// **'Jídlo není na burze'**
  String get errorsJidloNeniNaBurze;

  /// No description provided for @errorsChybaPriDavaniNaBurzu.
  ///
  /// In cs, this message translates to:
  /// **'Nastala chyba při dávání jídla na burzu'**
  String get errorsChybaPriDavaniNaBurzu;

  /// No description provided for @errorsBadConnection.
  ///
  /// In cs, this message translates to:
  /// **'Nepodařilo se připojit k serveru icanteen. Zkuste to znovu později'**
  String get errorsBadConnection;

  /// No description provided for @errorsNoInternet.
  ///
  /// In cs, this message translates to:
  /// **'Nemáte připojení k internetu'**
  String get errorsNoInternet;

  /// No description provided for @errorsLoginFailed.
  ///
  /// In cs, this message translates to:
  /// **'Přihlašování selhalo'**
  String get errorsLoginFailed;

  /// No description provided for @errorsLoginFailedDetail.
  ///
  /// In cs, this message translates to:
  /// **'Při přihlašování došlo k chybě: {error}'**
  String errorsLoginFailedDetail(String error);

  /// No description provided for @errorsDownloadingApp.
  ///
  /// In cs, this message translates to:
  /// **'Aktualizace aplikace selhala'**
  String get errorsDownloadingApp;

  /// No description provided for @errorsDownloadingAppDetail.
  ///
  /// In cs, this message translates to:
  /// **'Při Stahování aplikace došlo k chybě. Ověřte vaše připojení a zkuste znovu.'**
  String get errorsDownloadingAppDetail;

  /// No description provided for @errorsLoad.
  ///
  /// In cs, this message translates to:
  /// **'Selhalo načítání jídelníčku'**
  String get errorsLoad;

  /// No description provided for @errorsObedNelzeZrusit.
  ///
  /// In cs, this message translates to:
  /// **'Oběd nelze zrušit. Platnost objednávky vypršela.'**
  String get errorsObedNelzeZrusit;

  /// No description provided for @errorsNelzeObjednat.
  ///
  /// In cs, this message translates to:
  /// **'Oběd nelze objednat'**
  String get errorsNelzeObjednat;

  /// No description provided for @errorsNelzeObjednatKredit.
  ///
  /// In cs, this message translates to:
  /// **'Oběd nelze objednat - Nedostatečný kredit.'**
  String get errorsNelzeObjednatKredit;

  /// No description provided for @errorsChybaPriRuseni.
  ///
  /// In cs, this message translates to:
  /// **'Nastala chyba při rušení objednávky'**
  String get errorsChybaPriRuseni;

  /// No description provided for @errorsUndefined.
  ///
  /// In cs, this message translates to:
  /// **'Nastala Chyba'**
  String get errorsUndefined;

  /// No description provided for @errorsChangelog.
  ///
  /// In cs, this message translates to:
  /// **'Nepodařilo se získat změny :/'**
  String get errorsChangelog;

  /// No description provided for @tryAgain.
  ///
  /// In cs, this message translates to:
  /// **'Zkusit znovu'**
  String get tryAgain;

  /// No description provided for @cancel.
  ///
  /// In cs, this message translates to:
  /// **'Zrušit'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In cs, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @currency.
  ///
  /// In cs, this message translates to:
  /// **'Kč'**
  String get currency;

  /// No description provided for @appName.
  ///
  /// In cs, this message translates to:
  /// **'Autojídelna'**
  String get appName;

  /// No description provided for @shareDescription.
  ///
  /// In cs, this message translates to:
  /// **'Autojídelna (aplikace na objednávání jídla)'**
  String get shareDescription;

  /// No description provided for @settings.
  ///
  /// In cs, this message translates to:
  /// **'Nastavení'**
  String get settings;

  /// No description provided for @menu.
  ///
  /// In cs, this message translates to:
  /// **'Jídelníček'**
  String get menu;

  /// No description provided for @addAccount.
  ///
  /// In cs, this message translates to:
  /// **'Přidat účet'**
  String get addAccount;

  /// No description provided for @changeAccount.
  ///
  /// In cs, this message translates to:
  /// **'Změnit účet'**
  String get changeAccount;

  /// No description provided for @switchAccountPanelTitle.
  ///
  /// In cs, this message translates to:
  /// **'Účty'**
  String get switchAccountPanelTitle;

  /// No description provided for @updateSnackbarWaiting.
  ///
  /// In cs, this message translates to:
  /// **'Aktualizace - Čeká se na oprávnění'**
  String get updateSnackbarWaiting;

  /// No description provided for @updateSnackbarError.
  ///
  /// In cs, this message translates to:
  /// **'Došlo k chybě při stahování. Ověřte připojení a zkuste to znovu'**
  String get updateSnackbarError;

  /// No description provided for @updateSnackbarDownloading.
  ///
  /// In cs, this message translates to:
  /// **'Nová Aktualizace se stahuje - {value}%'**
  String updateSnackbarDownloading(int value);

  /// No description provided for @updateSnackbarDownloaded.
  ///
  /// In cs, this message translates to:
  /// **'Aktualizace byla stažena, instalování'**
  String get updateSnackbarDownloaded;

  /// No description provided for @popupNewVersionAvailable.
  ///
  /// In cs, this message translates to:
  /// **'Nová verze aplikace - {version}'**
  String popupNewVersionAvailable(String version);

  /// No description provided for @popupNewUpdateInfo.
  ///
  /// In cs, this message translates to:
  /// **'Nová verze přináší: '**
  String get popupNewUpdateInfo;

  /// No description provided for @popupChangelogNotAvailable.
  ///
  /// In cs, this message translates to:
  /// **'Changelog není k dispozici'**
  String get popupChangelogNotAvailable;

  /// No description provided for @popupUpdate.
  ///
  /// In cs, this message translates to:
  /// **'Aktualizovat'**
  String get popupUpdate;

  /// No description provided for @popupShowOnGithub.
  ///
  /// In cs, this message translates to:
  /// **'Zobrazit na Githubu'**
  String get popupShowOnGithub;

  /// No description provided for @popupNotNow.
  ///
  /// In cs, this message translates to:
  /// **'Teď ne'**
  String get popupNotNow;

  /// No description provided for @logoutUSure.
  ///
  /// In cs, this message translates to:
  /// **'Opravdu se chcete odhlásit?'**
  String get logoutUSure;

  /// No description provided for @logoutConfirm.
  ///
  /// In cs, this message translates to:
  /// **'Odhlásit se'**
  String get logoutConfirm;

  /// No description provided for @accountDrawerLocationsUnknown.
  ///
  /// In cs, this message translates to:
  /// **'Neznámá lokalita'**
  String get accountDrawerLocationsUnknown;

  /// No description provided for @account.
  ///
  /// In cs, this message translates to:
  /// **'Účet'**
  String get account;

  /// No description provided for @shareApp.
  ///
  /// In cs, this message translates to:
  /// **'Sdílet aplikaci'**
  String get shareApp;

  /// No description provided for @accountDrawerPickLocation.
  ///
  /// In cs, this message translates to:
  /// **'Vyberte lokaci: '**
  String get accountDrawerPickLocation;

  /// No description provided for @about.
  ///
  /// In cs, this message translates to:
  /// **'O aplikaci'**
  String get about;

  /// No description provided for @aboutCopyRight.
  ///
  /// In cs, this message translates to:
  /// **'© 2023 - {time} Tomáš Protiva, Matěj Verhaegen a kolaborátoři\nZveřejněno pod licencí GNU GPLv3'**
  String aboutCopyRight(DateTime time);

  /// No description provided for @aboutSourceCode.
  ///
  /// In cs, this message translates to:
  /// **'Zdrojový kód'**
  String get aboutSourceCode;

  /// No description provided for @aboutLatestVersion.
  ///
  /// In cs, this message translates to:
  /// **'Aktuálně jste na nejnovější verzi aplikace 👍'**
  String get aboutLatestVersion;

  /// No description provided for @aboutCheckForUpdates.
  ///
  /// In cs, this message translates to:
  /// **'Zkontrolovat aktualizace'**
  String get aboutCheckForUpdates;

  /// No description provided for @settingsAppearence.
  ///
  /// In cs, this message translates to:
  /// **'Vzhled'**
  String get settingsAppearence;

  /// No description provided for @settingsTheme.
  ///
  /// In cs, this message translates to:
  /// **'Schéma'**
  String get settingsTheme;

  /// No description provided for @systemThemeMode.
  ///
  /// In cs, this message translates to:
  /// **'Systém'**
  String get systemThemeMode;

  /// No description provided for @lightThemeMode.
  ///
  /// In cs, this message translates to:
  /// **'Světlý'**
  String get lightThemeMode;

  /// No description provided for @darkThemeMode.
  ///
  /// In cs, this message translates to:
  /// **'Tmavý'**
  String get darkThemeMode;

  /// No description provided for @settingsAmoled.
  ///
  /// In cs, this message translates to:
  /// **'AMOLED mód'**
  String get settingsAmoled;

  /// No description provided for @settingsAmoledSub.
  ///
  /// In cs, this message translates to:
  /// **'Join the dark side!'**
  String get settingsAmoledSub;

  /// No description provided for @settingsDisplay.
  ///
  /// In cs, this message translates to:
  /// **'Zobrazení'**
  String get settingsDisplay;

  /// No description provided for @settingsRelativeTimestamps.
  ///
  /// In cs, this message translates to:
  /// **'Relativní časové značky'**
  String get settingsRelativeTimestamps;

  /// No description provided for @settingsRelativeTimestampsSub.
  ///
  /// In cs, this message translates to:
  /// **'\'Dnes\' místo \'{date}\''**
  String settingsRelativeTimestampsSub(String date);

  /// No description provided for @convenience.
  ///
  /// In cs, this message translates to:
  /// **'Pohodlí'**
  String get convenience;

  /// No description provided for @listUi.
  ///
  /// In cs, this message translates to:
  /// **'List UI'**
  String get listUi;

  /// No description provided for @tabletUi.
  ///
  /// In cs, this message translates to:
  /// **'Tablet UI'**
  String get tabletUi;

  /// No description provided for @settingsCalendarBigMarkers.
  ///
  /// In cs, this message translates to:
  /// **'Velké ukazatele v kalendáři'**
  String get settingsCalendarBigMarkers;

  /// No description provided for @settingsSkipWeekends.
  ///
  /// In cs, this message translates to:
  /// **'Přeskakovat víkendy při procházení jídelníčku'**
  String get settingsSkipWeekends;

  /// No description provided for @settingsNotificationFor.
  ///
  /// In cs, this message translates to:
  /// **'Oznámení pro {username}'**
  String settingsNotificationFor(String username);

  /// No description provided for @settingsTitleTodaysFood.
  ///
  /// In cs, this message translates to:
  /// **'Dnešní jídlo'**
  String get settingsTitleTodaysFood;

  /// No description provided for @settingsTitleCredit.
  ///
  /// In cs, this message translates to:
  /// **'Nízký credit'**
  String get settingsTitleCredit;

  /// No description provided for @settingsNotificationTime.
  ///
  /// In cs, this message translates to:
  /// **'Čas oznámení: '**
  String get settingsNotificationTime;

  /// No description provided for @settingsNemateObjednano.
  ///
  /// In cs, this message translates to:
  /// **'Nemáte objednáno na příští týden'**
  String get settingsNemateObjednano;

  /// No description provided for @settingsAnotherOptions.
  ///
  /// In cs, this message translates to:
  /// **'Další možnosti v nastavení systému...'**
  String get settingsAnotherOptions;

  /// No description provided for @settingsDataCollection.
  ///
  /// In cs, this message translates to:
  /// **'Shromažďování údajů'**
  String get settingsDataCollection;

  /// No description provided for @settingsStopDataCollection.
  ///
  /// In cs, this message translates to:
  /// **'Zastavit sledování analytických služeb'**
  String get settingsStopDataCollection;

  /// No description provided for @settingsDataCollectionDescription_1.
  ///
  /// In cs, this message translates to:
  /// **'Informace sbíráme pouze pro opravování chyb v aplikaci a udržování velmi základních statistik. Vzhledem k tomu, že nemůžeme vyzkoušet autojídelnu u jídelen, kde nemáme přístup musíme záviset na tomto. Více informací naleznete ve '**
  String get settingsDataCollectionDescription_1;

  /// No description provided for @settingsDataCollectionDescription_2.
  ///
  /// In cs, this message translates to:
  /// **'Zdrojovém kódu'**
  String get settingsDataCollectionDescription_2;

  /// No description provided for @settingsDataCollectionDescription_3.
  ///
  /// In cs, this message translates to:
  /// **' nebo na '**
  String get settingsDataCollectionDescription_3;

  /// 0 -> Seznam zbíraných dat 1 -> seznamu zbíraných dat
  ///
  /// In cs, this message translates to:
  /// **'{arg, select, 1{seznamu} other{Seznam}} sbíraných dat'**
  String settingsDataCollectionDescription_4(String arg);

  /// No description provided for @settingsDebugOptions.
  ///
  /// In cs, this message translates to:
  /// **'Debug Options'**
  String get settingsDebugOptions;

  /// No description provided for @settingsDebugForceNotifications.
  ///
  /// In cs, this message translates to:
  /// **'Force send notifications'**
  String get settingsDebugForceNotifications;

  /// No description provided for @settingsDebugNotifications.
  ///
  /// In cs, this message translates to:
  /// **'Send Notifications'**
  String get settingsDebugNotifications;

  /// No description provided for @credit.
  ///
  /// In cs, this message translates to:
  /// **'Kredit: {ammount} Kč'**
  String credit(double ammount);

  /// No description provided for @personalInfo.
  ///
  /// In cs, this message translates to:
  /// **'Osobní Údaje'**
  String get personalInfo;

  /// No description provided for @name.
  ///
  /// In cs, this message translates to:
  /// **'Jméno: {first} {last}'**
  String name(String first, String last);

  /// No description provided for @category.
  ///
  /// In cs, this message translates to:
  /// **'Kategorie: {category}'**
  String category(String category);

  /// No description provided for @paymentInfo.
  ///
  /// In cs, this message translates to:
  /// **'Platební Údaje'**
  String get paymentInfo;

  /// No description provided for @paymentAccountNumber.
  ///
  /// In cs, this message translates to:
  /// **'Číslo účtu: {num}'**
  String paymentAccountNumber(String num);

  /// No description provided for @specificSymbol.
  ///
  /// In cs, this message translates to:
  /// **'Specifický symbol: {symbol}'**
  String specificSymbol(String symbol);

  /// No description provided for @variableSymbol.
  ///
  /// In cs, this message translates to:
  /// **'Variabilní symbol: {symbol}'**
  String variableSymbol(String symbol);

  /// No description provided for @ordersWithAutojidelna.
  ///
  /// In cs, this message translates to:
  /// **'Objednávky s Autojídelnou: {ammount}'**
  String ordersWithAutojidelna(int ammount);

  /// No description provided for @allowPermission.
  ///
  /// In cs, this message translates to:
  /// **'Udělit oprávnění'**
  String get allowPermission;

  /// No description provided for @neededPermission.
  ///
  /// In cs, this message translates to:
  /// **'Potřebné oprávnění'**
  String get neededPermission;

  /// No description provided for @neededPermissionDescription_1.
  ///
  /// In cs, this message translates to:
  /// **'Pro automatickou instalaci aktualizace je potřeba povolit oprávnění pro instalaci aplikací z neznámých zdrojů.'**
  String get neededPermissionDescription_1;

  /// No description provided for @neededPermissionDescription_2.
  ///
  /// In cs, this message translates to:
  /// **'Ta může vypadat takto:'**
  String get neededPermissionDescription_2;

  /// No description provided for @neededPermissionDescription_3.
  ///
  /// In cs, this message translates to:
  /// **'Toto oprávnění používáme pouze k aktualizaci aplikace. Pokud si nepřejete oprávnění povolit můžete stále stáhnout apk z githubu.'**
  String get neededPermissionDescription_3;

  /// No description provided for @loginUrlFieldLabel.
  ///
  /// In cs, this message translates to:
  /// **'Url stránky icanteen - např. jidelna.trebesin.cz'**
  String get loginUrlFieldLabel;

  /// No description provided for @loginUrlFieldHint.
  ///
  /// In cs, this message translates to:
  /// **'Zadejte prosím url stránky icanteen - např. jidelna.trebesin.cz'**
  String get loginUrlFieldHint;

  /// No description provided for @loginUserFieldLabel.
  ///
  /// In cs, this message translates to:
  /// **'Uživatelské jméno'**
  String get loginUserFieldLabel;

  /// No description provided for @loginUserFieldHint.
  ///
  /// In cs, this message translates to:
  /// **'Zadejte prosím své uživatelské jméno'**
  String get loginUserFieldHint;

  /// No description provided for @loginPasswordFieldLabel.
  ///
  /// In cs, this message translates to:
  /// **'Heslo'**
  String get loginPasswordFieldLabel;

  /// No description provided for @loginPasswordFieldHint.
  ///
  /// In cs, this message translates to:
  /// **'Zadejte prosím své heslo'**
  String get loginPasswordFieldHint;

  /// No description provided for @dataCollectionAgreement.
  ///
  /// In cs, this message translates to:
  /// **'Používáním aplikace souhlasíte se zasíláním anonymních dat. '**
  String get dataCollectionAgreement;

  /// No description provided for @moreInfo.
  ///
  /// In cs, this message translates to:
  /// **'Více informací.'**
  String get moreInfo;

  /// No description provided for @loginButton.
  ///
  /// In cs, this message translates to:
  /// **'Přihlásit se'**
  String get loginButton;

  /// No description provided for @soup.
  ///
  /// In cs, this message translates to:
  /// **'Polévka'**
  String get soup;

  /// No description provided for @mainCourse.
  ///
  /// In cs, this message translates to:
  /// **'Hlavní chod'**
  String get mainCourse;

  /// No description provided for @drinks.
  ///
  /// In cs, this message translates to:
  /// **'Pití'**
  String get drinks;

  /// No description provided for @sideDish.
  ///
  /// In cs, this message translates to:
  /// **'Přílohy'**
  String get sideDish;

  /// No description provided for @other.
  ///
  /// In cs, this message translates to:
  /// **'Ostatní'**
  String get other;

  /// No description provided for @allergens.
  ///
  /// In cs, this message translates to:
  /// **'Alergeny'**
  String get allergens;

  /// No description provided for @noFood.
  ///
  /// In cs, this message translates to:
  /// **'Žádná jídla pro tento den.'**
  String get noFood;

  /// No description provided for @objednat.
  ///
  /// In cs, this message translates to:
  /// **'Objednat'**
  String get objednat;

  /// No description provided for @nelzeZrusit.
  ///
  /// In cs, this message translates to:
  /// **'Nelze zrušit'**
  String get nelzeZrusit;

  /// No description provided for @nedostatekKreditu.
  ///
  /// In cs, this message translates to:
  /// **'Nedostatek kreditu'**
  String get nedostatekKreditu;

  /// No description provided for @nelzeObjednat.
  ///
  /// In cs, this message translates to:
  /// **'Nelze objednat'**
  String get nelzeObjednat;

  /// No description provided for @vlozitNaBurzu.
  ///
  /// In cs, this message translates to:
  /// **'Vložit na burzu'**
  String get vlozitNaBurzu;

  /// No description provided for @objednatZBurzy.
  ///
  /// In cs, this message translates to:
  /// **'Objednat z burzy'**
  String get objednatZBurzy;

  /// No description provided for @odebratZBurzy.
  ///
  /// In cs, this message translates to:
  /// **'Odebrat z burzy'**
  String get odebratZBurzy;

  /// No description provided for @notifications.
  ///
  /// In cs, this message translates to:
  /// **'Oznámení'**
  String get notifications;

  /// No description provided for @notificationsFor.
  ///
  /// In cs, this message translates to:
  /// **'Oznámení pro {username}'**
  String notificationsFor(String username);

  /// No description provided for @jidloChannelName.
  ///
  /// In cs, this message translates to:
  /// **'Dnešní jídlo'**
  String get jidloChannelName;

  /// No description provided for @jidloChannelDescription.
  ///
  /// In cs, this message translates to:
  /// **'Oznámení každý den o tom jaké je dnes jídlo pro {username}'**
  String jidloChannelDescription(String username);

  /// No description provided for @dochazejiciKreditChannelName.
  ///
  /// In cs, this message translates to:
  /// **'Docházející kredit'**
  String get dochazejiciKreditChannelName;

  /// No description provided for @dochazejiciKreditChannelDescription.
  ///
  /// In cs, this message translates to:
  /// **'Oznámení o tom, zda vám dochází kredit týden dopředu pro {username}'**
  String dochazejiciKreditChannelDescription(String username);

  /// No description provided for @objednanoChannelName.
  ///
  /// In cs, this message translates to:
  /// **'Objednáno?'**
  String get objednanoChannelName;

  /// No description provided for @objednanoChannelDescription.
  ///
  /// In cs, this message translates to:
  /// **'Oznámení týden dopředu o tom, zda jste si objednal jídlo na příští týden pro {username}'**
  String objednanoChannelDescription(String username);

  /// No description provided for @otherDescription.
  ///
  /// In cs, this message translates to:
  /// **'Ostatní oznámení, např. chybové hlášky'**
  String get otherDescription;

  /// No description provided for @gettingDataNotifications.
  ///
  /// In cs, this message translates to:
  /// **'Získávám data pro oznámení'**
  String get gettingDataNotifications;

  /// No description provided for @notificationDochaziVamKredit.
  ///
  /// In cs, this message translates to:
  /// **'Dochází vám kredit!'**
  String get notificationDochaziVamKredit;

  /// No description provided for @notificationKreditPro.
  ///
  /// In cs, this message translates to:
  /// **'Kredit pro {first} {last}: {ammount} Kč'**
  String notificationKreditPro(String first, String last, String ammount);

  /// No description provided for @notificationZtlumit.
  ///
  /// In cs, this message translates to:
  /// **'Ztlumit na týden'**
  String get notificationZtlumit;

  /// No description provided for @notificationObjednejteSi.
  ///
  /// In cs, this message translates to:
  /// **'Objednejte si na příští týden'**
  String get notificationObjednejteSi;

  /// No description provided for @notificationObjednejteSiDetail.
  ///
  /// In cs, this message translates to:
  /// **'Uživatel {fist} {last} si stále ještě neobjenal na příští týden'**
  String notificationObjednejteSiDetail(String first, String last, Object fist);

  /// No description provided for @objednatAction.
  ///
  /// In cs, this message translates to:
  /// **'Objednat náhodně'**
  String get objednatAction;

  /// No description provided for @version.
  ///
  /// In cs, this message translates to:
  /// **'Verze'**
  String get version;

  /// No description provided for @debug.
  ///
  /// In cs, this message translates to:
  /// **'Debug'**
  String get debug;

  /// No description provided for @stable.
  ///
  /// In cs, this message translates to:
  /// **'Stable'**
  String get stable;

  /// aboutVersionSubtitle
  ///
  /// In cs, this message translates to:
  /// **'{arg, select, true{Debug} other{Stable}} {version}'**
  String aboutVersionSubtitle(String arg, String version);

  /// No description provided for @licenses.
  ///
  /// In cs, this message translates to:
  /// **'Licenses'**
  String get licenses;

  /// No description provided for @statistics.
  ///
  /// In cs, this message translates to:
  /// **'Statistiky'**
  String get statistics;

  /// No description provided for @dateFormat.
  ///
  /// In cs, this message translates to:
  /// **'Formát dat'**
  String get dateFormat;
}

class _TextsDelegate extends LocalizationsDelegate<Texts> {
  const _TextsDelegate();

  @override
  Future<Texts> load(Locale locale) {
    return SynchronousFuture<Texts>(lookupTexts(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['cs'].contains(locale.languageCode);

  @override
  bool shouldReload(_TextsDelegate old) => false;
}

Texts lookupTexts(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'cs':
      return TextsCs();
  }

  throw FlutterError(
      'Texts.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
