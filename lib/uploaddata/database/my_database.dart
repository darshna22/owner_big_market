import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:owner_big_market/uploaddata/firebaseauth/auth_result_status.dart';
import 'package:owner_big_market/uploaddata/firebaseauth/my_auth_exception_handling.dart';
import 'package:owner_big_market/uploaddata/model/category_data.dart';
import 'package:owner_big_market/uploaddata/model/my_download_rsult.dart';
import 'package:owner_big_market/uploaddata/model/product_data.dart';
import 'package:owner_big_market/uploaddata/utility/custom_loader.dart';

class MyDatabase {
  var mFirebaseFirestoreInstance;
  late AuthResultStatus _status;
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("categories");
  MyDownloadResult myDownloadResult = MyDownloadResult();

  MyDatabase() {
    mFirebaseFirestoreInstance = FirebaseFirestore.instance;
  }

  Future getCategories() async {
    List categoriesList = [];
    try {
      //to get data from a single/particular document alone.
      // var temp = await collectionRef.doc("<your document ID here>").get();
      // to get data from all documents sequentially
      await collectionReference.get().then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          categoriesList.add(result.data());
        }
      });

      return categoriesList;
    } catch (e) {
      debugPrint("Error - $e");
      return null;
    }
  }

  Future<AuthResultStatus> saveCategoryDataToDB(
      CategoryData categoryData) async {
    var savedCategory;
    try {
      savedCategory =
          await mFirebaseFirestoreInstance.collection('categories').add({
        'categoryName': categoryData.categoryName,
        'categoryImageUrl': categoryData.categoryImageUrl,
        'categoryDataTimeStamp': categoryData.categoryDataTimeStamp
      });
      if (savedCategory != null) {
        _status = AuthResultStatus.successful;
      } else {
        _status = AuthResultStatus.undefined;
      }
    } catch (e) {
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }

  Future<AuthResultStatus> saveProductDataToDB(ProductData productData) async {
    var savedProduct;
    try {
      savedProduct =
          await mFirebaseFirestoreInstance.collection('products').add({
        'categoryName': productData.categoryName,
        'productName': productData.productName,
        'productOriginalPrice': productData.productOriginalPrice,
        'productWeight': productData.productWeight,
        'productUnit': productData.productUnit,
        'productQuantity': productData.productQuantity,
        'isProductRecommendable': productData.isProductRecommendable,
        'isProductPopular': productData.isProductPopular,
        'productImageUrl': productData.productImageUrl,
        'dataTimeStamp': productData.dataTimeStamp
      });
      if (savedProduct != null) {
        _status = AuthResultStatus.successful;
      } else {
        _status = AuthResultStatus.undefined;
      }
    } catch (e) {
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }
}
