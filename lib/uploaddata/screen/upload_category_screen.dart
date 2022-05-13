import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:owner_big_market/uploaddata/custom_widget/custom_dropdown_button2.dart';
import 'package:owner_big_market/uploaddata/database/my_database.dart';
import 'package:owner_big_market/uploaddata/firebaseauth/auth_result_status.dart';
import 'package:owner_big_market/uploaddata/firebaseauth/my_auth_exception_handling.dart';
import 'package:owner_big_market/uploaddata/model/category_data.dart';
import 'package:owner_big_market/uploaddata/model/product_data.dart';
import 'package:owner_big_market/uploaddata/reusable_widget/reusable_widget.dart';
import 'package:owner_big_market/uploaddata/screen/image_from_gallery.dart';
import 'dart:io';
import 'package:owner_big_market/storage_service1.dart';
import 'package:owner_big_market/uploaddata/utility/color_utils.dart';
import 'package:owner_big_market/uploaddata/utility/custom_loader.dart';
import 'package:owner_big_market/uploaddata/utility/my_utility.dart';

class UploadCategoryScreen extends StatefulWidget {
  const UploadCategoryScreen({Key? key}) : super(key: key);

  @override
  State<UploadCategoryScreen> createState() => _UploadCategoryScreenState();
}

class _UploadCategoryScreenState extends State<UploadCategoryScreen> {
  Storage storage = Storage();
  MyDatabase myDatabase = MyDatabase();
  var _image;
  var _fileName = '';
  var imagePicker;
  var type;
  var _imageUrl;
  var isLoading = true;
  bool _isImageSet = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController productCategoryNameEditText;
  late TextEditingController productNameEditText;
  late TextEditingController originalPriceEditText;
  late TextEditingController discountPriceEditText;
  late TextEditingController productAvailableCountEditText;
  late TextEditingController productWeightEditText;

