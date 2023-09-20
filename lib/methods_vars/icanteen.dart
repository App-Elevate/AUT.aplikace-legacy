import 'package:autojidelna/main.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
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
  bool savedCredetnials = false;
  if(username == null || password == null){
    savedCredetnials = true;
    //getting it from secure storage
  }
  username ??= await getDataFromSecureStorage('username');
  password ??= await getDataFromSecureStorage('password');
  if (username == null || password == null) {
    return Future.error('No password found');
  }

  try{
    await canteenInstance.login(username, password);
    await Future.delayed(const Duration(milliseconds: 100));
    if (!canteenInstance.prihlasen) {
      await Future.delayed(const Duration(seconds: 1));
      if (!canteenInstance.prihlasen) {
        await canteenInstance.login(username, password);
      }
      await Future.delayed(const Duration(milliseconds: 100));
      if (!(canteenInstance.prihlasen)) {
        analytics.logEvent(name: 'incorrectly_typed_credentials');
        return Future.error('login failed');
      }
    }
  }
  catch(e){
    if(e.toString().contains('Failed host lookup')){
      analytics.logEvent(name: 'incorrectly_typed_url');
      return Future.error('bad url');
    }
    return Future.error('no internet');
  }
  analytics.logLogin(loginMethod: savedCredetnials? 'saved credentials' : 'manual login');
  //get today
  DateTime currentDate = DateTime.now();
  DateTime currentDateWithoutTime =
      DateTime(currentDate.year, currentDate.month, currentDate.day);
  late Map<DateTime, Jidelnicek> jidelnicky;
  try{
    jidelnicky = {
      currentDateWithoutTime: await ziskatJidelnicekDen(currentDateWithoutTime)
    };
  }
  catch(e){
    return Future.error('no internet');
  }
  canteenData = CanteenData(
    username: username,
    url: url,
    uzivatel: await canteenInstance.ziskejUzivatele(),
    jidlaNaBurze: await canteenInstance.ziskatBurzu(),
    jidelnicky: jidelnicky,
    pocetJidel: {currentDateWithoutTime: jidelnicky[currentDateWithoutTime]!.jidla.length},
  );
  loggedOut = false;
  return canteenInstance;
}

