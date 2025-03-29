
import 'package:emeraldbank_mobileapp/global/common/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthServices {

  final FirebaseAuth _auth = FirebaseAuth.instance;


  // Code for the Signup Method
  Future<User?> signUpWithEmailAndPassword(String email, String password) async {

    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e){
      
      if(e.code == 'email-already-in-use'){
        showToast(message: "The email address is already in use.");
      }
      else{
        showToast(message: "An error occured ${e.code} ");
      }
    }

    return null;

  }

  // Code for the Signin Method
  Future<User?> signInWithEmailAndPassword(String email, String password) async {

    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e){
      
      if(e.code == 'user-not-found' || e.code == 'wrong-password'){
        showToast(message: "Invalid email or password.");
      }
      else{
        showToast(message: "An error occured ${e.code} ");
      }

    }

    return null;

  }

}