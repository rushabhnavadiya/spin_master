import 'dart:io';
import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:spin_master/Utills/Constants.dart';
import 'package:spin_master/Utills/UIUtills.dart';
import 'package:spin_master/Model/LinkModel.dart';

class RewardScreen extends StatefulWidget{
  RewardScreen({Key key,this.link,this.linkModel}) : super(key: key);
  final LinkModel linkModel;
  final Link1 link;
  _RewardScreen createState() =>_RewardScreen();
}

class _RewardScreen extends State<RewardScreen> {
  List<DateTime> dateList = List();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // extractZipFile();
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
          crossAxisAlignment: CrossAxisAlignment.center,
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
                    child: Text('Coin Reward',style: TextStyle(fontSize: 30,color: Constants.main_color,fontWeight: FontWeight.w600,fontFamily: 'Poppins'),),
                  )
                ],
              ),
            ),
            Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(widget.link.coin.toLowerCase()
                          .replaceAll('coins', '')
                          .replaceAll('coin', '')
                          .replaceAll('spins', '',)
                          .replaceAll('spin', ''),textAlign:TextAlign.center,style: TextStyle(fontSize: 40,color: Constants.main_color,fontWeight: FontWeight.w900,fontFamily: 'Poppins'),),
                      Text('Coins',textAlign:TextAlign.center,style: TextStyle(fontSize: 20,color: Constants.main_color,fontWeight: FontWeight.w400,fontFamily: 'Poppins'),),
                    ],
                  )
                )
            ),
            Text('You get '+widget.link.coin+' for get\nclick on reward.',textAlign:TextAlign.center,style: TextStyle(fontSize: 20,color: Constants.main_color,fontWeight: FontWeight.w400,fontFamily: 'Poppins'),),
            SizedBox(height: cH(20),),
            Text(widget.linkModel.date,textAlign:TextAlign.center,style: TextStyle(fontSize: 20,color: Constants.main_color,fontWeight: FontWeight.w400,fontFamily: 'Poppins'),),
            SizedBox(height: cH(20),),
            SizedBox(
              width: MediaQuery.of(context).size.width-cW(30),
              height: cH(45),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                onPressed: () {
                  showOpenDialog(context);
                },
                color: Constants.main_color,
                textColor: Colors.white,
                child: Text("Get Reward",style: TextStyle(fontSize: 22,color: Colors.white,fontWeight: FontWeight.w600,fontFamily: 'Poppins'),),
              ),
            )
            ,
            SizedBox(height: cH(30),),
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
  showOpenDialog(BuildContext context) {
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
                      child: Text('Are you sure?',style: TextStyle(color: Constants.main_color,fontWeight: FontWeight.bold,fontSize: 25.0),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      margin: EdgeInsets.only(bottom: 30.0),
                      child: Text('Open and get your reward.',style: TextStyle(fontSize: 20.0,color: Constants.main_color),),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(width: 10,),
                        Expanded(
                          child: RaisedButton(
                            padding: EdgeInsets.only(top: 10,bottom: 10),

                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            color: Constants.grey_color,
                            textColor: Constants.main_color,
                            child: Text("Cancel",style: TextStyle(fontSize: 15,color: Constants.main_color,fontWeight: FontWeight.w400,fontFamily: 'Poppins'),),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Expanded(
                          child: RaisedButton(
                            padding: EdgeInsets.only(top: 10,bottom: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            onPressed: () async {
                              await launch(widget.link.link);
                              // showOpenDialog(context);
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

}