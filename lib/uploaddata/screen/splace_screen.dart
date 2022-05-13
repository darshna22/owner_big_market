import 'dart:async';

import 'package:flutter/material.dart';
import 'package:owner_big_market/uploaddata/reusable_widget/reusable_widget.dart';
import 'package:owner_big_market/uploaddata/screen/add_product_category_screen.dart';
import 'package:owner_big_market/uploaddata/screen/signin_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => SignInScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: reusablePageDecoration(),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // logo here
                Image.asset(
                  'assets/images/logo.png',
                  height: 120,
                ),
                SizedBox(
                  height: 20,
                ),
                Text('Big Market Sellar'.toUpperCase(),style: TextStyle(color: Colors.white70,fontSize: 20),),
                SizedBox(
                  height: 20,
                ),
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              ],
            ),
          )),
    );
  }
}
