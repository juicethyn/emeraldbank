import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountVerificationResult {
  final bool isValid;
  final String message;
  final Map<String, dynamic>? accountData;

  AccountVerificationResult({
    required this.isValid,
    required this.message,
    this.accountData,
  });
}

class AccountVerificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Verify a savings account against user's personal information
  Future<AccountVerificationResult> verifySavingsAccount({
    required String accountNumber,
    required String accountHolderName,
    String? dateOfBirth,
    String? contactNumber,
    String? emailAddress,
    String? bankId,
    String? savingsTypeId,
  }) async {
    try {
      print('========= STARTING VERIFICATION =========');
      print('DEBUG: Account Number: $accountNumber');
      print('DEBUG: Bank ID: $bankId');
      print('DEBUG: Savings Type ID: $savingsTypeId');
      // Step 1: Get current user data
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        return AccountVerificationResult(
          isValid: false,
          message: 'User not logged in',
        );
      }

      // Step 2: Get user person reference
      final userDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();

      if (!userDoc.exists) {
        return AccountVerificationResult(
          isValid: false,
          message: 'User profile not found',
        );
      }

      final userData = userDoc.data()!;
      final personRef = userData['person'] as DocumentReference?;

      if (personRef == null) {
        return AccountVerificationResult(
          isValid: false,
          message: 'Person reference not found',
        );
      }

      // Step 3: Find the savings account by account number
      final savingsQuery =
          await _firestore
              .collection('savings')
              .where(
                'savingsAccountInformation.accountNumber',
                isEqualTo: accountNumber,
              )
              .limit(1)
              .get();

      if (savingsQuery.docs.isEmpty) {
        return AccountVerificationResult(
          isValid: false,
          message: 'Savings account not found with this account number',
        );
      }

      final savingsDoc = savingsQuery.docs.first;
      final savingsData = savingsDoc.data();

      print('DEBUG: Found savings account document');
      print('DEBUG: Savings doc ID: ${savingsDoc.id}');
      print(
        'DEBUG: Associated Bank in document: ${savingsData['savingsAccountInformation']['associatedBank']}',
      );
      print(
        'DEBUG: Account Type in document: ${savingsData['savingsAccountInformation']['accountType']}',
      );

      // Step 4: Get the person data linked to the account
      final accountHolder = savingsData['accountHolder'];
      DocumentReference accountHolderRef;

      if (accountHolder is DocumentReference) {
        accountHolderRef = accountHolder;
      } else if (accountHolder is String) {
        accountHolderRef = _firestore.doc(accountHolder);
      } else {
        return AccountVerificationResult(
          isValid: false,
          message: 'Invalid account holder reference',
        );
      }

      // Step 5: Check if this account already belongs to the user
      final userAcctRefQuery =
          await _firestore
              .collection('users')
              .doc(currentUser.uid)
              .collection('accountReferences')
              .where(
                'savingsAccounts',
                arrayContains: '/savings/${savingsDoc.id}',
              )
              .limit(1)
              .get();

      if (userAcctRefQuery.docs.isNotEmpty) {
        return AccountVerificationResult(
          isValid: false,
          message: 'This account is already linked to your profile',
        );
      }

      if (bankId != null) {
        final associatedBankRef =
            savingsData['savingsAccountInformation']['associatedBank'];
        String actualBankPath;

        if (associatedBankRef is DocumentReference) {
          actualBankPath = associatedBankRef.path;
        } else if (associatedBankRef is String) {
          actualBankPath = associatedBankRef;
        } else {
          return AccountVerificationResult(
            isValid: false,
            message: 'Invalid bank reference in account data',
          );
        }

        final expectedBankPath = 'banks/$bankId';
        if (actualBankPath != expectedBankPath) {
          return AccountVerificationResult(
            isValid: false,
            message: 'Selected bank does not match the account\'s bank',
          );
        }

        print('DEBUG: Comparing bank paths');
        print('DEBUG: actualBankPath: $actualBankPath');
        print('DEBUG: expectedBankPath: $expectedBankPath');
        print('DEBUG: Do they match? ${actualBankPath == expectedBankPath}');

        // If savings type is also selected, verify it too
        if (savingsTypeId != null) {
          final accountTypeRef =
              savingsData['savingsAccountInformation']['accountType'];
          String actualTypePath;

          if (accountTypeRef is DocumentReference) {
            actualTypePath = accountTypeRef.path;
          } else if (accountTypeRef is String) {
            actualTypePath = accountTypeRef;
          } else {
            return AccountVerificationResult(
              isValid: false,
              message: 'Invalid account type reference in account data',
            );
          }

          final expectedTypePath =
              'banks/$bankId/savingsProducts/$savingsTypeId';
          if (actualTypePath != expectedTypePath) {
            return AccountVerificationResult(
              isValid: false,
              message:
                  'Selected account type does not match the account\'s type',
            );
          }
          print('DEBUG: Comparing account type paths');
          print('DEBUG: actualTypePath: $actualTypePath');
          print('DEBUG: expectedTypePath: $expectedTypePath');
          print('DEBUG: Do they match? ${actualTypePath == expectedTypePath}');
        }
      }

      // Step 6: Verify ownership by comparing person references
      if (accountHolderRef.path != personRef.path) {
        // Additional verification with provided details
        final personDoc = await personRef.get();
        final personData = personDoc.data() as Map<String, dynamic>?;

        if (personData == null) {
          return AccountVerificationResult(
            isValid: false,
            message: 'Person data not found',
          );
        }

        // Build verification points system
        int verificationScore = 0;
        int requiredScore = 3; // Require at least 3 matching fields

        // Check name match (highest priority)
        if (personData['fullName'] == accountHolderName) {
          verificationScore += 2;
        } else {
          // Try more flexible name matching
          final personFullName = personData['fullName']?.toLowerCase() ?? '';
          final accountName = accountHolderName.toLowerCase();

          if (personFullName.contains(accountName) ||
              accountName.contains(personFullName)) {
            verificationScore += 1;
          }
        }

        // Check DOB if provided
        if (dateOfBirth != null && personData['date_of_birth'] == dateOfBirth) {
          verificationScore += 1;
        }

        // Check phone if provided
        if (contactNumber != null &&
            personData['contactNumber'] == contactNumber) {
          verificationScore += 1;
        }

        // Check email if provided
        if (emailAddress != null &&
            personData['emailAddress'] == emailAddress) {
          verificationScore += 1;
        }

        if (bankId != null) {
          verificationScore += 1; // Bank verification adds a point
          if (savingsTypeId != null) {
            verificationScore +=
                1; // Account type verification adds another point
          }
        }

        if (verificationScore < requiredScore) {
          return AccountVerificationResult(
            isValid: false,
            message:
                'Insufficient verification. Account details do not match your profile.',
          );
        }
      }

      // Account verification passed
      return AccountVerificationResult(
        isValid: true,
        message: 'Account verified successfully',
        accountData: {
          'id': savingsDoc.id,
          'path': savingsDoc.reference.path,
          'data': savingsData,
        },
      );
    } catch (e) {
      return AccountVerificationResult(
        isValid: false,
        message: 'Error verifying account: ${e.toString()}',
      );
    }
  }

  // Add verified account to user's profile
  Future<bool> addVerifiedAccountToUser({
    required String accountType, // 'savings', 'creditCard', or 'loan'
    required String accountPath,
  }) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      // Get the accountReferences document
      final accountRefsSnapshot =
          await _firestore
              .collection('users')
              .doc(currentUser.uid)
              .collection('accountReferences')
              .limit(1)
              .get();

      DocumentReference accountRefsDocRef;

      // Create accountReferences document if it doesn't exist
      if (accountRefsSnapshot.docs.isEmpty) {
        final newDocRef = await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .collection('accountReferences')
            .add({
              'createdAt': FieldValue.serverTimestamp(),
              'savingsAccounts': [],
              'loanAccounts': [],
              'creditCardAccounts': [],
            });
        accountRefsDocRef = newDocRef;
      } else {
        accountRefsDocRef = accountRefsSnapshot.docs.first.reference;
      }

      // Add the account to the appropriate array field
      String fieldName;
      switch (accountType) {
        case 'savings':
          fieldName = 'savingsAccounts';
          break;
        case 'creditCard':
          fieldName = 'creditCardAccounts';
          break;
        case 'loan':
          fieldName = 'loanAccounts';
          break;
        default:
          return false;
      }

      await accountRefsDocRef.update({
        fieldName: FieldValue.arrayUnion([accountPath]),
      });

      return true;
    } catch (e) {
      print('Error adding account: $e');
      return false;
    }
  }
}
