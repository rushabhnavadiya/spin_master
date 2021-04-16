import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:spin_master/Utills/Constants.dart';
import 'HomeScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Timer(
    //     Duration(seconds: 3),
    //         () => Navigator.of(context).pushReplacement(MaterialPageRoute(
    //         builder: (BuildContext context) => HomeScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: TypewriterAnimatedTextKit(
          textStyle: TextStyle(fontSize: 30,color: Constants.main_color,fontWeight: FontWeight.w700,fontFamily: 'Poppins'),
          text: [
            "  CM Reward",
          ],
          repeatForever: false,
          totalRepeatCount: 1,
          speed: Duration(milliseconds: 150),
          onFinished: (){
            Navigator.of(context).pushReplacement(PageTransition(
                type: PageTransitionType.fade,
                child: HomeScreen()));
          },
        )
        // Text('IELTS Reading',style: TextStyle(fontSize: 30,color: Constants.main_color,fontWeight: FontWeight.w700,fontFamily: 'Poppins'),),

      ),
    );
  }
}