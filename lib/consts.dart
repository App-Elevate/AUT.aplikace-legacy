// Purpose: stores constants used throughout the app.

/// Shared Preferences Ids
class Prefs {
  static const String theme = 'theme';
  static const String calendarBigMarkers = 'calendar_big_markers';
  static const String disableAnalytics = 'analytics';
  static const String skipWeekends = 'skipWeekends';
  static const String dailyFoodInfo = 'sendFoodInfo-';
  static const String foodNotifTime = 'FoodNotificationTime';
  static const String kreditNotifications = 'ignore_kredit_';
  static const String nemateObjednanoNotifications = 'ignore_objednat_';
  static const String lastJidloDneCheck = 'lastJidloDneCheck-';
  static const String lastNotificationCheck = 'lastCheck-';
  static const String lastVersion = 'lastVersion';
  static const String statistikaObjednavka = 'statistika:objednavka';
  static const String url = 'url';
  static const String firstTime = 'firstTime';
  static const String location = 'location_';
}

class OldPrefs {
  static const String theme = 'themeMode';
  static const String disableAnalytics = 'disableAnalytics';
}

class NotificationIds {
  static const String kreditChannel = 'kredit_channel_';
  static const String objednanoChannel = 'objednano_channel_';
  static const String dnesniJidloChannel = 'jidlo_channel_';
  static const String channelGroup = 'channel_group_';
  static const String channelGroupElse = 'channel_group_else';
  static const String channelElse = 'else_channel';
  static const String payloadUser = 'user';
  static const String payloadIndex = 'index';
  static const String payloadIndexDne = 'indexDne';
  static const String objednatButton = 'objednat_';
}

class Nums {
  static const int switchAccountPanelDuration = 300;
}

class AnalyticsEventIds {
  static const String updateButtonClicked = 'updateButtonClicked';
  static const String oldVer = 'oldVersion';
  static const String newVer = 'newVersion';
  static const String updateDownloaded = 'updateDownloaded';
}

// Strings shown to the user
class Texts {
  /// initAwesome has a problem with the localization package so we just force czech
  static String notificationsFor(String user) => 'Notifikace pro $user';
  static const String jidloChannelName = 'Dnešní jídlo';
  static String jidloChannelDescription(String user) => 'Notifikace každý den o tom jaké je dnes jídlo pro $user';
  static const String dochazejiciKreditChannelName = 'Docházející kredit';
  static String dochazejiciKreditChannelDescription(String user) => 'Notifikace o tom, zda vám dochází kredit týden dopředu pro $user';
  static const String objednanoChannelName = 'Objednáno?';
  static String objednanoChannelDescription(String user) => "Notifikace každý den o tom jaké je dnes jídlo pro $user";
  static const String notificationOther = 'Ostatní';
  static const String notificationOtherDescription = 'Ostatní notifikace, např. chybové hlášky...';

  static const String toastsExit = 'toast-exit';

  static const String errorsBadLogin = 'errors-bad-login';
  static const String errorsBadUrl = 'errors-bad-url';
  static const String errorsBadConnection = 'errors-bad-connection';
  static const String errorsNoInternet = 'errors-no-internet';
  static const String errorsLoad = 'errors-load';
  static const String errorsBadPassword = 'errors-bad-password';
  static const String errorsUpdatingData = 'errors-updating-data';
  static const String errorsLoadingData = 'errors-loading-data';
  static const String errorsJidloNeniNaBurze = 'errors-jidlo-neni-na-burze';
  static const String errorsDavaniJidla = 'errors-davani-jidla';
  static const String errorsObjednavaniJidla = 'errors-objednavani-jidla';
  static const String errorsObedNelzeZrusit = 'errors-obed-nelze-zrusit';
  static const String errorsNelzeObjednat = 'errors-nelze-objednat';
  static const String errorsNelzeObjednatKredit = 'errors-nelze-objednat-kredit';
  static const String errorsChybaPriRuseni = 'errors-chyba-pri-ruseni';
  static const String errorsChybaPriDavaniNaBurzu = 'errors-chyba-pri-davani-na-burzu';
  static const String errorsUndefined = 'errors-undefined';
  static const String errorsChangelog = 'errors-changelog';

