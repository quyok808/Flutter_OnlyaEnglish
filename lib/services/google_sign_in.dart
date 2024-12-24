import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        '1033504184241-aotsk3ir7q0ge73292n7o14silknm063.apps.googleusercontent.com', // Client ID từ Google Cloud
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
      "https://www.googleapis.com/auth/userinfo.profile",
      'openid',
    ],
  );

  Future<GoogleSignInAccount?> signIn() async {
    try {
      return await _googleSignIn.signIn();
    } catch (e) {
      print('Google Sign-In error: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }

  Future<GoogleSignInAuthentication?> getAuthentication() async {
    GoogleSignInAccount? user = _googleSignIn.currentUser;
    return await user?.authentication;
  }
}
