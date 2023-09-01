import '../every_import.dart';

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

late Canteen canteenInstance;
late CanteenData canteenData;
bool refreshing = false;
bool loggedOut = true;
Ordering ordering = Ordering();


/// Returns a [Canteen] instance with logged in user.
/// Has to be called before using [canteenInstance].
/// If [hasToBeNew] is true, it will create a new instance of [Canteen] even if there is already one.
/// If [url], [username] or [password] is null, it will try to get it from storage.
/// Can throw errors if login is not successful or when bad connection.
Future<Canteen> initCanteen(
    {bool hasToBeNew = false,
    String? url,
    String? username,
    String? password}) async {
  url ??= await readData('url');
  if (!url!.contains('https://')) {
    url = 'https://$url';
    saveData('url', url);
  }
  try {
    if (canteenInstance.prihlasen && !hasToBeNew) {
      return canteenInstance;
    } else {
      canteenInstance = Canteen(url);
    }
  } catch (e) {
    canteenInstance = Canteen(url);
  }
  username ??= await getDataFromSecureStorage('username');
  password ??= await getDataFromSecureStorage('password');
  if (username == null || password == null) {
    throw Exception('No password found');
  }

  await canteenInstance.login(username, password);
  await Future.delayed(const Duration(milliseconds: 100));
  if (!canteenInstance.prihlasen) {
    await Future.delayed(const Duration(seconds: 1));
    if (!canteenInstance.prihlasen) {
      await canteenInstance.login(username, password);
    }
    await Future.delayed(const Duration(milliseconds: 100));
    if (!(canteenInstance.prihlasen)) {
      throw Exception('Login failed');
    }
  }
  //get last monday
  DateTime currentDate = DateTime.now();
  DateTime lastMonday =
      currentDate.subtract(Duration(days: (currentDate.weekday - 1)));
  DateTime lastMondayWithoutTime =
      DateTime(lastMonday.year, lastMonday.month, lastMonday.day);
  Map<DateTime, Jidelnicek> jidelnicky = {
    lastMondayWithoutTime: await ziskatJidelnicekDen(lastMonday)
  };
  canteenData = CanteenData(
    username: username,
    url: url,
    uzivatel: await canteenInstance.ziskejUzivatele(),
    jidlaNaBurze: await canteenInstance.ziskatBurzu(),
    jidelnicky: jidelnicky,
  );

  preIndexLunches(lastMondayWithoutTime, 14).then((_) => {
        preIndexLunches(
                lastMondayWithoutTime.subtract(const Duration(days: 7)), 7)
            .then((_) => {
                  preIndexLunches(
                          lastMondayWithoutTime.add(const Duration(days: 14)),
                          7)
                      .then((_) {
                    preIndexLunches(
                        lastMondayWithoutTime
                            .subtract(const Duration(days: 14)),
                        7);
                  })
                })
      });
  loggedOut = false;
  return canteenInstance;
}

Future<Jidelnicek> ziskatJidelnicekDen(DateTime den) async {
  try {
    return await canteenInstance.jidelnicekDen(den: den);
  } catch (e) {
    if (e == 'Uživatel není přihlášen') {
      await initCanteen(hasToBeNew: true);
      await Future.delayed(const Duration(seconds: 1));
      return await ziskatJidelnicekDen(den);
    } else {
      await Future.delayed(const Duration(seconds: 1));
      return await ziskatJidelnicekDen(den);
    }
  }
}

Future<void> preIndexLunches(DateTime start, int howManyDays) async {
  for (int i = 0; i < howManyDays; i++) {
    try {
      if (refreshing || loggedOut) {
        return;
      }
      canteenData.jidelnicky[start.add(Duration(days: i))] =
          await getLunchesForDay(start.add(Duration(days: i)));
    } catch (e) {
      return;
    }
  }
}

Future<Jidelnicek> getLunchesForDay(DateTime date,{bool? requireNew}) async {
  late Jidelnicek jidelnicek;
  requireNew ??= false;
  if (canteenData.jidelnicky
      .containsKey(DateTime(date.year, date.month, date.day)) && !requireNew) {
    jidelnicek =
        canteenData.jidelnicky[DateTime(date.year, date.month, date.day)]!;
  } else {
    jidelnicek = await ziskatJidelnicekDen(date);
  }
  canteenData.jidelnicky[DateTime(date.year, date.month, date.day)] =
      jidelnicek;
  return jidelnicek;
}

Future<Jidelnicek> refreshLunches(DateTime currentDate) async {
  canteenData.jidelnicky = {};
      preIndexLunches(currentDate, 7).then((_) =>
          preIndexLunches(currentDate.subtract(const Duration(days: 7)), 7));
  return await getLunchesForDay(currentDate); 
}

CanteenData getCanteenData() {
  return canteenData;
}

bool jeJidloNaBurze(Jidlo jidlo) {
  String varianta = jidlo.varianta;
  DateTime den = jidlo.den;
  for (var jidloNaBurze in canteenData.jidlaNaBurze) {
    if (jidloNaBurze.den == den && jidloNaBurze.varianta == varianta) {
      return true;
    }
  }
  return false;
}

void setCanteenData(CanteenData data) {
  canteenData = data;
}

/// save data to secure storage used for storing username and password
void saveDataToSecureStorage(String key, String value) async {
  const storage = FlutterSecureStorage();
  await storage.write(key: key, value: value);
}

/// get data from secure storage used for storing username and password
Future<String?> getDataFromSecureStorage(String key) async {
  const storage = FlutterSecureStorage();
  String? value = await storage.read(key: key);
  return value;
}

/// save data to shared preferences used for storing url and unsecure data
void saveData(String key, String value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}

/// get data from shared preferences used for storing url and unsecure data
Future<String?> readData(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

void logout() {
  saveDataToSecureStorage('username', '');
  saveDataToSecureStorage('password', '');
  saveData('loggedIn', '0');
  loggedOut = true;
}
