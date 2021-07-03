import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mailto/mailto.dart';
import 'package:share/share.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Constants.dart';

class ConstantUtils {
  static appReview(){
    StoreRedirect.redirect(androidAppId: Constants.android_app,
        iOSAppId: Constants.ios_app);
  }
  static appRedirect(String appPackageName){
    StoreRedirect.redirect(androidAppId: appPackageName,
        iOSAppId: Constants.ios_app);
  }
  static shareApp(){
    Share.share('Please check out this app\n '
        +Constants.android_app_link);
  }
  static launchMailto() async {
    final mailtoLink = Mailto(
      to: [Constants.email_id],
      // cc: ['cc1@example.com', 'cc2@example.com'],
      subject: Constants.email_subject,
      body: '',
    );
    await launch('$mailtoLink');
  }
  static openLink(String link) async {
    await launch(link);
  }
  static screenPortraitMode() async {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
  static statusBarColor() async {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Constants.main_color
    ));
  }

  static showLoader() async {
    EasyLoading.show(status: 'loading...');
  }
  static hideLoader() async {
    EasyLoading.dismiss();
  }
  static Future<bool> checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }
}