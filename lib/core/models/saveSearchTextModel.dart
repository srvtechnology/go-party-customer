class SaveSearchTextModel {
  SaveSearchTextModel({
    required this.status,
    required this.data,
  });

  final bool? status;
  final List<String> data;

  factory SaveSearchTextModel.fromJson(Map<String, dynamic> json) {
    return SaveSearchTextModel(
      status: json["status"],
      data: json["data"] == null
          ? []
          : List<String>.from(json["data"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.map((x) => x).toList(),
      };
}
