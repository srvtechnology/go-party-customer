class Country {
  int id;
  String name;
  
  Country({
    required this.id,
    required this.name
});
  
  factory Country.fromJson(Map json){
    return Country(id: json["id"], name: json["name"]);
  }
}