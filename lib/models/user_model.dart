class UserModel {
  final String email;
  final String phoneNumber;
  double balance;
  final String accountNickName;
  final String accountName;
  final String accountNumber;
  final String birthDate;
  final String issuedOn;
  final String expiresEnd;

  UserModel({
    required this.email,
    required this.phoneNumber,
    required this.balance,
    required this.accountName,
    required this.accountNickName,
    required this.accountNumber,
    required this.birthDate,
    required this.issuedOn,
    required this.expiresEnd,
  });

  // Factory constructor to create a UserModel from Firestore data
  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      balance: data['balance']?.toDouble() ?? 0.00,
      accountNickName: data['accountNickname'] ?? '',
      accountName: data['accountName'] ?? '',
      accountNumber: data['accountNumber'] ?? '',
      birthDate: data['birthDate'] ?? '',
      issuedOn: data['issuedOn'] ?? '',
      expiresEnd: data['issuedOn'] ?? '',
    );
  }
}
