class UserModel {
  String name, email, phone, nationalID, nationality, dob;
  UserModel(
      {required this.dob,
      required this.email,
      required this.name,
      required this.nationalID,
      required this.nationality,
      required this.phone});

  factory UserModel.fromjson(Map<String, dynamic> json) {
    return UserModel(
        dob: json['dob'] ?? "",
        email: json['email'] ?? "",
        name: json['name'] ?? "",
        nationalID: json['nationalID'] ?? "",
        nationality: json['nationality'] ?? "",
        phone: json['phone'] ?? "");
  }
}
