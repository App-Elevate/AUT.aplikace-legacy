import 'package:autojidelna/every_import.dart';
import 'package:http/http.dart' as http;
late ReleaseInfo releaseInfo;

void getLatestRelease() async {
  try{
    if(!Platform.isAndroid){
      releaseInfo = ReleaseInfo(isAndroid: false);
      return;
    }

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    Uri url = Uri.parse('https://api.github.com/repos/tpkowastaken/autojidelna/releases/latest');
    const Map<String,String> headers = {
      'Accept': 'application/vnd.github+json',
      'X-GitHub-Api-Version': '2022-11-28',
    };
    final response = await http.get(url, headers: headers);
    var json = jsonDecode(response.body);
    String version = json['tag_name'].replaceAll('v', '');
    String? patchNotes;
    String? downloadUrl;
    for(int i = 0;i<json['assets'].length;i++){
      String apkname = json['assets'][i]['browser_download_url'].split('/').last;
      if(apkname.contains('.apk')){
        apkname.replaceAll('.apk', '');
      }
      else{
        patchNotes = utf8.decode((await http.get(Uri.parse(json['assets'][i]['browser_download_url']))).bodyBytes);
      }
      for(int k = 0;k<androidInfo.supportedAbis.length;k++){
        if(downloadUrl != null){
          break;
        }
        // either download the smaller package or every abi if the system hasn't been found
        if(apkname.contains(androidInfo.supportedAbis[k]) || i == json['assets'].length-2){
          downloadUrl = json['assets'][i]['browser_download_url'];
        }
      }
    }
    //get current app version
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appVersion = packageInfo.version;
    releaseInfo = ReleaseInfo(isAndroid: true, latestVersion: version, downloadUrl: downloadUrl, changelog: patchNotes, currentlyLatestVersion: version == appVersion);
  }
  catch(e){
    //having the last version isn't so important so we can just ignore it if it goes wrong
    releaseInfo = ReleaseInfo(isAndroid: false);
  }
}