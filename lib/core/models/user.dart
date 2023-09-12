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

class ReviewModel{
      String name,message,rating;
      ReviewModel(
      {
            required this.name,
            required this.message,
            required this.rating,
      }
      );

      factory ReviewModel.fromJson(Map json){
            return ReviewModel(name: "Raghav", message: "Clear Review", rating: "4.3");
      }

}