import 'dart:async';
import 'package:autojidelna/main.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import '../every_import.dart';

///variable that sets how many max lunches are expected. The higher the worse performance but less missing lunches. This is a fix for the api sometimes not sending all the lunches
const int numberOfMaxLunches = 3;
// třída pro funkcionalitu celé aplikace
LoggedInCanteen loggedInCanteen = LoggedInCanteen();

class LoggedInCanteen {
  LoggedInCanteen();
  Map<DateTime, Completer<Jidelnicek>> currentlyLoading = {};
  Map<DateTime, bool> checked = {};

  Completer<void> _indexingCompleter = Completer<void>();

  CanteenData? _canteenData;
  Canteen? _canteenInstance;

  Future<Canteen> get canteenInstance async {
    if (_canteenInstance != null && _canteenInstance!.prihlasen) {
      return _canteenInstance!;
    }
    if (await loginFromStorage()) {
      return _canteenInstance!;
    }
    //uživatel není přihlášen
    return Future.error('no login');
  }

  Future<CanteenData> get canteenData async {
    if (_canteenData != null && _canteenInstance!.prihlasen) {
      return _canteenData!;
    }
    if (await loginFromStorage()) {
      return _canteenData!;
    }
    //uživatel není přihlášen
    return Future.error('no login');
  }

  /// this should be safe to get since we are always logged in and the data is created with the login.
  /// DO NOT CALL BEFORE LOGGIN IN
  Uzivatel? get uzivatel => _canteenData?.uzivatel;

  CanteenData? get canteenDataUnsafe => _canteenData;

  ///refreshes lunches for the [currentDate]
  ///doesn't get a new token hovewer gets the lunches with supporting the api check
  Future<Jidelnicek> refreshLunches(DateTime currentDate) async {
    (await canteenData).jidelnicky = {};
    smartPreIndexing(currentDate);
    try {
      return await getLunchesForDay(currentDate);
    } catch (e) {
      return Future.error(e);
    }
  }

  ///přidá +1 pro counter statistiky a pokud je zapnutý analytics tak ji pošle do firebase
  void pridatStatistiku(TypStatistiky statistika) async {
    switch (statistika) {
      //default case
      case TypStatistiky.objednavka:
        String? str = await readData('statistika:objednavka');
        str ??= '0';
        int pocetStatistiky = int.parse(str);
        pocetStatistiky++;
        if (analyticsEnabledGlobally && analytics != null) {
          analytics!.logEvent(name: 'objednavka', parameters: {'pocet': pocetStatistiky});
        }
        saveData('statistika:objednavka', '$pocetStatistiky');
        break;
      case TypStatistiky.auto:
        String? str = await readData('statistika:auto');
        str ??= '0';
        int pocetStatistiky = int.parse(str);
        pocetStatistiky++;
        saveData('statistika:auto', '$pocetStatistiky');
        break;
      case TypStatistiky.burzaCatcher:
        String? str = await readData('statistika:burzaCatcher');
        str ??= '0';
        int pocetStatistiky = int.parse(str);
        pocetStatistiky++;
        saveData('statistika:burzaCatcher', '$pocetStatistiky');
        break;
    }
  }

  ///logs you in if you are already logged in or gets the already existing instance
  ///We don't have to do much of error handling here because we already know that the user has been logged in.
  ///If there is an error it's probably because of the internet connection or change of password. The popup is the best solution.
  Future<bool> loginFromStorage() async {
    try {
      LoginDataAutojidelna loginData = await getLoginDataFromSecureStorage();
      if (loginData.currentlyLoggedIn) {
        _canteenInstance = await _login(loginData.users[loginData.currentlyLoggedInId!].url, loginData.users[loginData.currentlyLoggedInId!].username,
            loginData.users[loginData.currentlyLoggedInId!].password,
            safetyId: (_canteenData?.id ?? 0) + 1);
        return true;
      } else {
        return Future.error('no login');
      }
    } catch (e) {
      return false;
    }
  }

