import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

typedef OAuthSignIn = void Function();

final FirebaseAuth _auth = FirebaseAuth.instance;

//Login page.
class AuthGate extends StatefulWidget {
  // ignore: public_member_api_docs
  const AuthGate({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String error = '';
  String verificationId = '';

  GoogleSignInAccount? _currentUser;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [],
      clientId:
          '740150444954-93f5kah5vqa1ogts10vmgrqsf2ekgu8g.apps.googleusercontent.com');

  Future<void> _handleSignIn() async {
    setIsLoading();
    try {
      await _googleSignIn.signIn();
      _currentUser = _googleSignIn.currentUser;
      final googleAuth = await _currentUser?.authentication;

      if (googleAuth != null) {
        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Once signed in, return the UserCredential
        await _auth.signInWithCredential(credential);
      }
    } catch (error) {
      print(error);
    }
    setIsLoading();
  }

  bool isLoading = false;

  void setIsLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  late Map<Buttons, OAuthSignIn> authButtons;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      authButtons = {
        Buttons.Google: _handleSignIn,
      };
    } else {
      authButtons = {
        if (!Platform.isMacOS) Buttons.Google: _handleSignIn,
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SafeArea(
                  child: Form(
                    key: formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...authButtons.keys
                              .map(
                                (button) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 200),
                                    child: isLoading
                                        ? Container(
                                            color: Colors.grey[200],
                                            height: 50,
                                            width: double.infinity,
                                          )
                                        : SizedBox(
                                            width: double.infinity,
                                            height: 50,
                                            child: SignInButton(
                                              button,
                                              onPressed: authButtons[button]!,
                                            ),
                                          ),
                                  ),
                                ),
                              )
                              .toList(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    setIsLoading();
    final GoogleSignInAccount? googleUser;
    try {
      //A client ID is required for web builds, so this checks if the platform is web before calling GoogleSignIn.
      // if (kIsWeb) {
      googleUser = await GoogleSignIn(
              clientId:
                  '740150444954-93f5kah5vqa1ogts10vmgrqsf2ekgu8g.apps.googleusercontent.com')
          .signIn();
      // } else {
      // googleUser = await GoogleSignIn().signIn();
      // }

      // Obtain the auth details from the request
      final googleAuth = await googleUser?.authentication;

      if (googleAuth != null) {
        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Once signed in, return the UserCredential
        await _auth.signInWithCredential(credential);
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        error = '${e.message}';
        print(error);
      });
    } finally {
      setIsLoading();
    }
  }
}

//This gets the user's name from their google account for the message on the To-Do page.
String getDisplayName() {
  String _result = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final User? user = _auth.currentUser;
  final name = user!.displayName;

  if (name is String) {
    _result = name;
  } else {
    _result = 'User';
  }
  return _result;
}

//This retrieves the user's unique User ID, which is what their data is stored under in the database.
String getUID() {
  String _result = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final User? user = _auth.currentUser;
  final String? uid = user!.uid;

  if (uid is String) {
    _result = uid;
  }
  return _result;
}

//More sign in methods can be added down the line but I felt that for the first version Google Account sign in was the best option.
