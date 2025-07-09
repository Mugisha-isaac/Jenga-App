class User {
  String? id;
  String? fullName;
  String? email;
  String? phoneNumber;
  String? profilePictureUrl;

  User({
    this.id,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.profilePictureUrl,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    profilePictureUrl = json['profilePictureUrl'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'profilePictureUrl': profilePictureUrl,
    };
  }
}
