class CategoryModel {
  int id;
  String name,description;
  
  CategoryModel({
    required this.id,
    required this.name,
    required this.description
});
  
  factory CategoryModel.fromJson(Map json)
  {
    return CategoryModel(
        id: json["id"],
        name: json["category_name"],
        description: json["category_description"]);
  }
}