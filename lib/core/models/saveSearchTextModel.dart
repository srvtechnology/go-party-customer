class SaveSearchTextModel {
  SaveSearchTextModel({
    required this.status,
    required this.data,
  });

  final bool? status;
  final List<Datum> data;

  factory SaveSearchTextModel.fromJson(Map<String, dynamic> json) {
    return SaveSearchTextModel(
      status: json["status"],
      data: json["data"] == null
          ? []
          : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.map((x) => x.toJson()).toList(),
      };
}

class Datum {
  Datum({
    required this.value,
  });

  final String? value;

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      value: json["value"],
    );
  }

  Map<String, dynamic> toJson() => {
        "value": value,
      };
}
