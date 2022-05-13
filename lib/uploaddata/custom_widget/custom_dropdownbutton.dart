import 'package:flutter/material.dart';
import 'package:owner_big_market/uploaddata/listeners/dropdown_interface.dart';
import 'package:owner_big_market/uploaddata/screen/upload_category_screen.dart';

class CustomDropDownButton extends StatefulWidget {
  String? defaultValue;
  String valueFrom;
  List<String> dropDownArr;
  DropdownInterface dropdownInterface;

  CustomDropDownButton(
      {Key? key,
      required this.dropDownArr,
      required this.valueFrom,
      this.defaultValue,
      required this.dropdownInterface})
      : super(key: key);

  @override
  State<CustomDropDownButton> createState() => _CustomDropDownButtonState();
}

class _CustomDropDownButtonState extends State<CustomDropDownButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: widget.defaultValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      items: widget.dropDownArr
          .map((label) => DropdownMenuItem(
                child: Text(label),
                value: label,
              ))
          .toList(),
      onChanged: (String? value) {
        setState(() {
          widget.defaultValue = value;
          widget.dropdownInterface
              .getDropdownSelectedValue(widget.defaultValue,widget.valueFrom);
        });
      },
    );
  }
}
