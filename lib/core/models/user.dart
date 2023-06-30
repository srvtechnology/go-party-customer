class UserModel {
      String name,email,mobile;
      UserModel({
      required this.name,
      required this.email,
      required this.mobile  
      });
      
      factory UserModel.fromJson(Map json){
        return UserModel(
            name: json["data"]["name"],
            email: json["data"]["email"],
            mobile: json["data"]["mobile"]);
      }
}