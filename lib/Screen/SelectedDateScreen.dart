import 'dart:io';
import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:spin_master/Screen/RewardScreen.dart';
import 'package:spin_master/Utills/Constants.dart';
import 'package:spin_master/Utills/UIUtills.dart';
import 'package:spin_master/Model/LinkModel.dart';

class SelectedDateScreen extends StatefulWidget{
  SelectedDateScreen({Key key,this.linkModel}) : super(key: key);
  final LinkModel linkModel;
  _SelectedDateScreen createState() =>_SelectedDateScreen();
}

class _SelectedDateScreen extends State<SelectedDateScreen> {
  List<String> coinsList = List();
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
    setState(() {
      coinsList.add('25');
      coinsList.add('500+');
      coinsList.add('1 Million');
      coinsList.add('5000');
      coinsList.add('2000');
    });

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
                    child: Text(widget.linkModel.date,style: TextStyle(fontSize: 30,color: Constants.main_color,fontWeight: FontWeight.w600,fontFamily: 'Poppins'),),
                  )
                ],
              ),
            ),
            Expanded(
                child: widget.linkModel.linkList.length != 0?
                Container(
                  child: ListView.builder(
                      padding: EdgeInsets.only(top: cH(20)),
                      itemCount: widget.linkModel.linkList.length,
                      itemBuilder: (BuildContext context,int index){

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
                                        Text(widget.linkModel.linkList[index].coin,style: TextStyle(fontSize: 20,color: Constants.main_color,fontWeight: FontWeight.w500,fontFamily: 'Poppins'),),
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
                                              child: RewardScreen(linkModel: widget.linkModel,link: widget.linkModel.linkList[index],))).then((value) => {
                                        // updateSavedAndFavList()
                                      });
                                    },
                                  ),
                                ],
                              ),

                            ),
                            onTap: (){
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: RewardScreen(linkModel: widget.linkModel,link: widget.linkModel.linkList[index],))).then((value) => {
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


}