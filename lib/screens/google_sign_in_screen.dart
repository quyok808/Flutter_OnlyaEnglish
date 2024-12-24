import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/product_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class GoogleSignInScreen extends StatefulWidget {
  @override
  _GoogleSignInScreenState createState() => _GoogleSignInScreenState();
}

class _GoogleSignInScreenState extends State<GoogleSignInScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId:
        '1033504184241-9jem8o5n16cg47pai2aifk9lvogh84vr.apps.googleusercontent.com', // Client ID từ Google Cloud
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
      "https://www.googleapis.com/auth/userinfo.profile",
      'openid',
    ],
  );

  GoogleSignInAccount? _currentUser;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleSignIn() async {
    try {
      final user = await _googleSignIn.signIn();
      if (user != null) {
        // Get the authentication details
        final GoogleSignInAuthentication googleAuth = await user.authentication;
        final String? idToken = googleAuth.idToken; // This is the ID Token
        final String? accessToken =
            googleAuth.accessToken; // Access Token (if needed)

        print("User: $user");
        print("ID Token: $idToken");
        print("Access Token: $accessToken");
        // Nếu bạn cần gửi ID Token tới backend của bạn:
        final response = await http.post(
          Uri.parse(
              'https://192.168.1.9:7240/api/Authenticate'), // Thay thế với URL API của bạn
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'signedToken': idToken}),
        );

        if (response.statusCode == 200) {
          print('Sign-in successful');
          final responseData = json.decode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Sign-in successful: ${responseData['message']}')),
          );
        } else {
          print('Sign-in failed: ${response.body}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sign-in failed: ${response.body}')),
          );
        }
      }
    } catch (error) {
      print('Google Sign-In error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign-in error: $error')),
      );
    }
  }

  Future<void> _handleSignOut() async {
    await _googleSignIn.signOut();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Signed out')),
    );
  }

  Future<void> _handleHome() async {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => ProductScreen(),
      ),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello'),
      ),
      body: Center(
        child: _currentUser == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('You are not signed in'),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: Icon(Icons.login),
                    label: Text('Sign in with Google'),
                    onPressed: _handleSignIn,
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Hello, ${_currentUser!.displayName}'),
                  SizedBox(height: 10),
                  CircleAvatar(
                    backgroundImage: _currentUser?.photoUrl != null
                        ? NetworkImage(_currentUser!.photoUrl!)
                        : null,
                    child: _currentUser?.photoUrl == null
                        ? Icon(Icons.person,
                            size: 40) // Display icon if no photo
                        : null,
                    radius: 40,
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      ElevatedButton.icon(
                        icon: Icon(Icons.logout),
                        label: Text('Sign out'),
                        onPressed: _handleSignOut,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                      ),
                      ElevatedButton.icon(
                        icon: Icon(Icons.home),
                        label: Text('Trang chủ'),
                        onPressed: _handleHome,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
