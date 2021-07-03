import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:spin_master/Model/SpinLink.dart';
import 'package:spin_master/Screen/SelectedDateScreen.dart';
import 'package:spin_master/Utills/Constants.dart';
import 'package:spin_master/Utills/UIUtills.dart';
import 'package:spin_master/Model/LinkModel.dart';
import 'package:spin_master/Database/Database.dart';

class DateSelectionScreen extends StatefulWidget{
  final List<SpinLink> spinLinkList;
  final int type;

  DateSelectionScreen({Key key,this.type,this.spinLinkList}) : super(key: key);
  _DateSelectionScreen createState() =>_DateSelectionScreen();
}

class _DateSelectionScreen extends State<DateSelectionScreen> {
  // List<DateTime> dateList = List();
  List<LinkModel> linkList = List();
  ReceivePort _port = ReceivePort();
  DatabaseHelper databaseHelper;

  String _downloadTaskId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

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
        }
      },
    );
    getDataFromLocalStorage().then((value){
      setState(() {
        linkList = value;
      });
    });
    // setState(() {
    //   dateList = getDaysInBeteween(DateTime.utc(2021,1,07,0,0,0,0,0), DateTime.now());
    // });
    // downloadFile();
  }
  @override
  Widget build(BuildContext context) {
    UIUtills().updateScreenDimension(width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height);
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: AppBar( // Here we create one to set status bar color
            backgroundColor: Constants.main_color, // Set any color of status bar you want; or it defaults to your theme's primary color
          )
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              // color: Constants.main_color,
              padding: EdgeInsets.fromLTRB(cW(10), cH(15), cW(10), cH(15)),
              child: Stack(
                children: [
                  Container(
                    // margin: EdgeInsets.only(top: cH(10)),
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: Icon(Icons.navigate_before_sharp),
                      iconSize: 35,
                      color: Constants.main_color,
                      onPressed: () {
                        Navigator.of(context).pop(this);
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(widget.type==1?'Coin Link':'Spin Link',style: TextStyle(fontSize: 30,color: Constants.main_color,fontWeight: FontWeight.w600,fontFamily: 'Poppins'),),
                  )
                ],
              ),
            ),
            Expanded(
                child: linkList.length != 0?
                Container(
                  child: ListView.builder(
                      padding: EdgeInsets.only(top: cH(20)),
                      itemCount: linkList.length,
                      itemBuilder: (BuildContext context,int index){
                        LinkModel singleLinkModel = linkList[index];
                        return Card(
                          margin: EdgeInsets.only(left: cW(20),right: cW(20),bottom: cH(12)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          elevation: 5,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Container(
                              padding: EdgeInsets.fromLTRB(cW(15), cH(20), cW(15), cH(20)),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(singleLinkModel.date,style: TextStyle(fontSize: 20,color: Constants.main_color,fontWeight: FontWeight.w400,fontFamily: 'Poppins'),),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.navigate_next),
                                    iconSize: cW(25),
                                    color: Constants.main_color,
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              type: PageTransitionType.rightToLeft,
                                              child: SelectedDateScreen(linkModel:singleLinkModel))).then((value) => {
                                        // updateSavedAndFavList()
                                      });
                                      // Navigator.of(context).pop(this);
                                    },
                                  ),
                                ],
                              ),

                            ),
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: SelectedDateScreen(linkModel:singleLinkModel))).then((value) => {
                                // updateSavedAndFavList()
                              });

                            },
                          ),
                        );
                      }
                  ),
                ):Center(
                  child: SizedBox(
                    height: cH(30),
                    width: cH(30),
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                    ),
                  ),
                )
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
    );
  }
  List<DateTime> getDaysInBeteween(DateTime startDate, DateTime endDate) {


    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    List<DateTime> reversedDays = days.reversed.toList();
    print(reversedDays);
    return reversedDays;
  }
  Future<List<LinkModel>> getDataFromLocalStorage() async {
    databaseHelper = DatabaseHelper.instance;
    return await databaseHelper.getCoins();
  }
}