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
}

class Nums {
  static const int switchAccountPanelDuration = 300;
}

class AnalyticsEventIds {
  static const String updateButtonClicked = 'updateButtonClicked';
  static const String oldVer = 'oldVersion';
  static const String newVer = 'newVersion';
}

// Strings shown to the user
class Texts {
  static const String toastsExit = 'toast-exit';

  static const String errorsBadLogin = 'errors-bad-login';
  static const String errorsBadUrl = 'errors-bad-url';
  static const String errorsBadConnection = 'errors-bad-connection';
  static const String errorsNoInternet = 'errors-no-internet';
  static const String errorsLoad = 'errors-load';

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
}

class Links {
  static const String autojidelna = 'https://autojidelna.tomprotiva.com';
  static const String repo = 'https://github.com/Autojidelna/autojidelna';
  static String get latestRelease => '$repo/releases/latest';
}
