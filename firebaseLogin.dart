//  Create a new Firebase project by going to the firebase console.
 
  firebase_auth: ^4.2.6
  firebase_core: ^2.5.0
  google_sign_in: ^5.4.0
  flutter_facebook_auth: ^4.4.1
  firebase_messaging: ^14.2.2


  void main()async{
     WidgetsFlutterBinding.ensureInitialized();
     await Firebase.initializeApp(); // initializes the default Firebase app instance.
  }

  //loginWithGoogle     

  // The signInWithGoogle() method that we have defined will help to
  // authenticate user with Google Sign-In on the Android and iOS platforms.

  signInWithGoogle() async {
    // The user's ID token is also retrieved and stored for use with Firebase Cloud Messaging. 
    String? pushToken = await FirebaseMessaging.instance.getToken();
    //  The obtained credentials are then used to authenticate with Firebase using the Google OAuthProvider

    GoogleSignInAccount? value = await _googleSignIn.signIn();

    if (value != null) {
      setState(() {
        isLoading = true; //  indicate that authentication is in progress.
      });
      var val = await value.authentication;
      //  The obtained credentials are then used to authenticate with Firebase using the Google OAuthProvider.
      final oAuthProvider = fbAuth.OAuthProvider("google.com");
       // Create a new credential
      final crd = oAuthProvider.credential(
        idToken: val.idToken,
        accessToken: val.accessToken,
      );

  // Once signed in, return the UserCredential
      var resp = await fbAuth.FirebaseAuth.instance.signInWithCredential(crd);
      String? firebaseUserId = resp.user?.uid;
      var fcmToken = await resp.user?.getIdToken();

      Future.delayed(
        const Duration(seconds: 0),
        () async {
       // print messages after authentication is complete
        },
      );
    }
  }

  // loginWithFacebook
  // Before getting started setup your Facebook Developer App and follow the setup process to enable Facebook Login.
// Ensure the "Facebook" sign-in provider is enabled on the Firebase Console. with the Facebook App ID and Secret set.
  signInWithFacebook() async {
    setState(() {
      isLoading = true; //  indicate that authentication is in progress.
    });
    // The user's ID token is also retrieved and stored for use with Firebase Cloud Messaging.
    String? pushToken = await FirebaseMessaging.instance.getToken();
    final LoginResult loginResult = await FacebookAuth.instance.login();
    // The login method returns an Access Token, which is then used to obtain a Facebook OAuthCredential.
    final fbAuth.OAuthCredential facebookAuthCredential =
        fbAuth.FacebookAuthProvider.credential(
      loginResult.accessToken!.token,
    );
    var resp = await fbAuth.FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);
    var fcmToken = await resp.user?.getIdToken();

    print(resp.user);
    Future.delayed( // Future.delayed() to add a delay of zero seconds to allow time for
    // the isLoading state to be set before proceeding with any additional actions.
      const Duration(seconds: 0),
      () async {
       // print messages after authentication is complete
      },
    );
  }
