import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:owner_big_market/uploaddata/firebaseauth/auth_result_status.dart';
import 'package:owner_big_market/uploaddata/firebaseauth/firebase_auth_helper.dart';
import 'package:owner_big_market/uploaddata/firebaseauth/my_auth_exception_handling.dart';
import 'package:owner_big_market/uploaddata/reusable_widget/reusable_widget.dart';
import 'package:owner_big_market/uploaddata/screen/add_category_screen.dart';
import 'package:owner_big_market/uploaddata/screen/upload_category_screen.dart';
import 'package:owner_big_market/uploaddata/utility/my_utility.dart';
import 'package:owner_big_market/uploaddata/utility/navigation_utility.dart';

class AddProductCategoryScreen extends StatefulWidget {
  @override
  State<AddProductCategoryScreen> createState() =>
      _AddProductCategoryScreenState();

  const AddProductCategoryScreen({Key? key}) : super(key: key);
}

class _AddProductCategoryScreenState extends State<AddProductCategoryScreen> {
  bool isInProgress = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        inAsyncCall: isInProgress,
        child: Scaffold(
            body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: reusablePageDecoration(),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  20, MediaQuery.of(context).size.height * 0.2, 20, 0),
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  reusableAddProductCategoryBtn(context, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddCategoryScreen()),
                    );
                  }, 'ADD CATEGORY DATA'),
                  reusableAddProductCategoryBtn(context, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UploadCategoryScreen()),
                    );
                  }, 'ADD PRODUCT DATA'),
                  reusableAddProductCategoryBtn(context, () {
                    logout();
                  }, 'LOGOUT')
                ],
              ),
            ),
          ),
        )));
  }

  logout() {
    {
      setState(() {
        isInProgress = true;
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        setState(() async {
          await FirebaseAuthHelper().logout();
          isInProgress = false;
          MyUtility.showToastMsg('Logout Successfully');
          NavigationUtility.navigateToLogin(context);
        });
      });
    }
  }
}
