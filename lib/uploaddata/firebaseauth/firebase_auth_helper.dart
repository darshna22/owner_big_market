import 'package:firebase_auth/firebase_auth.dart';
import 'package:owner_big_market/uploaddata/firebaseauth/auth_result_status.dart';
import 'package:owner_big_market/uploaddata/firebaseauth/my_auth_exception_handling.dart';

class FirebaseAuthHelper {
  final _auth = FirebaseAuth.instance;
  late AuthResultStatus _status;

  Future<AuthResultStatus> createAccount({email, pass}) async {
    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: pass);
      if (authResult.user != null) {
        _status = AuthResultStatus.successful;
      } else {
        _status = AuthResultStatus.undefined;
      }
    } catch (e) {
      print('Exception @createAccount: $e');
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }

  Future<AuthResultStatus> login({email, pass}) async {
    try {
      final authResult =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);

      if (authResult.user != null) {
        _status = AuthResultStatus.successful;
      } else {
        _status = AuthResultStatus.undefined;
      }
    } catch (e) {
      print('Exception @createAccount: $e');
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }


  logout() async{
    await _auth.signOut();
  }
}
