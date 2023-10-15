import 'package:autojidelna/main.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import '../every_import.dart';

/// initCanteen has to be called before using this variable
Canteen? canteenInstance;

/// initCanteen has to be called before using this variable
CanteenData? canteenData;

///function to getCanteenData so that we can get it in ValueNotifier constructor
CanteenData getCanteenData() {
  return canteenData!;
}

///variable that sets how many max lunches are expected. The higher the worse performance but less missing lunches. This is a fix for the api sometimes not sending all the lunches
const int numberOfMaxLunches = 3;

/// variable to stop caching lunches when refreshing
bool refreshing = false;

/// variable to stop ordering lunches when refreshing
Ordering ordering = Ordering();

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
/// 'Uživatel není přihlášen' - when user is not logged in and doesn't have credentials in storage
Future<Canteen> initCanteen({bool hasToBeNew = false, String? url, String? username, String? password, bool? doIndexing}) async {
  LoginDataAutojidelna loginData = await getLoginDataFromSecureStorage();
  url ??= loginData.users[loginData.currentlyLoggedInId!].url;
  doIndexing ??= true;
  if (canteenInstance != null && canteenInstance!.prihlasen && !hasToBeNew) {
    return canteenInstance!;
  } else {
    canteenInstance = Canteen(url);
  }

  /// variable to know if user is logging in with saved credentials or already logged in
  bool savedCredetnials = false;

  if (username == null || password == null) {
    savedCredetnials = true;
    if (loginData.currentlyLoggedInId == null) {
      return Future.error('Uživatel není přihlášen');
    }
  }

  username ??= loginData.users[loginData.currentlyLoggedInId!].username;
  password ??= loginData.users[loginData.currentlyLoggedInId!].password;

  try {
    await canteenInstance!.login(username, password);
  } catch (e) {
    try {
      await canteenInstance!.login(username, password);
    } catch (e) {
      return Future.error('bad url');
    }
  }
  if (!canteenInstance!.prihlasen) {
    return Future.error('login failed');
  }

  if (analyticsEnabledGlobally && analytics != null) {
    analytics!.logLogin(loginMethod: savedCredetnials ? 'saved credentials' : 'manual login');
  }

  ///get today and strip it from time
  DateTime currentDate = DateTime.now();

  ///get jidelnicek for today
  late Map<DateTime, Jidelnicek> jidelnicky;
  try {
    jidelnicky = {currentDate: await ziskatJidelnicekDen(currentDate)};
  } catch (e) {
    return Future.error('no internet');
  }
  if (doIndexing) {
    try {
      canteenData = CanteenData(
        username: username,
        url: url,
        uzivatel: await canteenInstance!.ziskejUzivatele(),
        jidlaNaBurze: await canteenInstance!.ziskatBurzu(),
        jidelnicky: jidelnicky,
        pocetJidel: canteenData == null ? {currentDate: jidelnicky[currentDate]!.jidla.length} : canteenData!.pocetJidel,
      );
    } catch (e) {
      return Future.error('no internet');
    }
    smartPreIndexing(currentDate);
  }
  return canteenInstance!;
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

///získá Jídelníček pro den [den]
///tuto funkci nevolat globálně, nebere informace s canteenData a zároveň je neukládá
///uživatel musí být přihlášen
///Jinak vyhodí chybu 'Uživatel není přihlášen'
///může vyhodit chybu 'no internet'
Future<Jidelnicek> ziskatJidelnicekDen(DateTime den) async {
  try {
    Jidelnicek jidelnicek = await canteenInstance!.jidelnicekDen(den: den);

    /// fix for api sometimes giving us less lunches that it should

    /// this variable is used as a maximum number of Lunches that it should check for this error. If you change it it only lowers/highers the effectiveness of this fix with a tradeoff in performance
    return jidelnicek;
  } catch (e) {
    if (e == 'Uživatel není přihlášen') {
      try {
        await initCanteen(hasToBeNew: true);
        await Future.delayed(const Duration(seconds: 1));
        return await ziskatJidelnicekDen(den);
      } catch (e) {
        if (e == 'Uživatel není přihlášen') {
          return Future.error('Uživatel není přihlášen');
        }
        return Future.error('no internet');
      }
    } else {
      rethrow;
    }
  }
}

///preindexes lunches around the [currentDate]
void smartPreIndexing(DateTime currentDate) {
  preIndexLunches(currentDate, 1, true)
      .then((_) => preIndexLunches(currentDate, 1, false))
      .then((_) => preIndexLunches(currentDate.add(const Duration(days: 1)), 1, true))
      .then((_) => preIndexLunches(currentDate.subtract(const Duration(days: 1)), 1, false))
      .then((_) => preIndexLunches(currentDate.add(const Duration(days: 2)), 3, true))
      .then((_) => preIndexLunches(currentDate.subtract(const Duration(days: 2)), 3, false))
      .then((_) => preIndexLunches(currentDate.add(const Duration(days: 5)), 7, true))
      .then((_) => preIndexLunches(currentDate.subtract(const Duration(days: 5)), 7, false));
}

/// [toTheFuture] is true if you want to get lunches for the next [howManyDays] days
/// otherwise it will get lunches for the previous [howManyDays] days
Future<void> preIndexLunches(DateTime start, int howManyDays, bool toTheFuture) async {
  for (int i = 0; i < howManyDays; i++) {
    try {
      if (refreshing) {
        return;
      }
      if (toTheFuture) {
        canteenData!.jidelnicky[start.add(Duration(days: i))] = await getLunchesForDay(start.add(Duration(days: i)));
      } else {
        canteenData!.jidelnicky[start.subtract(Duration(days: i))] = await getLunchesForDay(start.subtract(Duration(days: i)));
      }
    } catch (e) {
      return;
    }
  }
}

/// this function should be called globally hovewer you need to be logged in or have credentials in the storage.
/// can throw errors if there is no internet connection or if there is no user logged in and if there are no credentials in storage.
/// in both cases it throws 'no internet'
Future<Jidelnicek> getLunchesForDay(DateTime date, {bool? requireNew}) async {
  requireNew ??= false;

  late Jidelnicek jidelnicek;

  //if we already have lunches for this day and we don't require new ones, return them
  if (canteenData!.jidelnicky.containsKey(DateTime(date.year, date.month, date.day)) && !requireNew) {
    jidelnicek = canteenData!.jidelnicky[DateTime(date.year, date.month, date.day)]!;
  } else {
    //making sure that we don't have multiple requests for the same day
    while (canteenData!.currentlyLoading.contains(date)) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    try {
      //doing the request
      canteenData!.currentlyLoading.add(date);
      jidelnicek = await ziskatJidelnicekDen(date);
      canteenData!.currentlyLoading.remove(date);
    } catch (e) {
      canteenData!.currentlyLoading.remove(date);
      return Future.error('no internet');
    }
  }

  //addition to fix api sometimes giving us less lunches that it should. This is a second layer for the fix
  if (canteenData!.pocetJidel[DateTime(date.year, date.month, date.day)] != null &&
      canteenData!.pocetJidel[DateTime(date.year, date.month, date.day)]! > jidelnicek.jidla.length) {
    return getLunchesForDay(date, requireNew: requireNew);
  }

  //saving to cache
  canteenData!.jidelnicky[DateTime(date.year, date.month, date.day)] = jidelnicek;

  canteenData!.pocetJidel[DateTime(date.year, date.month, date.day)] = jidelnicek.jidla.length;

  return jidelnicek;
}

///refreshes lunches for the [currentDate]
///doesn't get a new token hovewer gets the lunches with supporting the api check
Future<Jidelnicek> refreshLunches(DateTime currentDate) async {
  canteenData!.jidelnicky = {};
  smartPreIndexing(currentDate);
  try {
    return await getLunchesForDay(currentDate);
  } catch (e) {
    return Future.error(e);
  }
}

///Kontroluje jestli je jídlo na burze a vrátí true/false
bool jeJidloNaBurze(Jidlo jidlo) {
  String varianta = jidlo.varianta;
  DateTime den = jidlo.den;
  for (var jidloNaBurze in canteenData!.jidlaNaBurze) {
    if (jidloNaBurze.den == den && jidloNaBurze.varianta == varianta) {
      return true;
    }
  }
  return false;
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
  canteenData = null;
  canteenInstance = null;
  changeDate(newDate: DateTime.now());
  saveLoginToSecureStorage(loginData);
  return;
}

///logs out everyone
Future<void> logoutEveryone() async {
  LoginDataAutojidelna loginData = await getLoginDataFromSecureStorage();
  loginData.currentlyLoggedIn = false;
  loginData.users.clear();
  loginData.currentlyLoggedInId = null;
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
