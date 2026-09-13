class DriverModel {
  final String uid;
  final String name;
  final String phone;
  final String aadharNumber;
  final String profileImageUrl;
  final String aadharImageUrl;
  final bool isVerified;

  DriverModel({
    required this.uid,
    required this.name,
    required this.phone,
    required this.aadharNumber,
    required this.profileImageUrl,
    required this.aadharImageUrl,
    this.isVerified = false,
  });

  // ফায়ারবেজে ডেটা পাঠানোর জন্য Map-এ কনভার্ট করা
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'phone': phone,
      'aadharNumber': aadharNumber,
      'profileImageUrl': profileImageUrl,
      'aadharImageUrl': aadharImageUrl,
      'isVerified': isVerified,
    };
  }

  // ফায়ারবেস থেকে ডেটা পড়ার জন্য
  factory DriverModel.fromMap(Map<String, dynamic> map) {
    return DriverModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      aadharNumber: map['aadharNumber'] ?? '',
      profileImageUrl: map['profileImageUrl'] ?? '',
      aadharImageUrl: map['aadharImageUrl'] ?? '',
      isVerified: map['isVerified'] ?? false,
    );
  }
}