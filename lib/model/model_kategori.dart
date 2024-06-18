import 'dart:convert';

ModelKategori modelKategoriFromJson(String str) =>
    ModelKategori.fromJson(json.decode(str));

String modelKategoriToJson(ModelKategori data) => json.encode(data.toJson());

class ModelKategori {
  bool isSuccess;
  String message;
  List<Kategori> data;

  ModelKategori({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory ModelKategori.fromJson(Map<String, dynamic> json) => ModelKategori(
    isSuccess: json["isSuccess"],
    message: json["message"],
    data: List<Kategori>.from(json["data"].map((x) => Kategori.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Kategori {
  String id_kategori;  // TODO Change to String
  String kategori;

  Kategori({
    required this.id_kategori,
    required this.kategori,
  });

  factory Kategori.fromJson(Map<String, dynamic> json) => Kategori(
    id_kategori: json["id_kategori"],
    kategori: json["kategori"],
  );

  Map<String, dynamic> toJson() => {
    "id_kategori": id_kategori,
    "kategori": kategori,
  };
}
