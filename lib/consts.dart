// Purpose: stores constants used throughout the app.

/// Shared Preferences Ids
class Prefs {
  final String theme = 'theme';
  final String calendarBigMarkers = 'calendar_big_markers';
  final String disableAnalytics = 'analytics';
  final String skipWeekends = 'skipWeekends';
  final String dailyFoodInfo = 'sendFoodInfo-';
  final String foodNotifTime = 'FoodNotificationTime';
  final String kreditNotifications = 'ignore_kredit_';
  final String nemateObjednanoNotifications = 'ignore_objednat_';
  final String lastJidloDneCheck = 'lastJidloDneCheck-';
  final String lastNotificationCheck = 'lastCheck-';
}

class Nums {
  final int switchAccountPanelDuration = 300;
}

class AnalyticsEventIds {
  final String updateButtonClicked = 'updateButtonClicked';
  final String oldVer = 'oldVersion';
  final String newVer = 'newVersion';
}

// Strings shown to the user
class Texts {
  final String toastsExit = 'toast-exit';

  final String errorsBadLogin = 'errors-bad-login';
  final String errorsBadUrl = 'errors-bad-url';
  final String errorsBadConnection = 'errors-bad-connection';
  final String errorsNoInternet = 'errors-no-internet';
  final String errorsLoad = 'errors-load';

  final String accPanelAddAccount = 'switch-account-panel-add-account';
  final String accPanelTitle = 'switch-account-panel-title';

  final String updateSnackbarWaiting = 'update-snackbar-waiting';
  final String updateSnackbarError = 'update-snackbar-error';
  final String updateSnackbarTryAgain = 'try-again';
  final String updateSnackbarDownloading = 'update-snackbar-downloading';
  final String updateSnackbarDownloaded = 'update-snackbar-downloaded';

  final String popupNewVersion = 'popup-new-version-available';
  final String popupNewUpdateInfo = 'popup-new-update-info';
  final String popupChangeLogNotAvailable = 'popup-change-log-not-available';
  final String popupUpdate = 'popup-update';
  final String popupShowOnGithub = 'popup-show-on-github';
  final String popupNotNow = 'popup-not-now';

  final String logoutUSure = 'logout-u-sure';
  final String logoutConfirm = 'logout-confirm';
  final String logoutCancel = 'cancel';

  final String failedDialogTryAgain = 'try-again';
  final String failedDialogLogOut = 'logout-confirm';
  final String failedDialogLoginFailed = 'errors-login-failed';
  final String failedDialogLoginDetail = 'errors-login-failed-detail';
  final String failedDialogDownload = 'errors-downloading-app';
  final String failedDialogDownloadDetail = 'errors-downloading-app-detail';
  final String faliedDialogCancel = 'cancel';

  final String datePickerCancel = 'cancel';
  final String datePickerOk = 'ok';

  final String accountDrawerLocationsUnknown = 'account-drawer-locations-unknown';
  final String accountDrawercurrency = 'currency';
  final String accountDrawerprofile = 'account-drawer-profile';
  final String accountDrawerSettings = 'settings';
  final String accountDrawerShareApp = 'account-drawer-share-app';
  final String shareDescription = 'share-description';
  final String accountDrawerPickLocation = 'account-drawer-pick-location';

  final String about = 'about';
  final String aboutAppName = 'app-name';
  final String aboutCopyRight = 'about-copy-right';
  final String aboutSourceCode = 'about-source-code';
  final String aboutLatestVersion = 'about-latest-version';
  final String aboutCheckForUpdates = 'about-check-for-updates';

  final String settingsTitle = 'settings';
  final String settingsAppearence = 'settings-appearence';
  final String settingsLabelLight = 'settings-label-light';
  final String settingsLabelDark = 'settings-label-dark';
  final String settingsLabelSystem = 'settings-label-system';
  final String settingsCalendarBigMarkers = 'settings-calendar-big-markers';
  final String settingsConvenienceTitle = 'menu';
  final String settingsSkipWeekends = 'settings-skip-weekends';
  final String settingsNotificationFor = 'settings-notification-for';
  final String settingsTitleTodaysFood = 'settings-title-todays-food';
  final String settingsTitleKredit = 'settings-title-kredit';
  final String settingsNotificationTime = 'settings-notification-time';
  final String settingsNemateObjednano = 'settings-nemate-objednano';
  final String settingsAnotherOptions = 'settings-another-options';
  final String settingsDataCollection = 'settings-data-collection';
  final String settingsStopDataCollection = 'settings-stop-data-collection';
}

class Links {
  final String autojidelna = 'https://autojidelna.tomprotiva.com';
  final String repo = 'https://github.com/Autojidelna/autojidelna';
  String get latestRelease => '$repo/releases/latest';
}

class Const {
  Prefs prefs = Prefs();
  Texts texts = Texts();
  Nums nums = Nums();
  AnalyticsEventIds analyticsEventIds = AnalyticsEventIds();
  Links links = Links();
}

Const consts = Const();
