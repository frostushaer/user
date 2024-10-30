class User {
  final String id;
  final String firstName;
  final String lastName;
  final String gender;
  final String countryCode;
  final String phone;
  final String email;
  final String uid;
  final String refCode;
  final String userDp; // Profile picture URL
  final String dateOfJoining; // Date of joining
  final String auth; // Authentication token or any relevant info

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.countryCode,
    required this.phone,
    required this.email,
    required this.uid,
    required this.refCode,
    required this.userDp,
    required this.dateOfJoining,
    required this.auth,
  });

  // Factory method to create a User object from a JSON map
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      gender: json['gender'],
      countryCode: json['c_code'],
      phone: json['phone'],
      email: json['email'],
      uid: json['uid'],
      refCode: json['ref_code'],
      userDp: json['user_dp'],
      dateOfJoining: json['doj'],
      auth: json['auth'],
    );
  }

  // Method to convert a User object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'gender': gender,
      'c_code': countryCode,
      'phone': phone,
      'email': email,
      'uid': uid,
      'ref_code': refCode,
      'user_dp': userDp,
      'doj': dateOfJoining,
      'auth': auth,
    };
  }
}
