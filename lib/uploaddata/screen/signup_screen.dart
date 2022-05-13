import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:owner_big_market/uploaddata/firebaseauth/auth_result_status.dart';
import 'package:owner_big_market/uploaddata/firebaseauth/firebase_auth_helper.dart';
import 'package:owner_big_market/uploaddata/firebaseauth/my_auth_exception_handling.dart';
import 'package:owner_big_market/uploaddata/reusable_widget/reusable_widget.dart';
import 'package:owner_big_market/uploaddata/screen/add_category_screen.dart';
import 'package:owner_big_market/uploaddata/screen/add_product_category_screen.dart';
import 'package:owner_big_market/uploaddata/screen/upload_category_screen.dart';
import 'package:owner_big_market/uploaddata/utility/color_utils.dart';
import 'package:owner_big_market/uploaddata/utility/my_utility.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:owner_big_market/uploaddata/utility/navigation_utility.dart';

class SingUpScreen extends StatefulWidget {
  const SingUpScreen({Key? key}) : super(key: key);

  @override
  State<SingUpScreen> createState() => _SingUpScreenState();
}

class _SingUpScreenState extends State<SingUpScreen> {
  bool isInProgress = false;
  bool _isObscureChange = true;
  TextEditingController _emailTextEditingController =
      new TextEditingController();
  TextEditingController _nameTextEditingController =
      new TextEditingController();
  TextEditingController _pwdTextEditingController = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: reusableAppbar(context, 'Add Category'),
        body: ModalProgressHUD(
            inAsyncCall: isInProgress,
            child: Form(
                key: _formKey,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: reusablePageDecoration(),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          20, MediaQuery.of(context).size.height * 0.2, 20, 0),
                      child: Column(
                        children: [
                          reusableTextField(
                              _isObscureChange,
                              showHidePwdIcon,
                              _nameTextEditingController,
                              'Enter UserName',
                              Icons.person_outline,
                              false,''),
                          SizedBox(
                            height: 30,
                          ),
                          reusableTextField(
                              _isObscureChange,
                              showHidePwdIcon,
                              _emailTextEditingController,
                              'Enter EmailID',
                              Icons.person_outline,
                              false,'email'),
                          SizedBox(
                            height: 30,
                          ),
                          reusableTextField(
                              _isObscureChange,
                              showHidePwdIcon,
                              _pwdTextEditingController,
                              'Enter Password',
                              Icons.email_outlined,
                              true,'pwd'),
                          SizedBox(
                            height: 30,
                          ),
                          reusableBtn(_formKey, context, false, () {
                            _createAccount(
                                context,
                                _emailTextEditingController.text,
                                _pwdTextEditingController.text);
                          },'SIGN UP'),
                          //signin code here
                        ],
                      ),
                    ),
                  ),
                ))));
  }

  _createAccount(BuildContext context, String email, String password) async {
    setState(() {
      isInProgress = true;
    });
    final status =
        await FirebaseAuthHelper().createAccount(email: email, pass: password);
    setState(() {
      isInProgress = false;
    });
    if (status == AuthResultStatus.successful) {
      // Navigate to success screen
      MyUtility.showToastMsg('Account Created Successfully');
      NavigationUtility.navigateToHome(context);
      // Navigator.push(context,
      //     MaterialPageRoute(builder: (context) => UploadCategoryScreen()));
    } else {
      final errorMsg = AuthExceptionHandler.generateExceptionMessage(status);
      MyUtility.showAlertDialog(errorMsg, context, 'Account Creation Failed');
    }
  }

  showHidePwdIcon(bool newObscureChange) {
    setState(() {
      _isObscureChange = newObscureChange;
    });
  }
}