  static const String accPanelAddAccount = 'switch-account-panel-add-account';
  static const String accPanelTitle = 'switch-account-panel-title';

  static const String updateSnackbarWaiting = 'update-snackbar-waiting';
  static const String updateSnackbarError = 'update-snackbar-error';
  static const String updateSnackbarTryAgain = 'try-again';
  static const String updateSnackbarDownloading = 'update-snackbar-downloading';
  static const String updateSnackbarDownloaded = 'update-snackbar-downloaded';

  static const String popupNewVersion = 'popup-new-version-available';
  static const String popupNewUpdateInfo = 'popup-new-update-info';
  static const String popupChangeLogNotAvailable = 'popup-change-log-not-available';
  static const String popupUpdate = 'popup-update';
  static const String popupShowOnGithub = 'popup-show-on-github';
  static const String popupNotNow = 'popup-not-now';

  static const String logoutUSure = 'logout-u-sure';
  static const String logoutConfirm = 'logout-confirm';
  static const String logoutCancel = 'cancel';

  static const String failedDialogTryAgain = 'try-again';
  static const String failedDialogLogOut = 'logout-confirm';
  static const String failedDialogLoginFailed = 'errors-login-failed';
  static const String failedDialogLoginDetail = 'errors-login-failed-detail';
  static const String failedDialogDownload = 'errors-downloading-app';
  static const String failedDialogDownloadDetail = 'errors-downloading-app-detail';
  static const String faliedDialogCancel = 'cancel';

  static const String datePickerCancel = 'cancel';
  static const String datePickerOk = 'ok';

  static const String accountDrawerLocationsUnknown = 'account-drawer-locations-unknown';
  static const String accountDrawercurrency = 'currency';
  static const String accountDrawerprofile = 'account-drawer-profile';
  static const String accountDrawerSettings = 'settings';
  static const String accountDrawerShareApp = 'account-drawer-share-app';
  static const String shareDescription = 'share-description';
  static const String accountDrawerPickLocation = 'account-drawer-pick-location';

  static const String about = 'about';
  static const String aboutAppName = 'app-name';
  static const String aboutCopyRight = 'about-copy-right';
  static const String aboutSourceCode = 'about-source-code';
  static const String aboutLatestVersion = 'about-latest-version';
  static const String aboutCheckForUpdates = 'about-check-for-updates';

  static const String settingsTitle = 'settings';
  static const String settingsAppearence = 'settings-appearence';
  static const String settingsLabelLight = 'settings-label-light';
  static const String settingsLabelDark = 'settings-label-dark';
  static const String settingsLabelSystem = 'settings-label-system';
  static const String settingsCalendarBigMarkers = 'settings-calendar-big-markers';
  static const String settingsConvenienceTitle = 'menu';
  static const String settingsSkipWeekends = 'settings-skip-weekends';
  static const String settingsNotificationFor = 'settings-notification-for';
  static const String settingsTitleTodaysFood = 'settings-title-todays-food';
  static const String settingsTitleKredit = 'settings-title-kredit';
  static const String settingsNotificationTime = 'settings-notification-time';
  static const String settingsNemateObjednano = 'settings-nemate-objednano';
  static const String settingsAnotherOptions = 'settings-another-options';
  static const String settingsDataCollection = 'settings-data-collection';
  static const String settingsStopDataCollection = 'settings-stop-data-collection';
  static const String settingsDataCollectionDescription1 = 'settings-data-collection-description-1';
  static const String settingsDataCollectionDescription2 = 'settings-data-collection-description-2';
  static const String settingsDataCollectionDescription3 = 'settings-data-collection-description-3';
  static const String settingsDataCollectionDescription4 = 'settings-data-collection-description-4';

