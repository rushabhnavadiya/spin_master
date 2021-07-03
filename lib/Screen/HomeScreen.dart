
import 'dart:io';

import 'package:auto_animated/auto_animated.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spin_master/Api/ApiCall.dart';
import 'package:spin_master/Database/Database.dart';
import 'package:spin_master/Model/CurrentApp.dart';
import 'package:spin_master/Model/LinkModel.dart';
import 'package:spin_master/Model/SpinLink.dart';
import 'package:spin_master/Utills/ConstantUtils.dart';
import 'package:spin_master/Utills/Constants.dart';
import 'package:spin_master/Utills/UIUtills.dart';
import 'package:mailto/mailto.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import 'DateSelectionScreen.dart';

class HomeScreen extends StatefulWidget{
  HomeScreen({Key key}) : super(key: key);
  _HomeScreen createState() =>_HomeScreen();
}

class _HomeScreen extends State<HomeScreen>{
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DatabaseHelper databaseHelper;
  List<String> list = List();
  List<String> subList = List();
  // List<LinkModel> linkList = List();
  List<SpinLink> spinLinkList = List();

  bool showLoader = false;
  final options = LiveOptions(
    delay: Duration(seconds: 0),
    showItemInterval: Duration(milliseconds: 0),
    showItemDuration: Duration(milliseconds: 0),
    visibleFraction: 0.05,
    reAnimateOnVisibility: false,
  );



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // idDataUpdate().then((value){
    //   if(value){
    //     getData();
    //   }
    // });
    getSpinLinkData();
    initialize();
  }

  void getSpinLinkData() async {
    bool internet = await ConstantUtils.checkInternet();
    if (internet) {
      ConstantUtils.showLoader();
      try {
        final response = await ApiCall.getSpinData();
        getCurrentApp();
        setState(() {
          spinLinkList = response;
        });
        ConstantUtils.hideLoader();
      } catch (e) {
        getCurrentApp();
        setState(() {
          spinLinkList = List();
        });
        ConstantUtils.hideLoader();
      }
    } else {
    }
  }

  void getCurrentApp() async {
    bool internet = await ConstantUtils.checkInternet();
    if (internet) {
      try {
        CurrentApp response = await ApiCall.getCurrentApp();
        if(response != null){
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return Dialog(
                  insetAnimationCurve: Curves.fastOutSlowIn,
                  insetAnimationDuration: Duration(milliseconds: 100),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ), ),
                  child: Center(
                    widthFactor: 2.0,
                    heightFactor: 1.0,
                    child: Container(
                        width: MediaQuery.of(context).size.width - 50,
                        height: MediaQuery.of(context).size.height/3.5,
                        color: Colors.white,
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[

                              Container(
                                padding: EdgeInsets.only(bottom: 30.0),
                                child: Text('Redirect App!!!',style: TextStyle(color: Constants.main_color,fontWeight: FontWeight.bold,fontSize: 25.0),
                                ),
                              ),
                              Container(
                                alignment: Alignment.topCenter,
                                margin: EdgeInsets.only(bottom: 30.0),
                                child: Text('Please redirect our another app and installed it.',style: TextStyle(fontSize: 20.0,color: Constants.main_color),),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[

                                  Expanded(
                                    child: RaisedButton(
                                      padding: EdgeInsets.only(top: 10,bottom: 10),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5.0)),
                                      onPressed: () async {
                                        ConstantUtils.appRedirect(response.packageName);
                                      },
                                      color: Constants.main_color,
                                      textColor: Colors.white,
                                      child: Text("Open",style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.w400,fontFamily: 'Poppins'),),
                                    ),
                                  ),

                                  SizedBox(width: 10,),

                                ],
                              ),
                            ],
                          ),)

                    ),
                  ),
                );
              });
        }
      } catch (e) {

      }
    }
  }
  showOpenDialog(BuildContext context) {

  }


  @override
  Widget build(BuildContext context) {
    UIUtills().updateScreenDimension(width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height);
    // TODO: implement build
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Container(
        color: Constants.blackGround_color,
        child: Scaffold(
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, cH(40), 0, cH(5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Expanded(
                    //   child: Container(),
                    // ),
                    Text('Spin Master',softWrap: true,style: TextStyle(fontSize: 40,color: Constants.main_color,fontWeight: FontWeight.w700,fontFamily: 'Poppins'),),

                  ],
                ),
              ),
              showLoader?
              Center(child: CircularProgressIndicator()):
              Expanded(
                child:SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        child: GridView.builder(
                          padding: EdgeInsets.only(left:cW(30),right:cW(30),bottom: cH(5),top: cH(10)),
                          itemCount: list.length,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 15,mainAxisSpacing: 15,childAspectRatio: 16/11),
                          itemBuilder: buildAnimatedItem,

                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        width: MediaQuery.of(context).size.width-cW(60),
                        height: 120,
                        child:  Card(
                          color: Constants.grey_color,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17.0),
                          ),
                          elevation: 5,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(17.0),
                            child:Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Text('More',textAlign:TextAlign.center,style: TextStyle(fontSize: 20,color: Constants.main_color,fontWeight: FontWeight.w600,fontFamily: 'Poppins'),),
                                ),
                              ],
                            ),
                            onTap: () async {
                              Share.share('check out other app\n Android apps: '
                                  +Constants.android_apps
                              +'\n IOS Apps: '
                                  +Constants.ios_apps);
                            },
                          ),),
                      ),
                      SizedBox(height: cH(10),)
                    ],
                  ),
                ),
              ),
              FacebookBannerAd(
                bannerSize: BannerSize.STANDARD,
                keepAlive: true,
                placementId: Platform.isAndroid ? Constants.android_banner_id: Constants.ios_banner_id,
                listener: (result, value) {
                  switch (result) {
                    case BannerAdResult.ERROR:
                      print("Error: $value");
                      break;
                    case BannerAdResult.LOADED:
                      print("Loaded: $value");
                      break;
                    case BannerAdResult.CLICKED:
                      print("Clicked: $value");
                      break;
                    case BannerAdResult.LOGGING_IMPRESSION:
                      print("Logging Impression: $value");
                      break;
                  }
                },
              ),
            ],
          ),
        ),

      ),

    );
  }
  Widget buildAnimatedItem(BuildContext context, int index) =>
       Card(
              color: Constants.grey_color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(17.0),
              ),
              elevation: 5,
              child: InkWell(
                borderRadius: BorderRadius.circular(17.0),
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Text(list[index],textAlign:TextAlign.center,style: TextStyle(fontSize: 20,color: Constants.main_color,fontWeight: FontWeight.w600,fontFamily: 'Poppins'),),
                    ),
                    // subList[index] == ''?Container():
                    // Text(subList[index],style: TextStyle(fontSize: 15,color: Colors.black45,fontWeight: FontWeight.w500,fontFamily: 'Poppins'),),
                  ],
                ),
                onTap: () async {
                  switch(index){
                    case 0:
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: DateSelectionScreen(type:1))).then((value) => {
                        // updateSavedAndFavList()
                      });

                      break;
                    case 1:
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: DateSelectionScreen(type:2))).then((value) => {
                        // updateSavedAndFavList()
                      });

                      break;
                    case 2:

                      FacebookInterstitialAd.loadInterstitialAd(
                        placementId: (Platform.isAndroid ? Constants.android_interstitial_id: Constants.ios_interstitial_id),
                        listener: (result, value) {
                          switch (result) {
                            case InterstitialAdResult.ERROR:
                              print("Error: $value");
                              break;
                            case InterstitialAdResult.LOADED:
                              FacebookInterstitialAd.showInterstitialAd();
                              print("Loaded: $value");
                              break;
                            case InterstitialAdResult.DISMISSED:
                              break;
                          }
                        },
                      );
                      Share.share('check out app\n '+Constants.android_app_link);

                      break;
                    case 3:
                      FacebookInterstitialAd.loadInterstitialAd(
                        placementId: (Platform.isAndroid ? Constants.android_interstitial_id: Constants.ios_interstitial_id),
                        listener: (result, value) {
                          switch (result) {
                            case InterstitialAdResult.ERROR:
                              print("Error: $value");
                              Share.share('check out app\n '+Constants.android_app_link);

                              break;
                            case InterstitialAdResult.LOADED:
                              FacebookInterstitialAd.showInterstitialAd();
                              print("Loaded: $value");
                              break;
                            case InterstitialAdResult.DISMISSED:
                              Share.share('check out app\n '+Constants.android_app_link);
                              break;
                          }
                        },
                      );
                      break;
                    case 4:

                      appReview();
                      break;
                    case 5:
                      launchMailto();
                      break;

                  }
                },
              ),);

  void initialize(){
    _firebaseMessaging.configure(
      onMessage: (message) async{
        print(message);
        setState(() {
        });
      },
      onResume: (message) async{
        print(message);
        setState(() {
        });
      },
      onLaunch: (message) async{
        print(message);
      },

    );

    FacebookAudienceNetwork.init(
      testingId: '858e366c-bcf6-4c02-a92c-15808a253c20', //optional
    );
    list.add("Coin Link");
    list.add("Spin Link");
    list.add("Share");
    list.add("Invite");
    list.add("Rate us");
    list.add("Suggestion");


    subList.add("   Type");
    subList.add("   Essays");
    subList.add("   Essays");
    subList.add("   Essays");
    subList.add("");
    subList.add("");


  }
  // void getData() {
  //   setState(() {
  //     showLoader = true;
  //   });
  //   try{
  //     firestore
  //         .collection("reward_link")
  //         .get()
  //         .then((QuerySnapshot snapshot) {
  //       linkList = List();
  //       snapshot.docs.forEach((f) => linkList.add(LinkModel.fromJson(f.data())));
  //       print(linkList.length);
  //       print(linkList[0].linkList[1].coin);
  //       storeDataLocalStorage(linkList);
  //       storeCurrentDate();
  //       setState(() {
  //         showLoader = false;
  //       });
  //     });
  //   }catch(e){
  //     setState(() {
  //       showLoader = false;
  //     });
  //   }
  //
  // }
  //
  // storeDataLocalStorage(List<LinkModel> list) async {
  //   databaseHelper = DatabaseHelper.instance;
  //   databaseHelper.clean();
  //   for(int i=0;i<list.length;i++){
  //     await databaseHelper.insertLinkModel(list[i]);
  //   }
  //   print("true");
  // }
  //
  // storeCurrentDate() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var now = new DateTime.now();
  //   var formatter = new DateFormat('dd MMM yyyy');
  //   String formattedDate = formatter.format(now);
  //   await prefs.setString(Constants.last_update_date, formattedDate);
  // }
  //
  // Future<bool> idDataUpdate() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String storedData = prefs.getString(Constants.last_update_date);
  //   var now = new DateTime.now();
  //   var formatter = new DateFormat('dd MMM yyyy');
  //   String currentDate = formatter.format(now);
  //   print(storedData);
  //   print(currentDate);
  //   if(storedData != currentDate){
  //     return true;
  //   }else{
  //     return false;
  //   }
  // }

  appReview(){
    StoreRedirect.redirect(androidAppId: Constants.android_app,
        iOSAppId: Constants.ios_app);
  }
  launchMailto() async {
    final mailtoLink = Mailto(
      to: [Constants.email_id],
      subject: Constants.email_subject,
      body: '',
    );
    await launch('$mailtoLink');
  }
}