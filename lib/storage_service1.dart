import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:owner_big_market/uploaddata/firebaseauth/auth_result_status.dart';
import 'package:owner_big_market/uploaddata/firebaseauth/my_auth_exception_handling.dart';
import 'package:owner_big_market/uploaddata/model/my_download_rsult.dart';

class Storage {

  final firebase_storage.FirebaseStorage mStorage =
      firebase_storage.FirebaseStorage.instance;
  late AuthResultStatus _status;
  MyDownloadResult myDownloadResult = MyDownloadResult();


  Future<void> uploadFiles(String filePath, String fileName) async {
    File file = File(filePath);
    try {
      await mStorage.ref('bigmarket/products/$fileName').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }

  Future<AuthResultStatus> uploadCategoryImage(
      String filePath, String fileName) async {
    File file = File(filePath);
    try {
      final authResult =
          await mStorage.ref('bigmarket/category/$fileName').putFile(file);
      if (authResult != null) {
        _status = AuthResultStatus.successful;
      } else {
        _status = AuthResultStatus.undefined;
      }
    } catch (e) {
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }


  Future<AuthResultStatus> uploadProductImage(
      String filePath, String fileName) async {
    File file = File(filePath);
    try {
      final authResult =
      await mStorage.ref('bigmarket/products/$fileName').putFile(file);
      if (authResult != null) {
        _status = AuthResultStatus.successful;
      } else {
        _status = AuthResultStatus.undefined;
      }
    } catch (e) {
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }

  Future<MyDownloadResult> invokeDownloadCategoryUrlApi(
      String imageName) async {
    try {
      String downloadUrl =
          await mStorage.ref('bigmarket/category/$imageName').getDownloadURL();
      myDownloadResult.downloadImageUrl = downloadUrl;


      if (downloadUrl.isNotEmpty) {
        _status = AuthResultStatus.successful;
      } else {
        _status = AuthResultStatus.undefined;
      }
    } catch (e) {
      _status = AuthExceptionHandler.handleException(e);
    }
    myDownloadResult.authResultStatus = _status;
    return myDownloadResult;
  }

  Future<MyDownloadResult> invokeDownloadProductUrlApi(
      String imageName) async {
    try {
      String downloadUrl =
      await mStorage.ref('bigmarket/products/$imageName').getDownloadURL();
      myDownloadResult.downloadImageUrl = downloadUrl;
      if (downloadUrl.isNotEmpty) {
        _status = AuthResultStatus.successful;
      } else {
        _status = AuthResultStatus.undefined;
      }
    } catch (e) {
      _status = AuthExceptionHandler.handleException(e);
    }
    myDownloadResult.authResultStatus = _status;
    return myDownloadResult;
  }

  Future<firebase_storage.ListResult> getListFiles() async {
    firebase_storage.ListResult results =
        await mStorage.ref('bigmarket/products').listAll();
    print('list data' + results.items.length.toString());
    return results;
  }

  Future<String> downloadUrl(String imageName) async {
    String downloadUrl =
        await mStorage.ref('bigmarket/products/$imageName').getDownloadURL();
    print('list data' + downloadUrl);
    return downloadUrl;
  }
}