  static const String settingsDebugOptions = 'settings-debug-options';
  static const String settingsDebugForceNotifications = 'settings-debug-force-notifications';
  static const String settingsDebugNotifications = 'settings-debug-notifications';

  static const String profile = 'profile';
  static const String kredit = 'kredit';
  static const String personalInfo = 'personal-info';
  static const String name = 'name';
  static const String category = 'category';
  static const String paymentInfo = 'payment-info';
  static const String paymentAccountNumber = 'payment-account-number';
  static const String specificSymbol = 'specific-symbol';
  static const String variableSymbol = 'variable-symbol';

  static const String ordersWithAutojidelna = 'orders-with-autojidelna';
  static const String allowPermission = 'allow-permission';
  static const String neededPermission = 'needed-permission';
  static const String neededPermissionDescription1 = 'needed-permission-description-1';
  static const String neededPermissionDescription2 = 'needed-permission-description-2';
  static const String neededPermissionDescription3 = 'needed-permission-description-3';

  static const String loginUrlFieldLabel = 'login-url-field-label';
  static const String loginUrlFieldHint = 'login-url-field-hint';
  static const String loginUserFieldLabel = 'login-user-field-label';
  static const String loginUserFieldHint = 'login-user-field-hint';
  static const String loginPasswordFieldLabel = 'login-password-field-label';
  static const String loginPasswordFieldHint = 'login-password-field-hint';
  static const String dataCollectionAgreement = 'data-collection-agreement';
  static const String moreInfo = 'more-info';
  static const String loginButton = 'login-button';

  static const String soup = 'soup';
  static const String mainCourse = 'main-course';
  static const String drinks = 'drinks';
  static const String sideDish = 'side-dish';
  static const String other = 'other';
  static const String allergens = 'allergens';

  static const String noFood = 'no-food';

  static const String obedTextZrusit = 'obed-text-zrusit';
  static const String obedTextObjednat = 'obed-text-objednat';
  static const String obedTextNelzeZrusit = 'obed-text-nelze-zrusit';
  static const String obedTextNedostatekKreditu = 'obed-text-nedostatek-kreditu';
  static const String obedTextNelzeObjednat = 'obed-text-nelze-objednat';
  static const String obedTextVlozitNaBurzu = 'obed-text-vlozit-na-burzu';
  static const String obedTextObjednatZBurzy = 'obed-text-objednat-z-burzy';
  static const String obedTextOdebratZBurzy = 'obed-text-odebrat-z-burzy';

  static const String gettingDataNotifications = 'getting-data-notifications';

  static const String notificationDochaziVamKredit = 'notification-dochazi-vam-kredit';
  static const String notificationKreditPro = 'notification-kredit-pro';
  static const String notificationZtlumit = 'notification-ztlumit';

  static const String notificationObjednejteSi = 'notification-objednejte-si';
  static const String notificationObjednejteSiDetail = 'notification-objednejte-si-detail';

  static const String objednatAction = 'objednat-action';
}

class Links {
  static const String autojidelna = 'https://autojidelna.cz/';
  static const String repo = 'https://github.com/Autojidelna/autojidelna';
  static const latestVersionApi = 'https://api.github.com/repos/Autojidelna/autojidelna/releases/latest';
  static const String appStore = 'https://autojidelna.cz/release/appStore.json';
  static String currentVersionCode(String appVersion) {
    return '$repo/blob/v$appVersion';
  }

  static String currentChangelog(String version) {
    return 'https://raw.githubusercontent.com/Autojidelna/autojidelna/v$version/CHANGELOG.md';
  }

  static String listSbiranychDat(String appVersion) {
    return '${currentVersionCode(appVersion)}/collected_data.md';
  }

  static String get latestRelease => '$repo/releases/latest';
}
