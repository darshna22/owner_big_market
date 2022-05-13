import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

enum ImageSourceType { gallery, camera }

class ImageFromGalleryEx extends StatefulWidget {
  final type;
  ImageFromGalleryEx(this.type);


  @override
  ImageFromGalleryExState createState() => ImageFromGalleryExState(this.type);
}

class ImageFromGalleryExState extends State<ImageFromGalleryEx> {
  var _image;
  var imagePicker;
  var type;

  ImageFromGalleryExState(this.type);

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: Column(
      children: <Widget>[
        SizedBox(
          height: 52,
        ),
        Center(
          child: GestureDetector(
            onTap: () async {
              var source = type == ImageSourceType.camera
                  ? ImageSource.camera
                  : ImageSource.gallery;
              XFile image = await imagePicker.pickImage(
                  source: source, imageQuality: 50, preferredCameraDevice: CameraDevice.front);
              setState(() {
                _image = File(image.path);
              });
            },
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                  color: Colors.red[200]),
              child: _image != null
                  ? Image.file(
                _image,
                width: 200.0,
                height: 200.0,
                fit: BoxFit.fill,
              )
                  : Container(
                decoration: BoxDecoration(
                    color: Colors.red[200]),
                width: 200,
                height: 200,
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.grey[800],
                ),
              ),
            ),
          ),
        )
      ],
    ),);
  }
}