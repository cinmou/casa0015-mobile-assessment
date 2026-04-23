import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential?> signInAnonymously() async {
    try {
      final userCredential = await _auth.signInAnonymously();
      print("Signed in anonymously. UID: ${userCredential.user?.uid}");
      return userCredential;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          print(
            "Error: Anonymous auth hasn't been enabled for this project. Please enable it in Firebase Console.",
          );
          break;
        default:
          print("Unknown error during anonymous sign-in: ${e.message}");
      }
      return null;
    }
  }

  /// Permanently deletes the current anonymous account.
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

  Future<void> signOut() async {
    await _auth.signOut();
    print("User signed out.");
  }
}