  /// Returns a [Canteen] instance with a logged in user.
  ///
  /// main logic about logging in is in this function
  ///
  /// Has to be called before using [canteenInstance].
  ///
  /// If [hasToBeNew] is true, it will create a new instance of [Canteen] even if there is already one. otherwise it returns already existing cached canteen instance
  /// If [url], [username] or [password] is null, it will try to get it from storage.
  /// If user is logging in all [url], [username] and [password] has to be provided.
  /// If user has already logged in nothing has to be provided
  /// [hasToBeNew] is used to for refreshing data
  ///
  /// can throw errors:
  ///
  /// 'login failed' - when login is not successful
  ///
  /// 'bad url' - when url is not valid
  ///
  /// 'no internet' - when there is no internet connection
  ///
  /// 'Nejdříve se musíte přihlásit' - when user is not logged in and doesn't have credentials in storage
  Future<Canteen> _login(String url, String username, String password, {int? safetyId, bool indexLunches = true}) async {
    Canteen canteenInstance = Canteen(url);
    try {
      if (!await canteenInstance.login(username, password)) {
        return Future.error('Špatné heslo');
      }
    } catch (e) {
      try {
        await canteenInstance.login(username, password); //second try's the charm
      } catch (e) {
        return Future.error('bad url or connection');
      }
    }
    try {
      checked = {};
      currentlyLoading = {};
      _canteenData = CanteenData(
        id: safetyId ?? 0,
        pocetJidel: {},
        username: username,
        url: url,
        uzivatel: await canteenInstance.ziskejUzivatele(),
        jidlaNaBurze: await canteenInstance.ziskatBurzu(),
        currentlyLoading: {},
        jidelnicky: {},
      );
    } catch (e) {
      return Future.error('bad url or connection');
    }
    if (indexLunches) {
      smartPreIndexing(DateTime.now());
    }
    _canteenInstance = canteenInstance;
    return canteenInstance;
  }

  ///získá Jídelníček pro den [den]
  ///tuto funkci nevolat globálně, nebere informace s canteenData a zároveň je neukládá
  ///uživatel musí být přihlášen
  ///Jinak vyhodí chybu 'Nejdříve se musíte přihlásit'
  ///může vyhodit chybu 'no internet'
  Future<Jidelnicek> _ziskatJidelnicekDen(DateTime den, {int? tries}) async {
    if (currentlyLoading.containsKey(den) && (tries == 0 || tries == null)) {
      return currentlyLoading[den]!.future;
    }
    currentlyLoading[den] ??= Completer<Jidelnicek>();
    tries ??= 0;
    try {
      Jidelnicek jidelnicek = await (await canteenInstance).jidelnicekDen(den: den);
      if (tries >= 2) {
        try {
          currentlyLoading[den]!.complete(jidelnicek);
        } catch (e) {
          //nothing
        }
        Future.delayed(const Duration(seconds: 1), () => currentlyLoading.remove(den));
        return jidelnicek;
      }
      //addition to fix api sometimes giving us less lunches that it should. This is a second layer for the fix
      if (_canteenData!.pocetJidel[DateTime(den.year, den.month, den.day)] != null &&
          _canteenData!.pocetJidel[DateTime(den.year, den.month, den.day)]! > jidelnicek.jidla.length) {
        return _ziskatJidelnicekDen(den, tries: tries + 1);
      }
      try {
        currentlyLoading[den]!.complete(jidelnicek);
      } catch (e) {
        //nothing
      }
      Future.delayed(const Duration(seconds: 1), () => currentlyLoading.remove(den));
      return jidelnicek;
    } catch (e) {
      currentlyLoading.remove(den);
      if (e == 'Nejdříve se musíte přihlásit') {
        return _ziskatJidelnicekDen(den, tries: tries + 1);
      }
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      await loginFromStorage();
      return _ziskatJidelnicekDen(den, tries: tries + 1);
    }
  }

