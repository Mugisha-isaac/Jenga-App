class User {
  String? id;
  String? fullName;
  String? email;
  String? phoneNumber;
  String? profilePictureUrl;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isActive;

  User({
    this.id,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.profilePictureUrl,
    this.createdAt,
    this.updatedAt,
    this.isActive = true,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    profilePictureUrl = json['profilePictureUrl'];
    createdAt = json['createdAt']?.toDate();
    updatedAt = json['updatedAt']?.toDate();
    isActive = json['isActive'] ?? true;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'profilePictureUrl': profilePictureUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt ?? DateTime.now(),
      'isActive': isActive,
    };
  }
}
