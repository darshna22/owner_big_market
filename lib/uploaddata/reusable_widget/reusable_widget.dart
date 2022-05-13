import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:owner_big_market/uploaddata/screen/signup_screen.dart';
import 'package:owner_big_market/uploaddata/utility/color_utils.dart';
import 'package:owner_big_market/uploaddata/utility/validator.dart';

Image logoWidget(String imageName) {
  return Image.asset(
    imageName,
    fit: BoxFit.fitWidth,
    height: 250,
    width: 250,
  );
}

Column reusableSelectImage(var _image) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 200,
        height: 150,
        decoration: BoxDecoration(color: Colors.red[200]),
        child: _image != null
            ? Image.file(
                _image,
                width: 230.0,
                height: 150.0,
                fit: BoxFit.fill,
              )
            : Container(
                decoration: BoxDecoration(color: Colors.red[200]),
                width: 230,
                height: 150,
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.grey[800],
                ),
              ),
      ),
    ],
  );
}

TextFormField reusableTextFieldWithoutImage(
    TextEditingController controller, String text, bool isEditable) {
  return TextFormField(
    validator: (String? value) {
      if (text == 'Enter Category Name' ||
          text == 'Enter Your Product Category Name')
        return Validator.validateCategory(name: value);
      else if (text == 'Enter Your Product Name')
        return Validator.validateName(name: value);
      else if (text == 'Enter Original Product Price')
        return Validator.validatePrice(name: value);
      else if (text == 'Enter Discount Product Price')
        return Validator.validateDiscountPrice(name: value);
      else if (text == 'Enter Product Available Quantity')
        return Validator.validateAvailableQuantity(name: value);
      else
        return Validator.validateImageUrl(name: value);
    },
    controller: controller,
    obscureText: false,
    enabled: isEditable,
    cursorColor: Colors.white,
    style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14),
    decoration: InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      errorStyle: TextStyle(
        color: Colors.red[400],
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      labelText: text,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white.withOpacity(0.3),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(style: BorderStyle.none, width: 0)),
    ),
    keyboardType: (text == 'Enter Original Product Price' ||
            (text == 'Enter Discount Product Price') ||
            (text == 'Enter Product Available Quantity') ||
            (text == 'Enter Product Weight'))
        ? TextInputType.number
        : TextInputType.text,
  );
}

TextFormField reusableTextField(
    bool _isObscureChange,
    Function(bool _newIsObscure) showHidePwdIcon,
    TextEditingController textEditingController,
    String text,
    IconData icon,
    bool isPasswordType,
    String validationType) {
  return TextFormField(
    validator: (String? value) {
      if (validationType == 'pwd') {
        return Validator.validatePassword(password: value);
      } else if (validationType == 'email') {
        return Validator.validateEmail(email: value);
      } else {
        return Validator.validateName(name: value);
      }
    },
    controller: textEditingController,
    obscureText: isPasswordType ? _isObscureChange : isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.white,
    style: TextStyle(color: Colors.white.withOpacity(0.9)),
    decoration: InputDecoration(
      errorStyle: TextStyle(
        color: Colors.red[400],
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      prefixIcon: Icon(
        icon,
        color: Colors.white70,
      ),
      suffixIcon: IconButton(
        icon: Visibility(
            visible: isPasswordType,
            child: Icon(
              _isObscureChange ? Icons.visibility_off : Icons.visibility,
              color: hexStringToColor('5e61f4'),
            )),
        onPressed: () {
          showHidePwdIcon(!_isObscureChange);
        },
      ),
      labelText: text,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white.withOpacity(0.3),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(style: BorderStyle.none, width: 0)),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}

Row signUpOption(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        "Don't  have account?",
        style: TextStyle(color: Colors.white70),
      ),
      GestureDetector(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SingUpScreen()));
        },
        child: Text(
          " Sign UP",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      )
    ],
  );
}

AppBar reusableAppbar(BuildContext context, String title) {
  return AppBar(
    elevation: 0,
    backgroundColor: hexStringToColor('#ca2c94'),
    title: Text(title),
    centerTitle: true,
    leading: InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Icon(
        Icons.arrow_back,
        color: Colors.white,
      ),
    ),
  );
}

LinearGradient reusableAppbarLinearGradient() {
  return LinearGradient(colors: [
    hexStringToColor('5e61f4'),
  ]);
}

LinearGradient reusableLinearGradient() {
  return LinearGradient(colors: [
    hexStringToColor('cb2b93'),
    hexStringToColor('9546c4'),
    hexStringToColor('5e61f4')
  ], begin: Alignment.topCenter, end: Alignment.bottomCenter);
}

BoxDecoration reusablePageDecoration() {
  return BoxDecoration(gradient: reusableLinearGradient());
}

Container reusableBtn(GlobalKey<FormState> _formKey, BuildContext context,
    bool isLogin, Function onTap, String text) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          onTap();
        }
      },
      child: Text(
        text,
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
      ),
      style: ElevatedButton.styleFrom(
          primary: hexStringToColor('5e61f4'), //background color
          onPrimary: Colors.black26, //ripple colorF
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(90))),
    ),
  );
}

Container reusableAddProductCategoryBtn(
    BuildContext context, Function onTap, String text) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () async {
        onTap();
      },
      child: Text(
        text,
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
      ),
      style: ElevatedButton.styleFrom(
          primary: hexStringToColor('5e61f4'), //background color
          onPrimary: Colors.black26, //ripple colorF
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(90))),
    ),
  );
}
