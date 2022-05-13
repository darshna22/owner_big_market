import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:owner_big_market/uploaddata/screen/add_category_screen.dart';
import 'package:owner_big_market/uploaddata/screen/add_product_category_screen.dart';
import 'package:owner_big_market/uploaddata/screen/signin_screen.dart';
import 'package:owner_big_market/uploaddata/screen/upload_category_screen.dart';

class NavigationUtility {
  static navigateToHome(BuildContext context) {
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => AddProductCategoryScreen(),
      ),
      (route) => false, //if you want to disable back feature set to false
    );
  }

  static navigateToLogin(BuildContext context) {
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => SignInScreen(),
      ),
          (route) => false, //if you want to disable back feature set to false
    );
  }
}
