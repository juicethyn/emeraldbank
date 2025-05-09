import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserModel {
  final String email;
  final String phoneNumber;
  final double balance;
  final String accountNickName;
  final String accountName;
  final String accountNumber;
  final String accountCardNumber;
  final String accountCVC;
  final String birthDate;
  final String issuedOn;
  final String expiresEnd;
  final String uid;

  // Constructor
  UserModel({
    this.email = '',
    this.phoneNumber = '',
    this.balance = 0.0,
    this.accountNickName = '',
    this.accountName = '',
    this.accountNumber = '',
    this.accountCardNumber = '',
    this.accountCVC = '',
    this.birthDate = '',
    this.issuedOn = '',
    this.expiresEnd = '',
    this.uid = '',
  });

  // Factory constructor to create a UserModel from Firestore data
  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      accountNickName: data['accountNickname'] ?? '',
      birthDate: data['birthDate'] ?? '',
      uid: data['uid'] ?? '',
    );
  }

  // Factory constructor to create a UserModel from Firestore data (savings collection)
  factory UserModel.fromSavings(Map<String, dynamic> data, String uid) {
    return UserModel(
      balance: data['currentBalance']?.toDouble() ?? 0.00,
      accountName: data['accountHolderName'] ?? '',
      accountNumber: data['savingsAccountInformation']['accountNumber'] ?? '',
      accountCardNumber: data['savingsAccountInformation']['cardNumber'] ?? '',
      accountCVC: data['savingsAccountInformation']['cvv_cvc'] ?? '',
      issuedOn: data['expiryDate'] ?? '',
      expiresEnd: data['issuedDate'] ?? '',
      uid: uid,
    );
  }
}

Future<UserModel?> fetchUserData(String uid) async {
  try {
    // Step 1: Get the user's document from the `users` collection
    final userDocRef = FirebaseFirestore.instance.collection('users').doc(uid);
    final userDocSnapshot = await userDocRef.get();

    if (!userDocSnapshot.exists) {
      debugPrint("No user found with the given UID.");
      return null;
    }

    // Step 2: Query the `savings` collection where `accountHolder` matches the user's document path
    final querySnapshot = await FirebaseFirestore.instance
        .collection('savings')
        .where('accountHolder', isEqualTo: "users/$uid") // Use the full document path as a string
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Get the first matching document
      final savingsData = querySnapshot.docs.first.data();

      // Create a UserModel from the savings data
      return UserModel.fromSavings(savingsData, uid);
    } else {
      debugPrint("No savings account found for the user.");
      return null;
    }
  } catch (e) {
    debugPrint("Error fetching user data: $e");
    return null;
  }
}