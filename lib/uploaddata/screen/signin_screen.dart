import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:owner_big_market/uploaddata/firebaseauth/auth_result_status.dart';
import 'package:owner_big_market/uploaddata/firebaseauth/firebase_auth_helper.dart';
import 'package:owner_big_market/uploaddata/firebaseauth/my_auth_exception_handling.dart';
import 'package:owner_big_market/uploaddata/reusable_widget/reusable_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:owner_big_market/uploaddata/utility/my_utility.dart';
import 'package:owner_big_market/uploaddata/utility/navigation_utility.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _emailTextEditingController =
      new TextEditingController();
  TextEditingController _pwdTextEditingController = new TextEditingController();
  bool isInProgress = false;
  bool _isObscureChange = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          logoWidget('assets/images/logo.png'),
                          SizedBox(
                            height: 30,
                          ),
                          reusableTextField(
                              _isObscureChange,
                              showHidePwdIcon,
                              _emailTextEditingController,
                              'Enter UserName',
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
                          reusableBtn(_formKey, context, true, () {
                            _login(_emailTextEditingController.text,
                                _pwdTextEditingController.text);
                          },'LOG IN'), //signin code here
                          signUpOption(context),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                ))));
  }

  _login(String email, String password) async {
    {
      setState(() {
        isInProgress = true;
      });
      final status =
          await FirebaseAuthHelper().login(email: email, pass: password);
      setState(() {
        isInProgress = false;
      });
      if (status == AuthResultStatus.successful) {
        // Navigate to success screen
        MyUtility.showToastMsg('Logined Successfully');
        NavigationUtility.navigateToHome(context);
      } else {
        final errorMsg = AuthExceptionHandler.generateExceptionMessage(status);
        MyUtility.showAlertDialog(errorMsg, context, 'Login Failed');
      }
    }
  }

  showHidePwdIcon(bool newObscureChange) {
    setState(() {
      _isObscureChange = newObscureChange;
    });
  }
}