  /// this function should be called globally hovewer you need to be logged in or have credentials in the storage.
  /// can throw errors if there is no internet connection or if there is no user logged in and if there are no credentials in storage.
  /// in both cases it throws 'no internet'
  Future<Jidelnicek> getLunchesForDay(DateTime date, {bool? requireNew}) async {
    date = DateTime(date.year, date.month, date.day);
    if ((_canteenData == null || _canteenInstance == null || !_canteenInstance!.prihlasen) && !await loginFromStorage()) {
      return Future.error('no login');
    }
    int id = _canteenData!.id;
    requireNew ??= false;

    if (_canteenData!.jidelnicky.containsKey(DateTime(date.year, date.month, date.day)) && !requireNew) {
      return _canteenData!.jidelnicky[DateTime(date.year, date.month, date.day)]!;
    }
    if (_canteenData!.currentlyLoading[date] != null) {
      return _canteenData!.currentlyLoading[date]!.future;
    }
    Jidelnicek jidelnicek = await _ziskatJidelnicekDen(date);

    //saving to cache
    if (_canteenData != null && _canteenData!.id == id) {
      _canteenData!.jidelnicky[DateTime(date.year, date.month, date.day)] = jidelnicek;

      _canteenData!.pocetJidel[DateTime(date.year, date.month, date.day)] = jidelnicek.jidla.length;
    }
    return jidelnicek;
  }

  void smartPreIndexing(DateTime dateToBeJumpedTo) {
    preIndexLunchesRange(dateToBeJumpedTo.subtract(const Duration(days: 2)), 4)
        .then((_) => preIndexLunchesRange(dateToBeJumpedTo, 7))
        .then((_) => preIndexLunchesRange(dateToBeJumpedTo.subtract(const Duration(days: 7)), 20));
  }

  Future<void> preIndexLunchesRange(DateTime start, int howManyDays) async {
    _indexingCompleter = Completer();
    for (int i = 0; i < howManyDays; i++) {
      preIndexLunches(start.add(Duration(days: i)));
    }
    await _indexingCompleter.future;
  }

  Future<void> preIndexLunches(DateTime date) async {
    await getLunchesForDay(date);
    try {
      if (_canteenData!.currentlyLoading.isEmpty) {
        _indexingCompleter.complete();
      }
    } catch (e) {
      return;
    }
    return;
  }

  Future<bool> changeAccount(int id, {bool indexLunches = false}) async {
    LoginDataAutojidelna loginData = await getLoginDataFromSecureStorage();
    String url = loginData.users[id].url;
    String username = loginData.users[id].username;
    String password = loginData.users[id].password;
    loginData.currentlyLoggedInId = id;
    saveLoginToSecureStorage(loginData);
    try {
      _canteenInstance = await _login(url, username, password, safetyId: _canteenData?.id ?? 0, indexLunches: indexLunches);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addAccount(String url, String username, String password) async {
    try {
      _canteenInstance = await _login(url, username, password, safetyId: _canteenData?.id ?? 0);
      LoginDataAutojidelna loginData = await getLoginDataFromSecureStorage();
      loginData.users.add(LoggedInUser(username: username, password: password, url: url));
      loginData.currentlyLoggedInId = loginData.users.length - 1;
      loginData.currentlyLoggedIn = true;
      saveLoginToSecureStorage(loginData);
      return true;
    } catch (e) {
      if (e == 'bad url or connection') {
        return Future.error('bad url');
      }
      return false;
    }
  }

  /// save data to secure storage used for storing username and password
  Future<void> saveDataToSecureStorage(String key, String value) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: key, value: value);
  }

  ///saves the loginData class to secure storage
  Future<void> saveLoginToSecureStorage(LoginDataAutojidelna loginData) async {
    await saveDataToSecureStorage('loginData', jsonEncode(loginData));
    initAwesome();
  }

  ///gets an instance of loginData.

  /// get data from secure storage
  /// can return null if there is no data
  Future<String?> getDataFromSecureStorage(String key) async {
    const storage = FlutterSecureStorage();
    try {
      String? value = await storage.read(key: key);
      return value;
    } catch (e) {
      return null;
    }
  }

