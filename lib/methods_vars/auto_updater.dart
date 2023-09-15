import 'dart:convert';
import 'dart:io';
import 'package:autojidelna/every_import.dart';
import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';

late final ReleaseInfo releaseInfo;

void getLatestRelease() async {
  /*
  if(!Platform.isAndroid){
    releaseInfo = ReleaseInfo(isAndroid: false);
    return;
  }

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  print('CPU architecture: ${androidInfo.supportedAbis}');
  */
  Uri url = Uri.parse('https://api.github.com/repos/tpkowastaken/autojidelna/releases/latest');
  const Map<String,String> headers = {
    'Accept': 'application/vnd.github+json',
    'X-GitHub-Api-Version': '2022-11-28',
  };
  final response = await http.get(url, headers: headers);
  var json = jsonDecode(response.body);
  String version = json['tag_name'].replaceAll('v', '');
  for(int i = 0;i<json['assets'].length;i++){
    print(json['assets'][i]/*['browser_download_url']*/);
  }
}
void main(){
  getLatestRelease();
}