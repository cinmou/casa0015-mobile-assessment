import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// 获取当前登录的用户
  /// Gets the currently signed-in user.
  User? get currentUser => _auth.currentUser;

  /// 监听用户的认证状态变化 (例如从登出变为登录)
  /// Listens for changes in the user's authentication state.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// 匿名登录
  /// Signs in the user anonymously.
  Future<UserCredential?> signInAnonymously() async {
    try {
      final userCredential = await _auth.signInAnonymously();
      print("Signed in anonymously. UID: ${userCredential.user?.uid}");
      return userCredential;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          print("Error: Anonymous auth hasn't been enabled for this project. Please enable it in Firebase Console.");
          break;
        default:
          print("Unknown error during anonymous sign-in: ${e.message}");
      }
      return null;
    }
  }

  /// **新增功能**: 删除当前用户账户
  /// Deletes the current user's account permanently.
  /// This is irreversible and will also delete their associated data in Firestore if rules are set up correctly.
  Future<bool> deleteCurrentUserAccount() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.delete();
        print("User account deleted successfully. UID: ${user.uid}");
        return true;
      }
      print("No user is currently signed in.");
      return false;
    } on FirebaseAuthException catch (e) {
      // "requires-recent-login" is a common error, but less likely for anonymous users
      // unless their session has been active for a very long time.
      print("Error deleting user account: ${e.code} - ${e.message}");
      return false;
    }
  }


  /// 退出登录 (对于纯匿名应用通常不需要，但保留以备后用)
  /// Signs out the current user.
  Future<void> signOut() async {
    await _auth.signOut();
    print("User signed out.");
  }
}