//přidá +1 pro counter statistiky
void pridatStatistiku(TypStatistiky statistika)async {
  switch(statistika){
    //default case
    case TypStatistiky.objednavka:
      String? str = await readData('statistika:objednavka');
      str ??= '0';
      int pocetStatistiky = int.parse(str);
      pocetStatistiky++;
      await FirebaseAnalytics.instance.logEvent(name: 'objednavka', parameters: {'pocet': pocetStatistiky});
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

ParsedFoodString parseJidlo(String jidlo, {String? alergeny}) {
  late ParsedFoodStringType type;
  String zkracenyNazevJidla = '';
  String plnyNazevJidla = '';
  if(alergeny == ''){
    alergeny = null;
  }
  if (jidlo.contains('<span')) {
    type = ParsedFoodStringType.span;
    List<String> listJidel = jidlo.split('<span');
    zkracenyNazevJidla = listJidel[0];
    listJidel.removeAt(0);
    alergeny = '<span${listJidel.join('<span')}';
  }
  else if(alergeny != null){
    type = ParsedFoodStringType.alergeny;
    zkracenyNazevJidla = '$jidlo, alergeny: $alergeny';
  }
  else{
    zkracenyNazevJidla = jidlo;
    type = ParsedFoodStringType.bezAlergenu;
  }
  zkracenyNazevJidla = zkracenyNazevJidla.replaceAll(' *', '');
  zkracenyNazevJidla = zkracenyNazevJidla.replaceAll('*', '');
  List<String> cistyListJidel = zkracenyNazevJidla.split(',');
  for(int i = 0;i<cistyListJidel.length;i++){
    cistyListJidel[i] = cistyListJidel[i].trimLeft();
  }
  String polevka = '';
  String hlavniJidlo = '';
  String salatovyBar = '';
  String piti = '';
  for(int i = 0;i < cistyListJidel.length;i++){
    cistyListJidel[i] = cistyListJidel[i].trimLeft();
  }
  for(int i = 0; i < cistyListJidel.length; i++){
    if(cistyListJidel[i].contains('Polévka') || cistyListJidel[i].contains('fridátové nudle')){
      if(polevka != ''){
        polevka += ', ';
      }
      polevka = '$polevka ${cistyListJidel[i]}';
    }
    else if(cistyListJidel[i].contains('salátový bar')){
      if(salatovyBar != ''){
        salatovyBar += ', ';
      }
      salatovyBar = '$salatovyBar ${cistyListJidel[i]}';
    }
    else if(cistyListJidel[i].contains('nápoj') || cistyListJidel[i].contains('čaj') || cistyListJidel[i].contains('káva')){
      if(piti != ''){
        piti += ', ';
      }
      piti = '$piti ${cistyListJidel[i]}';
    }
    else {
      if(hlavniJidlo != ''){
        hlavniJidlo += ', ';
      }
      hlavniJidlo = '$hlavniJidlo ${cistyListJidel[i]}';
    }
  }
  zkracenyNazevJidla = '';
  plnyNazevJidla = '';
  hlavniJidlo = hlavniJidlo.trimLeft();
  polevka = polevka.trimLeft();
  piti = piti.trimLeft();
  salatovyBar = salatovyBar.trimLeft();
  if(polevka != ''){
    if(plnyNazevJidla != ''){
      plnyNazevJidla += '<br>';
    }
    //make first letter of polevka capital
    polevka = polevka.substring(0, 1).toUpperCase() + polevka.substring(1);
    plnyNazevJidla += polevka;
  }
  if(hlavniJidlo != ''){
    //make first letter of hlavniJidlo capital
    hlavniJidlo = hlavniJidlo.substring(0, 1).toUpperCase() + hlavniJidlo.substring(1);
    if(zkracenyNazevJidla != ''){
      zkracenyNazevJidla += '<br>';
    }
    if(plnyNazevJidla != '') {
      plnyNazevJidla += '<br>';
    }
    plnyNazevJidla += hlavniJidlo;
    zkracenyNazevJidla += hlavniJidlo;
  }
  if(piti != ''){
    //make first letter of piti capital
    piti = piti.substring(0, 1).toUpperCase() + piti.substring(1);
    if(plnyNazevJidla != ''){
      plnyNazevJidla += '<br>';
    }
    plnyNazevJidla += piti;
  }
  if(salatovyBar != '') {
    //make first letter of salatovyBar capital
    salatovyBar = salatovyBar.substring(0, 1).toUpperCase() + salatovyBar.substring(1);
    if(plnyNazevJidla != ''){
      plnyNazevJidla += '<br>';
    }
    plnyNazevJidla += salatovyBar;
  }
  if(zkracenyNazevJidla.substring(0,3) == 'N. ') {
    zkracenyNazevJidla = zkracenyNazevJidla.substring(3);
  }
  if(plnyNazevJidla.substring(0,3) == 'N. ') {
    plnyNazevJidla = plnyNazevJidla.substring(3);
  }
  //first regex match for '(' and last for ')' gets replaced with ''
  if(alergeny != null){
    if(alergeny.lastIndexOf(')') != -1){
      alergeny = alergeny.substring(0, alergeny.lastIndexOf(')')) + alergeny.substring(alergeny.lastIndexOf(')') + 1);
    }
  }
  alergeny = alergeny?.replaceFirst('(', '');
  if(alergeny != null){
    plnyNazevJidla = '$plnyNazevJidla<br>Alergeny: $alergeny';
  }
  return ParsedFoodString(
    polevka: polevka,
    hlavniJidlo: hlavniJidlo,
    salatovyBar: salatovyBar,
    piti: piti,
    alergeny: alergeny,
    type: type,
    plnyNazevJidla: plnyNazevJidla,
    zkracenyNazevJidla: zkracenyNazevJidla,
  );
}

Future<Jidelnicek> ziskatJidelnicekDen(DateTime den) async {
  try {
    Jidelnicek jidelnicek = await canteenInstance.jidelnicekDen(den: den);
    //bad api check
    if(jidelnicek.jidla.length < 3){
      Jidelnicek checkjidelnicek = await canteenInstance.jidelnicekDen(den: den);
      return checkjidelnicek.jidla.length > jidelnicek.jidla.length? checkjidelnicek : jidelnicek;
    }
    return jidelnicek;
  } catch (e) {
    if (e == 'Uživatel není přihlášen') {
      try{
        await initCanteen(hasToBeNew: true);
        await Future.delayed(const Duration(seconds: 1));
        return await ziskatJidelnicekDen(den);
      }
      catch(e){
        return Future.error('no internet');
      }
    } else {
      await Future.delayed(const Duration(seconds: 1));
      return await ziskatJidelnicekDen(den);
    }
  }
}
void smartPreIndexing(DateTime currentDate){
    preIndexLunches(currentDate, 1, true)
    .then((_) => preIndexLunches(currentDate, 1, false))
    .then((_) => preIndexLunches(currentDate.add(const Duration(days: 1)), 1, true))
    .then((_) => preIndexLunches(currentDate.add(const Duration(days: 1)), 1, false))
    .then((_) => preIndexLunches(currentDate.add(const Duration(days: 1)), 3, true))
    .then((_) => preIndexLunches(currentDate.add(const Duration(days: 1)), 3, false))
    .then((_) => preIndexLunches(currentDate.add(const Duration(days: 3)), 7, true))
    .then((_) => preIndexLunches(currentDate.add(const Duration(days: 3)), 7, false));
}

/// [toTheFuture] is true if you want to get lunches for the next [howManyDays] days
/// otherwise it will get lunches for the previous [howManyDays] days

Future<void> preIndexLunches(DateTime start, int howManyDays, bool toTheFuture) async {
  for (int i = 0; i < howManyDays; i++) {
    try {
      if (refreshing || loggedOut) {
        return;
      }
      if(toTheFuture){
        canteenData.jidelnicky[start.add(Duration(days: i))] =
            await getLunchesForDay(start.add(Duration(days: i)));
      }
      else{
        canteenData.jidelnicky[start.subtract(Duration(days: i))] =
            await getLunchesForDay(start.subtract(Duration(days: i)));
      }
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
    if(canteenData.currentlyLoading.contains(date)){
      await Future.delayed(const Duration(milliseconds: 100));
      return getLunchesForDay(date,requireNew: requireNew);
    }
    try{
      canteenData.currentlyLoading.add(date);
      jidelnicek = await ziskatJidelnicekDen(date);
      canteenData.currentlyLoading.remove(date);
    }
    catch(e){
      canteenData.currentlyLoading.remove(date);
      return Future.error('no internet');
    }
  }
  if(canteenData.pocetJidel[DateTime(date.year, date.month, date.day)] != null && canteenData.pocetJidel[DateTime(date.year, date.month, date.day)]! > jidelnicek.jidla.length ){
    return getLunchesForDay(date,requireNew: requireNew);
  }
  canteenData.jidelnicky[DateTime(date.year, date.month, date.day)] =
      jidelnicek;
  canteenData.pocetJidel[DateTime(date.year, date.month, date.day)] = jidelnicek.jidla.length;
  return jidelnicek;
}

Future<Jidelnicek> refreshLunches(DateTime currentDate) async {
  canteenData.jidelnicky = {};
  smartPreIndexing(currentDate);
  try{
    return await getLunchesForDay(currentDate); 
  }
  catch(e){
    rethrow;
  }

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
  try{
    String? value = await storage.read(key: key);
    return value;
  }
  catch(e){
    return null;
  }
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
  analytics.logEvent(name: 'logout');
  saveDataToSecureStorage('username', '');
  saveDataToSecureStorage('password', '');
  saveData('loggedIn', '0');
  loggedOut = true;
}
