import 'package:emeraldbank_mobileapp/global/common/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Variable to store verification ID for OTP
  String _verificationId = '';

  // Code for the Signup Method (with Email and Phone Verification)
  Future<User?> signUpWithEmailAndPassword(String email, String password, String phoneNumber) async {
    try {
      // Step 1: Create user with email/password
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = credential.user;

      if (user != null) {
        // Step 2: Send OTP for phone verification
        await _sendPhoneVerificationOTP(phoneNumber);
      }
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showToast(message: "The email address is already in use.");
      } else {
        showToast(message: "An error occurred ${e.code}");
      }
    }

    return null;
  }

  // Code for the Signin Method with Email and Password
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-email') {
        showToast(message: "Invalid email or password.");
      } else {
        showToast(message: "An error occurred ${e.code} ");
      }
    }
    return null;
  }

  // Code for the Signin Method (with Email and Phone Verification)
  Future<User?> signInWithEmailPhoneAndPassword(String email, String password, String phoneNumber) async {
    try {
      // Step 1: Sign in with email/password
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = credential.user;

      if (user != null) {
        // Step 2: Send OTP for phone verification
        await _sendPhoneVerificationOTP(phoneNumber);
      }
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-email') {
        showToast(message: "Invalid email or password.");
      } else {
        showToast(message: "An error occurred ${e.code}");
      }
    }

    return null;
  }

  // Helper function to send OTP via phone number for verification
  Future<void> _sendPhoneVerificationOTP(String phoneNumber) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // If OTP is auto-retrieved, sign in the user
          await _auth.currentUser?.linkWithCredential(credential);
          showToast(message: "Phone number verified successfully.");
        },
        verificationFailed: (FirebaseAuthException e) {
          showToast(message: "Phone number verification failed: ${e.message}");
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          showToast(message: "OTP sent to your phone.");
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } on FirebaseAuthException catch (e) {
      showToast(message: "Error sending OTP: ${e.message}");
    }
  }

  // Code to verify OTP (for both sign-up and sign-in)
  Future<void> verifyPhoneOTP(String otp) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otp,
      );

      // Link the phone credential with the current user
      await _auth.currentUser?.linkWithCredential(credential);
      showToast(message: "Phone number verified successfully.");
    } on FirebaseAuthException catch (e) {
      showToast(message: "OTP verification failed: ${e.message}");
    }
  }

  Future<void> verifyPhoneNumber(String phoneNumber, Function(PhoneAuthCredential) onVerificationCompleted, Function(String) onVerificationFailed, Function(String) onOtpSent) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: onVerificationCompleted,
      verificationFailed: (FirebaseAuthException e) {
        onVerificationFailed(e.message ?? "Verification failed");
      },
      codeSent: (String verificationId, int? resendToken) {
        onOtpSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Handle timeout
      },
    );
  }

  // Method to sign in with the OTP
  Future<User?> signInWithOTP(String verificationId, String otp) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otp);
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      // Handle errors
      print(e);
    }
    return null;
  }
}
