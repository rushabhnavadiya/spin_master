import 'package:http/http.dart' as http;
import 'package:package_info/package_info.dart';
import 'package:spin_master/Model/CurrentApp.dart';
import 'package:spin_master/Model/SpinLink.dart';

class ApiCall {
  static var url =
      "https://raw.githubusercontent.com/manthanvanani/application_content/main/spinlink_coinmaster";
  static var appUrl =
      "https://raw.githubusercontent.com/manthanvanani/application_details/main/spinlink1.json";

  static Future<List<SpinLink>> getSpinData() async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        print(response.body);
        final List<SpinLink> res = spinLinkFromJson(response.body);
        return res;
      }else{
        return List();
      }
    } catch (error) {
      return List();
    }
  }
  static Future<CurrentApp> getCurrentApp() async {
    try {
      final response = await http.get(Uri.parse(appUrl));
      if (response.statusCode == 200) {
        print(response.body);
        final CurrentApp res = currentAppFromJson(response.body);
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        if(packageInfo.packageName !=  res.packageName){
          return res;
        }else{
          return null;
        }
      }else{
        return null;
      }
    } catch (error) {
      return null;
    }
  }
}
