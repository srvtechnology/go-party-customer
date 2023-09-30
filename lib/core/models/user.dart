class UserModel {
      String id,name,email,mobile;
      UserModel({
      required this.id,
      required this.name,
      required this.email,
      required this.mobile  
      });
      
      factory UserModel.fromJson(Map json){
        return UserModel(
            id: json["data"]["id"].toString(),
            name: json["data"]["name"],
            email: json["data"]["email"],
            mobile: json["data"]["mobile"]);
      }
}