  /// save data to shared preferences used for storing url, statistics and settings
  void saveData(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  /// get data from shared preferences used for storing url, statistics and settings
  Future<String?> readData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  ///logs out a user with [id].
  ///if [id] is null it will log out currently logged in user
  Future<void> logout({int? id}) async {
    id ??= (await getLoginDataFromSecureStorage()).currentlyLoggedInId;
    if (id == null) {
      return logoutEveryone();
    }
    if (analyticsEnabledGlobally && analytics != null) {
      analytics!.logEvent(name: 'logout');
    }
    LoginDataAutojidelna loginData = await getLoginDataFromSecureStorage();
    bool isDuplicate = false;
    for (int i = 0; i < loginData.users.length; i++) {
      if (loginData.users[i].username == loginData.users[id].username && i != id) {
        isDuplicate = true;
        break;
      }
    }
    if (!isDuplicate) {
      AwesomeNotifications().removeChannel('objednano_channel_${loginData.users[loginData.currentlyLoggedInId!].username}');
      AwesomeNotifications().removeChannel('kredit_channel_${loginData.users[loginData.currentlyLoggedInId!].username}');
    }
    //removing just the one item from the array

    //ensuring correct loginData.currentlyloggedInId
    if (id == loginData.currentlyLoggedInId) {
      changeDate(newDate: DateTime.now());
      loginData.currentlyLoggedInId = loginData.users.length - 2;
    } else if (loginData.currentlyLoggedInId != null && loginData.currentlyLoggedInId! > id) {
      loginData.currentlyLoggedInId = loginData.currentlyLoggedInId! - 1;
    }

    loginData.users.removeAt(id);
    // if it's empty make sure to throw user on login screen
    if (loginData.users.isEmpty) {
      loginData.currentlyLoggedIn = false;
      loginData.currentlyLoggedInId = null;
    }
    await saveLoginToSecureStorage(loginData);
    changeAccount(loginData.currentlyLoggedInId!);
    return;
  }

  ///logs out everyone
  Future<void> logoutEveryone() async {
    LoginDataAutojidelna loginData = await getLoginDataFromSecureStorage();
    loginData.currentlyLoggedIn = false;
    loginData.users.clear();
    loginData.currentlyLoggedInId = null;
    for (int id = 0; id < loginData.users.length; id++) {
      AwesomeNotifications().removeChannel('objednano_channel_${loginData.users[id].username}');
      AwesomeNotifications().removeChannel('kredit_channel_${loginData.users[id].username}');
    }
    //even though I don't like this it is safe because this is called rarely
    _canteenInstance = null;
    _canteenData = null;
    saveLoginToSecureStorage(loginData);
    return;
  }

  String ziskatDenZData(int den) {
    switch (den) {
      case 1:
        return 'Pondělí';
      case 2:
        return 'Úterý';
      case 3:
        return 'Středa';
      case 4:
        return 'Čtvrtek';
      case 5:
        return 'Pátek';
      case 6:
        return 'Sobota';
      case 7:
        return 'Neděle';
      default:
        throw Exception('Invalid day');
    }
  }

  Future<LoginDataAutojidelna> getLoginDataFromSecureStorage() async {
    try {
      String? value = await getDataFromSecureStorage('loginData');
      if (value == null || value == '') {
        return LoginDataAutojidelna(currentlyLoggedIn: false);
      }
      return LoginDataAutojidelna.fromJson(jsonDecode(value));
    } catch (e) {
      return LoginDataAutojidelna(currentlyLoggedIn: false);
    }
  }

  ///Kontroluje jestli je jídlo na burze a vrátí true/false
  bool jeJidloNaBurze(Jidlo jidlo) {
    try {
      String varianta = jidlo.varianta;
      DateTime den = jidlo.den;
      for (var jidloNaBurze in _canteenData!.jidlaNaBurze) {
        if (jidloNaBurze.den == den && jidloNaBurze.varianta == varianta) {
          return true;
        }
      }
    } catch (e) {
      return false;
    }
    return false;
  }
}
