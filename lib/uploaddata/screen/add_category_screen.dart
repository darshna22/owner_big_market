import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:owner_big_market/storage_service1.dart';
import 'package:owner_big_market/uploaddata/database/my_database.dart';
import 'package:owner_big_market/uploaddata/firebaseauth/auth_result_status.dart';
import 'package:owner_big_market/uploaddata/firebaseauth/my_auth_exception_handling.dart';
import 'package:owner_big_market/uploaddata/model/category_data.dart';
import 'package:owner_big_market/uploaddata/reusable_widget/reusable_widget.dart';
import 'package:owner_big_market/uploaddata/screen/image_from_gallery.dart';
import 'package:owner_big_market/uploaddata/utility/color_utils.dart';
import 'package:owner_big_market/uploaddata/utility/custom_loader.dart';
import 'package:owner_big_market/uploaddata/utility/my_utility.dart';
import 'package:owner_big_market/uploaddata/utility/validator.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({Key? key}) : super(key: key);

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  TextEditingController _categoryNameTextEditingController =
      new TextEditingController();
  TextEditingController _categoryImageUrlTextEditingController =
      new TextEditingController();
  bool isInProgress = false;
  bool _isImageSet = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _image;
  var _fileName = '';
  var imagePicker;
  var type;
  String _imageUrl = '';
  Storage storage = Storage();
  MyDatabase myDatabase = MyDatabase();

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
  }

  void _handleURLButtonPress(BuildContext context, var type) async {
    var source = type == ImageSourceType.camera
        ? ImageSource.camera
        : ImageSource.gallery;
    XFile image = await imagePicker.pickImage(
        source: source,
        imageQuality: 50,
        preferredCameraDevice: CameraDevice.front);
    setState(() {
      _image = File(image.path);
      var fileExtension = image.path.split('/').last.split('.');
      _fileName = MyUtility.getUniqueUUId() + '.' + fileExtension[1];
      _uploadCategoryImage(image.path, _fileName).then((value) =>
          MyUtility.showToastMsg('Category Image Uploaded Successfully'));
    });
  }

  @override
  Widget build(BuildContext context) {
    final overlay = LoadingOverlay.of(context);
    return Scaffold(
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
                          20, 20, 20, 0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          reusableTextFieldWithoutImage(
                              _categoryNameTextEditingController,
                              'Enter Category Name',
                              true),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  reusableSelectImage(_image),
                                  Center(
                                      child: _isImageSet
                                          ? CircularProgressIndicator()
                                          : Text(''))
                                ],
                              ),
                              Padding(padding: EdgeInsets.only(right: 20)),
                              Row(
                                children: [
                                  IconButton(
                                    color: hexStringToColor('5e61f4'),
                                    onPressed: () {
                                      _handleURLButtonPress(
                                          context, ImageSourceType.gallery);
                                    },
                                    icon: const Icon(Icons.browse_gallery),
                                  ),
                                  IconButton(
                                    color: hexStringToColor('5e61f4'),
                                    onPressed: () {
                                      _handleURLButtonPress(
                                          context, ImageSourceType.camera);
                                    },
                                    icon: const Icon(Icons.camera_alt),
                                  )
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          reusableTextFieldWithoutImage(
                              _categoryImageUrlTextEditingController,
                              (_imageUrl.isEmpty)
                                  ? 'Image Url here...'
                                  : _imageUrl,
                              true),
                          SizedBox(
                            height: 10,
                          ),
                          reusableBtn(_formKey, context, true, () {
                            //btn call will be here
                            _saveCategoryData(
                                _categoryNameTextEditingController.text,
                                _categoryImageUrlTextEditingController.text,
                                overlay);
                          }, 'SAVE CATEGORY DATA')
                        ],
                      ),
                    ),
                  ),
                ))));
  }

  _uploadCategoryImage(String filePath, String fileName) async {
    {
      setState(() {
        _isImageSet = true;
      });
      final status = await storage.uploadCategoryImage(filePath, fileName);
      if (status == AuthResultStatus.successful) {
        MyUtility.showToastMsg('Category Image Uploaded Successfully');
        _downloadCategoryImageUrl(fileName);
      } else {
        final errorMsg = AuthExceptionHandler.generateExceptionMessage(status);
        MyUtility.showAlertDialog(
            errorMsg, context, 'Category Image Upload Failed');
      }
    }
  }

  _downloadCategoryImageUrl(String fileName) async {
    {
      final status = await storage.invokeDownloadCategoryUrlApi(fileName);

      if (status.authResultStatus == AuthResultStatus.successful) {
        setState(() {
          _isImageSet = false;
          _imageUrl = status.downloadImageUrl!;
          _categoryImageUrlTextEditingController.text = _imageUrl;
        });
      } else {
        final errorMsg = AuthExceptionHandler.generateExceptionMessage(status);
        MyUtility.showAlertDialog(
            errorMsg, context, 'Category Image download Failed');
      }
    }
  }

  _saveCategoryData(
      String categoryName, String categoryUrl, LoadingOverlay overlay) async {
    {
      overlay.show();
      CategoryData categoryData = CategoryData(
          categoryName: categoryName,
          categoryImageUrl: categoryUrl,
          categoryDataTimeStamp: MyUtility.getUniqueUUId());
      final status = await myDatabase.saveCategoryDataToDB(categoryData);

      if (status == AuthResultStatus.successful) {
        setState(() {
          overlay.hide();
        });
        MyUtility.showToastMsg('Category Data Saved successfully Successfully');
        clearAllEditFields();
      } else {
        final errorMsg = AuthExceptionHandler.generateExceptionMessage(status);
        MyUtility.showAlertDialog(
            errorMsg, context, 'Category Data Saved to Fail');
      }
    }
  }

  void clearAllEditFields() {
    _categoryNameTextEditingController.clear();
    _categoryImageUrlTextEditingController.clear();
    setState(() {
      _fileName = '';
      _imageUrl = '';
      _image = null;
    });
  }
}