  String? productWeightUnitValue;
  String? isProductRecommendableValue;
  String? isCategoryNameValue;
  String? isProductPopularValue;
  var productImageUrl = '';
  List<String> selectWeightArray = ['kg', 'gm', 'ml', 'lt'];
  List<String> selectIsRecommendableArray = ['True', 'False'];
  List<String> selectIsPopularArray = ['True', 'False'];
  Future? productCategories;

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
    productNameEditText = TextEditingController();
    originalPriceEditText = TextEditingController();
    discountPriceEditText = TextEditingController();
    productAvailableCountEditText = TextEditingController();
    productWeightEditText = TextEditingController();
    productCategories = _getProductCategories();
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
      _uploadProductImage(image.path, _fileName).then((value) =>
          MyUtility.showToastMsg('Product Image Uploaded Successfully'));
    });
  }

  _getProductCategories() async {
    return await myDatabase.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    final overlay = LoadingOverlay.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: reusableAppbar(context, 'Add Product'),
      body: FutureBuilder(
        future: productCategories,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text(
              "Something went wrong",
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            List dataList = snapshot.data as List;
            List<CategoryData> categoryDataList = [];
            List<String> categoryNameList = [];
            for (var index = 0; index < dataList.length; index++) {
              CategoryData categoryData = CategoryData(
                  categoryName: dataList[index]["categoryName"],
                  categoryImageUrl: dataList[index]["categoryImageUrl"],
                  categoryDataTimeStamp: dataList[index]
                      ["categoryDataTimeStamp"]);
              categoryDataList.add(categoryData);
              if (!categoryNameList.contains(categoryData.categoryName))
                categoryNameList.add(categoryData.categoryName);
            }
            return getWidgets(overlay, categoryNameList);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget getWidgets(LoadingOverlay overlay, List<String> categoryNameList) {
    return Form(
        key: _formKey,
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: reusablePageDecoration(),
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.height,
                decoration: reusablePageDecoration(),
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.height,
                        child: CustomDropdownButton2(
                          hint: 'Select Product Category Name',
                          dropdownItems: categoryNameList,
                          value: isCategoryNameValue,
                          onChanged: (value) {
                            setState(() {
                              isCategoryNameValue = value;
                            });
                          },
                        )),
                    SizedBox(
                      height: 30,
                    ),
                    reusableTextFieldWithoutImage(
                        productNameEditText, 'Enter Your Product Name', true),
                    SizedBox(
                      height: 30,
                    ),
                    reusableTextFieldWithoutImage(originalPriceEditText,
                        'Enter Original Product Price', true),
                    SizedBox(
                      height: 30,
                    ),
                    reusableTextFieldWithoutImage(discountPriceEditText,
                        'Enter Discount Product Price', true),
                    SizedBox(
                      height: 30,
                    ),
                    reusableTextFieldWithoutImage(productAvailableCountEditText,
                        'Enter Product Available Quantity', true),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: reusableTextFieldWithoutImage(
                              productWeightEditText,
                              'Enter Product Weight',
                              true),
                        ),
                        Padding(padding: EdgeInsets.only(right: 20)),
                        Expanded(
                          flex: 1,
                          child: CustomDropdownButton2(
                            hint: 'Select Item',
                            dropdownItems: selectWeightArray,
                            value: productWeightUnitValue,
                            onChanged: (value) {
                              setState(() {
                                productWeightUnitValue = value;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Text('Select is Product Reccommendable',
                                style: TextStyle(color: Colors.white70))),
                        Padding(padding: EdgeInsets.only(right: 20)),
                        CustomDropdownButton2(
                          hint: 'Select Item',
                          dropdownItems: selectIsRecommendableArray,
                          value: isProductRecommendableValue,
                          onChanged: (value) {
                            setState(() {
                              isProductRecommendableValue = value;
                            });
                          },
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
                    Row(
                      children: [
                        Expanded(
                            child: Text('Is Product Popular',
                                style: TextStyle(color: Colors.white70))),
                        Padding(padding: EdgeInsets.only(right: 20)),
                        CustomDropdownButton2(
                          hint: 'Select Item',
                          dropdownItems: selectIsPopularArray,
                          value: isProductPopularValue,
                          onChanged: (value) {
                            setState(() {
                              isProductPopularValue = value;
                            });
                          },
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
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
                    reusableBtn(_formKey, context, true, () {
                      setState(() {
                        if (validateDropDownData()) {
                          saveProductData(getProductData(), overlay);
                        }
                      });
                    }, 'ADD PRODUCT')
                  ],
                ),
              ),
            )));
  }

  bool validateDropDownData() {
    bool mBool = true;
    if (isProductPopularValue == null ||
        isProductPopularValue!.isEmpty ||
        isProductPopularValue == 'Select Item') {
      setState(() {
        MyUtility.showToastMsg('Please select product popular or not');
        mBool = false;
      });
    } else if (isProductRecommendableValue == null ||
        isProductRecommendableValue!.isEmpty ||
        isProductRecommendableValue == 'Select Item') {
      setState(() {
        MyUtility.showToastMsg('Please select product recommendable or not');
        mBool = false;
      });
    } else if (isCategoryNameValue == null ||
        isCategoryNameValue!.isEmpty ||
        isCategoryNameValue == 'Select Product Category Name') {
      setState(() {
        MyUtility.showToastMsg('Please select product category name');
        mBool = false;
      });
    } else if (productWeightUnitValue == null ||
        productWeightUnitValue!.isEmpty ||
        productWeightUnitValue == 'Select Item') {
      setState(() {
        MyUtility.showToastMsg('Please select WeightUnit');
        mBool = false;
      });
    } else if (_imageUrl == null || _imageUrl!.isEmpty) {
      setState(() {
        MyUtility.showToastMsg('Please select image');
        mBool = false;
      });
    }
    return mBool;
  }

  void saveProductData(ProductData productData, LoadingOverlay overlay) async {
    overlay.show();
    final status = await myDatabase.saveProductDataToDB(productData);

    if (status == AuthResultStatus.successful) {
      setState(() {
        overlay.hide();
      });
      MyUtility.showToastMsg('Product Data Saved successfully Successfully');
      clearAllEditFields();
    } else {
      final errorMsg = AuthExceptionHandler.generateExceptionMessage(status);
      MyUtility.showAlertDialog(
          errorMsg, context, 'Product Data Saved to Fail');
    }
  }

  ProductData getProductData() {
    var mCategoryName = isCategoryNameValue;
    var mProductName = productNameEditText.text;
    var originalPrice = originalPriceEditText.text;
    var discountPrice = discountPriceEditText.text;
    var productAvailableCount = productAvailableCountEditText.text;
    var productWeight = productWeightEditText.text;

    var mProductData = ProductData();
    mProductData.categoryName = mCategoryName;
    mProductData.productName = mProductName;
    mProductData.productOriginalPrice = double.parse(originalPrice);
    mProductData.productDiscountPrice = double.parse(discountPrice);
    mProductData.productWeight = double.parse(productWeight);
    mProductData.productUnit = productWeightUnitValue;
    mProductData.productQuantity = int.parse(productAvailableCount);
    mProductData.isProductRecommendable =
        (isProductRecommendableValue.toString().toLowerCase() == 'true'
            ? true
            : false);
    mProductData.isProductPopular =
        (isProductPopularValue.toString().toLowerCase() == 'true'
            ? true
            : false);
    mProductData.productImageUrl = _imageUrl;
    mProductData.dataTimeStamp = MyUtility.getCurrentTimeStamp();

    //save product data to firebasedata base
    return mProductData;
  }

  _uploadProductImage(String filePath, String fileName) async {
    {
      setState(() {
        _isImageSet = true;
      });
      final status = await storage.uploadProductImage(filePath, fileName);
      if (status == AuthResultStatus.successful) {
        MyUtility.showToastMsg('Product Image Uploaded Successfully');
        downloadProductImageUrl(fileName);
      } else {
        final errorMsg = AuthExceptionHandler.generateExceptionMessage(status);
        MyUtility.showAlertDialog(
            errorMsg, context, 'Product Image Upload Failed');
      }
    }
  }

  downloadProductImageUrl(String fileName) async {
    {
      final status = await storage.invokeDownloadProductUrlApi(fileName);

      if (status.authResultStatus == AuthResultStatus.successful) {
        setState(() {
          _isImageSet = false;
          _imageUrl = status.downloadImageUrl!;
        });
      } else {
        final errorMsg = AuthExceptionHandler.generateExceptionMessage(status);
        MyUtility.showAlertDialog(
            errorMsg, context, 'Product Image download Failed');
      }
    }
  }

  void clearAllEditFields() {
    productNameEditText.clear();
    originalPriceEditText.clear();
    discountPriceEditText.clear();
    productAvailableCountEditText.clear();
    productWeightEditText.clear();
    setState(() {
      // productWeightUnitValue = 'Select Item';
      // isProductRecommendableValue = 'Select Item';
      // isProductPopularValue = 'Select Item';
      // isCategoryNameValue = 'Select Product Category Name';
      _fileName = '';
      _imageUrl = null;
      _image = null;
    });
  }
}
