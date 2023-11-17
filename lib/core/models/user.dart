class UserModel {
  String id, name, email, mobile, status;
  UserModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.mobile,
      required this.status});

  factory UserModel.fromJson(Map json) {
    return UserModel(
        id: json["data"]["id"].toString(),
        name: json["data"]["name"],
        email: json["data"]["email"],
        mobile: json["data"]["mobile"],
        status: json["data"]["status"]);
  }
}
