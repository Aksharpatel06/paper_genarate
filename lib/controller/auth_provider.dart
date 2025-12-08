// providers/auth_provider.dart
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider with ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  bool _isAuthenticated = false;
  User? _user;
  String? _error;

  // Getters
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  User? get user => _user;
  String? get error => _error;

  // Google Sign-In
  Future<void> signInWithGoogle() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _googleSignIn.initialize(clientId: '128853313339-5ke7jvn2nf98adtvmovthopj9dtjj2ct.apps.googleusercontent.com');

      final GoogleSignInAccount? googleUser = await _googleSignIn.authenticate();

      if (googleUser == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken);

      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      _user = userCredential.user;
      _isAuthenticated = true;
      _error = null;
    } catch (error) {
      _error = error.toString();
      _isAuthenticated = false;
      if (kDebugMode) {
        debugPrint('Firebase Auth Error: $error');
        print('Google Sign-In Error: $error');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      _isLoading = true;
      notifyListeners();

      await _googleSignIn.signOut();
      await _auth.signOut();

      _user = null;
      _isAuthenticated = false;
      _error = null;
    } catch (error) {
      _error = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
