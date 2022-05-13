import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  TextEditingController textEditingController;
  String mLabelText;
  String mHintText;
  TextInputType? keyboardType;
  String defaultText = '';
  String? mErrorText = '';

  CustomTextField(
      {Key? key,
      required this.textEditingController,
      required this.mLabelText,
      required this.mHintText,
      this.mErrorText,
      this.keyboardType})
      : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: widget.keyboardType ?? TextInputType.text,
      controller: widget.textEditingController,
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: widget.mLabelText,
          hintText: widget.mHintText,
          errorText: widget.mErrorText),
    );
  }
}
