import 'dart:convert';

ModelAddAlamatPengiriman modelAddAlamatPengirimanFromJson(String str) =>
    ModelAddAlamatPengiriman.fromJson(json.decode(str));

String modelAddAlamatPengirimanToJson(ModelAddAlamatPengiriman data) =>
    json.encode(data.toJson());

class ModelAddAlamatPengiriman {
  bool isSuccess;
  String message;

  ModelAddAlamatPengiriman({
    required this.isSuccess,
    required this.message,
  });

  factory ModelAddAlamatPengiriman.fromJson(Map<String, dynamic> json) =>
      ModelAddAlamatPengiriman(
        isSuccess: json["isSuccess"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
  };
}
